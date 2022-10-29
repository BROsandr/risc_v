module instruction_memory(
  input  [31:0] A_i,
  
  output [31:0] RD_o
);

  reg [7:0] RAM [0:1023];
  assign RD_o = { RAM[A_i + 3], RAM[A_i + 2], RAM[A_i + 1], RAM[A_i] };
  
  initial
    $readmemh( "prog.txt", RAM );
endmodule
