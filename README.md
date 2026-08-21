# Logic Design Course Notes / Laboratory

This repository contains Verilog designs and simulation files for the 2026 Fall Logic Design course (`logic2026f`).

The contents are organized by chapter and cover fundamental digital logic topics, including hazards, combinational circuits, arithmetic circuits, sequential logic, registers, and finite-state style logic.

## Contents

### Chapter 3
Folder: `chap3`

Topics and examples include:
- Hazard analysis and hazardous logic behavior
- Hazard-free circuit design
- Simulation testbenches for logic timing and signal transitions

Files include:
- `18a_hazardfree.v`
- `18a_hazardous.v`
- `18a_hazardous.json`
- `18a_sim.v`
- `18c_hazardous.v`
- `18c_sim.v`
- `19.v`
- `19_sim.v`

### Chapter 5
Folder: `chap5`

Topics and examples include:
- Basic combinational logic design
- Adders and arithmetic building blocks
- Carry lookahead and related implementations

Files include:
- `4.v`, `4_sim.v`
- `7.v`, `7_sim.v`
- `9.v`, `9_sim.v`
- `24.v`
- `adder.json`
- `cla.json`
- `cla4.json`
- `cla16.json`

### Chapter 6
Folder: `chap6`

Topics and examples include:
- Latches and flip-flops
- Register file design
- ALU implementation
- Stack memory and related simulation/test files

Files include:
- `dff.v`, `dff.json`
- `rs_latch.v`, `rs_latch_manual.v`, `rs_latch_nand.v`
- `rs_latch.json`, `rs_latch_manual.json`, `rs_latch_nand.json`
- `alu8.v`, `alu8.json`
- `regfile.v`, `regfile.json`
- `stack.v`, `stack2.v`, `stack_test.v`, `stack_test2.v`
- `stack.json`, `stack2.json`

### Chapter 7
Folder: `chap7`

Topics and examples include:
- Flip-flop with reset
- Pulse generation
- Shift register logic
- Serial adder design

Files include:
- `dffr.v`, `dffr.json`
- `pulse_generator.v`, `pulse_generator.json`, `pulse_generator_tb.v`
- `shift.v`, `shift.json`
- `serial_adder.v`, `serial_adder.json`, `serial_adder_tb.v`

## Notes
- The files are written in Verilog and are intended for digital logic design practice and simulation.
- Simulation outputs are stored as `.vcd` files and JSON summaries for debugging and waveform inspection.
- This directory is best used alongside the lecture/lab materials for the corresponding chapter.

## Suggested Workflow
1. Open the relevant chapter folder.
2. Review the `.v` source files.
3. Run the corresponding simulation/testbench(s).
4. Inspect waveform output (`dump.vcd`) and JSON artifacts when available.

## License
This project is intended for academic learning and course use.
