`timescale 1ns/1ps

module EXE_WB(
           input clk,
           input [31:0] in_aluRes,
           input [31:0] in_memRead,
           input        in_regWrite,
           input [2 :0] in_regWriteSrc,
           input        in_memToReg,
           output reg [31:0] out_aluRes,
           output reg [31:0] out_memRead,
           output reg        out_regWrite,
           output reg [2 :0] out_regWriteSrc,
           output reg        out_memToReg
       );
always @(posedge clk) begin
    out_aluRes      <= in_aluRes;
    out_memRead     <= in_memRead;
    out_regWrite    <= in_regWrite;
    out_regWriteSrc <= in_regWriteSrc;
    out_memToReg    <= in_memToReg;
end
endmodule
