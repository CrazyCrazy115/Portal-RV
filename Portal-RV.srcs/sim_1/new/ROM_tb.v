`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/01 13:45:09
// Design Name: 
// Module Name: ROM_tb
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


module ROM_tb(

    );
reg					sys_clk;
	reg					sys_rst_n;
	reg 	[7 : 0] 	addra;
	wire	[7 : 0]		douta;
//init sys_clk
initial 
	begin
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		#20
		sys_rst_n <= 1'b1;
	end
//change sys_clk
always #10 sys_clk = ~sys_clk;
always @(posedge sys_clk or negedge sys_rst_n) begin
	if (sys_rst_n == 1'b0) begin
		addra <= 8'b0;
	end
	else if (addra == 8'd255) begin
		addra <= 8'b0;
	end
	else begin
		addra <= addra + 1'b1;
	end
end
//例化
ROM tb_rom(
	.addra(addra + 1),
	.douta(douta),
	.clka(sys_clk)
);
endmodule
