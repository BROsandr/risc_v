module data_memory(
  input         clk_i,
  input         rst_i,
  
  input  [31:0] A_i,
 
  input  [31:0] WD_i,
 
  output [31:0] RD_o,
 
  input         WE_i
);

  reg [7:0] mem [0:1023];
  
  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      for( int i = 0; i < 1024; ++i )
        mem[i] <= 0;
    else
      if( WE_i )
        { mem[A_i], mem[A_i + 1], mem[A_i + 2], mem[A_i + 3] } <= WD_i;
        
endmodule
