# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "D:/coding/cpu/Portal-RV/Portal-RV.runs/synth_1/.Xil/Vivado-13532-OMEN-7/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7a35tcsg324-1
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    # Skipping read_* RTL commands because this is post-elab optimize flow
    set rt::useElabCache true
    if {$rt::useElabCache == false} {
      rt::read_verilog -include D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new {
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/RegFiles.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/cpu.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/PC.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/IF_ID.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/ImmGen.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/alu.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/adder.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/ID_EXE.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/MEM_WB.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/EXE_MEM.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/data_memory.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/top.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/IDU.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/ForwardUnit.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/ALU_Branch.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/HazardDetectionUnit.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/ForwardBUnit.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/BHazardDetectionUnit.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/instruction_memory.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/ram.v
      D:/coding/cpu/Portal-RV/Portal-RV.srcs/sources_1/new/rom.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification true
    set rt::SDCFileList D:/coding/cpu/Portal-RV/Portal-RV.runs/synth_1/.Xil/Vivado-13532-OMEN-7/realtime/top_synth.xdc
    rt::sdcChecksum
    set rt::top top
    rt::set_parameter enableIncremental true
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
# MODE: 
    rt::set_parameter webTalkPath {D:/coding/cpu/Portal-RV/Portal-RV.cache/wt}
    rt::set_parameter enableSplitFlowPath "D:/coding/cpu/Portal-RV/Portal-RV.runs/synth_1/.Xil/Vivado-13532-OMEN-7/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_synthesis -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    rt::HARTNDb_stopSystemStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
