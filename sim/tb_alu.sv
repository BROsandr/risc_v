`timescale 1ns / 1ps

`include "../common/constants.vh"

module tb_alu();
  reg         [4:0]  ALUOp;
  reg         [31:0] A;
  reg         [31:0] B;
  wire signed [31:0] Result;
  wire               Flag;
  
  reg test_failed = 0;

  ALU_RISCV alu(
    .ALUOp ( ALUOp  ),
    .A     ( A      ), 
    .B     ( B      ), 
    .Result( Result ), 
    .Flag  ( Flag   )
  ); 

  function void dec_disp( input reg [31:0] a, input reg [31:0] b, input reg [31:0] result );
    $display( "A = %d, B = %d, Result = %d", a, b, result );
  endfunction
  
  function void dec_disp_signed( input int a, input int b, input int result );
    $display( "A = %d, B = %d, Result = %d", a, b, result );
  endfunction

  function void bin_disp( input reg [31:0] a, input reg [31:0] b, input reg [31:0] result );
    $display( "A = %b, B = %b, Result = %b", a, b, result );
  endfunction
  
  function void bin_disp_shift( input reg [31:0] a, input reg [31:0] b, input reg [31:0] result );
    $display( "A = %b, B = %d, Result = %b", a, b, result );
  endfunction

  function signed [31:0] signed_func( input [31:0] a );
    return a;
  endfunction
  
  function [31:0] unsigned_func( input [31:0] a );
    return a;
  endfunction

  initial begin
