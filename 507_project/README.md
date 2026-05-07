# ECE 507 Project: Basic SIMD Vector Co-Processor for PicoRV32

## Abstract

For our ECE 507 project, we are designing a basic SIMD vector co-processor for the PicoRV32 RISC-V core. The goal is to add a small custom hardware module that can improve simple data-parallel operations. Our current design uses the Pico Co-Processor Interface (PCPI), which allows an external co-processor to receive operands from the PicoRV32 core and return results back to the register file.

The first version of the module uses a 32-bit data path divided into four 8-bit lanes. It supports four basic operations: VADD8, VSUB8, VAND, and VOR. VADD8 and VSUB8 perform four parallel 8-bit additions or subtractions, while VAND and VOR perform 32-bit bitwise logic operations.

So far, we have completed the standalone Verilog module, a standalone testbench, a basic PicoRV32 integration wrapper, and a processor-level custom instruction execution test. The standalone simulation passes all five tests, including vector addition, vector subtraction, bitwise AND, bitwise OR, and invalid instruction handling. The processor-level test also confirms that PicoRV32 can execute a custom VADD8 instruction through PCPI and produce the correct result.

The next step is to use SiliconCompiler / SkyWater 130nm flow for synthesis, layout, and area/timing analysis.

---

## Project Goal

The main goal of this project is to extend the PicoRV32 RISC-V core with a small SIMD-style hardware accelerator. Instead of processing only one small data value at a time, the vector unit divides a 32-bit word into four 8-bit lanes and performs the same operation on all four lanes in parallel.

This type of design is useful for simple data-parallel workloads, such as image processing, signal processing, and embedded acceleration tasks.

---

## Current Project Status

Completed so far:

- Created the standalone PCPI SIMD vector module
- Created a standalone Verilog testbench
- Ran standalone simulation using Icarus Verilog
- Generated a VCD waveform file
- Verified that all standalone tests passed
- Downloaded the PicoRV32 source code
- Added the custom vector module into the PicoRV32 project folder
- Created a basic PicoRV32 integration wrapper
- Ran a basic PicoRV32 + PCPI vector unit integration simulation
- Created a processor-level custom instruction execution test
- Verified that PicoRV32 can execute a custom VADD8 instruction through PCPI
- Confirmed the expected VADD8 result: `0x06080A0C`

Still needs to be completed:

- Add more comments and clean up the Verilog files
- Add more custom instruction execution tests for VSUB8, VAND, and VOR
- Run synthesis / layout using SiliconCompiler and SkyWater 130nm flow
- Collect area, timing, and performance results
- Write the final report

---

## Folder Structure

Current files:

```text
507_project
├── picorv32_pcpi_vec.v
├── tb_pcpi_vec.v
├── tb_pcpi_vec
├── tb_pcpi_vec.vcd
├── README.md
└── picorv32
    ├── picorv32.v
    ├── picorv32_pcpi_vec.v
    ├── picorv32_vec_top.v
    ├── tb_picorv32_vec_top.v
    ├── tb_picorv32_vec_top.vcd
    ├── picorv32_vec_program_top.v
    ├── tb_picorv32_vec_program_top.v
    └── tb_picorv32_vec_program_top.vcd
