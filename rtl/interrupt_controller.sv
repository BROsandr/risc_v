module interrupt_controller(
  input         clk_i,
  input         rst_i,
  input  [31:0] int_req,
  input  [31:0] mie,
  input         INT_RST,

  output        INT,
  output [31:0] int_fin,
  output [31:0] mcause
);
endmodule
