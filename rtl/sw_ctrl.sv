module sw_ctrl(
  input  logic         clk_i,
  input  logic         rst_i,

  input  logic  [15:0] in_i,
  output logic  [31:0] out_o,

  output logic  [31:0] int_req_o,
  input  logic  [31:0] int_fin_i
);
  logic  [15:0] in_prev;
  logic         int_req;
  logic         int_fin;

  logic  [15:0] in_debounced;

  assign        int_req_o[0] = int_req;
  assign        int_fin      = int_fin_i[0];

  assign        out_o[15:0]  = in_debounced;

genvar i;
generate
  for( i = 0; i < 16; ++i )
    debouncing debouncing(
      .clock( clk_i ),
      .reset( rst_i ),
      .button( in_i[i] ),
      .out( in_debounced[i] )
    );
endgenerate

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      in_prev <= 0;
    else
      in_prev <= in_debounced;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      int_req <= 0;
    else if( int_fin )
      int_req <= 0;
    else if( in_debounced != in_prev )
      int_req <= 1;

endmodule

