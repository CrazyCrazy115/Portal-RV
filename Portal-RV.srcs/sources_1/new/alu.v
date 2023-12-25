`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/25 20:52:48
// Design Name:
// Module Name: alu
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


module alu(
           input clk,
           input rst,
           input [31:0] a,
           input [31:0] b,
           input [4:0]  aluOp,
           output reg [31:0] out,
           output reg overflow,
           output reg carry
       );
reg [31:0] t_no_cin;
always @(posedge clk) begin
    case(aluOp)
        `ADD : begin
            {carry, out} <= a + b;
            overflow <= (a[31] == b[31] && a[31] != out[31]);
        end
        `SUB : begin
            t_no_cin <= {32{1'b1}} ^ b;
            {carry, out} <= a + t_no_cin + 1'b1;
            overflow <= (a[31] != t_no_cin[31] && a[31] != out[31]);
        end
        `XOR :
            out <= a ^ b;
        `AND :
            out <= a & b;
        `OR  :
            out <= a | b;
        `SLL :
            out <= a << b[4:0];
        `SRL :
            out <= a >> b[4:0];
        `SRA :
            out <= $signed(a) >>> b[4:0];
        `MULL:
            out <= $signed(a) * $signed(b);
        `MULH:
            out <= $signed(a) * $signed(b) >> 32;
        `DIVU:
            out <= a / b;
        `DIVS:
            out <= $signed(a) / $signed(b);
        `LTU :
            out <= a < b;
        `GEU :
            out <= a >= b;
        `LTS :
            out <= $signed(a) < $signed(b);
        `GES :
            out <= $signed(a) >= $signed(b);
        `EQ  :
            out <= a == b;
        `NEQ :
            out <= a != b;
        default:
            out <= 0;
    endcase
end
endmodule
