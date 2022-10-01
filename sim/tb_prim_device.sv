`timescale 1ns / 1ps

module tb_prim_device();

  reg clk = 0;
  reg rst = 0;
  
  reg [31:0] result;
  
  reg en = 0;
  
  primitive_device primitive_device(
    .clk_i( clk ),
    .rst_i( rst ),
    .HEX_o( result ),
    .en_i ( en )
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
      @( posedge clk );
      @( posedge clk );
      #200
      $display( "result = %d", result );
    end

endmodule
