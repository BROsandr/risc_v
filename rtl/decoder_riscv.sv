`include "../common/defines_riscv.v"

module decoder_riscv (
  input       [31:0]  fetched_instr_i,
  output  reg [1:0]   ex_op_a_sel_o,      // ?????? ??????? ??????????,
  output  reg [2:0]   ex_op_b_sel_o,      // ?????? ??? ??? ?????????? 
  output  reg [4:0]   alu_op_o,           // ????? ?????????????? ??????
  output  reg         mem_req_o,          // ????????? ?????? ????? 
  output  reg         mem_we_o,           // always, ? ????? ?? ????? ?????
  output  reg [2:0]   mem_size_o,         // ?????? always ?????? ??????
  output  reg         gpr_we_a_o,         // ?????? ?????? ????????,
  output  reg         wb_src_sel_o,       // ???? ???? ? ????? ?????
  output  reg         illegal_instr_o,    // ??????????? ?
  output  reg         branch_o,           // ????????????? ??????????
  output  reg         jal_o,              // ??? ??????
  output  reg         jalr_o              // 
);

  wire [4:0] opcode;
  assign opcode = fetched_instr_i[6:2];
  
  wire [2:0] funct3;
  assign funct3 = fetched_instr_i[14:12];

  always_comb begin
//    ex_op_a_sel_o     = `OP_A_RS1;   
//    ex_op_b_sel_o     = `OP_B_IMM_I;
//    alu_op_o          = `ALU_ADD;
//    mem_req_o         = 0;
//    mem_we_o          = 0;
//    mem_size_o        = `LDST_B;
//    gpr_we_a_o        = 0;
//    wb_src_sel_o      = `WB_EX_RESULT;
//    illegal_instr_o   = 0;
//    branch_o          = 0;
//    jal_o             = 0;
//    jalr_o            = 0;
    
    case( opcode )
      `LOAD_OPCODE: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_IMM_I;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 1;
        mem_we_o          = 0;
        mem_size_o        = funct3;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_LSU_DATA;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
        
        if( funct3 != `LDST_B  &&
            funct3 != `LDST_H  &&
            funct3 != `LDST_W  &&
            funct3 != `LDST_BU &&
            funct3 != `LDST_HU ) begin
          illegal_instr_o = 1;
          mem_size_o = `LDST_B;
        end
      end
      
      `MISC_MEM_OPCODE: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_IMM_I;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = funct3;
        gpr_we_a_o        = 0;
        wb_src_sel_o      = `WB_LSU_DATA;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
      end
      
      `OP_IMM_OPCODE: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_IMM_I;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = funct3;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
      end  
//      `AUIPC_OPCODE   
//      `STORE_OPCODE   
//      `OP_OPCODE      
//      `LUI_OPCODE     
//      `BRANCH_OPCODE  
//      `JALR_OPCODE    
//      `JAL_OPCODE     
//      `SYSTEM_OPCODE  
    endcase
  end
          


// ??? ???? ??? ????????
//  end
endmodule