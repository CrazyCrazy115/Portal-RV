`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/23 21:34:15
// Design Name:
// Module Name: IF_ID
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


module IF_ID(
           input clk,
           input [31:0] in_inst,
           output reg [31:0] out_inst,
           output reg [4:0]  rs2,
           output reg [4:0]  rs1,
           output reg [4:0]  rd
       );
always @(posedge clk) begin
    out_inst <= in_inst;
    // split the instruction
    rs2      <= in_inst[24:20];
    rs1      <= in_inst[19:15];
    rd       <= in_inst[11:7];
end
endmodule
