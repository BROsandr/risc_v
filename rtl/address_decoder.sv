`include "../common/defines_riscv.v"

module address_decoder #(
  parameter RDSEL_WIDTH = 2,
  parameter RAM_SIZE    = 256 // bytes
)(
  input  logic                 we_i,
  input  logic                 req_i,
  input  logic [31:0]          addr_i,

  output logic                 we_leds_o,
  output logic                 we_hex_o,
  output logic                 we_ps2_o,
  output logic                 we_m_o,
  output logic                 req_m_o,
  output logic [RDSEL_WIDTH-1:0] RDsel_o
);

  logic  data_mem_valid;
  logic  is_leds_addr;
  logic  is_hex_addr;

  assign is_leds_addr = { addr_i[31:2], 2'b0 } == 32'h80000800;
  assign is_hex_addr  = { addr_i[31:4], 4'b0 } == 32'h80001000;
  assign is_ps2_addr  = { addr_i[31:2], 4'b0 } == 32'h80003000;

  assign data_mem_valid   = ( addr_i >= RAM_SIZE ) ?  ( 1'b0 ) : ( 1'b1 );

  assign req_m_o          = ( data_mem_valid ) ? ( req_i ) : ( 1'b0 );

  assign we_leds_o        = req_i && we_i && ( is_leds_addr );
  assign we_hex_o         = req_i && we_i && ( is_hex_addr );
  assign we_ps2_o         = req_i && we_i && ( is_ps2_addr );

  assign we_m_o           = we_i;

  always_comb
    if( is_leds_addr )
      RDsel_o = `RDSEL_LEDS;
    else if( is_hex_addr )
      RDsel_o = `RDSEL_HEX;
    else if( is_ps2_addr )
      RDsel_o = `RDSEL_PS2;
    else
      RDsel_o = `RDSEL_MEM;

endmodule