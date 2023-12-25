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


module EX_MEM(
           input clk,
           input [31:0] in_aluRes,
           input [31:0] in_rs2,
           input [31:0] in_dnpc,
           // mem stage
           input [1:0]  in_nextPCSrc,
           input [1:0]  in_memWrite,
           input [2:0]  in_memRead,
           // wb stage
           input        in_regWrite,
           input [2:0]  in_regWriteSrc,
           input        in_memToReg,

           output reg [31:0] out_aluRes,
           output reg [31:0] out_rs2,
           output reg [31:0] out_dnpc,
           output reg [1:0]  out_nextPCSrc,
           output reg [1:0]  out_memWrite,
           output reg [2:0]  out_memRead,
           output reg        out_regWrite,
           output reg [2:0]  out_regWriteSrc,
           output reg        out_memToReg
       );
always @(posedge clk) begin
    out_aluRes      <= in_aluRes;
    out_rs2         <= in_rs2;
    out_dnpc        <= in_dnpc;
    out_nextPCSrc   <= in_nextPCSrc;
    out_memWrite    <= in_memWrite;
    out_memRead     <= in_memRead;
    out_regWrite    <= in_regWrite;
    out_regWriteSrc <= in_regWriteSrc;
    out_memToReg    <= in_memToReg;
end
endmodule
