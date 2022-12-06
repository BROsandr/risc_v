`timescale 1ns / 1ps

module tb_interrupt();
  localparam  CLK_PERIOD = 20;
  localparam  RAM_SIZE   = 512;       // in 32-bit words

  reg         clk        = 0;
  reg         rst_n      = 0;

  
  int         number     = 4;
  
  reg [15:0]  result;
  
  logic [31:0] int_req;
  logic [31:0] int_fin;
  
  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "prog_mem_test.txt"         )
  ) dut (
    .clk_i          ( clk                ),
    .rst_n_i        ( rst_n              ),
    .int_req_i      ( int_req            ),
    .int_fin_o      ( int_fin            )
  );

  
  always
    #( CLK_PERIOD / 2 ) clk <= !clk;
  
  task reset;
    rst_n <= 0;
    @( posedge clk );  
    rst_n <= 1;
    @( posedge clk );  
    rst_n <= 0;
  endtask
  
    
  task interrupt( input int num );  
    dut.core.csr.mie_o[num] <= 1;
    dut.core.csr.mtvec_o <= 10;
    #2 int_req[num] <= 1;
  endtask
    
  initial
    begin
      @( posedge clk );
      reset; 
      repeat( 7 )
 @( posedge clk ); 
      interrupt( 15 );
      @( posedge clk ); 
      repeat( 300 ) @( posedge clk );
      $finish;
    end

endmodule
