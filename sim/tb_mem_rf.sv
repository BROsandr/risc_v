`timescale 1ns / 1ps

module tb_mem_rf();

  reg clk = 0;
  reg rst = 0;
  
  reg  [8:0]  A;
  wire [31:0] RD;
  
  RAM ram(
    .A_i  ( A   ),
    .RD_o ( RD  )
  );
  
  always
    #10 clk = !clk;
  
  initial
    begin
      @( posedge clk ); 
      rst = 0;
      @( posedge clk );  
      rst = 1;
      @( posedge clk );  
      rst = 0;
    end
    
    
  initial
    begin
      @( negedge rst );
      @( posedge clk );
      $display( "ram_test" );
      for( int i = 40; i >= 0; --i )
        begin
          A = i;
          @( posedge clk );
          $display( "index = %d: data = %b", i, RD );
        end
    end

endmodule
