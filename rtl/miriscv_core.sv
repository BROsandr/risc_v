`include "../common/defines_riscv.v"

module miriscv_core(
  input         clk_i,
  input         rst_n_i,
  
  input [31:0]  instr_rdata_i,
  input [31:0]  instr_addr_o,
  
  input  [31:0] data_rdata_i,
  output        data_req_o,
  output        data_we_o,
  output [3:0]  data_be_o,
  output [31:0] data_addr_o,
  output [31:0] data_wdata_o 
);
  logic [31:0] RD1;
  
  logic [31:0] RD2;

  logic [31:0] RD;
  assign       RD           = instr_rdata_i;
  
  logic [31:0] instr;
  assign       instr        = RD;
  
  logic [31:0] Result;
  
  logic        comp;
  
  logic        enpc;
  
  logic [31:0] imm_I;
  assign       imm_I = { { 21{instr[31]} },  instr[30:20] };

  logic [31:0] imm_S;
  assign       imm_S = { { 21{instr[31]} },  instr[30:25], instr[11:7] };  
  
  logic [31:0] imm_J;
  assign       imm_J = { { 12{instr[31]} },  instr[19:12], instr[20], instr[30:21], 1'b0 };    
  
  logic [31:0] imm_B;
  assign       imm_B = { { 12{instr[31]} },  instr[7], instr[30:25], instr[11:8], 1'b0 };    
  
  logic [1:0]  ex_op_a_sel;
  logic [2:0]  ex_op_b_sel; 
  logic [4:0]  alu_op;      
  logic        mem_req;     
  logic        mem_we;      
  logic [2:0]  mem_size;    
  logic        gpr_we_a;    
  logic        wb_src_sel;  
  logic        illegal_instr;
  logic        branch;      
  logic        jal;         
  logic        jalr;       
  
  logic [31:0] A;
  logic [31:0] B;
  
  logic [31:0] RD_mem;
  
  logic [31:0] WD3;
  assign       WD3 = ( wb_src_sel ) ? ( RD_mem ) : ( Result );
  
  logic [31:0] PC;
  assign       instr_addr_o = PC;
  
  logic [31:0] add_to_PC;
  assign       add_to_PC = ( ( comp & branch ) | jal  ) ? ( ( branch ) ? ( imm_B ) : ( imm_J ) ) : ( 4 );
  
  logic [4:0]  A1;
  assign       A1  = instr[19:15];
  
  logic [4:0]  A2;
  assign       A2  = instr[24:20];
  
  logic [4:0]  WA3;
  assign       WA3 = instr[11:7];       
  
  logic        lsu_stall_req;
  
  miriscv_lsu miriscv_lsu(
    .clk_i          ( clk_i         ), // ?????????????
    .arstn_i        ( rst_n_i       ), // ????? ?????????? ?????????

    // core protocol
    .lsu_addr_i     ( RD            ), // ?????, ?? ???????? ????? ??????????
    .lsu_we_i       ( mem_we        ), // 1 - ???? ????? ???????? ? ??????
    .lsu_size_i     ( mem_size      ), // ?????? ?????????????? ??????
    .lsu_data_i     ( RD2           ), // ?????? ??? ?????? ? ??????
    .lsu_req_i      ( mem_req       ), // 1 - ?????????? ? ??????
    .lsu_stall_req_o( lsu_stall_req ), // ???????????? ??? !enable pc
    .lsu_data_o     ( RD_mem        ), // ?????? ????????? ?? ??????

    // memory protocol
    .data_rdata_i   ( data_rdata_i  ), // ??????????? ??????
    .data_req_o     ( data_req_o    ), // 1 - ?????????? ? ??????
    .data_we_o      ( data_we_o     ), // 1 - ??? ?????? ?? ??????
    .data_be_o      ( data_be_o     ), // ? ????? ?????? ????? ???? ?????????
    .data_addr_o    ( data_addr_o   ), // ?????, ?? ???????? ???? ?????????
    .data_wdata_o   ( data_wdata_o  ) // ??????, ??????? ????????? ????????
  ); 
  
  decoder_riscv decoder_riscv (
    .fetched_instr_i( RD            ),
    .lsu_stall_req_i( lsu_stall_req ),
    .ex_op_a_sel_o  ( ex_op_a_sel   ),      
    .ex_op_b_sel_o  ( ex_op_b_sel   ),      
    .alu_op_o       ( alu_op        ),           
    .mem_req_o      ( mem_req       ),          
    .mem_we_o       ( mem_we        ),           
    .mem_size_o     ( mem_size      ),         
    .gpr_we_a_o     ( gpr_we_a      ),         
    .wb_src_sel_o   ( wb_src_sel    ),       
    .illegal_instr_o( illegal_instr ),    
    .branch_o       ( branch        ),           
    .jal_o          ( jal           ),              
    .jalr_o         ( jalr          ),
    .enpc_o         ( enpc          )              
  );
  
  RF rf(
    .clk_i( clk_i    ),
    .rst_i( rst_n_i  ),
    .A1_i ( A1       ),
    .A2_i ( A2       ),
    .WA3_i( WA3      ),
    .WD3_i( WD3      ),
    .RD1_o( RD1      ),
    .RD2_o( RD2      ),
    .WE3_i( gpr_we_a )
  );

  ALU_RISCV alu(
    .ALUOp ( alu_op ),
    .A     ( A      ), 
    .B     ( B      ), 
    .Result( Result ), 
    .Flag  ( comp   )
  ); 
  
  always_ff @( posedge clk_i or posedge rst_n_i )
    if( rst_n_i )
      PC <= 0;
    else
      if( enpc )
        PC <= ( jalr ) ? ( RD1 + imm_I ) : ( PC + add_to_PC );   
  
  always_comb
    case( ex_op_a_sel )
      `OP_A_RS1    : A = RD1;  
      `OP_A_CURR_PC: A = PC;
      `OP_A_ZERO   : A = 0;
      default      : A = 0;
    endcase
    
  always_comb
    case( ex_op_b_sel )
      `OP_B_RS2  :   B = RD2; 
      `OP_B_IMM_I:   B = imm_I; 
      `OP_B_IMM_U:   B = { instr[31:12], { 12{1'b0} } };
      `OP_B_IMM_S:   B = imm_S;
      `OP_B_INCR :   B = 4;
      default    :   B = 0;
    endcase  
endmodule
