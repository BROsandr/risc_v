module miriscv_ram
#(
  parameter RAM_SIZE      = 256, // bytes
  parameter RAM_INIT_FILE = ""
)
(
  // clock, reset
  input clk_i,
  input rst_n_i,

  // instruction memory interface
  output logic  [31:0]  instr_rdata_o,
  input         [31:0]  instr_addr_i,

  // data memory interface
  output logic  [31:0]  data_rdata_o,
  input                 data_req_i,
  input                 data_we_i,
  input         [3:0]   data_be_i,
  input         [31:0]  data_addr_i,
  input         [31:0]  data_wdata_i
);

  reg [31:0]    mem [0:RAM_SIZE/4-1];
  reg [31:0]    data_int;

  logic         data_req_buff;

  logic         data_req;
  assign        data_req  = data_req_buff & data_req_i;

  //Init RAM
  integer ram_index;

  initial begin
    if(RAM_INIT_FILE != "")
      $readmemh(RAM_INIT_FILE, mem);
    else
      for (ram_index = 0; ram_index < RAM_SIZE/4-1; ram_index = ram_index + 1)
        mem[ram_index] = {32{1'b0}};
  end


  //Instruction port
  assign instr_rdata_o = mem[(instr_addr_i % RAM_SIZE) / 4];

  always_ff @( posedge clk_i or posedge rst_n_i )
    if( rst_n_i )
      data_req_buff <= 1;
    else if( !data_req_buff )
      data_req_buff <= 1;
    else
      data_req_buff <= !data_req_i;

  // always_ff @( posedge clk_i or posedge rst_n_i )
  //   if( rst_n_i )
  //     data_req_buff <= 0;
  //   else
  //     data_req_buff <= data_req_i; 

  always_ff @( posedge clk_i or posedge rst_n_i )
    if( rst_n_i )
      data_rdata_o <= 32'b0;
    else if( data_req )
      data_rdata_o <= mem[(data_addr_i  % RAM_SIZE) / 4];

  always@(posedge clk_i)
    if(data_req) begin
      if(data_we_i && data_be_i[0])
        mem [data_addr_i[31:2]] [7:0]  <= data_wdata_i[7:0];

      if(data_we_i && data_be_i[1])
        mem [data_addr_i[31:2]] [15:8] <= data_wdata_i[15:8];

      if(data_we_i && data_be_i[2])
        mem [data_addr_i[31:2]] [23:16] <= data_wdata_i[23:16];

      if(data_we_i && data_be_i[3])
        mem [data_addr_i[31:2]] [31:24] <= data_wdata_i[31:24];

    end


endmodule