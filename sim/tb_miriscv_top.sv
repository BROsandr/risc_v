`timescale 1ns / 1ps

module tb_miriscv_top();
  localparam  CLK_PERIOD = 20;
  localparam  RAM_SIZE   = 512;       // in 32-bit words

  reg         clk        = 0;
  reg         rst_n      = 0;

  
  int         number     = 62;
  
  reg [15:0]  result;
  
  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "prog.txt"         )
  ) dut (
    .clk_i    ( clk   ),
    .rst_n_i  ( rst_n )
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
    
  task input_number( input [11:0] number );
    logic [31:0] instruction;
    
    instruction <= { number, 5'b00000, 3'b000, 5'b00001, 7'b0010011 };
    @( posedge clk );
    { dut.ram.mem[0], 
      dut.ram.mem[1],
      dut.ram.mem[2],
      dut.ram.mem[3] } <= { instruction[7:0], instruction[15:8], instruction[23:16], instruction[31:24] };
  endtask  
    
  initial
    begin
      input_number( number );
      @( posedge clk );
      reset; 
      @( posedge clk ); 
      
      $display( "primitive device test" );
      repeat( 300 ) @( posedge clk );
      if( dut.core.rf.registers[4] )
        $display( "%d IS PRIME", number );
      else
        $display( "%d IS NOT PRIME", number );
      $finish;
    end

endmodule