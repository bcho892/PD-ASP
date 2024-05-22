puts {
    biglari counter unit test
}
set top_level              test_library.testbench_counter
set wave_patterns {
      /testbench_counter/t_clock
      /testbench_counter/t_data_out
      /testbench_counter/t_enable
      /testbench_counter/t_reset
}

set wave_radices {
  decimal {
    t_data_out
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
run 650ns

# if waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  CLLOWNDS SMALLARI
  *************************
}