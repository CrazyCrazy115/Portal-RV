`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/30 19:40:08
// Design Name: 
// Module Name: ForwardBUnit
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


module ForwardBUnit(
    input [4:0] exe_mem_rd,
    input       exe_mem_regWrite,
    input [4:0] rs1,
    input [4:0] rs2,
    output      forwardA,
    output      forwardB
    );
assign forwardA = ((exe_mem_regWrite) &&
                   (exe_mem_rd != 0)  &&
                   (exe_mem_rd == rs1)) ? `FORWARD_B_EXE_MEM : `FORWARD_B_RF;
assign forwardB = ((exe_mem_regWrite) &&
                   (exe_mem_rd != 0 ) &&
                   (exe_mem_rd == rs2)) ? `FORWARD_B_EXE_MEM : `FORWARD_B_RF;
endmodule
