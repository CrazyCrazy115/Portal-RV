`timescale 1ns/1ps

module ID_EX(
           input clk,
           input [31:0] in_rs1,
           input [31:0] in_rs2,
           input [1:0]  in_aluSrc1,
           input        in_aluSrc2,
           input [4:0]  in_aluOp,
           input [1:0]  in_nextPCSrc,
           input [1:0]  in_memWrite,
           input [2:0]  in_memRead,
           input        in_regWrite,
           input [2:0]  in_regWriteSrc,
           input        in_memToReg,
           output reg [31:0] out_rs1,
           output reg [31:0] out_rs2,
           output reg [1:0]  out_aluSrc1,
           output reg        out_aluSrc2,
           output reg [4:0]  out_aluOp,
           output reg [1:0]  out_nextPCSrc,
           output reg [1:0]  out_memWrite,
           output reg [2:0]  out_memRead,
           output reg        out_regWrite,
           output reg [2:0]  out_regWriteSrc,
           output reg        out_memToReg
       );
always @(posedge clk) begin
    out_rs1 <= in_rs1;
    out_rs2 <= in_rs2;
    out_aluSrc1 <= in_aluSrc1;
    out_aluSrc2 <= in_aluSrc2;
    out_aluOp <= in_aluOp;
    out_nextPCSrc <= in_nextPCSrc;
    out_memWrite <= in_memWrite;
    out_memRead <= in_memRead;
    out_regWrite <= in_regWrite;
    out_regWriteSrc <= in_regWriteSrc;
    out_memToReg <= in_memToReg;
end


endmodule
