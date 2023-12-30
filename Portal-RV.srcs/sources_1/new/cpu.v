`timescale 1ns / 1ps
`include "definitions.vh"

module cpu(
           input clk,
           input rst,
           // instruction
           input [31:0] inst,
           output [31:0] pc,
           // memory write
           output        we,
           output [1 :0] wtype,
           output [31:0] waddr,
           output [31:0] wdata,
           // memory read
           output        re,
           output [31:0] raddr,
           input  [31:0] rdata
       );

// if/id
wire [31:0] inst_id;
wire [4 :0] rs2_id;
wire [4 :0] rs1_id;
wire [4 :0] rd_id;
wire [31:0] pc_id;
// register files
wire regWrite;
wire [4 :0] reg_waddr;
wire [31:0] reg_wdata;
wire [31:0] rdata1_id;
wire [31:0] rdata2_id;
// control signal decode from idu
wire [31:0] imm_id;
wire [1 :0] aluSrc1_id;
wire [1 :0] aluSrc2_id;
wire [4 :0] aluOp_id;
wire [1 :0] nextPCSrc_id;
wire [1 :0] memWrite_id;
wire [2 :0] memRead_id;
wire        regWrite_id;
wire [2 :0] regWriteSrc_id;

// id/exe
wire [31:0] pc_exe;
wire [31:0] imm_exe;
wire [4 :0] rs1_exe;
wire [4 :0] rs2_exe;
wire [31:0] rdata1_exe;
wire [31:0] rdata2_exe;
wire [1 :0] aluSrc1_exe;
wire [1 :0] aluSrc2_exe;
wire [4 :0] aluOp_exe;
wire [1 :0] memWrite_exe;
wire [2 :0] memRead_exe;
wire        regWrite_exe;
wire [2 :0] regWriteSrc_exe;
wire [4 :0] regWriteRd_exe;

// exe/mem
wire [31:0] aluRes_mem;
wire [31:0] rdata2_mem;
wire [31:0] pc_mem;
wire [1 :0] memWrite_mem;
wire [2 :0] memRead_mem;
wire        regWrite_mem;
wire [2 :0] regWriteSrc_mem;
wire [4 :0] regWriteRd_mem;

// mem/wb
wire [31:0] aluRes_wb;
wire [31:0] pc_wb;
wire [31:0] memRead_wb;
wire        regWrite_wb;
wire [2 :0] regWriteSrc_wb;
wire [4 :0] regWriteRd_wb;

// ------------------------------------------------------------------
// instruction fetch stage
// PC
wire stallD;
wire stallB;
wire stall;
wire jump;
wire [31:0] d_next_pc;
PC PC(
       .clk(clk),
       .rst(rst),
       .stall(stall),
       .d_next_pc(d_next_pc),
       .pc(pc)
   );

IF_ID if_id(
          .clk(clk),
          .rst(rst),
          .flush(jump),
          .stall(stall),
          .in_inst(inst),
          .in_pc(pc),
          .out_inst(inst_id),
          .rs2(rs2_id),
          .rs1(rs1_id),
          .rd(rd_id),
          .out_pc(pc_id)
      );

// Data Hazard detection unit
HazardDetectionUnit hdu(
    .id_exe_memRead(memRead_exe),
    .id_exe_rd(regWriteRd_exe),
    .if_id_rs1(rs1_id),
    .if_id_rs2(rs2_id),
    .stall(stallD)
);

// Control Hazard detection unit
BHazardDetectionUnit bhdu(
    .next_pc_src(nextPCSrc_id),
    .exe_mem_memRead(memRead_mem),
    .exe_mem_rd(regWriteRd_mem),
    .id_exe_regWrite(regWrite_exe),
    .id_exe_regWriteRd(regWriteRd_exe),
    .rs1(rs1_id),
    .rs2(rs2_id),
    .stall(stallB)
);
assign stall = stallD || stallB;

// instruction decode stage
// register files
RegFiles rf(
             .clk(clk),
             .rst(rst),
             .wen(regWrite),
             .wdata(reg_wdata),
             .waddr(reg_waddr),
             .raddr1(rs1_id),
             .rdata1(rdata1_id),
             .raddr2(rs2_id),
             .rdata2(rdata2_id)
         );

