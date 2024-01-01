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


module ALU(
           input [31:0] a,
           input [31:0] b,
           input [4 :0] aluOp,
           output reg [31:0] out
       );
always @(*) begin
    case(aluOp)
        `ADD : begin
            out <= $signed(a) + $signed(b);
        end
        `SUB : begin
            out <= $signed(a) - $signed(b);
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
