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
    reg [7:0] mem[0:`DM_SIZE-1];
    initial begin
        $readmemh(`RAM_PATH, mem);
    end
    always @(*) begin
        rdata <= re ? {mem[raddr+3], mem[raddr+2], mem[raddr+1], mem[raddr]} : 0;
    end
    always @(posedge clk) begin
        if (we) begin
            mem[waddr] <= wdata[7:0];
            mem[waddr+1] <= wdata[15:8];
            mem[waddr+2] <= wdata[23:16];
            mem[waddr+3] <= wdata[31:24];
        end
    end

endmodule