// instruction decode
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
    .io_regWriteSrc(regWriteSrc_id)
);
// branch or jump


// check the branch condition
wire branch_cond;
wire forwardBranch_A;
wire [31:0] aluBranch_a;
wire [31:0] aluBranch_b;
wire forwardBranch_B;
ForwardBUnit fbu(
    .exe_mem_rd(regWriteRd_mem),
    .exe_mem_regWrite(regWrite_mem),
    .rs1(rs1_id),
    .rs2(rs2_id),
    .forwardA(forwardBranch_A),
    .forwardB(forwardBranch_B)
);
assign aluBranch_a = (forwardBranch_A == `FORWARD_B_EXE_MEM) ? aluRes_mem :
                     (forwardBranch_A == `FORWARD_B_RF     ) ? rdata1_id  :
                     0;
assign aluBranch_b = (forwardBranch_B == `FORWARD_B_EXE_MEM) ? aluRes_mem :
                     (forwardBranch_B == `FORWARD_B_RF     ) ? rdata2_id  :
                     0;
// calculate dynamic next pc
wire [31:0] dnpc;
wire [31:0] adder_a;
assign adder_a = (nextPCSrc_id == `NEXT_PC_JUMPR) ? rdata1_id : pc_id;
Adder dnpc_adder(
    .a(adder_a),
    .b(imm_id),
    .out(dnpc)
);
ALU_Branch alu_branch(
    .a(aluBranch_a),
    .b(aluBranch_b),
    .aluOp(aluOp_id),
    .cond(branch_cond)
);

assign jump = (nextPCSrc_id == `NEXT_PC_JUMP                 ) ? 1'b1 :
              (nextPCSrc_id == `NEXT_PC_BRANCH && branch_cond) ? 1'b1 :
              (nextPCSrc_id == `NEXT_PC_JUMPR                ) ? 1'b1 : 
              1'b0;
assign d_next_pc = (jump && nextPCSrc_id == `NEXT_PC_JUMPR) ? dnpc & 32'hfffffffe : 
                   (jump                                  ) ? dnpc : 
                   pc + 4'h4;

// id/exe
ID_EXE id_exe(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .in_pc(pc_id),
    .in_imm(imm_id),
    .in_rs1(rs1_id),
    .in_rs2(rs2_id),
    .in_rdata1(rdata1_id),
    .in_rdata2(rdata2_id),
    .in_aluSrc1(aluSrc1_id),
    .in_aluSrc2(aluSrc2_id),
    .in_aluOp(aluOp_id),
    .in_memWrite(memWrite_id),
    .in_memRead(memRead_id),
    .in_regWrite(regWrite_id),
    .in_regWriteSrc(regWriteSrc_id),
    .in_regWriteRd(rd_id),
    .out_pc(pc_exe),
    .out_imm(imm_exe),
    .out_rs1(rs1_exe),
    .out_rs2(rs2_exe),
    .out_rdata1(rdata1_exe),
    .out_rdata2(rdata2_exe),
    .out_aluSrc1(aluSrc1_exe),
    .out_aluSrc2(aluSrc2_exe),
    .out_aluOp(aluOp_exe),
    .out_memWrite(memWrite_exe),
    .out_memRead(memRead_exe),
    .out_regWrite(regWrite_exe),
    .out_regWriteSrc(regWriteSrc_exe),
    .out_regWriteRd(regWriteRd_exe)
);


// execute stage
// prepare for alu
// forward unit
wire [1:0] forwardA;
wire [1:0] forwardB;
wire [31:0] data1;
wire [31:0] data2;
ForwardUnit fu(
    .exe_mem_rd(regWriteRd_mem),
    .mem_wb_rd(regWriteRd_wb),
    .exe_mem_regWrite(regWrite_mem),
    .mem_wb_regWrite(regWrite_wb),
    .id_exe_rs1(rs1_exe),
    .id_exe_rs2(rs2_exe),
    .forwardA(forwardA),
    .forwardB(forwardB)
);
assign data1 = (forwardA == `FORWARD_ID_EXE ) ? rdata1_exe :
               (forwardA == `FORWARD_EXE_MEM) ? aluRes_mem :
               (forwardA == `FORWARD_MEM_WB ) ? reg_wdata  : 
               0;
