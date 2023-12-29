`timescale 1ns/1ps
`include "definitions.vh"

module ID_EXE(
           input clk,
           input rst,
           input stall,
           input [31:0] in_pc,
           input [31:0] in_imm,
           input [5 :0] in_rs1,
           input [5 :0] in_rs2,
           input [31:0] in_rdata1,
           input [31:0] in_rdata2,
           // control signals
           // exe stage
           input [1 :0] in_aluSrc1,
           input        in_aluSrc2,
           input [4 :0] in_aluOp,
           // mem stage
           input [1 :0] in_memWrite,
           input [2 :0] in_memRead,
           // wb stage
           input        in_regWrite,
           input [2 :0] in_regWriteSrc,
           input [4 :0] in_regWriteRd,

           output reg [31:0] out_pc,
           output reg [31:0] out_imm,
           output reg [4 :0] out_rs1,
           output reg [4 :0] out_rs2,
           output reg [31:0] out_rdata1,
           output reg [31:0] out_rdata2,
           output reg [1 :0] out_aluSrc1,
           output reg        out_aluSrc2,
           output reg [4 :0] out_aluOp,
           output reg [1 :0] out_memWrite,
           output reg [2 :0] out_memRead,
           output reg        out_regWrite,
           output reg [2 :0] out_regWriteSrc,
           output reg [4 :0] out_regWriteRd
       );
always @(posedge clk) begin
    if (rst) begin
        out_pc          <= 0;
        out_imm         <= 0;
        out_rs1         <= 0;     
        out_rs2         <= 0;
        out_rdata1      <= 0;
        out_rdata2      <= 0;
        out_aluSrc1     <= 0;
        out_aluSrc2     <= 0;
        out_aluOp       <= 0;
        out_memWrite    <= 0;
        out_memRead     <= 0;
        out_regWrite    <= 0;
        out_regWriteSrc <= 0;
        out_regWriteRd  <= 0;
    end
    else begin
        out_pc          <= in_pc;
        out_imm         <= in_imm;
        out_rs1         <= in_rs1;
        out_rs2         <= in_rs2;
        out_rdata1      <= in_rdata1;
        out_rdata2      <= in_rdata2;
        out_aluSrc1     <= stall ? `ALU_SRC1_N      : in_aluSrc1;
        out_aluSrc2     <= stall ? `ALU_SRC2_N      : in_aluSrc2;
        out_aluOp       <= stall ? `ALU_OP_N        : in_aluOp;
        out_memWrite    <= stall ? `MEM_WRITE_N     : in_memWrite;
        out_memRead     <= stall ? `MEM_READ_N      : in_memRead;
        out_regWrite    <= stall ? `REG_WRITE_N     : in_regWrite;
        out_regWriteSrc <= stall ? `REG_WRITE_SRC_N : in_regWriteSrc;
        out_regWriteRd  <= in_regWriteRd;
    end
end
endmodule
