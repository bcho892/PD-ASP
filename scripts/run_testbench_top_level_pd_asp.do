puts {
    biglari peak detector TOP LEVEL integration test
}
set top_level              test_library.testbench_top_level_pd_asp
set wave_patterns {
        top_level_inst/control_unit/current_state
        t_clock
        t_data_in
        t_data_out
        t_reset
        top_level_inst/min_value_storage/registered_min_value
        top_level_inst/max_value_storage/registered_max_value
        top_level_inst/packet_decode/packet_type
        top_level_inst/peak_detection/peak_detected
}

set wave_radices {
  hexadecimal {
        t_data_in
        t_data_out
        t_reset
        registered_min_value
        registered_max_value
  }
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
run 1000ns

# if waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  CLLOWNDS SMALLARI
  *************************
}