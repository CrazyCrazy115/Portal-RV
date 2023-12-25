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


module adder(
    input clk,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] out,
    output reg carry,
    output reg overflow
    );
    always @(posedge clk ) begin
        {carry, out} <= a + b;
        overflow <= (a[31] == b[31] && a[31] != out[31]);
    end
endmodule
