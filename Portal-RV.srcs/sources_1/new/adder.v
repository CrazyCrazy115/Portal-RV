`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/25 21:24:47
// Design Name: 
// Module Name: adder
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


// simple adder for dynamic next pc calculate
module Adder(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] out
);
    always @(*) begin
        out = a + b;
    end
endmodule
