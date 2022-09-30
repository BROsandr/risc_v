`timescale 1ns / 1ps

module tb_mem_rf();

  reg clk = 0;
  
  reg  [8:0]  A;
  wire [31:0] RD;
  
  RAM ram(
    .clk_i( clk ),
    .A_i  ( A   ),
    .RD_o ( RD  )
  );
  
  always @( * )
    #10 clk = !clk;
    
  initial
    begin
      $display( "ram_test" );
      for( int i = 0; i < 255; i++ )
        begin
          A = i;
          $display( "index = %d: data = %d", i, RD );
        end
    end

endmodule
