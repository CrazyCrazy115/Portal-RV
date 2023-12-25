`timescale 1ns / 1ps
`include "definitions.vh"

module cpu(
           input clk,
           input rst,
           // instruction
           input [31:0] inst,
           output [31:0] pc,
           // memory write
           output [31:0] mem_waddr,
           output [31:0] mem_wdata,
           // memory read
           output [31:0] mem_raddr,
           input  [31:0] mem_rdata
       );
// PC
wire stall;
wire [31:0] d_next_pc;
wire b_cond;
PC PC(
       .clk(clk),
       .rst(rst),
       .stall(stall),
       .b_cond(b_cond),
       .d_next_pc(d_next_pc),
       .pc(pc)
   );

// if/id
wire [31:0] inst_id;
wire [4 :0] rs2_id;
wire [4 :0] rs1_id;
wire [4 :0] rd_id;
wire [31:0] pc_id;
IF_ID if_id(
          .clk(clk),
          .in_inst(inst),
          .in_pc(pc),
          .out_inst(inst_id),
          .rs2(rs2_id),
          .rs1(rs1_id),
          .rd(rd_id),
          .out_pc(pc_id)
      );


// instruction decode stage

// register files
wire regWrite;
wire [31:0] wdata;
wire [31:0] rdata1_id;
wire [31:0] rdata2_id;
RegFiles rf(
             .clk(clk),
             .rst(rst),
             .wen(regWrite),
             .wdata(wdata),
             .waddr(rd_id),
             .raddr1(rs1_id),
             .rdata1(rdata1_id),
             .raddr2(rs2_id),
             .rdata2(rdata2)
         );

// control signal decode from idu
wire [31:0] imm_id;
wire [1:0]  aluSrc1_id;
wire        aluSrc2_id;
wire [4:0]  aluOp_id;
wire [1:0]  nextPCSrc_id;
wire [1:0]  memWrite_id;
wire [2:0]  memRead_id;
wire        regWrite_id;
wire [2:0]  regWriteSrc_id;
wire        memToReg_id;

IDU idu(
    .clock(clk),
    .reset(rst),
    .io_inst(inst_id),
    .io_imm(imm_id),
    .io_aluSrc1(aluSrc1_id),
    .io_aluSrc2(aluSrc2_id),
    .io_aluOp(aluOp_id),
    .io_nextPCSrc(nextPCSrc_id),
    .io_memWrite(memWrite_id),
    .io_memRead(memRead_id),
    .io_regWrite(regWrite_id),
    .io_regWriteSrc(regWriteSrc_id),
    .io_memToReg(memToReg_id)
);

// id/exe
wire [31:0] rs1_exe;
wire [31:0] rs2_exe;
wire [31:0] imm_exe;
wire [1:0]  aluSrc1_exe;
wire        aluSrc2_exe;
wire [4:0]  aluOp_exe;
wire [1:0]  nextPCSrc_exe;
wire [1:0]  memWrite_exe;
wire [2:0]  memRead_exe;
wire        regWrite_exe;
wire [2:0]  regWriteSrc_exe;
wire        memToReg_exe;
ID_EX id_ex(
    .clk(clk),
    .in_pc(pc_id),
    .in_imm(imm_id),
    .in_rs1(rdata1_id),
    .in_rs2(rdata2_id),
    .in_aluSrc1(aluSrc1_id),
    .in_aluSrc2(aluSrc2_id),
    .in_aluOp(aluOp_id),
    .in_nextPCSrc(nextPCSrc_id),
    .in_memWrite(memWrite_id),
    .in_memRead(memRead_id),
    .in_regWrite(regWrite_id),
    .in_regWriteSrc(regWriteSrc_id),
    .in_memToReg(memToReg_id),
    .out_pc(pc_exe),
    .out_imm(imm_exe),
    .out_rs1(rs1_exe),
    .out_rs2(rs2_exe),
    .out_aluSrc1(aluSrc1_exe),
    .out_aluSrc2(aluSrc2_exe),
    .out_aluOp(aluOp_exe),
    .out_nextPCSrc(nextPCSrc_exe),
    .out_memWrite(memWrite_exe),
    .out_memRead(memRead_exe),
    .out_regWrite(regWrite_exe),
    .out_regWriteSrc(regWriteSrc_exe),
    .out_memToReg(memToReg_exe)
);

// execute stage
wire [31:0] alu_a;
wire [31:0] alu_b;
wire [31:0] alu_res_exe;
wire overflow;
wire carry;
assign alu_a = (aluSrc1_exe == `RS1) ? rs1_exe :
               (aluSrc1_exe == `PC ) ? pc_exe  : 0;
assign alu_b = (aluSrc2_exe == `RS2) ? rs2_exe :
               (aluSrc2_exe == `IMM) ? imm_exe : 0;

// alu
ALU alu(
    .a(alu_a),
    .b(alu_b),
    .aluOp(aluOp_exe),
    .out(alu_res_exe),
    .overflow(overflow),
    .carry(carry)
);

// adder for next pc
// immediate number shift left 2 bits
wire [31:0] sl2_imm;
wire [31:0] dnpc;
assign sl2_imm = imm_exe << 2;
Adder dnpc_adder(
    .a(pc_exe),
    .b(imm_exe),
    .out(dnpc)
);


endmodule

