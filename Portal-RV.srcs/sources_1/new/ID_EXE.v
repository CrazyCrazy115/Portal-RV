`timescale 1ns/1ps

module ID_EXE(
           input clk,
           input rst,
           input [31:0] in_pc,
           input [31:0] in_imm,
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
        out_rdata1      <= in_rdata1;
        out_rdata2      <= in_rdata2;
        out_aluSrc1     <= in_aluSrc1;
        out_aluSrc2     <= in_aluSrc2;
        out_aluOp       <= in_aluOp;
        out_memWrite    <= in_memWrite;
        out_memRead     <= in_memRead;
        out_regWrite    <= in_regWrite;
        out_regWriteSrc <= in_regWriteSrc;
        out_regWriteRd  <= in_regWriteRd;
    end
end
endmodule
