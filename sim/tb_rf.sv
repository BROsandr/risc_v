`timescale 1ns / 1ps

module tb_rf();

  reg clk = 0;
  reg rst = 0;
  
  reg [4:0]  A1;
  reg [4:0]  A2;
  reg [4:0]  WA3;
  
  reg [31:0] WD3;
  
  reg [31:0] RD1;
  reg [31:0] RD2;
  
  reg        WE3;
  
  
  
  RF rf(
    .clk_i( clk ),
    .rst_i( rst ),
    .A1_i ( A1  ),
    .A2_i ( A2  ),
    .WA3_i( WA3 ),
    .WD3_i( WD3 ),
    .RD1_o( RD1 ),
    .RD2_o( RD2 ),
    .WE3_i( WE3 )
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
   
  reg failed = 0;  
    
  initial
    begin
      @( negedge rst );
      @( posedge clk );
      $display( "rf_test" );
      for( int i = 31; i >= 0; --i )
        begin
          WA3 = i;
          WD3 = i;
          WE3 = 1;
          @( posedge clk );
          WE3 = 0;
          @( posedge clk );
        end
        
      for( int i = 31; i >= 0; --i )
        begin
          A1 = i;
          A2 = i;
          @( posedge clk );
          $display( "A1 = %d\nA2 = %d\nRD1 = %d\nRD2 = %d\ndata = %d\n", A1, A2, RD1, RD2, i );
          if( RD1 != i || RD2 != i )
            failed = 1;
        end
        
        if( failed )
          $display( "SOME TESTS FAILED" );
        else
          $display( "ALL TESTS SUCCESS" );
      end

endmodule
