`timescale 1ns/1ps

module ID_EXE(
           input clk,
           input [31:0] in_pc,
           input [31:0] in_imm,
           input [31:0] in_rs1,
           input [31:0] in_rs2,
           // control signals
           // exe stage
           input [1 :0] in_aluSrc1,
           input        in_aluSrc2,
           input [4 :0] in_aluOp,
           // mem stage
           input [1 :0] in_nextPCSrc,
           input [1 :0] in_memWrite,
           input [2 :0] in_memRead,
           // wb stage
           input        in_regWrite,
           input [2 :0] in_regWriteSrc,
           input        in_memToReg,
           input [4 :0] in_regWriteRd,

           output reg [31:0] out_pc,
           output reg [31:0] out_imm,
           output reg [31:0] out_rs1,
           output reg [31:0] out_rs2,
           output reg [1 :0] out_aluSrc1,
           output reg        out_aluSrc2,
           output reg [4 :0] out_aluOp,
           output reg [1 :0] out_nextPCSrc,
           output reg [1 :0] out_memWrite,
           output reg [2 :0] out_memRead,
           output reg        out_regWrite,
           output reg [2 :0] out_regWriteSrc,
           output reg        out_memToReg,
           output reg [4 :0] out_regWriteRd
       );
always @(posedge clk) begin
    out_rs1         <= in_rs1;
    out_rs2         <= in_rs2;
    out_aluSrc1     <= in_aluSrc1;
    out_aluSrc2     <= in_aluSrc2;
    out_aluOp       <= in_aluOp;
    out_nextPCSrc   <= in_nextPCSrc;
    out_memWrite    <= in_memWrite;
    out_memRead     <= in_memRead;
    out_regWrite    <= in_regWrite;
    out_regWriteSrc <= in_regWriteSrc;
    out_memToReg    <= in_memToReg;
    out_regWriteRd  <= in_regWriteRd;
end
endmodule
