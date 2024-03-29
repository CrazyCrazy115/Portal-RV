`timescale 1ns / 1ps

module ImmGen(
           input  [31:7] io_inst,
           input  [2:0]  io_instType,
           output [31:0] io_imm
       );

wire [31:0] _GEN [7:0];

assign _GEN[0] = {32'h0};
assign _GEN[1] = {{21{io_inst[31]}}, io_inst[30:20]};
assign _GEN[2] = {{21{io_inst[31]}}, io_inst[30:25], io_inst[11:7]};
assign _GEN[3] = {{20{io_inst[31]}}, io_inst[7], io_inst[30:25], io_inst[11:8], 1'h0};
assign _GEN[4] = {io_inst[31:12], 12'h0};
assign _GEN[5] = {{12{io_inst[31]}}, io_inst[19:12], io_inst[20], io_inst[30:21], 1'h0};
assign _GEN[6] = {32'h0};
assign _GEN[7] = {32'h0};

assign io_imm = _GEN[io_instType];
endmodule
