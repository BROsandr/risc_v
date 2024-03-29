`include "../common/defines_riscv.v"

module miriscv_top
#(
  parameter RAM_SIZE      = 2048, // bytes
  parameter RAM_INIT_FILE = "prog.txt"
)
(
  // clock, reset
  input                clk_i,
  input                rst_n_i,

  output [14:0]        leds_out_o,
  output [6:0 ]        seg_o,
  output [3:0 ]        an_o,

  input ps2_clk_i,
  input ps2_dat_i,

  input [15:0]         sw_i,
  output error_o
);

  localparam     RDSEL_WIDTH = 8;

  logic          rst;
  assign         rst = !rst_n_i;

  logic valid_data_o;

  logic  [31:0]  instr_rdata_core;
  logic  [31:0]  instr_addr_core;

  logic  [31:0]  data_rdata_core;
  logic          data_req_core;
  logic          data_we_core;
  logic  [3:0]   data_be_core;
  logic  [31:0]  data_addr_core;
  logic  [31:0]  data_wdata_core;

  logic  [31:0]  data_rdata_ram;
  logic          data_req_ram;
  logic          data_we_ram;
  logic  [3:0]   data_be_ram;
  logic  [31:0]  data_addr_ram;
  logic  [31:0]  data_wdata_ram;

  logic  [31:0]  mie;
  logic          INT_RST;
  logic          interrupt;
  logic  [31:0]  mcause;

  logic  [31:0]  hex_out;

  logic                      req;
  logic                      we_leds;
  logic  [RDSEL_WIDTH-1:0]   RDsel;
  logic  [31:0]              rdata;

  logic                      we_hex;
  logic                      we_ps2;
  logic                      we_sw;

  logic                      valid_addr;

  logic  [31:0]              leds_out;
  logic  [31:0]              ps2_out;
  logic  [31:0]              sw_out;

  logic  [31:0]              int_req;
  logic  [31:0]              int_fin;

//  assign                     int_req[31:1] = 0;

  assign                     leds_out_o = leds_out[15:0];

  assign valid_addr       = ( data_addr_core < RAM_SIZE ) || 
                            ( ( data_addr_core < 32'h80006000 ) && 
                              ( data_addr_core >= 32'h80000000 ) );
  assign data_rdata_core  = ( valid_addr ) ? ( rdata ) : ( 1'b0 );
  assign req              = ( valid_addr ) ? ( data_req_core ) : ( 1'b0 );
  assign data_be_ram      =  data_be_core;
  assign data_addr_ram    =  data_addr_core;
  assign data_wdata_ram   =  data_wdata_core;

  miriscv_core core (
    .clk_i   ( clk_i   ),
    .rst_n_i ( rst ),

    .instr_rdata_i ( instr_rdata_core ),
    .instr_addr_o  ( instr_addr_core  ),

    .data_rdata_i  ( data_rdata_core  ),
    .data_req_o    ( data_req_core    ),
    .data_we_o     ( data_we_core     ),
    .data_be_o     ( data_be_core     ),
    .data_addr_o   ( data_addr_core   ),
    .data_wdata_o  ( data_wdata_core  ),
    .INT_i( interrupt ),
    .mcause_i( mcause ),

    .INT_RST_o( INT_RST ),
    .mie_o( mie )
  );

  miriscv_ram
  #(
    .RAM_SIZE      (RAM_SIZE),
    .RAM_INIT_FILE (RAM_INIT_FILE)
  ) ram (
    .clk_i   ( clk_i   ),
    .rst_n_i ( rst ),

    .instr_rdata_o ( instr_rdata_core ),
    .instr_addr_i  ( instr_addr_core  ),

    .data_rdata_o  ( data_rdata_ram  ),
    .data_req_i    ( data_req_ram    ),
    .data_we_i     ( data_we_ram     ),
    .data_be_i     ( data_be_ram     ),
    .data_addr_i   ( data_addr_ram   ),
    .data_wdata_i  ( data_wdata_ram  )
  );

  interrupt_controller interrupt_controller(
    .clk_i( clk_i ),
    .rst_i( rst ),
    .int_req_i( int_req ),
    .mie_i( mie ),
    .INT_RST_i( INT_RST ),

    .INT_o( interrupt ),
    .int_fin_o( int_fin ),
    .mcause_o( mcause )
  );

  address_decoder #(
    .RDSEL_WIDTH( RDSEL_WIDTH ),
    .RAM_SIZE   ( RAM_SIZE    )
  ) address_decoder(
    .we_i( data_we_core ),
    .req_i( req ),
    .addr_i( data_addr_core ),
    .we_leds_o( we_leds ),
    .we_hex_o ( we_hex ),
    .we_ps2_o ( we_ps2 ),
    .we_m_o( data_we_ram ),
    .req_m_o( data_req_ram ),
    .RDsel_o( RDsel )
  );


  leds_ctrl leds_ctrl(
    .clk_i( clk_i ),
    .rst_i( rst ),

    .wdata_i( data_wdata_core ),
    .addr_i( data_addr_core ),
    .be_i( data_be_core ),
    .we_i( we_leds ),

    .out_o( leds_out )
  );

  sw_ctrl sw_ctrl(
    .clk_i( clk_i ),
    .rst_i( rst ),

    .in_i( sw_i ),
    .out_o( sw_out ),
    .int_req_o( int_req ),
    .int_fin_i( int_fin ),
    .error_o( error_o )
  );

  hex_ctrl hex_ctrl(
    .clk_i( clk_i ),
    .rst_i( rst ),

    .wdata_i( data_wdata_core ),
    .addr_i( data_addr_core ),
    .be_i( data_be_core ),
    .we_i( we_hex ),

    .seg_o( seg_o ),
    .an_o ( an_o  ),
    .out_o( hex_out )
  );

  ps_2 ps_2(
    .clk_50_i( clk_i ),
    .rst_i( rst_i ),

    .ps2_clk_i( ps2_clk_i ),
    .ps2_dat_i( ps2_dat_i ),
    .valid_data_o( valid_data_o ),
    .data_o( ps2_out )
  ); 

  always_comb
    case( RDsel )
      `RDSEL_MEM   : rdata = data_rdata_ram;
      `RDSEL_LEDS  : rdata = leds_out_o;
      `RDSEL_HEX   : rdata = hex_out;
      `RDSEL_PS2   : rdata = ps2_out;
      `RDSEL_SW    : rdata = sw_out;

      default:       rdata = 32'bx;
    endcase

endmodule