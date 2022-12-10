module leds_ctrl(
  input               clk_i,
  input               rst_i,

  input  logic [31:0] wdata_i,
  input  logic [31:0] addr_i,
  input  logic [3:0]  be_i,
  input  logic        we_i,

  output logic [31:0] out_o
);

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      out_o <= 0;
    else if( we_i ) begin
      if( be_i[0] )
        out_o <= wdata_i[7:0];
      if( be_i[1] )
        out_o <= wdata_i[15:8];
    end

endmodule