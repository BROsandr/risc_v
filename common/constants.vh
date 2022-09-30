`define ALU_ADD   5'b00000
`define ALU_SUB   5'b01000

`define ALU_XOR   5'b00100
`define ALU_OR    5'b00110
`define ALU_AND   5'b00111

// shifts

// shift left
`define ALU_SLL   5'b00001
// shift right
`define ALU_SRL   5'b00101
// shift right signed
`define ALU_SRA   5'b01101

// comparisons non-flagged
// signed less
`define ALU_SLTS  5'b00010
// less
`define ALU_SLTU  5'b00011

// comparisons flagged
// signed less
`define ALU_LTS   5'b11100
// less
`define ALU_LTU   5'b11110
// signed greater or equal
`define ALU_GES   5'b11101
// greater or equal
`define ALU_GEU   5'b11111
// equal
`define ALU_EQ    5'b11000
// not equal
`define ALU_NE    5'b11001