assign data2 = (forwardB == `FORWARD_ID_EXE ) ? rdata2_exe :
               (forwardB == `FORWARD_EXE_MEM) ? aluRes_mem :
               (forwardB == `FORWARD_MEM_WB)  ? reg_wdata  :
               0;

wire [31:0] alu_a;
wire [31:0] alu_b;
wire [31:0] aluRes_exe;
wire overflow;
wire carry;
assign alu_a = (aluSrc1_exe == `RS1) ? data1   :
               (aluSrc1_exe == `PC ) ? pc_exe  : 
               0;
assign alu_b = (aluSrc2_exe == `RS2) ? data2   :
               (aluSrc2_exe == `IMM) ? imm_exe : 
               0;

// alu
ALU alu(
    .a(alu_a),
    .b(alu_b),
    .aluOp(aluOp_exe),
    .out(aluRes_exe),
    .overflow(overflow),
    .carry(carry)
);

// exe/mem
EXE_MEM exe_mem(
    .clk(clk),
    .rst(rst),
    .in_aluRes(aluRes_exe),
    .in_rdata2(data2),
    .in_pc(pc_exe),
    .in_memWrite(memWrite_exe),
    .in_memRead(memRead_exe),
    .in_regWrite(regWrite_exe),
    .in_regWriteSrc(regWriteSrc_exe),
    .in_regWriteRd(regWriteRd_exe),
    .out_aluRes(aluRes_mem),
    .out_rdata2(rdata2_mem),
    .out_pc(pc_mem),
    .out_memWrite(memWrite_mem),
    .out_memRead(memRead_mem),
    .out_regWrite(regWrite_mem),
    .out_regWriteSrc(regWriteSrc_mem),
    .out_regWriteRd(regWriteRd_mem)
);

// memory stage
// memory write
assign we = (memWrite_mem != `MEM_WRITE_N) ? 1'b1 : 1'b0;
assign wtype = memWrite_mem;
assign waddr = aluRes_mem;
assign wdata = rdata2_mem;

// memory read
assign re = (memRead_mem != `MEM_READ_N) ? 1'b1 : 1'b0;
assign raddr = aluRes_mem;
wire [31:0] rdata_mem;
// data extend
assign rdata_mem = (memRead_mem == `MEM_READ_BS) ? {{24{rdata[7]}}, rdata[7:0]}   :
                   (memRead_mem == `MEM_READ_BU) ? {{24{1'b0}}, rdata[7:0]}       :
                   (memRead_mem == `MEM_READ_HU) ? {{16{1'b0}}, rdata[15:0]}      :
                   (memRead_mem == `MEM_READ_HS) ? {{16{rdata[15]}}, rdata[15:0]} :
                   (memRead_mem == `MEM_READ_W ) ? rdata                          : 
                   0;

// mem/wb
MEM_WB mem_wb(
    .clk(clk),
    .rst(rst),
    .in_aluRes(aluRes_mem),
    .in_pc(pc_mem),
    .in_memRead(rdata_mem),
    .in_regWrite(regWrite_mem),
    .in_regWriteSrc(regWriteSrc_mem),
    .in_regWriteRd(regWriteRd_mem),
    .out_aluRes(aluRes_wb),
    .out_pc(pc_wb),
    .out_memRead(memRead_wb),
    .out_regWrite(regWrite_wb),
    .out_regWriteSrc(regWriteSrc_wb),
    .out_regWriteRd(regWriteRd_wb)
);

// write back stage
assign regWrite = (regWriteSrc_wb != `REG_WRITE_SRC_N) ? 1'b1 : 1'b0;
assign reg_wdata = (regWriteSrc_wb == `REG_WRITE_SRC_ALU_RES) ? aluRes_wb :
                   (regWriteSrc_wb == `REG_WRITE_SRC_PC4    ) ? pc_wb + 4'h4 :
                   (regWriteSrc_wb == `REG_WRITE_SRC_MEM    ) ? memRead_wb : 0;
assign reg_waddr = regWriteRd_wb;
endmodule

