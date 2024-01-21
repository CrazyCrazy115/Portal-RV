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
           input btn,
           input rst,
           output finish,
           output stall,
           output jump,
           output [3:0] an,
           output [6:0] sseg
       );
wire clk_dived;
wire [31:0] inst;
wire [31:0] pc;
wire we;
wire [1:0] wtype;
wire [31:0] waddr;
wire [31:0] wdata;
wire re;
wire [31:0] raddr;
wire [31:0] rdata;

clk_div clk_div(
    .clk(clk),
    .rst(rst),
    .clk_out(clk_dived)
);
cpu cpu(
        .clk(clk_dived),
        .rst(rst),
        .finish(finish),
        .stall(stall),
        .jump(jump),
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

// instruction_memory instruction_memory(
//                        .pc(pc),
//                        .inst(inst)
//                    );
// data_memory data_memory(
//                 .clk(clk),
//                 .we(we),
//                 .wtype(wtype),
//                 .waddr(waddr),
//                 .wdata(wdata),
//                 .re(re),
//                 .raddr(raddr),
//                 .rdata(rdata)
//             );

rom rom(
    .ce(rst),
    .addr(pc),
    .inst(inst)
);

ram ram(
    .clk(clk_dived),
    .we(we),
    .waddr(waddr),
    .wdata(wdata),
    .re(re),
    .raddr(raddr),
    .rdata(rdata)
);

scan_led_hex_disp seg(
    .clk(clk),
    .reset(rst),
    .hex0(pc[3:0]),
    .hex1(pc[7:4]),
    .hex2(pc[11:8]),
    .hex3(pc[15:12]),
    .an(an),
    .sseg(sseg)
);


endmodule
