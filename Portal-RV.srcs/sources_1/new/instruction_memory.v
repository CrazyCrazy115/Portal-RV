`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/26 20:33:01
// Design Name:
// Module Name: instruction_memory
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


module instruction_memory(
           input [31:0] pc,
           output [31:0] inst
       );
reg [31:0] mem [0:`IM_SIZE - 1];
initial begin
    $readmemh(`ROM_PATH, mem);
end

assign inst = mem[pc >> 2];
endmodule
