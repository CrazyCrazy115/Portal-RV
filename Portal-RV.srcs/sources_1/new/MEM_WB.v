`timescale 1ns/1ps

module MEM_WB(
           input clk,
           input rst,
           input [31:0] in_aluRes,
           input [31:0] in_pc,
           input [31:0] in_memRead,
           input        in_regWrite,
           input [2 :0] in_regWriteSrc,
           input        in_memToReg,
           input [4 :0] in_regWriteRd,
           output reg [31:0] out_aluRes,
           output reg [31:0] out_pc,
           output reg [31:0] out_memRead,
           output reg        out_regWrite,
           output reg [2 :0] out_regWriteSrc,
           output reg        out_memToReg,
           output reg [4 :0] out_regWriteRd
       );
always @(posedge clk) begin
    if (rst) begin
        out_aluRes      <= 0;
        out_pc          <= 0;
        out_memRead     <= 0;
        out_regWrite    <= 0;
        out_regWriteSrc <= 0;
        out_memToReg    <= 0;
        out_regWriteRd  <= 0;
    end
    else begin
        out_aluRes      <= in_aluRes;
        out_memRead     <= in_memRead;
        out_regWrite    <= in_regWrite;
        out_regWriteSrc <= in_regWriteSrc;
        out_memToReg    <= in_memToReg;
    end
end
endmodule
