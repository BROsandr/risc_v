`timescale 1ns / 1ps

module tb_miriscv_top();
  localparam  CLK_PERIOD = 20;
  localparam  RAM_SIZE   = 512;       // in 32-bit words

  reg         clk        = 0;
  reg         rst_n      = 0;

  
  int         number     = 4;
  
  reg [15:0]  result;
  
  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "prog.txt"         )
  ) dut (
    .clk_i          ( clk                ),
    .rst_n_i        ( rst_n              )
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
    
  initial
    begin
      input_number( number, 2 );
      @( posedge clk );
      reset; 
      @( posedge clk ); 
      
      repeat( 300 ) @( posedge clk );
      if( dut.core.rf.registers[4] )
        $display( "%d IS PRIME", number );
      else
        $display( "%d IS NOT PRIME", number );
      $finish;
    end

endmodule
