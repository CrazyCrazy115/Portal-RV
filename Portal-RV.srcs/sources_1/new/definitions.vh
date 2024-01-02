// ControlSignals.vh

`ifndef CONTROL_SIGNALS_VH
`define CONTROL_SIGNALS_VH

`define IM_SIZE 1024
`define DM_SIZE 32'h00002000

`define RAM_PATH "D:/coding/cpu/Portal-RV/sim_data/instructions/bubble-sort-ram.txt"
`define ROM_PATH "D:/coding/cpu/Portal-RV/sim_data/instructions/bubble-sort-hex.txt"

`define PC_INIT 32'h00000000

`define Y    1'b1
`define N    1'b0
`define X    1'bx

// Instruction type
`define R    3'b000
`define I    3'b001
`define S    3'b010
`define B    3'b011
`define U    3'b100
`define J    3'b101
`define INST_TYPE_X 3'hxxx
`define INST_TYPE_WIDTH 3

// ALU source 1
`define RS1  2'b00
`define ZERO 2'b01
`define PC   2'b10
`define ALU_SRC1_N 2'b11
`define ALU_SRC1_X 2'bxx
`define ALU_SRC1_WIDTH 2

// ALU source 2
`define RS2  2'b00
`define IMM  2'b01
`define ALU_SRC2_N 2'b10
`define ALU_SRC2_X 2'bxx
`define ALU_SRC2_WIDTH 2

// ALU operation
`define ADD  5'b00000
`define SUB  5'b00001
`define XOR  5'b00010
`define AND  5'b00011
`define OR   5'b00100
`define SLL  5'b00101
`define SRL  5'b00110
`define SRA  5'b00111
`define MULL 5'b01000
`define MULH 5'b01001
`define DIVU 5'b01010
`define DIVS 5'b01011
`define LTU  5'b01100
`define GEU  5'b01101
`define LTS  5'b01110
`define GES  5'b01111
`define EQ   5'b10000
`define NEQ  5'b10001
`define ALU_OP_N 5'b10010
`define ALU_OP_X 5'bxxxxx
`define ALU_OP_WIDTH 5

// Memory write
`define MEM_WRITE_B 2'b00
`define MEM_WRITE_H 2'b01
`define MEM_WRITE_W 2'b10
`define MEM_WRITE_N 2'b11
`define MEM_WRITE_X 2'hxx
`define MEM_WRITE_WIDTH 2

// Memory read
`define MEM_READ_BS  3'b000
`define MEM_READ_BU  3'b101
`define MEM_READ_HU  3'b001
`define MEM_READ_HS  3'b010
`define MEM_READ_W   3'b011
`define MEM_READ_N   3'b100
`define MEM_READ_X   3'hxxx
`define MEM_READ_WIDTH 3

// Next PC source
`define NEXT_PC_PC4 2'b00
`define NEXT_PC_BRANCH 2'b01
`define NEXT_PC_JUMP 2'b10
`define NEXT_PC_JUMPR 2'b11
`define NEXT_PC_X 2'hxx
`define NEXT_PC_WIDTH 2

// Register write
`define REG_WRITE_Y 1'b1
`define REG_WRITE_N 1'b0
`define REG_WRITE_X 1'bx
`define REG_WRITE_WIDTH 1

// Register write source
`define REG_WRITE_SRC_ALU_RES 3'b000
`define REG_WRITE_SRC_IMM     3'b001
`define REG_WRITE_SRC_PC4     3'b010
`define REG_WRITE_SRC_MEM     3'b011
`define REG_WRITE_SRC_N       3'b100
`define REG_WRITE_SRC_X       3'hxxx
`define REG_WRITE_SRC_WIDTH   3

// Forward signal for exe stage
`define FORWARD_ID_EXE 2'b00
`define FORWARD_EXE_MEM 2'b01
`define FORWARD_MEM_WB 2'b10

// Forward signal for branch(id) stage
`define FORWARD_B_RF 1'b0
`define FORWARD_B_EXE_MEM 1'b1



`endif // CONTROL_SIGNALS_VH
