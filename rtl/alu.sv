`include "../common/defines_riscv.v"

module ALU_RISCV(
  input      [4:0]  ALUOp,
  input      [31:0] A,
  input      [31:0] B,
  output reg [31:0] Result,
  output reg        Flag
);
  
  always @( * ) begin
    case (ALUOp)
      `ALU_ADD: 
        begin
          Result = A + B;
          Flag = 0;
        end
      
      `ALU_SUB: 
        begin
          Result = A - B;
          Flag = 0;
        end
      
      `ALU_SLL: 
        begin
          Result = A << B;
          Flag = 0;
        end
      
      `ALU_SLTS: 
        begin
          Result = $signed(A) < $signed(B);
          Flag = 0;
        end
      
      `ALU_SLTU: 
        begin
          Result = A < B;
          Flag = 0;
        end
      
      `ALU_XOR: 
        begin
          Result = A ^ B;
          Flag = 0;
        end
      
      `ALU_SRL: 
        begin
          Result = A >> B;
          Flag = 0;
        end
      
      `ALU_SRA:
        begin
          Result = $signed(A) >>> B;
          Flag = 0;
        end
      
      `ALU_OR: 
        begin
          Result = A | B;
          Flag = 0;
        end
      
      `ALU_AND: 
        begin
          Result = A & B;
          Flag = 0;
        end
      
      // comparisons
      
      `ALU_EQ: 
        begin
          Flag = (A == B);
          Result = 0;
        end
      
      `ALU_NE: 
        begin
          Flag = (A != B);
          Result = 0;
        end
      
      `ALU_LTS: 
        begin
          Flag = $signed(A) < $signed(B);
          Result = 0;
        end
      
      `ALU_GES: 
        begin
          Flag = $signed(A) >= $signed(B);
          Result = 0;
        end
      
      `ALU_LTU: 
        begin
          Flag = A < B;
          Result = 0;
        end
      
      `ALU_GEU: 
        begin
          Flag = A >= B;
          Result = 0;
        end
        
      default:
        begin
          Flag   = 0;
          Result = 0;
        end
    endcase
  end
endmodule
