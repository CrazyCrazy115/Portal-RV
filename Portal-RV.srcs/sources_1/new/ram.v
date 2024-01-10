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
    reg [7:0] ram_mem[0:`DM_SIZE-1];
    initial begin
        $readmemh(`RAM_PATH, ram_mem);
    end
    always @(*) begin
        rdata <= re ? {ram_mem[raddr+3], ram_mem[raddr+2], ram_mem[raddr+1], ram_mem[raddr]} : 0;
    end
    always @(posedge clk) begin
        if (we) begin
            ram_mem[waddr] <= wdata[7:0];
            ram_mem[waddr+1] <= wdata[15:8];
            ram_mem[waddr+2] <= wdata[23:16];
            ram_mem[waddr+3] <= wdata[31:24];
        end
    end

endmodule
