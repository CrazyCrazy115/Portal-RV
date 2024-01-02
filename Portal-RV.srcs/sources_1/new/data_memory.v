`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/26 20:33:01
// Design Name:
// Module Name: data_memory
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


module data_memory(
           input clk,
           input we,
           input [1 :0] wtype,
           input [31:0] waddr,
           input [31:0] wdata,
           input re,
           input [31:0] raddr,
           output [31:0] rdata
       );
reg [7:0] mem [0:`DM_SIZE - 1];
initial begin
    $readmemh(`RAM_PATH, mem);
end
assign rdata = re ? {mem[raddr + 3], mem[raddr + 2], mem[raddr + 1], mem[raddr]} : 0;
always @(posedge clk) begin
    if (we) begin
        case (wtype)
            `MEM_WRITE_B: begin
                mem[waddr] <= wdata[7:0];
            end
            `MEM_WRITE_H: begin
                mem[waddr + 1] <= wdata[15:8];
                mem[waddr]     <= wdata[7:0];
            end
            `MEM_WRITE_W: begin
                mem[waddr + 3] <= wdata[31:24];
                mem[waddr + 2] <= wdata[23:16];
                mem[waddr + 1] <= wdata[15:8];
                mem[waddr]     <= wdata[7:0];
            end
        endcase
    end
end
endmodule
