`timescale 1ns / 1ps

module tb_risc_v_lab4();

  reg         clk    = 0;
  reg         rst    = 0;
  
  reg [15:0]  result;
  
  reg         en     = 0;
  
  reg [2:0]   SW     = 1;
  
  int         number = 62;
  
  risc_v_lab4 risc_v_lab4(
    .clk_i( clk ),
    .rst_i( rst ),
    .en_i( en )
  );
  
  always
    #10 clk <= !clk;
  
  task reset;
    rst <= 0;
    @( posedge clk );  
    rst <= 1;
    @( posedge clk );  
    rst <= 0;
  endtask
    
  task input_number( input [11:0] number );
    logic [31:0] instruction;
    
    instruction <= { number, 5'b00000, 3'b000, 5'b00001, 7'b0010011 };
    @( posedge clk );
    { risc_v_lab4.instruction_memory.RAM[0], 
      risc_v_lab4.instruction_memory.RAM[1],
      risc_v_lab4.instruction_memory.RAM[2],
      risc_v_lab4.instruction_memory.RAM[3] } <= { instruction[7:0], instruction[15:8], instruction[23:16], instruction[31:24] };
  endtask  
    
  initial
    begin
      input_number( number );
      @( posedge clk );
      reset; 
      @( posedge clk ); 
      en <= 1;
      
      $display( "primitive device test" );
      #6000
      if( risc_v_lab4.rf.registers[4] )
        $display( "%d IS PRIME", number );
      else
        $display( "%d IS NOT PRIME", number );
      $finish;
    end

endmodule
