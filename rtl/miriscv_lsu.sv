`include "../common/defines_riscv.v"

module miriscv_lsu
(
 input               clk_i, // ?????????????
 input               arstn_i, // ????? ?????????? ?????????

 // core protocol
 input        [31:0] lsu_addr_i, // ?????, ?? ???????? ????? ??????????
 input               lsu_we_i, // 1 - ???? ????? ???????? ? ??????
 input        [2:0]  lsu_size_i, // ?????? ?????????????? ??????
 input        [31:0] lsu_data_i, // ?????? ??? ?????? ? ??????
 input               lsu_req_i, // 1 - ?????????? ? ??????
 output logic        lsu_stall_req_o, // ???????????? ??? !enable pc
 output logic [31:0] lsu_data_o, // ?????? ????????? ?? ??????

 // memory protocol
 input        [31:0] data_rdata_i, // ??????????? ??????
 output              data_req_o, // 1 - ?????????? ? ??????
 output              data_we_o, // 1 - ??? ?????? ?? ??????
 output logic [3:0]  data_be_o, // ? ????? ?????? ????? ???? ?????????
 output       [31:0] data_addr_o, // ?????, ?? ???????? ???? ?????????
 output logic [31:0] data_wdata_o // ??????, ??????? ????????? ????????
); 
  
  logic [1:0] lsu_byte_offset;
  assign      lsu_byte_offset  = lsu_addr_i[1:0]; // lsu_addr_i % 4
  
  logic [1:0] data_byte_offset;
  assign      data_byte_offset = data_addr_o[1:0]; // data_addr_o % 4

  logic       stall_buff;
  assign      lsu_stall_req_o  = stall_buff & lsu_req_i;

  always_ff @( posedge clk_i or posedge arstn_i )
    if( arstn_i )
      stall_buff <= 1;
    else if( !stall_buff )
      stall_buff <= 1;
    else
      stall_buff <= !lsu_req_i;
  
  assign data_req_o  = lsu_req_i; // 1 - ?????????? ? ??????
  assign data_we_o   = lsu_we_i; // 1 - ??? ?????? ?? ??????
  assign data_addr_o = { lsu_addr_i[31:2], 2'b00 }; // ?????, ?? ???????? ???? ?????????
  
  // load
  always_comb
    unique case( lsu_size_i ) inside
      `LDST_B, `LDST_BU: 
        unique case( lsu_byte_offset )
          2'b00  : begin
            data_be_o  = 4'b0001;
            lsu_data_o = ( lsu_size_i == `LDST_B ) ? ( { { 24{data_rdata_i[7]} }, data_rdata_i[7:0] } ) : 
                                                     ( {24'b0, data_rdata_i[7:0]}                     );
          end
          
          2'b01  : begin
            data_be_o  = 4'b0010;
            lsu_data_o = ( lsu_size_i == `LDST_B ) ? ( { { 24{data_rdata_i[15]} }, data_rdata_i[15:8] } ) :
                                                     ( {24'b0, data_rdata_i[15:8]}                      );
          end
          
          2'b10  : begin 
            data_be_o  = 4'b0100;
            lsu_data_o = ( lsu_size_i == `LDST_B ) ? ( { { 24{data_rdata_i[23]} }, data_rdata_i[23:16] } ) :
                                                     ( {24'b0, data_rdata_i[23:16]}                      );
          end
          
          2'b11  : begin 
            data_be_o  = 4'b1000;
            lsu_data_o = ( lsu_size_i == `LDST_B ) ? ( { {24{data_rdata_i[31]}}, data_rdata_i[31:24] } ) :
                                                     ( {24'b0, data_rdata_i[31:24]}                    );
          end
          
          default: begin
            data_be_o  = 4'bxxxx;
            lsu_data_o = { 31'dX };
          end
        endcase
        
      `LDST_H, `LDST_HU: 
        unique case( lsu_byte_offset )
          2'b00  : begin
            data_be_o  = 4'b0011;
            lsu_data_o = ( lsu_size_i == `LDST_H ) ? ( {{16{data_rdata_i[15]}}, data_rdata_i[15:0]} ) :
                                                     ( {16'b0, data_rdata_i[15:0]}                  );
          end
          
          2'b10  : begin
            data_be_o  = 4'b1100;
            lsu_data_o = ( lsu_size_i == `LDST_H ) ? ( {{16{data_rdata_i[31]}}, data_rdata_i[31:16]} ) :
                                                     ( {16'b0, data_rdata_i[31:16]}                  );
          end
          
          default: begin
            data_be_o  = 4'bxxxx;
            lsu_data_o = { 31'dx };
          end
        endcase

      `LDST_W: begin
        data_be_o  = 4'b1111;
        lsu_data_o = data_rdata_i[31:0];
      end

      default: begin
        data_be_o  = 4'bxxxx;
        lsu_data_o = { 31'dx };
      end
    endcase

	// store
  always_comb begin
    unique case( lsu_size_i )
      `LDST_B: data_wdata_o = { 4{lsu_data_i[7:0]} };
        
      `LDST_H: data_wdata_o = { 2{lsu_data_i[15:0]} };

      `LDST_W: data_wdata_o = lsu_data_i[31:0];

      default: data_wdata_o = { 31'dx };
    endcase
  end
endmodule
