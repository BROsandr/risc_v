module csr(
  input clk_i,
  input  [31:0] mcause_i,
  input  [31:0] PC_i,
  input  [11:0] A_i,
  input  [31:0] WD_i,
  input  [2:0]  OP_i,

  output [31:0] mie_o,
  output [31:0] mtvec_o,
  output [31:0] mepc_o,
  output [31:0] RD_o
);
endmodule
