`timescale 1ns / 1ps

module cpu(
           input clk,
           input rst,
           // instruction
           input [31:0] inst,
           output [31:0] pc,
           // memory write
           output [31:0] mem_waddr,
           output [31:0] mem_wdata,
           // memory read
           output [31:0] mem_raddr,
           input  [31:0] mem_rdata
       );
// PC
wire stall;
wire [31:0] d_next_pc;
wire b_cond;
PC PC(
       .clk(clk),
       .rst(rst),
       .stall(stall),
       .b_cond(b_cond),
       .d_next_pc(d_next_pc),
       .pc(pc)
   );

endmodule

