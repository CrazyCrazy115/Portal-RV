`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/25 15:55:41
// Design Name:
// Module Name: idu
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


module IDU(	// <stdin>:60:3
  input         clock,	// <stdin>:61:11
  input         reset,	// <stdin>:62:11
  input  [31:0] io_inst,	// playground/src/core/idu.scala:72:14
  output [31:0] io_imm,	// playground/src/core/idu.scala:72:14
  output [1:0]  io_aluSrc1,	// playground/src/core/idu.scala:72:14
  output        io_aluSrc2,	// playground/src/core/idu.scala:72:14
  output [4:0]  io_aluOp,	// playground/src/core/idu.scala:72:14
  output [1:0]  io_nextPCSrc,	// playground/src/core/idu.scala:72:14
  output [1:0]  io_memWrite,	// playground/src/core/idu.scala:72:14
  output [2:0]  io_memRead,	// playground/src/core/idu.scala:72:14
  output        io_regWrite,	// playground/src/core/idu.scala:72:14
  output [2:0]  io_regWriteSrc	// playground/src/core/idu.scala:72:14
);

  wire [25:0] ctrlWord_invInputs = ~(io_inst[25:0]);	// playground/src/core/idu.scala:72:14, src/main/scala/chisel3/util/pla.scala:78:21
  wire [2:0]  _ctrlWord_T_1 = {io_inst[0], ctrlWord_invInputs[4], ctrlWord_invInputs[5]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [1:0]  _ctrlWord_T_3 = {io_inst[2], ctrlWord_invInputs[4]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [1:0]  _ctrlWord_T_5 = {io_inst[2], ctrlWord_invInputs[5]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [2:0]  _ctrlWord_T_9 = {ctrlWord_invInputs[2], io_inst[4], ctrlWord_invInputs[5]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [2:0]  _ctrlWord_T_11 = {ctrlWord_invInputs[4], io_inst[5], ctrlWord_invInputs[6]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [2:0]  _ctrlWord_T_13 = {io_inst[2], io_inst[4], io_inst[5]};	// src/main/scala/chisel3/util/pla.scala:90:45, :98:53
  wire [2:0]  _ctrlWord_T_15 =
    {ctrlWord_invInputs[2], io_inst[6], ctrlWord_invInputs[14]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [3:0]  _ctrlWord_T_18 =
    {ctrlWord_invInputs[4], ctrlWord_invInputs[5], io_inst[12], ctrlWord_invInputs[14]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [2:0]  _ctrlWord_T_27 =
    {ctrlWord_invInputs[4], ctrlWord_invInputs[5], io_inst[13]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [3:0]  _ctrlWord_T_31 =
    {ctrlWord_invInputs[2], io_inst[4], io_inst[13], ctrlWord_invInputs[14]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [2:0]  _ctrlWord_T_35 =
    {ctrlWord_invInputs[4], ctrlWord_invInputs[5], io_inst[14]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [2:0]  _ctrlWord_T_43 = {ctrlWord_invInputs[2], io_inst[6], io_inst[14]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  wire [4:0]  _ctrlWord_T_45 =
    {ctrlWord_invInputs[2], io_inst[4], io_inst[12], io_inst[13], io_inst[14]};	// src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:53
  ImmGen immExt (	// playground/src/core/idu.scala:110:22
    .io_inst     (io_inst),
    .io_instType
      ({|{&_ctrlWord_T_5, io_inst[3], &_ctrlWord_T_13},
        |{&_ctrlWord_T_11, &_ctrlWord_T_15, &_ctrlWord_T_43},
        |{&_ctrlWord_T_1,
          &_ctrlWord_T_3,
          &_ctrlWord_T_9,
          &_ctrlWord_T_15,
          &_ctrlWord_T_43}}),	// playground/src/core/idu.scala:89:26, src/main/scala/chisel3/util/pla.scala:90:45, :98:{53,70}, :114:{19,36}
    .io_imm      (io_imm)
  );
  assign io_aluSrc1 = {|{&_ctrlWord_T_5, io_inst[3]}, &_ctrlWord_T_13};	// <stdin>:60:3, playground/src/core/idu.scala:91:25, src/main/scala/chisel3/util/pla.scala:90:45, :98:{53,70}, :114:{19,36}
  assign io_aluSrc2 =
    |{&_ctrlWord_T_3,
      &_ctrlWord_T_5,
      &_ctrlWord_T_9,
      &_ctrlWord_T_11,
      &_ctrlWord_T_13,
      &_ctrlWord_T_18,
      &_ctrlWord_T_27,
      &_ctrlWord_T_35};	// <stdin>:60:3, src/main/scala/chisel3/util/pla.scala:98:{53,70}, :114:{19,36}
  assign io_aluOp =
    {&_ctrlWord_T_15,
     |{&_ctrlWord_T_31,
       &_ctrlWord_T_43,
       &{ctrlWord_invInputs[2], io_inst[4], io_inst[5], io_inst[25]}},
     |{&{ctrlWord_invInputs[2],
         io_inst[4],
         io_inst[12],
         ctrlWord_invInputs[13],
         ctrlWord_invInputs[25]},
       &{ctrlWord_invInputs[2], io_inst[4], ctrlWord_invInputs[12], io_inst[13]},
       &_ctrlWord_T_31,
       &_ctrlWord_T_43},
     |{&{ctrlWord_invInputs[2],
         io_inst[4],
         ctrlWord_invInputs[12],
         io_inst[13],
         ctrlWord_invInputs[14]},
       &{ctrlWord_invInputs[2], io_inst[4], ctrlWord_invInputs[13], io_inst[14]},
       &{ctrlWord_invInputs[2], io_inst[5], ctrlWord_invInputs[13], io_inst[14]},
       &_ctrlWord_T_45},
     |{&{ctrlWord_invInputs[2],
         io_inst[4],
         io_inst[12],
         ctrlWord_invInputs[13],
         ctrlWord_invInputs[14]},
       &{ctrlWord_invInputs[2], io_inst[6], io_inst[12]},
       &_ctrlWord_T_45,
       &{ctrlWord_invInputs[2],
         io_inst[4],
         io_inst[5],
         ctrlWord_invInputs[12],
         io_inst[14],
         io_inst[25]},
       &{ctrlWord_invInputs[2], io_inst[4], io_inst[5], io_inst[30]},
       &{ctrlWord_invInputs[2],
         io_inst[4],
         io_inst[12],
         ctrlWord_invInputs[13],
         io_inst[30]}}};	// <stdin>:60:3, playground/src/core/idu.scala:95:23, src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:{53,70}, :114:{19,36}
  assign io_nextPCSrc = {&_ctrlWord_T_3, |{&_ctrlWord_T_15, &_ctrlWord_T_43}};	// <stdin>:60:3, playground/src/core/idu.scala:97:27, src/main/scala/chisel3/util/pla.scala:98:{53,70}, :114:{19,36}
  assign io_memWrite =
    {|{ctrlWord_invInputs[0],
       &_ctrlWord_T_1,
       &_ctrlWord_T_3,
       io_inst[4],
       &_ctrlWord_T_15,
       io_inst[13],
       &_ctrlWord_T_43},
     |{ctrlWord_invInputs[0],
       &_ctrlWord_T_1,
       &_ctrlWord_T_3,
       io_inst[4],
       &_ctrlWord_T_15,
       io_inst[12],
       &_ctrlWord_T_43}};	// <stdin>:60:3, playground/src/core/idu.scala:99:26, src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:{53,70}, :114:{19,36}
  assign io_memRead =
    {|{ctrlWord_invInputs[0],
       &_ctrlWord_T_3,
       io_inst[4],
       &_ctrlWord_T_11,
       &_ctrlWord_T_15,
       &{ctrlWord_invInputs[12], io_inst[14]},
       &_ctrlWord_T_43},
     |{&_ctrlWord_T_18, &_ctrlWord_T_27},
     |{&_ctrlWord_T_27, &_ctrlWord_T_35}};	// <stdin>:60:3, playground/src/core/idu.scala:101:25, src/main/scala/chisel3/util/pla.scala:78:21, :90:45, :91:29, :98:{53,70}, :114:{19,36}
  assign io_regWrite = |{&_ctrlWord_T_1, &_ctrlWord_T_3, io_inst[4]};	// <stdin>:60:3, src/main/scala/chisel3/util/pla.scala:90:45, :98:{53,70}, :114:{19,36}
  assign io_regWriteSrc =
    {|{ctrlWord_invInputs[0], &_ctrlWord_T_11, &_ctrlWord_T_15, &_ctrlWord_T_43},
     |{&_ctrlWord_T_1, &_ctrlWord_T_3},
     &_ctrlWord_T_1};	// <stdin>:60:3, playground/src/core/idu.scala:105:29, src/main/scala/chisel3/util/pla.scala:78:21, :91:29, :98:{53,70}, :114:{19,36}

endmodule

