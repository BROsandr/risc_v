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
  // logic [15:0] displayed_number_masked;

  // logic [3:0]  an_enable;

  // logic [15:0] displayed_number_selected;

  // logic [7:0]  selection;

  // logic [26:0] one_second_counter; // counter for generating 1 second clock enable
  // logic        one_second_enable;// one second enable for counting numbers

  // logic [7:0]  reset;

  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i ) 
  //     displayed_number_selected            <= 0;
  //   else if( selection == 8'hFF )
  //     displayed_number_selected            <= displayed_number_masked;
  //   else
  //     case( selection )
  //       0: begin
  //         displayed_number_selected[3:0]   <= ( one_second_enable ) ? ( displayed_number_masked[3:0] ) : ( 4'b1111 );
  //         displayed_number_selected[7:4]   <= displayed_number_masked[7:4];
  //         displayed_number_selected[11:8]  <= displayed_number_masked[11:8];
  //         displayed_number_selected[15:12] <= displayed_number_masked[15:12];
  //       end

  //       1: begin
  //         displayed_number_selected[3:0]   <= displayed_number_masked[3:0];
  //         displayed_number_selected[7:4]   <= ( one_second_enable ) ? ( displayed_number_masked[7:4] ) : ( 4'b1111 );
  //         displayed_number_selected[11:8]  <= displayed_number_masked[11:8];
  //         displayed_number_selected[15:12] <= displayed_number_masked[15:12];
  //       end

  //       2: begin
  //         displayed_number_selected[3:0]   <= displayed_number_masked[3:0];
  //         displayed_number_selected[7:4]   <= displayed_number_masked[7:4];
  //         displayed_number_selected[11:8]  <= ( one_second_enable ) ? ( displayed_number_masked[11:8] ) : ( 4'b1111 );
  //         displayed_number_selected[15:12] <= displayed_number_masked[15:12];
  //       end

  //       3: begin
  //         displayed_number_selected[3:0]   <= displayed_number_masked[3:0];
  //         displayed_number_selected[7:4]   <= displayed_number_masked[7:4];
  //         displayed_number_selected[11:8]  <= displayed_number_masked[11:8];
  //         displayed_number_selected[15:12] <= ( one_second_enable ) ? ( displayed_number_masked[15:12] ) : ( 4'b1111 );
  //       end

  //       default:
  //         displayed_number_selected        <= 0;
  //     endcase
    
  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i )
  //     one_second_counter <= 0;
  //   else if( one_second_counter >= 99999999 ) 
  //     one_second_counter <= 0;
  //   else
  //     one_second_counter <= one_second_counter + 1;

  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i )
  //     one_second_enable <= 0;
  //   else if( one_second_counter == 99999999 )
  //     one_second_enable <= ~one_second_enable;

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i )
      displayed_number          <= { 16 { 1'b0 } };
    // else if( reset )
    //   displayed_number          <= 16'h0000;
    // else if( we_i && addr_i[3] == 0 ) begin
    else if( we_i ) begin
      // if( be_i[0] )
        displayed_number[3:0]   <= wdata_i[3:0];
      // if( be_i[1] )  
        displayed_number[7:4]   <= wdata_i[7:4];
      // if( be_i[2] )
        displayed_number[11:8]  <= wdata_i[11:8];
      // if( be_i[3] )
        displayed_number[15:12] <= wdata_i[15:12];
    end

  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i )
  //     displayed_number_masked        <= 0;
  //   else begin
  //     displayed_number_masked[3:0]   <= ( !an_enable[0] && selection != 0 ) ? ( 4'hF ) : ( displayed_number[3:0] );
  //     displayed_number_masked[7:4]   <= ( !an_enable[1] && selection != 1 ) ? ( 4'hF ) : ( displayed_number[7:4] );
  //     displayed_number_masked[11:8]  <= ( !an_enable[2] && selection != 2 ) ? ( 4'hF ) : ( displayed_number[11:8] );
  //     displayed_number_masked[15:12] <= ( !an_enable[3] && selection != 3 ) ? ( 4'hF ) : ( displayed_number[15:12] );
  //   end

  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i )
  //     an_enable <= 0;
  //   else if( reset )
  //     an_enable <= 4'hF;
  //   else if( we_i && addr_i[3] == 1 && be_i[0] == 1 )
  //     an_enable <= wdata_i[3:0];

  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i )
  //     selection <= 0;
  //   else if( reset )
  //     selection <= 8'hFF;
  //   else if( we_i && addr_i[3] == 1 && be_i[1] == 1 ) 
  //     selection <= wdata_i[7:0];

  // always_ff @( posedge clk_i or posedge rst_i )
  //   if( rst_i )
  //     reset <= { 8 { 1'b0 } };
  //   else if( we_i && addr_i[3] == 1 && be_i[2] == 1 )
  //     reset <= wdata_i[7:0];
  //   else 
  //     reset <= { 8 { 1'b0 } };

  Seven_segment_LED_Display_Controller Seven_segment_LED_Display_Controller(
    .clock_100Mhz( clk_i ), // 100 Mhz clock source on Basys 3 FPGA
    .reset( rst_i ), // reset
    // .displayed_number_i( displayed_number_selected ),
    .displayed_number_i( displayed_number ),
    
    .AN( an_o ), // anode signals of the 7-segment LED display
    .SEG( seg_o )// cathode patterns of the 7-segment LED display
  );

endmodule