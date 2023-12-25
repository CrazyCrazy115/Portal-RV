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
           output reg [5:0]  rs2,
           output reg [5:0]  rs1,
           output reg [5:0]  rd,
           output reg [6:0]  opcode,
           output reg [9:0]  funct
       );
always @(posedge clk) begin
    out_inst <= in_inst;
    // split the instruction
    rs2      <= in_inst[24:20];
    rs1      <= in_inst[19:15];
    rd       <= in_inst[11:7];
    opcode   <= in_inst[6:0];
    funct    <= {in_inst[31:25], in_inst[14:12]};
end
endmodule
