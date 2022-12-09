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
    rst_n <= 0;
    @( posedge clk );  
    rst_n <= 1;
    @( posedge clk );  
    rst_n <= 0;
  endtask
    
  task input_number( input [11:0] number, input [4:0] rd = 1 );
    logic [31:0] instruction;
    instruction    <= { number, 5'b00000, 3'b000, rd, 7'b0010011 };
    @( posedge clk );
    dut.ram.mem[0] <= { instruction[31:24], instruction[23:16], instruction[15:8], instruction[7:0] };
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
    @( negedge rst_n );
    forever begin
      @( dut.core.rf.registers[28] );
      $display( "%d interrupt detected", dut.core.rf.registers[28] );
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
      
      #500;
      interrupt( 5 );
      #100;
      interrupt( 3 );
      #500;
      interrupt( 2 );
      #2000;
      $finish;
    end

endmodule
