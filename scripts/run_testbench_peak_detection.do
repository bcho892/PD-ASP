puts {
    biglari peak detector unit test
}
set top_level              test_library.testbench_peak_detection
set wave_patterns {
            /testbench_peak_detection/t_enable
            /testbench_peak_detection/t_clock
            /testbench_peak_detection/t_correlation_data
            /testbench_peak_detection/t_enable
            /testbench_peak_detection/t_peak_detected
            /testbench_peak_detection/t_reset
            /testbench_peak_detection/peak_detection_inst/comparator_inst/a
            /testbench_peak_detection/peak_detection_inst/comparator_inst/b
}

set wave_radices {
  hexadecimal {
            t_correlation_data
            a
            b
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