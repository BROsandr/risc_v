module RF(
  input         clk_i,
  input         rst_i,
  
  input  [4:0]  A1_i,
  input  [4:0]  A2_i,
  input  [4:0]  WA3_i,
  
  input  [31:0] WD3_i,
  
  output [31:0] RD1_o,
  output [31:0] RD2_o,
  
  input         WE3_i
);

  reg [31:0] registers [0:31];
  
  assign RD1_o = ( A1_i ) ? ( registers[A1_i] ) : ( 0 );
  assign RD2_o = ( A2_i ) ? ( registers[A2_i] ) : ( 0 );
  
  always @( posedge clk_i )
    if( rst_i )
      for( int i = 0; i < 32; ++i )
        registers[i] <= 0;
    else
      if( WE3_i )
        registers[WA3_i] <= WD3_i;
endmodule
