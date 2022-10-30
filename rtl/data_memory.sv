module data_memory(
  input         clk_i,
  input         rst_i,
  
  input  [31:0] A_i,
 
  input  [31:0] WD_i,
 
  output [31:0] RD_o,
 
  input         WE_i
);

  reg [7:0] mem [0:1023];
  
  wire      virtual_address;
  assign    virtual_address = A_i - 32'h88000000;
  
  assign RD_o = ( A_i >= 32'h88000000 && A_i <= 32'h880003FC ) ? ( mem[virtual_address] ) : ( 0 );
  
  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      for( int i = 0; i < 1024; ++i )
        mem[i] <= 0;
    else
      if( WE_i )
        if( A_i >= 32'h88000000 && A_i <= 32'h880003FC )
          { mem[virtual_address + 3], mem[virtual_address + 2], mem[virtual_address + 1], mem[virtual_address] } <= WD_i;
        
endmodule
