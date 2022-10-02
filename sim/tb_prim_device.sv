`timescale 1ns / 1ps

module tb_prim_device();

  reg clk = 0;
  reg rst = 0;
  
  reg [31:0] result;
  
  reg en = 0;
  
  reg [2:0] SW = 7;
  
  wire done;
  
  primitive_device primitive_device(
    .clk_i( clk ),
    .rst_i( rst ),
    .HEX_o( result ),
    .en_i ( en ),
    .SW_i ( SW ),
    .done_o( done )
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
      en = 1;
      $display( "primitive device test" );
      @( posedge done );
      @( posedge clk );
      $display( "result = %d", result );
    end

endmodule
