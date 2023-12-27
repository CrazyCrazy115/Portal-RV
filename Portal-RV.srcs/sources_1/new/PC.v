`timescale 1ns / 1ps
`include "definitions.vh"

module PC(
           input clk,
           input rst,
           input stall,
           input [31:0] d_next_pc,
           output reg [31:0] pc
       );

always @(posedge clk) begin
    if (rst)
        pc <= `PC_INIT;
    else
        pc <= stall ? pc : d_next_pc;
end

endmodule
