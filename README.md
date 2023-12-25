# Portal-RV

## 控制信号Control Signal

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
