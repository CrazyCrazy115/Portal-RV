`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/25 17:59:51
// Design Name: 
// Module Name: idu_testbench
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


module idu_testbench(

    );
    reg clk;
reg rst;
reg [31:0] mem [0:1023];
reg  [9:0] addr ;
reg  [31:0]data_out ;
wire [31:0] imm;
wire [2:0] instType;
wire [1:0] alusrc1;
wire alusrc2;
wire [4:0] aluOp;
wire [1:0] nextPCSrc;
wire [1:0] memWrite;
wire [2:0] memRead;
wire regWrite;
wire [2:0] regWriteSrc;
wire memToReg;

idu idu(.clock(clk),
.reset(rst),
.io_inst(data_out[31:0]),
.io_imm(imm[31:0]),
.io_instType(instType[2:0]),
.io_aluSrc1(alusrc1[1:0]),
.io_aluSrc2(alusrc2),
.io_aluOp(aluOp[4:0]),
.io_nextPCSrc(nextPCSrc[1:0]),
.io_memWrite(memWrite[1:0]),
.io_memRead(memRead[2:0]),
.io_regWrite(regWrite),
.io_regWriteSrc(regWriteSrc[2:0]),
.io_memToReg(memToReg));


initial begin
    $readmemh("E:/Download/add-longlong-riscv32-nemu-instruction.txt",mem);
    addr  = 10'd0;
end

always #10
begin
    data_out = mem[addr][31:0];
    addr = addr + 10'd1;
end



endmodule
