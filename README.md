# PD-ASP

This is the repository for _PEAK DETECTION_ Application Specific Processor, designed by BENSON CHO in collaboration with BIGLARI-ABHARI.

## Repository Structure

- `vhdl` Where all the source files used to synthesize the PD-ASP are held. The following subfolders are contained:
  - `control`
  - `data`
  - `logic`
  - `utils`
- `test` Contains all _Modelsim_ testbenches
- `scripts` Stores `*.do` scripts used for automating _Modelsim_ testbenches
- `quartus` Contains the Quartus project which can be used to synthesize the design
- `docs` Information on using the PD-ASP (Configuration etc)

## Running Modelsim Testbenches

> [!WARNING]
> Start a terminal in the folder which _THIS_ `README.md` is located before running any of the following commands

1. Run `py open_modelsim.py` this will automatically compile all the project files and put you in the directory with all the scripts
2. You should then type in the _Modelsim_ terminal `do` followed by a script prefixed with `run_testbench_<name>` (You should also get autocomplete when `do ` is typed into the modelsim terminal). The available ones are:

- `run_testbench_control_unit.do`
- `run_testbench_counter.do`
- `run_testbench_noc_output_stage.do`
- `run_testbench_peak_detection.do`
- `run_testbench_top_level_pd_asp.do`

> [!NOTE]
> The most relevant one will probably be `run_testbench_top_level_pd_asp.do` as that shows the operation of the **PD-ASP** with realistic inputs from the **NOC**

### Troubleshooting

> [!IMPORTANT]
> If for some reason `vsim` or `py` doesn't work on your terminal you must manually follow these steps

1. Open modelsim
2. Change directories to `/scripts`
3. Run `do compile.do` in the _Modelsim_ terminal
4. You may now run the testbenches like shown above

## Synthesising in Quartus

The project has already been set up with the correct files and settings, so you are able to run compilation to check Synthesis results.

To do so:

1. Open `quartus\Teaser_PD_ASP.qpf`
2. Click `Compile Design`
3. Wait for it to finish
