`include "../common/defines_riscv.v"

module risc_v_lab4(
  input clk_i,
  input rst_i,
  
  input en_i,
  
  output [15:0] OUT_o,
  
  input  [2:0]  SW_i
);
  wire [31:0] RD1;
  wire [31:0] RD2;

  wire [31:0] RD;
  
  wire signed [31:0] Result;
  wire               Flag;

  assign OUT_o = RD1;
  
  wire [31:0] const_SE;
  assign const_SE = { {24{ RD[12] }}, RD[12:5] };
  
  reg [7:0] PC;
  
  wire [7:0] add_to_PC;
  assign     add_to_PC = ( ( Flag & RD[30] ) | RD[31]  ) ? ( const_SE ) : ( 4 );
  
  always @( posedge clk_i or posedge rst_i )
    if( rst_i )
      PC <= 0;
    else
      if( en_i )
        PC <= PC + add_to_PC;
  
  logic [1:0] ex_op_a_sel_o;
  logic [2:0] ex_op_b_sel_o; 
  logic [4:0] alu_op_o;      
  logic       mem_req_o;     
  logic       mem_we_o;      
  logic [2:0] mem_size_o;    
  logic       gpr_we_a_o;    
  logic       wb_src_sel_o;  
  logic       illegal_instr_o;
  logic       branch_o;      
  logic       jal_o;         
  logic       jalr_o;         
  
  decoder_riscv decoder_riscv (
    .fetched_instr_i( RD ),
    .ex_op_a_sel_o  ( ex_op_a_sel_o ),      
    .ex_op_b_sel_o  ( ex_op_b_sel_o ),      
    .alu_op_o       ( alu_op_o ),           
    .mem_req_o      ( mem_req_o ),          
    .mem_we_o       ( mem_we_o ),           
    .mem_size_o     ( mem_size_o ),         
    .gpr_we_a_o     ( gpr_we_a_o ),         
    .wb_src_sel_o   ( wb_src_sel_o ),       
    .illegal_instr_o( illegal_instr_o ),    
    .branch_o       ( branch_o ),           
    .jal_o          ( jal_o ),              
    .jalr_o         ( jalr_o )              
);
  
  RAM ram(
    .A_i  ( PC  ),
    .RD_o ( RD  )
  );

  logic [31:0] WD3_mux;
  
  wire [31:0] SW_E;
  assign SW_E = { {29{ 1'b0 }}, SW_i };
  
  assign WD3_mux = ( wb_src_sel_o ) ? ( `WB_LSU_DATA ) : ( `WB_EX_RESULT );

  wire [4:0] A1;
  assign A1 = RD[22:18];
  
  wire [4:0] A2;
  assign A2 = RD[17:13];
  
  wire [4:0] WA3;
  assign WA3 = RD[4:0];
  
  wire       WE3;
  assign WE3 = RD[29] | RD[28];

  RF rf(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .A1_i ( A1 ),
    .A2_i ( A2  ),
    .WA3_i( WA3 ),
    .WD3_i( WD3_mux ),
    .RD1_o( RD1 ),
    .RD2_o( RD2 ),
    .WE3_i( WE3 )
  );

  ALU_RISCV alu(
    .ALUOp ( ALUOp ),
    .A     ( RD1      ), 
    .B     ( RD2      ), 
    .Result( Result ), 
    .Flag  ( Flag   )
  ); 
endmodule
