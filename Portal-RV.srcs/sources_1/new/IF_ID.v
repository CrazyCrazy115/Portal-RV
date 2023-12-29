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
           input rst,
           input flush,
           input [31:0] in_inst,
           input [31:0] in_pc,
           output reg [31:0] out_inst,
           output reg [4 :0] rs2,
           output reg [4 :0] rs1,
           output reg [4 :0] rd,
           output reg [31:0] out_pc
       );
always @(posedge clk) begin
    if (rst) begin
        out_inst <= 0;
        rs2      <= 0;
        rs1      <= 0;
        rd       <= 0;
        out_pc   <= 0;
    end
    else begin
        out_inst <= flush ? 32'h00000000 : in_inst;
        // split the instruction
        rs2      <= flush ? 5'b00000 : in_inst[24:20];
        rs1      <= flush ? 5'b00000 : in_inst[19:15];
        rd       <= flush ? 5'b00000 : in_inst[11:7];
        out_pc   <= in_pc;
    end
end
endmodule
