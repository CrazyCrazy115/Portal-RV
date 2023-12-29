`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/29 12:16:01
// Design Name: 
// Module Name: HazardDetectionUnit
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


module HazardDetectionUnit(
    input [2:0] id_exe_memRead,
    input [4:0] id_exe_rd,
    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,
    output stall
    );
assign stall = (id_exe_memRead != `MEM_READ_N && 
                ((id_exe_rd == if_id_rs1) || 
                 (id_exe_rd == if_id_rs2))
               );
endmodule
