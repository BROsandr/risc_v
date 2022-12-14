`timescale 1ns / 1ps

module tb_lab7();
  localparam  CLK_PERIOD = 20;
  localparam  RAM_SIZE   = 2048;       // in 32-bit words

  reg         clk        = 0;
  reg         rst_n      = 0;

  
  int         number     = 4;
  
  reg [15:0]  result;

  logic [31:0] int_req;
  logic [31:0] int_fin;

  logic [6:0] seg;
  logic [3:0] an;
  logic [15:0] leds_out;
  
  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "prog.txt"         )
  ) dut (
    .clk_i          ( clk                ),
    .rst_n_i        ( rst_n              ),
    .leds_out_o( leds_out ),
    .seg_o( seg ),
    .an_o( an )
//    .int_req_i      ( int_req            ),
//    .int_fin_o      ( int_fin            )
  );

  
  always
    #( CLK_PERIOD / 2 ) clk <= !clk;
  
  task reset;
    rst_n <= 1;
    @( posedge clk );  
    rst_n <= 0;
    @( posedge clk );  
    rst_n <= 1;
  endtask
    
  initial
    begin
      for( int i = 0; i < 32; ++i ) 
        int_req[i] <= 0;
      @( posedge clk );
      reset; 
      @( posedge clk ); 
      
      #200000000;
      $finish;
    end

endmodule
