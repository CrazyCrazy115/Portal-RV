`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/23 19:37:05
// Design Name:
// Module Name: PC
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


module PC(
           input clk,
           input rst,
           input stall,
           input b_cond,
           input [31:0] d_next_pc,
           output reg [31:0] pc
       );

always @(posedge clk) begin
    if (rst)
        pc <= 0;
    else
        pc <= stall  ? pc :
              b_cond ? d_next_pc : 
              pc + 4'h4;
end

endmodule
