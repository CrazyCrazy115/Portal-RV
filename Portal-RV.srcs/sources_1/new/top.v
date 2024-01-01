`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/26 20:46:07
// Design Name:
// Module Name: top
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


module top(
           input clk,
           input rst,
           output finish
       );
wire [31:0] inst;
wire [31:0] pc;
wire we;
wire [1:0] wtype;
wire [31:0] waddr;
wire [31:0] wdata;
wire re;
wire [31:0] raddr;
wire [31:0] rdata;

cpu cpu(
        .clk(clk),
        .rst(rst),
        .finish(finish),
        .inst(inst),
        .pc(pc),
        .we(we),
        .wtype(wtype),
        .waddr(waddr),
        .wdata(wdata),
        .re(re),
        .raddr(raddr),
        .rdata(rdata)
    );

instruction_memory instruction_memory(
                       .pc(pc),
                       .inst(inst)
                   );

data_memory data_memory(
                .clk(clk),
                .we(we),
                .wtype(wtype),
                .waddr(waddr),
                .wdata(wdata),
                .re(re),
                .raddr(raddr),
                .rdata(rdata)
            );
endmodule
