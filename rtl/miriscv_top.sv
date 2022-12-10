module miriscv_top
#(
  parameter RAM_SIZE      = 256, // bytes
  parameter RAM_INIT_FILE = ""
)
(
  // clock, reset
  input         clk_i,
  input         rst_n_i,

  input  [31:0] int_req_i,
  output [31:0] int_fin_o
);

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

  logic          we;
  logic          we_m;
  logic          req;
  logic          we_leds;
  logic          RDsel;

  logic  data_mem_valid;
  assign data_mem_valid   = (data_addr_core >= RAM_SIZE) ?  1'b0 : 1'b1;

  assign data_rdata_core  = (data_mem_valid) ? RDsel : 1'b0;
  assign data_req_ram     = (data_mem_valid) ? req_m : 1'b0;
  assign data_be_ram      =  data_be_core;
  assign data_addr_ram    =  data_addr_core;
  assign data_wdata_ram   =  data_wdata_core;

  miriscv_core core (
    .clk_i   ( clk_i   ),
    .rst_n_i ( rst_n_i ),

    .instr_rdata_i ( instr_rdata_core ),
    .instr_addr_o  ( instr_addr_core  ),

    .data_rdata_i  ( data_rdata_core  ),
    .data_req_o    ( data_req_core    ),
    .data_we_o     ( we_m     ),
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
    .rst_n_i ( rst_n_i ),

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
    .rst_i( rst_n_i ),
    .int_req_i( int_req_i ),
    .mie_i( mie ),
    .INT_RST_i( INT_RST ),

    .INT_o( interrupt ),
    .int_fin_o( int_fin_o ),
    .mcause_o( mcause )
  );

  address_decoder address_decoder(
    .we_i( we ),
    .req_i( req ),
    .addr_i( data_addr_core ),
    .we_leds_o( we_leds ),
    .we_m_o( data_we_ram ),
    .req_m_o( data_req_ram ),
    .RDsel_o( RDsel )
  );



endmodule