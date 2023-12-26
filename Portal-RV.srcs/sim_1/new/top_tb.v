`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/26 21:09:38
// Design Name:
// Module Name: top_tb
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


module top_tb();
reg clk;
reg rst;
top top(
        .clk(clk),
        .rst(rst)
    );
initial begin
    // load instructions
    $readmemh("E:/Download/add-longlong-riscv32-nemu-instruction.txt", top.instruction_memory.mem);
    rst = 1;
    clk = 0;
    #30
    rst = 0;
end

always #5 clk = ~clk;
endmodule