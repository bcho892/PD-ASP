puts {
  *****************************
  BIGLARI-COMPILER FOR MODELSIM
  *****************************
}

set library_file_list {
                           design_library {
                                           ../vhdl/utils/biglari_types.vhd
                                           ../vhdl/utils/zoran_types.vhd
                                           ../vhdl/utils/mux_constants.vhd
                                           ../vhdl/utils/noc_constants.vhd
                                           ../vhdl/data/register_buffer.vhd
                                           ../vhdl/logic/comparator.vhd
                                           ../vhdl/data/max_value_storage.vhd
                                           ../vhdl/data/min_value_storage.vhd
                                           ../vhdl/logic/bit_truncation.vhd
                                           ../vhdl/control/packet_decode.vhd
                                           ../vhdl/data/config_registers.vhd
                                           ../vhdl/logic/counter.vhd
                                           ../vhdl/control/control_unit.vhd
                                           ../vhdl/data/noc_output_stage.vhd
                                           ../vhdl/logic/peak_detection.vhd
                                           ../vhdl/top_level_pd_asp.vhd
                           }
                           test_library   {
                                           ../test/testbench_control_unit.vhd
                                           ../test/testbench_noc_output_stage.vhd
                                           ../test/testbench_peak_detection.vhd
                                           ../test/testbench_counter.vhd
                                           ../test/testbench_top_level_pd_asp.vhd
                           }
}

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

catch {
  vlib work
}

foreach {library file_list} $library_file_list {
  vlib $library
  vmap $library work
  foreach file $file_list {
    if [regexp {.vhdl?$} $file] {
    vcom -93 $file
    } else {
    vlog $file
    }
  }
}

puts {
  *************************************************************************************************
  All files successfully compiled. You may now run the .do scripts that are prefixed with 'run_test' 
  *************************************************************************************************

  Q: wHaT iS rEc0P?????
  A: You asking questions that make NO SENSE

}

  