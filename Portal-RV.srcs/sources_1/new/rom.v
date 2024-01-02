`timescale 1ns/1ps
`include "definitions.vh"

module rom(
    input ce,
    input [31:0] addr,
    output reg [31:0] inst
);
reg [31:0] mem [0:`IM_SIZE - 1];

initial begin
    $readmemh(`ROM_PATH, mem);
end

always @(*) begin
    if (ce) begin
        inst <= 32'h00000000;
    end
    else begin
        inst <= mem[addr >> 2];
    end
end

endmodule

