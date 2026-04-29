# ECE 507 Project: Basic SIMD Vector Co-Processor for PicoRV32

## Abstract

For our ECE 507 project, we are designing a basic SIMD vector co-processor for the PicoRV32 RISC-V core. The goal is to add a small custom hardware module that can improve simple data-parallel operations. Our current design uses the Pico Co-Processor Interface (PCPI), which allows an external co-processor to receive operands from the PicoRV32 core and return results back to the register file.

The first version of the module uses a 32-bit data path divided into four 8-bit lanes. It supports four basic operations: VADD8, VSUB8, VAND, and VOR. VADD8 and VSUB8 perform four parallel 8-bit additions or subtractions, while VAND and VOR perform 32-bit bitwise logic operations. So far, we have completed the standalone Verilog module and a testbench to verify the basic function of the vector unit. The current simulation passes all five tests, including vector addition, vector subtraction, bitwise AND, bitwise OR, and invalid instruction handling.

The next step is to integrate this PCPI vector module with the PicoRV32 core and later use SiliconCompiler / SkyWater 130nm flow for synthesis, layout, and area/timing analysis.

## Current Project Status

Completed so far:

- Created the standalone PCPI SIMD vector module
- Created a Verilog testbench
- Ran simulation using Icarus Verilog
- Generated a VCD waveform file
- Verified that all current tests passed

Current files:

```text
507_project
├── picorv32_pcpi_vec.v
├── tb_pcpi_vec.v
├── tb_pcpi_vec
└── tb_pcpi_vec.vcd