# Portal-RV

本项目为合肥工业大学系统硬件综合设计成果, 项目使用verilog代码实现主体部分, 其中的译码部分使用chisel硬件描述语言生成, 实现了一个基于RISC-V 32I的五级流水线处理器, 能够通过前推和流水线停顿处理数据与控制冒险问题.

整体架构设计参考<计算机组成与设计: 软件硬件接口>中的处理器章节.

最后可综合、可上板, 可正确运行本项目中的测试案例

>  注意事项:
>
> 对于数据存储器和指令存储器的实现均分别有两个, 原instruction_memory与data_memory模块是为了实现更多形式的读写存储器 (如 `lb`, `lbu`, `lh`, `lhu`指令), 但由于实现不符合vivado综合ram的规范, 无法成功将其综合为片上的BRAM资源, 因此对其进行简化, 获得了最后的rom和ram模块, 其中的数据单元为32bit, 因此只能实现 `lw/sw`, 但对于测试用例来说已足够使用.
>
> 总结, 想要更多读写存储器的形式, 需要使用data_memory模块作为数据存储器, 但无法实现综合和上板; 想要综合并上板, 则需要使用简化后的ram作为数据存储器.
>
> 本项目**仅供参考**

## 项目结构

```
./Portal-RV
├── Portal-RV.cache
├── Portal-RV.hw
├── Portal-RV.ip_user_files
├── Portal-RV.runs
├── Portal-RV.sim
├── Portal-RV.srcs
│   ├── constrs_1-------------------------------约束文件
│   │   └── new
│   │       └── top.xdc
│   ├── sim_1-----------------------------------仿真测试
│   │   └── new
│   │       ├── ImmGen_tb.v---------------------立即数生成测试
│   │       ├── PC_tb.v-------------------------PC模块测试
│   │       ├── ROM_tb.v------------------------ROM的读写测试
│   │       ├── idu_testbench.v-----------------译码模块测试
│   │       └── top_tb.v------------------------顶层测试
│   └── sources_1-------------------------------Portal-RV verilog部分实现
│       └── new
│           ├── ALU_Branch.v--------------------用于判断分支条件的简化ALU
│           ├── BHazardDetectionUnit.v----------控制冒险的冒险检测单元
│           ├── EXE_MEM.v-----------------------流水线寄存器EX/MEM
│           ├── ForwardBUnit.v------------------控制冒险的前推单元
│           ├── ForwardUnit.v-------------------数据冒险的前推单元
│           ├── HazardDetectionUnit.v-----------数据冒险的冒险检测单元
│           ├── ID_EXE.v------------------------流水线寄存器ID/EX
│           ├── IF_ID.v-------------------------流水线寄存器IF/ID
│           ├── ImmGen.v------------------------立即数生成模块
│           ├── MEM_WB.v------------------------流水线寄存器MEM/WB
│           ├── PC.v----------------------------PC模块
│           ├── RegFiles.v----------------------寄存器堆
│           ├── adder.v-------------------------加法器
│           ├── alu.v---------------------------ALU
│           ├── cpu.v---------------------------Portal-RV实现的主体
│           ├── data_memory.v-------------------数据存储器（旧）
│           ├── definitions.vh------------------头文件，定义信号
│           ├── idu.v---------------------------译码器，使用Chisel生成
│           ├── instruction_memory.v------------指令存储器（旧）
│           ├── ram.v---------------------------RAM，用作数据存储器（新）
│           ├── rom.v---------------------------ROM，用作指令存储器（新）
│           └── top.v---------------------------顶层文件，soc
├── Portal-RV.tcl
├── Portal-RV.xpr
├── README.md
├── chisel-src----------------------------------Chisel部分源代码
│   ├── Elaborate.scala-------------------------生成verilog代码部分实现
│   ├── core
│   │   └── idu.scala---------------------------译码器实现
│   └── utils
│       ├── ControlSignals.scala----------------控制信号定义
│       └── Instructions.scala------------------指令定义
├── sim_config
│   └── top_tb_behav.wcfg-----------------------仿真配置文件
└── sim_data
    ├── data_memory-----------------------------数据存储器初始化数据
    ├── instructions----------------------------指令存储器初始化数据
    └── reg-init.txt----------------------------寄存器初始化数
```

## 相关环境

- windows 11:
  - vivado 2019.2
- ubuntu 22.04(wsl):
  - chisel 3.6.0
  - mill 0.10.7-1-982551
  - java 17.0.8.1
  - chisel项目框架: [OpenXiangShan/chisel-playground (github.com)](https://github.com/OpenXiangShan/chisel-playground) commit **9dc4d45**
- FPGA开发板: EGO1

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
    def ALUSrc1 = BitPat("b11")
    def X    = BitPat("b??")
    def WIDTH = X.getWidth
  }

  // the source of alu operator 2
  object ALUSrc2{
    // register rs2
    def RS2 = BitPat("b00")
    // immediate number
    def IMM = BitPat("b01")
    def ALUSrc2_N = BitPat("b10")
    def X = BitPat("b??")
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
    def BS = BitPat("b000")
    def BU = BitPat("b101")
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
    def JumpR    = BitPat("b11")
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
```
