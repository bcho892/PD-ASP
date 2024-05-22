puts {
    biglari noc unit test
}
set top_level              test_library.testbench_noc_output_stage
set wave_patterns {
            t_clock
            t_counter_value
            t_enable
            t_max_value
            t_min_value
            t_message_out
            t_message_select
            t_reset
}

set wave_radices {
  hexadecimal {
            t_counter_value
            t_max_value
            t_min_value
            t_message_out
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
run 100ns

# if waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  CLLOWNDS SMALLARI
  *************************
}