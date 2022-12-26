module leds_ctrl(
  (* mark_debug = "true" *)input               clk_i,
  (* mark_debug = "true" *)input               rst_i,

  (* mark_debug = "true" *)input  logic [31:0] wdata_i,
  (* mark_debug = "true" *)input  logic [31:0] addr_i,
  (* mark_debug = "true" *)input  logic [3:0]  be_i,
  (* mark_debug = "true" *)input  logic        we_i,

  (* mark_debug = "true" *)output logic [31:0] out_o
);

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      out_o <= 0;
    else if( we_i ) begin
      if( be_i[0] )
        out_o[7:0]  <= wdata_i[7:0];
      if( be_i[1] )
        out_o[15:8] <= wdata_i[15:8];
    end

endmodule