`include "constants.vh"

module ALU_RISCV(
  input  [4:0]  ALUOp,
  input  [31:0] A,
  input  [31:0] B,
  output [31:0] Result,
  output        Flag
);
  
  reg [31:0] Result_;
  reg        Flag_;
  
  assign Result = Result_;
  assign Flag = Flag_;
  
  always @( * ) begin
    case (ALUOp)
      `ALU_ADD: 
        begin
          Result_ = A + B;
          Flag_ = 0;
        end
      
      `ALU_SUB: 
        begin
          Result_ = A - B;
          Flag_ = 0;
        end
      
      `ALU_SLL: 
        begin
          Result_ = A << B;
          Flag_ = 0;
        end
      
      `ALU_SLTS: 
        begin
          Result_ = $signed(A) < $signed(B);
          Flag_ = 0;
        end
      
      `ALU_SLTU: 
        begin
          Result_ = A < B;
          Flag_ = 0;
        end
      
      `ALU_XOR: 
        begin
          Result_ = A ^ B;
          Flag_ = 0;
        end
      
      `ALU_SRL: 
        begin
          Result_ = A >> B;
          Flag_ = 0;
        end
      
      `ALU_SRA:
        begin
          Result_ = $signed(A) >>> B;
          Flag_ = 0;
        end
      
      `ALU_OR: 
        begin
          Result_ = A | B;
          Flag_ = 0;
        end
      
      `ALU_AND: 
        begin
          Result_ = A & B;
          Flag_ = 0;
        end
      
      // comparisons
      
      `ALU_EQ: 
        begin
          Flag_ = (A == B);
          Result_ = 0;
        end
      
      `ALU_NE: 
        begin
          Flag_ = (A != B);
          Result_ = 0;
        end
      
      `ALU_LTS: 
        begin
          Flag_ = $signed(A) < $signed(B);
          Result_ = 0;
        end
      
      `ALU_GES: 
        begin
          Flag_ = $signed(A) >= $signed(B);
          Result_ = 0;
        end
      
      `ALU_LTU: 
        begin
          Flag_ = A < B;
          Result_ = 0;
        end
      
      `ALU_GEU: 
        begin
          Flag_ = A >= B;
          Result_ = 0;
        end
        
      default:
        begin
        end
    endcase
  end
endmodule
