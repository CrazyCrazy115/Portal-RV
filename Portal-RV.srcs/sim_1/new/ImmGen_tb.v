`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/26 23:19:52
// Design Name: 
// Module Name: ImmGen_tb
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


module ImmGen_tb(
    );
reg [31:0] inst;
reg [2 :0] instType;
wire [31:0] imm;
ImmGen immGen(
    .io_inst(inst),
    .io_instType(instType),
    .io_imm(imm)
);
initial begin
    inst <= 32'h0c4000ef;
    instType <= 3'b101;

    
end
endmodule
