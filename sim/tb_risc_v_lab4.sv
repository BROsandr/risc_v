`timescale 1ns / 1ps

module tb_prim_device();

  reg clk = 0;
  reg rst = 0;
  
  reg [15:0] result;
  
  reg en = 0;
  
  reg [2:0] SW = 1;
  
  risc_v_lab4 risc_v_lab4(
    .clk_i( clk ),
    .rst_i( rst ),
    .en_i( en )
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
      #6000
      $display( "result = %d", risc_v_lab4.rf.registers[4] );
      $finish;
    end

endmodule
