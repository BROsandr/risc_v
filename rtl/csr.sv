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

  logic to_mie;
  logic to_mtvec;
  logic to_mscratch;
  logic to_mepc;
  logic to_mcause;

  always_comb
    unique case( A ) inside 
      'h304  : RD = mie_o;
      'h305  : RD = mtvec_o;
      'h340  : RD = mscratch; 
      'h341  : RD = mepc_o;
      'h342  : RD = mcause_o;

      default: RD = 0;
    endcase

  always_comb
    unique case( A ) inside 
      'h304  : to_mie      = OP_i[1] & OP_i[0];
      'h305  : to_mtvec    = OP_i[1] & OP_i[0];
      'h340  : to_mscratch = OP_i[1] & OP_i[0]; 
      'h341  : to_mepc     = OP_i[1] & OP_i[0];
      'h342  : to_mcause   = OP_i[1] & OP_i[0];

      default: begin
        to_mie      = 0;
        to_mtvec    = 0;
        to_mscratch = 0;
        to_mepc     = 0;
        to_mcause   = 0;
      end
    endcase

endmodule
