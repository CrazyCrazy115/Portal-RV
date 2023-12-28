`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/28 19:49:44
// Design Name: 
// Module Name: ALU_Branch
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



// alu for branch, check branch condition
module ALU_Branch(
    input [31:0] a,
    input [31:0] b,
    input [4 :0] aluOp,
    output cond
    );
wire eq;
wire neq;
wire lt;
wire ge;
wire ltu;
wire geu;
assign eq = (a == b);
assign neq = ~eq;
assign lt = $signed(a) < $signed(b);
assign ge = ~lt;
assign ltu = a < b;
assign geu = ~ltu;
assign cond = (aluOp == `EQ && eq) ||
              (aluOp == `NEQ && neq) ||
              (aluOp == `LTS && lt) ||
              (aluOp == `GES && ge) ||
              (aluOp == `LTU && ltu) ||
              (aluOp == `GEU && geu);
endmodule


