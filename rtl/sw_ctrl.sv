module sw_ctrl(
  input  logic clk_i,
  input  logic rst_i,

  input  logic [15:0] in_i,
  output logic [31:0] out_o
);

  assign out_o[15:0] = in_i;


endmodule

