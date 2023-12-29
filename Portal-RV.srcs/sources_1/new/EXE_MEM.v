`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/25 23:54:06
// Design Name:
// Module Name: EX_MEM
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module EXE_MEM(
           input clk,
           input rst,
           input [31:0] in_aluRes,
           input [31:0] in_rdata2,
           input [31:0] in_pc,
           // mem stage
           input [1 :0] in_memWrite,
           input [2 :0] in_memRead,
           // wb stage
           input        in_regWrite,
           input [2 :0] in_regWriteSrc,
           input        in_memToReg,
           input [4 :0] in_regWriteRd,

           output reg [31:0] out_aluRes,
           output reg [31:0] out_rdata2,
           output reg [31:0] out_pc,
           output reg [1 :0] out_nextPCSrc,
           output reg [1 :0] out_memWrite,
           output reg [2 :0] out_memRead,
           output reg        out_regWrite,
           output reg [2 :0] out_regWriteSrc,
           output reg        out_memToReg,
           output reg [4 :0] out_regWriteRd
       );
always @(posedge clk) begin
    if (rst) begin
        out_aluRes      <= 0;
        out_rdata2      <= 0;
        out_pc          <= 0;
        out_memWrite    <= 0;
        out_memRead     <= 0;
        out_regWrite    <= 0;
        out_regWriteSrc <= 0;
        out_memToReg    <= 0;
        out_regWriteRd  <= 0;
    end
    else begin
        out_aluRes      <= in_aluRes;
        out_rdata2      <= in_rdata2;
        out_pc          <= in_pc;
        out_memWrite    <= in_memWrite;
        out_memRead     <= in_memRead;
        out_regWrite    <= in_regWrite;
        out_regWriteSrc <= in_regWriteSrc;
        out_memToReg    <= in_memToReg;
        out_regWriteRd  <= in_regWriteRd;
    end
end
endmodule
