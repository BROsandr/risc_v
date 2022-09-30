module RAM(
  input         clk_i,
  
  input  [8:0]  A_i,
  
  output [31:0] RD_o
);

  reg [7:0] RAM [0:255];
  assign RD_o = {RAM[A_i + 3], RAM[A_i + 2], RAM[A_i + 1], RAM[A_i] };
  
  initial
    $readmemb( "ram", RAM );
endmodule
