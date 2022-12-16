// fpga4student.com: FPGA projects, Verilog projects, VHDL projects
// FPGA tutorial: seven-segment LED display controller on Basys  3 FPGA
module Seven_segment_LED_Display_Controller(
    input clk_i, // 100 Mhz clock source on Basys 3 FPGA
    input rst_i, // reset
    input logic [15:0] displayed_number_i,
    
    output reg [3:0] AN, // anode signals of the 7-segment LED display
    output reg [6:0] SEG// cathode patterns of the 7-segment LED display
    );
    logic        tick;
    
    logic [3:0]  LED_BCD;
    logic [18:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             
    always_ff @(posedge clk_i or posedge rst_i)
      if( rst_i == 1 )
        refresh_counter <= 0;
      else
        refresh_counter <= refresh_counter + 1;

    assign       tick = &refresh_counter;

    always_ff @( posedge clk_i or posedge rst_i )
      if( rst_i )
        AN <= 4'b0111;
      else if( tick )
        AN <= { AN[0], AN[3:1] };

    always_comb
      case(AN)
        4'b0111: LED_BCD = displayed_number_i[15:12];
        4'b1011: LED_BCD = displayed_number_i[11:8];
        4'b1101: LED_BCD = displayed_number_i[7:4];
        4'b1110: LED_BCD = displayed_number_i[3:0];

        default: LED_BCD = 4'b1111;
      endcase

  always_comb
    case(LED_BCD)
      4'b0000: SEG = 7'b0000001; // "0"     
      4'b0001: SEG = 7'b1001111; // "1" 
      4'b0010: SEG = 7'b0010010; // "2" 
      4'b0011: SEG = 7'b0000110; // "3" 
      4'b0100: SEG = 7'b1001100; // "4" 
      4'b0101: SEG = 7'b0100100; // "5" 
      4'b0110: SEG = 7'b0100000; // "6" 
      4'b0111: SEG = 7'b0001111; // "7" 
      4'b1000: SEG = 7'b0000000; // "8"     
      4'b1001: SEG = 7'b0000100; // "9" 
      4'b1111: SEG = 7'b1111111; // off
      default: SEG = 7'b0000001; // "0"
    endcase
endmodule