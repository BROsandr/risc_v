module hex_ctrl(
  input              clk_i,
  input              rst_i,

  input  logic [31:0] wdata_i,
  input  logic [31:0] addr_i,
  input  logic [3:0]  be_i,
  input  logic        we_i,

  output logic [6:0]  seg_o,
  output logic [3:0]  an_o,
  output logic [31:0] out_o
);

  logic [15:0] displayed_number;

  logic [3:0]  mask;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      displayed_number <= 0;
    else if( we_i && addr_i[3] == 0 ) begin
      if( be_i == 4'b0001 )
        displayed_number[3:0]   <= wdata_i[3:0];
      if( be_i == 4'b0010 )  
        displayed_number[7:4]   <= wdata_i[7:4];
      if( be_i == 4'b0100 )
        displayed_number[11:8]  <= wdata_i[11:8];
      if( be_i == 4'b1000 )
        displayed_number[15:12] <= wdata_i[15:12];
    end

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      displayed_number          <= 0;
    else begin
      if( mask == 4'b1110 )
        displayed_number[3:0]   <= 0;
      if( mask == 4'b1101 )  
        displayed_number[7:4]   <= 0;
      if( mask == 4'b1011 )
        displayed_number[11:8]  <= 0;
      if( mask == 4'b0111 )
        displayed_number[15:12] <= 0;
    end

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      mask <= 0;
    else if( we_i && addr_i[3] == 1 )
      mask <= wdata_i[3:0];

  Seven_segment_LED_Display_Controller Seven_segment_LED_Display_Controller(
    .clock_100Mhz( clk_i ), // 100 Mhz clock source on Basys 3 FPGA
    .reset( rst_i ), // reset
    .displayed_number_i( displayed_number ),
    
    .AN( an_o ), // anode signals of the 7-segment LED display
    .SEG( seg_o )// cathode patterns of the 7-segment LED display
  );

endmodule