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
    .rst_n_i        ( rst_n              ),
    .int_req_i      ( int_req            ),
    .int_fin_o      ( int_fin            )
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

  task interrupt( input int num );  
    // simulation int trigger at random time
    #2 int_req[num] <= 1;
  endtask

  initial
    forever begin
      @( posedge clk );
      if( int_fin )
        int_req <= ~int_fin & int_req;
    end

  initial begin
    logic [30:0] int_num;
    @( negedge rst_n );
    forever begin
      @( dut.core.rf.registers[28] );
      int_num = dut.core.rf.registers[28];
      $display( "%d interrupt detected", int_num );
    end
  end
    
  initial
    begin
      for( int i = 0; i < 32; ++i ) 
        int_req[i] <= 0;
      // input_number( number, 2 );
      @( posedge clk );
      reset; 
      @( posedge clk ); 
      
      #5000;
      interrupt( 5 );
      #1000;
      interrupt( 0 );
      #1500;
      interrupt( 4 );
      #2000;
      interrupt( 15 );
      #1000;
      $finish;
    end

endmodule
