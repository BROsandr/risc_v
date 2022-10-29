`include "../common/defines_riscv.v"

module risc_v_lab4(
  input clk_i,
  input rst_i,
  
  input en_i,
  
  output [15:0] OUT_o,
  
  input  [2:0]  SW_i
);
  logic [31:0] RD1;
  assign       OUT_o = RD1;
  
  logic [31:0] RD2;

  logic [31:0] RD;
  
  logic [31:0] instr;
  assign       instr = RD;
  
  logic [31:0] Result;
  logic        comp;
  
  logic [31:0] imm_I;
  assign       imm_I = { { 21{instr[31]} },  instr[30:20] };

  logic [31:0] imm_S;
  assign       imm_S = { { 21{instr[31]} },  instr[30:25], instr[11:7] };  
  
  logic [31:0] imm_J;
  assign       imm_J = { { 13{instr[31]} },  instr[19:12], instr[20], instr[30:21] };    
  
  logic [31:0] imm_B;
  assign       imm_B = { { 13{instr[31]} },  instr[7], instr[30:25], instr[11:8] };    
  
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
  
  logic        A;
  logic        B;
  
  logic        WD3;
  assign       WD3 = ( wb_src_sel ) ? ( `WB_LSU_DATA ) : ( `WB_EX_RESULT );
  
  logic [31:0] SW_E;
  assign       SW_E = { {29{ 1'b0 }}, SW_i };
  
  logic [31:0] PC;
  
  logic [31:0] add_to_PC;
  assign       add_to_PC = ( ( comp & branch ) | jal  ) ? ( ( branch ) ? ( imm_B ) : ( imm_J ) ) : ( 4 );
  
  logic [4:0]  A1;
  assign       A1  = instr[19:15];
  
  logic [4:0]  A2;
  assign       A2  = instr[24:20];
  
  logic [4:0]  WA3;
  assign       WA3 = instr[11:7];    
  
  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      PC <= 0;
    else
      if( en_i )
        PC <= PC + add_to_PC;      
  
  decoder_riscv decoder_riscv (
    .fetched_instr_i( RD ),
    .ex_op_a_sel_o  ( ex_op_a_sel ),      
    .ex_op_b_sel_o  ( ex_op_b_sel ),      
    .alu_op_o       ( alu_op ),           
    .mem_req_o      ( mem_req ),          
    .mem_we_o       ( mem_we ),           
    .mem_size_o     ( mem_size ),         
    .gpr_we_a_o     ( gpr_we_a ),         
    .wb_src_sel_o   ( wb_src_sel ),       
    .illegal_instr_o( illegal_instr ),    
    .branch_o       ( branch ),           
    .jal_o          ( jal ),              
    .jalr_o         ( jalr )              
  );
  
  instruction_memory instruction_memory(
    .A_i  ( PC  ),
    .RD_o ( RD  )
  );
  
  always_comb
    case( ex_op_a_sel )
      `OP_A_RS1    : A = RD1;  
      `OP_A_CURR_PC: A = PC;
      `OP_A_ZERO   : A = 0;
    endcase
    
  always_comb
    case( ex_op_b_sel )
      `OP_B_RS2  :   B = RD2;  
      `OP_B_IMM_U:   B = { instr[31:12], { 12{1'b0} } };
      `OP_B_IMM_S:   B = imm_S;
      `OP_B_INCR :   B = 4;
    endcase  

  RF rf(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .A1_i ( A1 ),
    .A2_i ( A2  ),
    .WA3_i( WA3 ),
    .WD3_i( WD3 ),
    .RD1_o( RD1 ),
    .RD2_o( RD2 ),
    .WE3_i( gpr_we_a )
  );

  ALU_RISCV alu(
    .ALUOp ( alu_op ),
    .A     ( A      ), 
    .B     ( B      ), 
    .Result( Result ), 
    .Flag  ( comp   )
  ); 
  
  data_memory data_memory(
    .clk_i ( clk_i ),
    .rst
    
    .WD( RD2 ),
    .A ( Result ),
    
endmodule
