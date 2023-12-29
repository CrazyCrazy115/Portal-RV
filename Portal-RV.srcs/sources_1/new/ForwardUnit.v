`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/27 23:11:11
// Design Name:
// Module Name: ForwardUnit
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


module ForwardUnit(
           input [4:0] exe_mem_rd,
           input [4:0] mem_wb_rd,
           input       exe_mem_regWrite,
           input       mem_wb_regWrite,
           input [4:0] id_exe_rs1,
           input [4:0] id_exe_rs2,
           output [1:0] forwardA,
           output [1:0] forwardB
       );
assign forwardA = ((exe_mem_regWrite) && 
                   (exe_mem_rd != 0) && 
                   (exe_mem_rd == id_exe_rs1)) ? `FORWARD_EXE_MEM :
                  ((mem_wb_regWrite) &&
                   (mem_wb_rd != 0) &&
                   (mem_wb_rd == id_exe_rs1)) ? `FORWARD_MEM_WB : 
                  `FORWARD_ID_EXE;

assign forwardB = ((exe_mem_regWrite) && 
                   (exe_mem_rd != 0) && 
                   (exe_mem_rd == id_exe_rs2)) ? `FORWARD_EXE_MEM :
                  ((mem_wb_regWrite) &&
                   (mem_wb_rd != 0) &&
                   (mem_wb_rd == id_exe_rs2)) ? `FORWARD_MEM_WB : 
                  `FORWARD_ID_EXE;
endmodule
