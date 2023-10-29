# 
# Report generation script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {33-285} -limit 100
set_msg_config -id {33-288} -limit 100
set_msg_config -id {HDL-1065} -limit 10000
set_msg_config  -id {Vivado 12-1790}  -string {{Evaluation} {features} {should} {NOT} {be} {used} {in} {production} {systems.}}  -new_severity {WARNING} 
set_msg_config  -id {Place 30-73}  -string {{axi_spi}}  -new_severity {WARNING} 
set_msg_config  -string {{PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY}}  -new_severity {WARNING} 
set_msg_config  -id {BD 41-1343}  -new_severity {WARNING} 
set_msg_config  -id {BD 41-1306}  -new_severity {WARNING} 
set_msg_config  -id {BD 41-1276}  -severity {CRITICAL WARNING}  -new_severity {ERROR} 
set_msg_config  -id {IP_Flow 19-3656}  -new_severity {INFO} 
set_msg_config  -id {IP_Flow 19-4623}  -new_severity {INFO} 
set_msg_config  -id {IP_Flow 19-459}  -new_severity {INFO} 
set_msg_config  -id {Synth 8-3331}  -new_severity {INFO} 
set_msg_config  -id {Designutils 20-3303}  -string {{HDPYFinalizeIO}}  -new_severity {INFO} 

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param messaging.defaultLimit 2000
  set_param chipscope.maxJobs 1
  reset_param project.defaultXPMLibraries 
  open_checkpoint /home/myh/Documents/antsdr/antsdr-fw/hdl/projects/ant/ant.runs/impl_1/system_top.dcp
  set_property webtalk.parent_dir /home/myh/Documents/antsdr/antsdr-fw/hdl/projects/ant/ant.cache/wt [current_project]
  set_property parent.project_path /home/myh/Documents/antsdr/antsdr-fw/hdl/projects/ant/ant.xpr [current_project]
  set_property ip_repo_paths {
  /home/myh/Documents/antsdr/antsdr-fw/hdl/library
  /home/myh/Documents/antsdr/antsdr-fw/ghdl/library
} [current_project]
  update_ip_catalog
  set_property ip_output_repo /home/myh/Documents/antsdr/antsdr-fw/hdl/projects/ant/ant.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force system_top_opt.dcp
  create_report "impl_1_opt_report_drc_0" "report_drc -file system_top_drc_opted.rpt -pb system_top_drc_opted.pb -rpx system_top_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design 
  write_checkpoint -force system_top_placed.dcp
  create_report "impl_1_place_report_io_0" "report_io -file system_top_io_placed.rpt"
  create_report "impl_1_place_report_utilization_0" "report_utilization -file system_top_utilization_placed.rpt -pb system_top_utilization_placed.pb"
  create_report "impl_1_place_report_control_sets_0" "report_control_sets -verbose -file system_top_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force system_top_routed.dcp
  create_report "impl_1_route_report_drc_0" "report_drc -file system_top_drc_routed.rpt -pb system_top_drc_routed.pb -rpx system_top_drc_routed.rpx"
  create_report "impl_1_route_report_methodology_0" "report_methodology -file system_top_methodology_drc_routed.rpt -pb system_top_methodology_drc_routed.pb -rpx system_top_methodology_drc_routed.rpx"
  create_report "impl_1_route_report_power_0" "report_power -file system_top_power_routed.rpt -pb system_top_power_summary_routed.pb -rpx system_top_power_routed.rpx"
  create_report "impl_1_route_report_route_status_0" "report_route_status -file system_top_route_status.rpt -pb system_top_route_status.pb"
  create_report "impl_1_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file system_top_timing_summary_routed.rpt -pb system_top_timing_summary_routed.pb -rpx system_top_timing_summary_routed.rpx -warn_on_violation "
  create_report "impl_1_route_report_incremental_reuse_0" "report_incremental_reuse -file system_top_incremental_reuse_routed.rpt"
  create_report "impl_1_route_report_clock_utilization_0" "report_clock_utilization -file system_top_clock_utilization_routed.rpt"
  create_report "impl_1_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file system_top_bus_skew_routed.rpt -pb system_top_bus_skew_routed.pb -rpx system_top_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force system_top_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
  catch { write_mem_info -force system_top.mmi }
  write_bitstream -force system_top.bit 
  catch { write_sysdef -hwdef system_top.hwdef -bitfile system_top.bit -meminfo system_top.mmi -file system_top.sysdef }
  catch {write_debug_probes -quiet -force system_top}
  catch {file copy -force system_top.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

