package core
import chisel3._
import chisel3.util._
import chisel3.util.experimental.decode.{EspressoMinimizer, QMCMinimizer, TruthTable, decoder}
import utils.ControlSignals._
import utils.Instructions._

object ControlLogic{
  val default: Seq[BitPat] = Seq(InstType.X, ALUSrc1.X, ALUSrc2.X, ALUOp.X, NextPCSrc.X, MemWrite.X, MemRead.X, RegWrite.X, RegWriteSrc.X)
  val table = TruthTable(Map(
    LUI   -> Seq(InstType.U, ALUSrc1.ZERO, ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    AUIPC -> Seq(InstType.U, ALUSrc1.PC  , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    JAL   -> Seq(InstType.J, ALUSrc1.PC  , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.Jump  , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.PC4   ),
    JALR  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.JumpR , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.PC4   ),
    BEQ   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.EQ  , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    BNE   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.NEQ , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    BLT   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTS , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    BGE   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.GES , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    BLTU  -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTU , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    BGEU  -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.GEU , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    LB    -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.BS, RegWrite.Y, RegWriteSrc.MEM   ),
    LH    -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.HS, RegWrite.Y, RegWriteSrc.MEM   ),
    LW    -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.W , RegWrite.Y, RegWriteSrc.MEM   ),
    LBU   -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.BU, RegWrite.Y, RegWriteSrc.MEM   ),
    LHU   -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.HU, RegWrite.Y, RegWriteSrc.MEM   ),
    SB    -> Seq(InstType.S, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.B, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    SH    -> Seq(InstType.S, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.H, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    SW    -> Seq(InstType.S, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.W, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    ADDI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SLTI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.LTS , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SLTIU -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.LTU , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    XORI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.XOR , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    ORI   -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.OR  , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    ANDI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.AND , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SLLI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.SLL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SRLI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.SRL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SRAI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.SRA , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    ADD   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SUB   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SUB , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SLL   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SLL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SLT   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTS , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SLTU  -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTU , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    XOR   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.XOR , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SRL   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SRL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    SRA   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SRA , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    OR    -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.OR  , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    AND   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.AND , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    MUL   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.MULL, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    MULH  -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.MULH, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    DIV   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.DIVS, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    DIVU  -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.DIVU, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes),
    EBRAK -> Seq(InstType.I, ALUSrc1.X   , ALUSrc2.X  , ALUOp.X   , NextPCSrc.X     , MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     ),
    NOP   -> Seq(InstType.X, ALUSrc1.X   , ALUSrc2.X  , ALUOp.X   , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     )
  ).map({case(k, v) => k -> v.reduce(_##_)}), default.reduce(_##_))
}

class ImmGen extends Module{
  val io = IO(new Bundle{
    val inst = Input(UInt(32.W))
    val instType = Input(UInt(InstType.WIDTH.W))
    val imm  = Output(UInt(32.W))
  })
  io.imm := MuxCase(0.U, Array(
    (io.instType === InstType.I) -> Cat(Fill(21, io.inst(31)), io.inst(30, 20)),
    (io.instType === InstType.S) -> Cat(Fill(21, io.inst(31)), io.inst(30, 25), io.inst(11, 7)),
    (io.instType === InstType.B) -> Cat(Fill(20, io.inst(31)), io.inst(7), io.inst(30, 25), io.inst(11, 8), 0.U(1.W)),
    (io.instType === InstType.U) -> Cat(io.inst(31, 12), Fill(12, 0.U(1.W))),
    (io.instType === InstType.J) -> Cat(Fill(12, io.inst(31)), io.inst(19, 12), io.inst(20), io.inst(30, 21), 0.U(1.W))
  ))
}

class idu extends Module{
  val io = IO(new Bundle{
    val rst = Input(Bool())
    val inst = Input(UInt(32.W))
    val imm = Output(UInt(32.W))
    val aluSrc1 = Output(UInt(ALUSrc1.WIDTH.W))
    val aluSrc2 = Output(UInt(ALUSrc2.WIDTH.W))
    val aluOp = Output(UInt(ALUOp.WIDTH.W))
    val nextPCSrc = Output(UInt(NextPCSrc.WIDTH.W))
    val memWrite = Output(UInt(MemWrite.WIDTH.W))
    val memRead = Output(UInt(MemRead.WIDTH.W))
    val regWrite = Output(UInt(RegWrite.WIDTH.W))
    val regWriteSrc = Output(UInt(RegWriteSrc.WIDTH.W))
  })
  val ctrlWord: UInt = decoder(minimizer = EspressoMinimizer, input = io.inst, truthTable = ControlLogic.table)
  val ctrlWordWidth = ctrlWord.getWidth
  var ctrlOffset = 0

  val instType = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - InstType.WIDTH)
  ctrlOffset += InstType.WIDTH
  val aluSrc1 = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - ALUSrc1.WIDTH)
  ctrlOffset += ALUSrc1.WIDTH
  val aluSrc2 = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - ALUSrc2.WIDTH)
  ctrlOffset += ALUSrc2.WIDTH
  val aluOp = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - ALUOp.WIDTH)
  ctrlOffset += ALUOp.WIDTH
  val nextPCSrc = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - NextPCSrc.WIDTH)
  ctrlOffset += NextPCSrc.WIDTH
  val memWrite = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - MemWrite.WIDTH)
  ctrlOffset += MemWrite.WIDTH
  val memRead = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - MemRead.WIDTH)
  ctrlOffset += MemRead.WIDTH
  val regWrite = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - RegWrite.WIDTH)
  ctrlOffset += RegWrite.WIDTH
  val regWriteSrc = ctrlWord(ctrlWordWidth - ctrlOffset - 1, ctrlWordWidth - ctrlOffset - RegWriteSrc.WIDTH)
  ctrlOffset += RegWriteSrc.WIDTH


  // get immediate value from immExt
  val immExt = Module(new ImmGen)
  immExt.io.inst <> io.inst
  immExt.io.instType <> instType
  immExt.io.imm <> io.imm

  io.aluSrc1 <> aluSrc1
  io.aluSrc2 <> aluSrc2
  io.aluOp <> aluOp
  io.nextPCSrc <> nextPCSrc
  io.memWrite <> memWrite
  io.memRead <> memRead
  io.regWrite <> regWrite
  io.regWriteSrc <> regWriteSrc
}