`define TEST( a, b, op, alu_op, disp_func, sign_func, flag_or_res )     \
      A = a;                                                            \
      B = b;                                                            \
      ALUOp = alu_op;                                                   \
      #10                                                               \
      if ( flag_or_res !== ( sign_func( A ) op sign_func( B ) ) )       \
        begin                                                           \
          $write( "FAIL %s : ", `"op`" );                               \
          disp_func(A, B, flag_or_res);                                 \
          $write( "Internal results %s : ", `"op`");                    \
          disp_func( a, b, sign_func( a ) op sign_func( b ) );          \
          test_failed = 1;                                              \
        end                                                             \
      else                                                              \
        begin                                                           \
          $write("PASS %s : ", `"op`");                                 \
          disp_func(A, B, flag_or_res);                                 \
        end 
    
    // add  
    `TEST(  1,  2, +, `ALU_ADD, dec_disp_signed, signed_func, Result );
    `TEST( -1, -2, +, `ALU_ADD, dec_disp_signed, signed_func, Result );
    `TEST( $random, $random, +, `ALU_ADD, dec_disp, unsigned_func, Result );
    
    // sub
    `TEST( -1,  2, -, `ALU_SUB, dec_disp_signed, signed_func, Result );
    `TEST( 1,  2, -, `ALU_SUB, dec_disp_signed, signed_func, Result );
    `TEST( -1, -2, -, `ALU_SUB, dec_disp_signed, signed_func, Result );
    `TEST( $random, $random, -, `ALU_SUB, dec_disp_signed, unsigned_func, Result );
    
    // xor
    `TEST( 1, 2, ^, `ALU_XOR, bin_disp, unsigned_func, Result );
    `TEST( 1, 3, ^, `ALU_XOR, bin_disp, unsigned_func, Result );
    `TEST( $random, $random, ^, `ALU_XOR, bin_disp, unsigned_func, Result );
    
    // or
    `TEST( 1, 3, |, `ALU_OR, bin_disp, unsigned_func, Result );
    `TEST( $random, $random, |, `ALU_OR, bin_disp, unsigned_func, Result );
    
    // and
    `TEST( 1, 3, &, `ALU_AND, bin_disp, unsigned_func, Result );
    `TEST( $random, $random, &, `ALU_AND, bin_disp, unsigned_func, Result );
    
    // shift left
    `TEST( 1, 1, <<, `ALU_SLL, bin_disp_shift, unsigned_func, Result );
    `TEST( 3, 2, <<, `ALU_SLL, bin_disp_shift, unsigned_func, Result );
    `TEST( $random, $random, <<, `ALU_SLL, bin_disp_shift, unsigned_func, Result );
    // shift right
    `TEST( 3, 2, >>, `ALU_SRL, bin_disp_shift, unsigned_func, Result );
    `TEST( 3, $random, >>, `ALU_SRL, bin_disp_shift, unsigned_func, Result );
    // shift right signed
    `TEST( -1, 2, >>>, `ALU_SRA, bin_disp_shift, signed_func, Result );
    `TEST( 5, 2, >>>, `ALU_SRA, bin_disp_shift, signed_func, Result );
    `TEST( -1, $random, >>>, `ALU_SRA, bin_disp_shift, signed_func, Result );
    
    // comparisons non-flagged
    // signed less
    `TEST( -2, 1, <, `ALU_SLTS, dec_disp_signed, signed_func, Result );
    `TEST( $random, $random, <, `ALU_SLTS, dec_disp_signed, signed_func, Result );
    //unsigned
    `TEST( -3, 2, <, `ALU_SLTU, dec_disp, unsigned_func, Result );
    `TEST( $random, $random, <, `ALU_SLTU, dec_disp, unsigned_func, Result );
    
    //Flags
    `TEST( 1, -3, >=, `ALU_GES, dec_disp_signed, signed_func, Flag );
    `TEST( 1,  3, >=, `ALU_GES, dec_disp_signed, signed_func, Flag );
    `TEST( $random,  $random, >=, `ALU_GES, dec_disp_signed, signed_func, Flag );
    
    `TEST( -1, 3, <, `ALU_LTU, dec_disp, unsigned_func, Flag );
    `TEST(  1, 3, <, `ALU_LTU, dec_disp, unsigned_func, Flag );
    `TEST(  -1, -3, <, `ALU_LTU, dec_disp, unsigned_func, Flag );
    `TEST(  $random, $random, <, `ALU_LTU, dec_disp, unsigned_func, Flag );
    
    `TEST( 1, 3, !=, `ALU_NE, dec_disp, unsigned_func, Flag );
    `TEST( 1, 1, !=, `ALU_NE, dec_disp, unsigned_func, Flag );
    `TEST( 1, -1, !=, `ALU_NE, dec_disp, unsigned_func, Flag );
    `TEST( $random, $random, !=, `ALU_NE, dec_disp, unsigned_func, Flag );
    
    `TEST( 1, 1, ==, `ALU_EQ, dec_disp, unsigned_func, Flag );
    `TEST( 1, -1, ==, `ALU_EQ, dec_disp, unsigned_func, Flag );
    `TEST( $random, $random, ==, `ALU_EQ, dec_disp, unsigned_func, Flag );
    
    // Less than signed
    `TEST( 1, 3, <, `ALU_LTS, dec_disp_signed, signed_func, Flag );
    `TEST( -1, 3, <, `ALU_LTS, dec_disp_signed, signed_func, Flag );
    `TEST( $random, $random, <, `ALU_LTS, dec_disp_signed, signed_func, Flag );
    
    // Greater or equal unsigned
    `TEST( 1, 3, >=, `ALU_GEU, dec_disp, unsigned_func, Flag); 
    `TEST( -1, 3, >=, `ALU_GEU, dec_disp, unsigned_func, Flag);
    `TEST( 3, 3, >=, `ALU_GEU, dec_disp, unsigned_func, Flag);
    `TEST( $random, $random, >=, `ALU_GEU, dec_disp, unsigned_func, Flag); 
`undef TEST

    if( !test_failed )
      $display("ALL TESTS HAVE BEEN PASSED");
    else
      $display("SOME TESTS HAVE BEEN FAILED");
      
    $finish;
  
  end
endmodule
