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

  logic        mscratch;

  logic        mie_en;
  logic        mtvec_en;
  logic        mscratch_en;
  logic        mepc_en;
  logic        mcause_en;

  logic [31:0] csr_write_expr;

  logic        en            [0:4];

  assign mie_en      = en[0];
  assign mtvec_en    = en[1];
  assign mscratch_en = en[2];
  assign mepc_en     = en[3];
  assign mcause_en   = en[4];

  always_comb
    unique case( A_i ) inside 
      'h304  : RD_o = mie_o;
      'h305  : RD_o = mtvec_o;
      'h340  : RD_o = mscratch; 
      'h341  : RD_o = mepc_o;
      'h342  : RD_o = mcause_o;

      default: RD_o = 0;
    endcase

    always_comb
      for( int i = 0; i < 5; ++i )
        en[i] = ( A_i == i ) ? ( OP_i[1] & OP_i[0] ) : ( 0 );

    always_comb
      unique case( OP_i[1:0] ) inside
        0      : csr_write_expr = 0;
        1      : csr_write_expr = WD_i;
        2      : csr_write_expr = RD_o & ~WD_i;
        3      : csr_write_expr = RD_o |  WD_i;

        default: csr_write_expr = 0;
      endcase

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mie_o <= 0;
      else if( mie_en )
        mie_o <= csr_write_expr;

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mtvec_o <= 0;
      else if( mtvec_en )
        mtvec_o <= csr_write_expr;

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mscratch <= 0;
      else if( mscratch_en )
        mscratch <= csr_write_expr;

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mepc_o <= 0;
      else if( mepc_en | OP_i[2] )
        mepc_o <= ( OP_i[2] ) ? ( PC_i ) : ( csr_write_expr );

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mcause_o <= 0;
      else if( mcause_en | OP_i[2] )
        mcause_o <= ( OP_i[2] ) ? ( mcause_i ) : ( csr_write_expr );
endmodule
