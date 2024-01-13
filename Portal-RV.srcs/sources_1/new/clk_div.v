`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/12 16:44:39
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input clk,
    input rst,
    output reg clk_out
);

parameter N = 26'd20_000_000 , WIDTH = 25;
reg [WIDTH:0] counter;

always @(posedge clk or negedge rst) begin
	if (rst) begin
		counter <= 0;
		clk_out <= 0;
	end
	else if (counter == N-1) begin
		clk_out <= ~clk_out;
		counter <= 0;
	end
	else
		counter <= counter + 1;
end

endmodule
