module csr(
  input               clk_i,
  input               rst_i,
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

  logic mie_en;
  logic mtvec_en;
  logic mscratch_en;
  logic mepc_en;
  logic mcause_en;

  logic csr_write_expr;

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
      'h304  : mie_en      = OP_i[1] & OP_i[0];
      'h305  : mtvec_en    = OP_i[1] & OP_i[0];
      'h340  : mscratch_en = OP_i[1] & OP_i[0]; 
      'h341  : mepc_en     = OP_i[1] & OP_i[0];
      'h342  : mcause_en   = OP_i[1] & OP_i[0];

      default: begin
        mie_en             = 0;
        mtvec_en           = 0;
        mscratch_en        = 0;
        mepc_en            = 0;
        mcause_en          = 0;
      end
    endcase

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mie_o <= 0;
      else if( mie_en )
        mie_o <= csr_write_expr;

endmodule
