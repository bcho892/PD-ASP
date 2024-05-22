puts {
    biglari control unit test
}
set top_level              test_library.testbench_control_unit
set wave_patterns {
        DUT/current_state
        DUT/c_message_select
        DUT/d_packet_type
        DUT/c_wipe_data_registers
        DUT/c_write_config_registers
        DUT/c_write_correlation_registers
        DUT/c_write_data_buffers
        DUT/c_write_min_max_registers
        DUT/c_write_send_register
        DUT/clock
        DUT/d_reset
        DUT/d_peak_detected
        t_d_enable
}

set wave_radices {
}

# load the simulation
eval vsim $top_level

# if waves are required
set a [if [llength $wave_patterns] {
  noview wave
  foreach pattern $wave_patterns {
    add wave $pattern
  }
  configure wave -signalnamewidth 1
  foreach {radix signals} $wave_radices {
    foreach signal $signals {
      catch {property wave -radix $radix $signal}
    }
  }
}]; list

# run the simulation
run 400ns

# if waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  CLLOWNDS SMALLARI
  *************************
}