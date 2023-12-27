# Portal-RV

## 控制信号Control Signal

- 控制信号

```scala
object ControlSignals {
  def Y = BitPat("b1")
  def N = BitPat("b0")
  def X = BitPat("b?")

  // instruction type
  object InstType{
    def R = BitPat("b000") // R-Type
    def I = BitPat("b001") // I-Type
    def S = BitPat("b010") // S-Type
    def B = BitPat("b011") // B-Type
    def U = BitPat("b100") // U-Type
    def J = BitPat("b101") // J-Type
    def X = BitPat("b???")
    def WIDTH = X.getWidth
  }

  // the source of alu operator 1
  object ALUSrc1{
    // register rs1
    def RS1 = BitPat("b00")
    // zero
    def ZERO = BitPat("b01")
    // program counter(pc)
    def PC   = BitPat("b10")
    def X    = BitPat("b??")
    def WIDTH = X.getWidth
  }

  // the source of alu operator 2
  object ALUSrc2{
    // register rs2
    def RS2 = BitPat("b0")
    // immediate number
    def IMM = BitPat("b1")
    def X = BitPat("b?")
    def WIDTH = X.getWidth
  }
  object ALUOp{
    def ADD = BitPat("b00000")
    def SUB = BitPat("b00001")
    def XOR = BitPat("b00010")
    def AND = BitPat("b00011")
    def OR  = BitPat("b00100")
    // shift left logical
    def SLL = BitPat("b00101")
    // shift right logical
    def SRL = BitPat("b00110")
    // shift right arithmetic
    def SRA = BitPat("b00111")
    // multiply(sign)
    // low 32 bits
    def MULL = BitPat("b01000")
    // high 32 bits
    def MULH = BitPat("b01001")
    // divide
    // unsigned
    def DIVU = BitPat("b01010")
    // sign
    def DIVS = BitPat("b01011")
    // less than unsign
    def LTU = BitPat("b01100")
    // greater equal unsign
    def GEU = BitPat("b01101")
    // lest than sign
    def LTS = BitPat("b01110")
    // greater equal sign
    def GES = BitPat("b01111")
    // equal
    def EQ  = BitPat("b10000")
    // not equal
    def NEQ = BitPat("b10001")
    def X = BitPat("b?????")
    def WIDTH = X.getWidth
  }

  object MemWrite{
    // Write 1 Byte
    def B = BitPat("b00")
    // Write 2 Byte (half word)
    def H = BitPat("b01")
    // Write 4 Byte (word)
    def W = BitPat("b10")
    def N = BitPat("b11")
    def X = BitPat("b??")
    def WIDTH = X.getWidth
  }

  object MemRead{
    // Read 1 Byte
    def B = BitPat("b000")
    // Read 2 Byte (half word)
    // unsigned
    def HU = BitPat("b001")
    // sign
    def HS = BitPat("b010")
    // Read 4 Byte (word)
    def W = BitPat("b011")
    def N = BitPat("b100")
    def X = BitPat("b???")
    def WIDTH = X.getWidth
  }

  // the source of next pc
  object NextPCSrc{
    // PC + 4
    def PC4      = BitPat("b00")
    // branch
    def Branch   = BitPat("b01")
    // jump target
    def Jump     = BitPat("b10")
    def X        = BitPat("b??")
    def WIDTH    = X.getWidth
  }

  object RegWrite{
    def Y = BitPat("b1")
    def N = BitPat("b0")
    def X = BitPat("b?")
    def WIDTH = X.getWidth
  }

  // register write source
  object RegWriteSrc{
    // the result of alu
    def ALURes = BitPat("b000")
    // immediate number
    def IMM    = BitPat("b001")
    // PC + 4
    def PC4    = BitPat("b010")
    // from memory read
    def MEM    = BitPat("b011")
    def N      = BitPat("b100")
    def X      = BitPat("b???")
    def WIDTH  = X.getWidth
  }

  object MemToReg{
    def Y = BitPat("b1")
    def N = BitPat("b0")
    def X = BitPat("b?")
    def WIDTH = X.getWidth
  }
}

```

- 真值表

```scala
object ControlLogic{
  val default: Seq[BitPat] = Seq(InstType.X, ALUSrc1.X, ALUSrc2.X, ALUOp.X, NextPCSrc.X, MemWrite.X, MemRead.X, RegWrite.X, RegWriteSrc.X, MemToReg.X)
  val table = TruthTable(Map(
    LUI   -> Seq(InstType.U, ALUSrc1.ZERO, ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.IMM   , MemToReg.N),
    AUIPC -> Seq(InstType.U, ALUSrc1.PC  , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    JAL   -> Seq(InstType.J, ALUSrc1.PC  , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.Jump  , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.PC4   , MemToReg.N),
    JALR  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.Jump  , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.PC4   , MemToReg.N),
    BEQ   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.EQ  , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    BNE   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.NEQ , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    BLT   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTS , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    BGE   -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.GES , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    BLTU  -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTU , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    BGEU  -> Seq(InstType.B, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.GEU , NextPCSrc.Branch, MemWrite.N, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    LH    -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.HU, RegWrite.Y, RegWriteSrc.MEM   , MemToReg.Y),
    LW    -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.W , RegWrite.Y, RegWriteSrc.MEM   , MemToReg.Y),
    LBU   -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.B , RegWrite.Y, RegWriteSrc.MEM   , MemToReg.Y),
    LHU   -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.HS, RegWrite.Y, RegWriteSrc.MEM   , MemToReg.Y),
    SB    -> Seq(InstType.S, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.B, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    SH    -> Seq(InstType.S, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.H, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    SW    -> Seq(InstType.S, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.W, MemRead.N , RegWrite.N, RegWriteSrc.N     , MemToReg.N),
    ADDI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SLTI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.LTS , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SLTIU -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.LTU , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    XORI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.XOR , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    ANDI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.AND , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SLLI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.SLL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SRLI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.SRL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SRAI  -> Seq(InstType.I, ALUSrc1.RS1 , ALUSrc2.IMM, ALUOp.SRA , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    ADD   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.ADD , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SUB   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SUB , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SLL   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SLL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SLT   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTS , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SLTU  -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.LTU , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    XOR   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.XOR , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SRL   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SRL , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    SRA   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.SRA , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    OR    -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.OR  , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    AND   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.AND , NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    MUL   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.MULL, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    MULH  -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.MULH, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    DIV   -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.DIVS, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N),
    DIVU  -> Seq(InstType.R, ALUSrc1.RS1 , ALUSrc2.RS2, ALUOp.DIVU, NextPCSrc.PC4   , MemWrite.N, MemRead.N , RegWrite.Y, RegWriteSrc.ALURes, MemToReg.N)
  ).map({case(k, v) => k -> v.reduce(_##_)}), default.reduce(_##_))
}

```
