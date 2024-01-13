`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/01/02 16:51:48
// Design Name:
// Module Name: ram
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


module ram(
           input clk,
           input we,
           input [31:0] waddr,
           input [31:0] wdata,
           input re,
           input [31:0] raddr,
           output reg [31:0] rdata
       );
(*ram_style = "block"*) reg [31:0] ram_mem [0:`DM_SIZE-1];
initial begin
    $readmemh(`RAM_PATH, ram_mem);
end
always @(*) begin
    rdata <= re ? ram_mem[raddr[31:2]] : 0;
end
always @(posedge clk) begin
    if (we) begin
        ram_mem[waddr[31:2]] <= wdata;
    end
end

endmodule
