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

  logic en[0:4];

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
    unique case( A_i ) inside 
      'h304  : begin 
        en[0]        = OP_i[1] & OP_i[0];
        en[1]        = 0;
        en[2]        = 0;
        en[3]        = 0;
        en[4]        = 0;
      end

      'h305  : begin
        en[0]        = 0;
        en[1]        = OP_i[1] & OP_i[0];
        en[2]        = 0;
        en[3]        = 0;
        en[4]        = 0;
      end

      'h340  : begin
        en[0]        = 0;
        en[1]        = 0;
        en[2]        = OP_i[1] & OP_i[0];
        en[3]        = 0;
        en[4]        = 0;
      end
      'h341  : begin
        en[0]        = 0;
        en[1]        = 0;
        en[2]        = 0;
        en[3]        = OP_i[1] & OP_i[0];
        en[4]        = 0;
      end
      'h342  : begin
        en[0]        = 0;
        en[1]        = 0;
        en[2]        = 0;
        en[3]        = 0;
        en[4]        = OP_i[1] & OP_i[0];
      end

      default: begin
        en[0]        = 0;
        en[1]        = 0;
        en[2]        = 0;
        en[3]        = 0;
        en[4]        = 0;
      end
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
        mscratch <= 0;
      else if( mepc_en | OP_i[2] )
        mscratch <= ( OP_i[2] ) ? ( PC_i ) : ( csr_write_expr );

    always_ff @(posedge clk_i or posedge rst_i )
      if( rst_i )
        mcause_o <= 0;
      else if( mcause_en | OP_i[2] )
        mcause_o <= ( OP_i[2] ) ? ( mcause_i ) : ( csr_write_expr );
endmodule
