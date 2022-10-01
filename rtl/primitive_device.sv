module primitive_device(
  input clk_i,
  input rst_i,
  
  input en_i,
  
  output [31:0] HEX_o
);
  wire [31:0] RD1;
  wire [31:0] RD2;

  wire [31:0] RD;
  
  wire signed [31:0] Result;
  wire               Flag;

  assign HEX_o = RD1;
  
  wire [31:0] const_SE;
  assign const_SE = { {24{ RD[7] }}, RD[7:0] };
  
  reg [8:0] PC;
  
  always @( posedge clk_i or posedge rst_i )
    if( rst_i )
      PC <= 0;
    else
      if( en_i )
        PC <= PC + ( ( ( Flag & RD[30] ) | RD[31]  ) ? ( const_SE ) : ( 4 ) );
//        PC <= PC + 4;
  
  RAM ram(
    .A_i  ( PC  ),
    .RD_o ( RD  )
  );

  wire [31:0] WD3_mux;
  assign WD3_mux = ( RD[28] ) ? ( Result ) : ( const_SE ) ;

  wire [4:0] A1;
  assign A1 = RD[22:18];
  
  wire [4:0] A2;
  assign A2 = RD[17:13];
  
  wire [4:0] WA3;
  assign WA3 = RD[12:8];
  
  wire       WE3;
  assign WE3 = RD[29];

  RF rf(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .A1_i ( A1 ),
    .A2_i ( A2  ),
    .WA3_i( WA3 ),
    .WD3_i( WD3_mux ),
    .RD1_o( RD1 ),
    .RD2_o( RD2 ),
    .WE3_i( WE3 )
  );

  wire ALUOp;
  assign ALUOp = RD[26:23];

  ALU_RISCV alu(
    .ALUOp ( ALUOp ),
    .A     ( RD1      ), 
    .B     ( RD2      ), 
    .Result( Result ), 
    .Flag  ( Flag   )
  ); 
endmodule
