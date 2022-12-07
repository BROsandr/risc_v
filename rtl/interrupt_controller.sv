module interrupt_controller(
  input               clk_i,
  input               rst_i,
  input        [31:0] int_req_i,
  input        [31:0] mie_i,
  input               INT_RST_i,

  output              INT_o,
  output logic [31:0] int_fin_o,
  output       [31:0] mcause_o
);

  logic [4:0]  interrupt_counter;
  logic [31:0] interrupt_counter_decoded;

  logic [31:0] int_befor_or;

  logic        int_or;
  assign       int_or = |int_befor_or;

  logic        int_reg;

  always_comb
    for( int i = 0; i < 32; ++i )
      interrupt_counter_decoded[i] = ( interrupt_counter == i ) ? ( 1 ) : ( 0 );

  always_comb
    for( int i = 0; i < 32; ++i )
      int_befor_or[i] = ( mie_i[i] & int_req_i[i] ) & interrupt_counter_decoded[i];

  always_comb begin
    for( int i = 0; i < 32; ++i )
      int_fin_o[i] = int_befor_or[i] & INT_RST_i;
  end

  always_ff @( posedge clk_i or posedge rst_i )
    if( rst_i || INT_RST_i )
      interrupt_counter <= 0;
    else if( INT_RST_i )
      interrupt_counter <= 0;
    else if( !int_or )
      interrupt_counter <= interrupt_counter + 1;

  always_ff @( posedge clk_i or posedge rst_i or posedge INT_RST_i)
    if( rst_i || INT_RST_i )
      int_reg <= 0;
    else
      int_reg <= int_or;

  assign INT_o = int_or ^ int_reg;

  assign mcause_o = { 27'h0_000_000, interrupt_counter };

endmodule
