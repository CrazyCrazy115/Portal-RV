`timescale 1ns / 1ps

module RegFiles (
           input clk,
           // regs write
           input wen,
           input rst,
           input   [31:0]    wdata,
           input   [4 :0]    waddr,
           // regs read 1
           input   [4 :0]    raddr1,
           output  [31:0]    rdata1,
           // regs read 2
           input   [4 :0]    raddr2,
           output  [31:0]    rdata2
       );
reg [31:0] rf [31:0];
integer i;

assign rdata1 = (raddr1 == 0) ? 0 :
       (waddr == raddr1 && wen ? wdata : rf[raddr1]);
assign rdata2 = (raddr2 == 0) ? 0 :
       (waddr == raddr2 && wen ? wdata : rf[raddr2]);

always @(posedge clk) begin
	if (rst) begin
		for (i = 0; i < 32; i = i + 1) begin
			rf[i] <= 0;
		end
	end
	else begin
		if (wen) begin
			rf[waddr] <= wdata;
		end
	end
end
endmodule

