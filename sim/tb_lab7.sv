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
  
  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "../ram/prog_int.txt"         )
  ) dut (
    .clk_i          ( clk                ),
    .rst_n_i        ( rst_n              )
    // .int_req_i      ( int_req            ),
    // .int_fin_o      ( int_fin            )
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
      
      #2000;
      $finish;
    end

endmodule
