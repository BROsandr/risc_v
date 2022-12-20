module sw_ctrl(
  input  logic         clk_i,
  input  logic         rst_i,

  (* mark_debug = "true" *)input  logic  [15:0] in_i,
  (* mark_debug = "true" *)output logic  [31:0] out_o,

  (* mark_debug = "true" *)output logic  [31:0] int_req_o,
  (* mark_debug = "true" *)input  logic  [31:0] int_fin_i,
  (* mark_debug = "true" *)output logic error_o
);
  (* mark_debug = "true" *)logic  [15:0] in_curr;

  (* mark_debug = "true" *)logic  [15:0] in_prev;
  (* mark_debug = "true" *)logic         int_req;
  (* mark_debug = "true" *)logic         int_fin;

  (* mark_debug = "true" *)logic  [15:0] in_debounced;
  assign        in_debounced = in_i;

  assign        int_req_o[0] = int_req;
  assign        int_fin      = int_fin_i[0];

  assign        out_o[15:0]  = in_debounced;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      in_curr <= 0;
    else
      in_curr <= in_debounced;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      in_prev <= 0;
    else
      in_prev <= in_curr;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      error_o <= 0;
    else if( in_curr != in_prev && int_req )
      error_o <= 1;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      int_req <= 0;
    else if( int_fin )
      int_req <= 0;
    else if( in_curr != in_prev )
      int_req <= 1;

endmodule

