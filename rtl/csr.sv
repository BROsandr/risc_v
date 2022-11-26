module csr(
  input               clk_i,
  input        [31:0] mcause_i,
  input        [31:0] PC_i,
  input        [11:0] A_i,
  input        [31:0] WD_i,
  input        [2:0]  OP_i,

  output logic [31:0] mie_o,
  output logic [31:0] mtvec_o,
  output logic [31:0] mepc_o,
  output logic [31:0] mcause_o,
  output logic [31:0] RD_o
);

  logic mscratch;

  always_comb
    unique case( A ) inside 
      'h304  : RD = mie_o;
      'h305  : RD = mtvec_o;
      'h340  : RD = mscratch; 
      'h341  : RD = mepc_o;
      'h342  : RD = mcause_o;

      default: RD = 0;
    endcase


endmodule
