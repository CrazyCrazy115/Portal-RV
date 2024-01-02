import circt.stage._
import chisel3._
import chisel3.util.BitPat
import chisel3.util.experimental.decode.{TruthTable, decoder}
import core._
import utils.BarrelShift


object Elaborate extends App {
  def top = new GCD()
  val generator = Seq(
    chisel3.stage.ChiselGeneratorAnnotation(() => new idu()),
  )
  (new ChiselStage).execute(args, generator :+ CIRCTTargetAnnotation(CIRCTTarget.Verilog))
}