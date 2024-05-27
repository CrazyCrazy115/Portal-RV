`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/30 19:57:16
// Design Name: 
// Module Name: BHazardDetectionUnit
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


module BHazardDetectionUnit(
    input [1:0] next_pc_src,
    input [2:0] exe_mem_memRead,
    input [4:0] exe_mem_rd,
    input       id_exe_regWrite,
    input [4:0] id_exe_regWriteRd,
    input [4:0] rs1,
    input [4:0] rs2,
    output stall
    );
assign stall = (next_pc_src != `NEXT_PC_JUMP) && 
               (next_pc_src == `NEXT_PC_BRANCH || next_pc_src == `NEXT_PC_JUMPR) && 
               (((exe_mem_memRead != `MEM_READ_N) && 
                 ((exe_mem_rd == if_id_rs1) || (exe_mem_rd == if_id_rs2))
                ) || 
                ((id_exe_regWrite == `REG_WRITE_Y) &&
                 ((id_exe_regWriteRd == if_id_rs1) || (id_exe_regWriteRd == if_id_rs2))
                ));
endmodule
