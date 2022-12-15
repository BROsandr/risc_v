module ps_2 (
  input  logic       clk_50_i,
  input  logic       rst_i,

  input  logic       ps2_clk_i,
  input  logic       ps2_dat_i,
  output logic       valid_data_o,
  output logic [7:0] data_o
); 

  localparam IDLE                   = 2'd0;
  localparam RECEIVE_DATA           = 2'd1;
  localparam CHECK_PARITY_STOP_BITS = 2'd2;

  logic [3:0] count_bit;

  logic [9:0] ps2_clk_detect;

  always_ff @( posedge clk_50_i or posedge rst_i )
    if ( rst_i )
      ps2_clk_detect <= 10'd0;
    else
      ps2_clk_detect <= { ps2_clk_i, ps2_clk_detect[9:1] };

  logic ps2_clk_negedge = &ps2_clk_detect[4:0] && &( ~ps2_clk_detect[9:5] ); 

  logic [1:0] state;

  always_ff @(negedge ps2_clk_i or posedge rst_i)
    if ( rst_i )
      state <= IDLE;
    else
      case( state )
        IDLE: begin
          if ( !ps2_dat_i )
            state <= RECEIVE_DATA;
        end

        RECEIVE_DATA: begin
          if ( count_bit == 8 )
            state <= CHECK_PARITY_STOP_BITS;
        end

        CHECK_PARITY_STOP_BITS: 
          state <= IDLE;

        default: 
          state <= IDLE;
      endcase

  logic [8:0] shift_reg;
  assign      data_o = shift_reg[7:0];

  always_ff @( posedge clk_50_i or posedge rst_i )
  if( rst_i )
    shift_reg <= 9'b0;
  else if( ps2_clk_negedge )
    if( state == RECEIVE_DATA )
      shift_reg <= { ps2_dat_i, shift_reg[8:1] };

  always_ff @( posedge clk_50_i or posedge rst_i )
    if ( rst_i )
      count_bit <= 4'b0;
    else if( ps2_clk_negedge ) begin
      if ( state == RECEIVE_DATA )
        count_bit <= count_bit + 4'b1;
      else
        count_bit <= 4'b0;
      end

  function parity_calc;
    input [7:0] a;
    parity_calc = ~(a[0] ^ a[1] ^ a[2] ^ a[3] ^
                    a[4] ^ a[5] ^ a[6] ^ a[7]);
  endfunction

  always_ff @( posedge clk_50_i or posedge rst_i )
    if ( rst_i ) 
      valid_data_o <= 1'b0;
    else if ( ps2_clk_negedge )
      if (ps2_dat_i &&
          parity_calc(shift_reg[7:0]) == shift_reg[8] &&
          state == CHECK_PARITY_STOP_BITS)
        valid_data_o <= 1'b1;
      else
        valid_data_o <= 1'b0;

endmodule
