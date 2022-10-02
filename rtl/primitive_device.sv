module primitive_device(
  input clk_i,
  input rst_i,
  
//  input en_i,
  
  output [15:0] HEX_o,
  
  input  [2:0]  SW_i
  
//  output        done_o
);
  wire [31:0] RD1;
  wire [31:0] RD2;

  wire [31:0] RD;
  
  wire signed [31:0] Result;
  wire               Flag;

  assign HEX_o = RD1;
  
  wire [31:0] const_SE;
  assign const_SE = { {24{ RD[12] }}, RD[12:5] };
  
  reg [8:0] PC;
  
  wire [8:0] add_to_PC;
  assign add_to_PC = ( ( Flag & RD[30] ) | RD[31]  ) ? ( const_SE ) : ( 4 );
  
  always @( posedge clk_i or posedge rst_i )
    if( rst_i )
      PC <= 0;
    else
//      if( en_i )
        PC <= PC + add_to_PC;
  
//  assign done_o = (add_to_PC == 0) && en_i;
  
  RAM ram(
    .A_i  ( PC  ),
    .RD_o ( RD  )
  );

  reg [31:0] WD3_mux;
  
  wire [31:0] SW_E;
  assign SW_E = { {29{ 1'b0 }}, SW_i };
  
  always @( * )
    case( RD[29:28] )
      1:
        begin
          WD3_mux = SW_E;
        end
        
      2:
        begin
          WD3_mux = const_SE;
        end
        
      3:
        begin
          WD3_mux = Result;
        end
      
      default:
        begin
          WD3_mux = -1;
        end
    endcase

  wire [4:0] A1;
  assign A1 = RD[22:18];
  
  wire [4:0] A2;
  assign A2 = RD[17:13];
  
  wire [4:0] WA3;
  assign WA3 = RD[4:0];
  
  wire       WE3;
  assign WE3 = RD[29] | RD[28];

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

  wire [4:0] ALUOp;
  assign ALUOp = RD[27:23];

  ALU_RISCV alu(
    .ALUOp ( ALUOp ),
    .A     ( RD1      ), 
    .B     ( RD2      ), 
    .Result( Result ), 
    .Flag  ( Flag   )
  ); 
endmodule
