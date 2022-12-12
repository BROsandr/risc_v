`timescale 1ns / 1ps

module tb_int_prog();
  localparam  CLK_PERIOD = 20;
  localparam  RAM_SIZE   = 512;       // in 32-bit words

  reg         clk        = 0;
  reg         rst_n      = 0;

  
  int         number     = 4;
  
  reg [15:0]  result;

  logic [31:0] int_req;
  logic [31:0] int_fin;
  
  logic [31:0] r1;
  
  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "prog.txt"         )
  ) dut (
    .clk_i          ( clk                ),
    .rst_n_i        ( rst_n              ),
    .int_req_i      ( int_req            ),
    .int_fin_o      ( int_fin            ),
    .r1_o( r1 )
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
      reset;
    
      #1000;
      $finish;
    end

endmodule
