`include "../common/defines_riscv.v"

module decoder_riscv (
  input       [31:0]  fetched_instr_i,
  input               lsu_stall_req_i,
  input               INT_i,
  output  reg [1:0]   ex_op_a_sel_o,      
  output  reg [2:0]   ex_op_b_sel_o,      
  output  reg [4:0]   alu_op_o,           
  output  reg         mem_req_o,          
  output  reg         mem_we_o,           
  output  reg [2:0]   mem_size_o,         
  output  reg         gpr_we_a_o,         
  output  reg         wb_src_sel_o,       
  output  reg         illegal_instr_o,    
  output  reg         branch_o,           
  output  reg         jal_o,              
  output  reg [1:0]   jalr_o,
  output              enpc_o,
  output  logic       INT_RST_o,
  output  logic       csr_o,
  output  logic       CSRop_o 
);
  localparam FUNCT7_1 = 7'b0100000,
             FUNCT7_0 = 7'b0000000;


  wire [6:0] opcode;
  assign     opcode = fetched_instr_i[6:0];
  
  wire [2:0] funct3;
  assign     funct3 = fetched_instr_i[14:12];
  
  wire [6:0] funct7;
  assign     funct7 = fetched_instr_i[31:25];

  assign     enpc_o = !lsu_stall_req_i;

  always_comb
    case( opcode )
      { `LOAD_OPCODE, 2'b11 }: begin
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
      
      { `MISC_MEM_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_IMM_I;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 0;
        wb_src_sel_o      = `WB_LSU_DATA;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
      end
      
      { `OP_IMM_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_IMM_I;
        alu_op_o          = { 2'b00, funct3 };
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;    
        
        if( alu_op_o == `ALU_SRL && funct7 == FUNCT7_1 )
            alu_op_o          = { 2'b01, funct3 };  
                      
        if( alu_op_o == `ALU_SLL ||
            alu_op_o == `ALU_SRL ) begin
          if( funct7 != FUNCT7_0 )
            illegal_instr_o = 1;
        end else
          if( alu_op_o == `ALU_SRA )
            if( funct7 != FUNCT7_1 )
              illegal_instr_o = 1;
      end  
      
      { `AUIPC_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_CURR_PC;   
        ex_op_b_sel_o     = `OP_B_IMM_U;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
      end  
      
      { `STORE_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_IMM_S;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 1;
        mem_we_o          = 1;
        mem_size_o        = funct3;
        gpr_we_a_o        = 0;
        wb_src_sel_o      = `WB_LSU_DATA;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
        
        if( funct3 != `LDST_B  &&
            funct3 != `LDST_H  &&
            funct3 != `LDST_W ) begin
          illegal_instr_o = 1;
          mem_size_o = `LDST_B;
        end
      end 
      
      { `OP_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_RS2;
        alu_op_o          = { 2'b00, funct3 };
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
        
        if( funct7 == FUNCT7_1 )
          alu_op_o          = { 2'b01, funct3 };
        
        if( funct7 == FUNCT7_1 ) begin
          if( funct3 != 3'b000 &&
              funct3 != 3'b101 )
            illegal_instr_o   = 1;
        end else
          if( funct7 != FUNCT7_0 )
            illegal_instr_o   = 1;
      end
             
      { `LUI_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_ZERO ;   
        ex_op_b_sel_o     = `OP_B_IMM_U;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
      end  
           
      { `BRANCH_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_RS1;   
        ex_op_b_sel_o     = `OP_B_RS2;
        alu_op_o          = { 2'b11, funct3 };
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 0;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 1;
        jal_o             = 0;
        jalr_o            = 0;
        
        if( funct3 == 3'b011 ||
            funct3 == 3'b010 ) begin
          illegal_instr_o   = 1;
          alu_op_o          = `ALU_EQ;
        end
      end    
      
      { `JALR_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_CURR_PC;   
        ex_op_b_sel_o     = `OP_B_INCR;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 1;
        
        if( funct3 != 3'b000 ) begin
          illegal_instr_o   = 1;
        end
      end
            
      { `JAL_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_CURR_PC;   
        ex_op_b_sel_o     = `OP_B_INCR;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 1;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 1;
        jalr_o            = 0;
      end    
      
      { `SYSTEM_OPCODE, 2'b11 }: begin
        ex_op_a_sel_o     = `OP_A_CURR_PC;   
        ex_op_b_sel_o     = `OP_B_INCR;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 0;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 0;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;   

        if( fetched_instr_i[31:7] == { 25{ 1'b0 } } || 
            fetched_instr_i[31:7] == { { 11{ 1'b0 } }, 1'b1 } ) begin
          illegal_instr_o   = 1;
        end 
      end

      default: begin
        ex_op_a_sel_o     = `OP_A_CURR_PC;   
        ex_op_b_sel_o     = `OP_B_IMM_U;
        alu_op_o          = `ALU_ADD;
        mem_req_o         = 0;
        mem_we_o          = 0;
        mem_size_o        = `LDST_B;
        gpr_we_a_o        = 0;
        wb_src_sel_o      = `WB_EX_RESULT;
        illegal_instr_o   = 1;
        branch_o          = 0;
        jal_o             = 0;
        jalr_o            = 0;
      end
    endcase

endmodule