# ECE 507 Project: Basic SIMD Vector Co-Processor for PicoRV32

## Abstract

For our ECE 507 project, we designed, integrated, and verified a basic SIMD vector co-processor for the PicoRV32 RISC-V core. The goal of this project was to add a small custom hardware module that can accelerate simple data-parallel operations. The custom module uses the Pico Co-Processor Interface (PCPI), which allows PicoRV32 to send custom non-branching instructions and register operands to an external co-processor.

The vector co-processor uses a 32-bit data path divided into four 8-bit lanes. It supports four custom operations: VADD8, VSUB8, VAND, and VOR. VADD8 and VSUB8 perform four parallel 8-bit additions or subtractions, while VAND and VOR perform 32-bit bitwise logic operations.

The design was verified in multiple stages. First, the vector module was tested as a standalone Verilog module using Icarus Verilog. Then, it was connected to PicoRV32 through PCPI using an integration wrapper. Finally, processor-level verification confirmed that PicoRV32 can execute all four custom SIMD instructions through PCPI and produce the expected results.

The custom vector module was also processed using SiliconCompiler with the SkyWater 130nm flow. The flow completed successfully with 19/19 steps finished and 0 reported errors. The generated layout, GDS output, and summary metrics are included as part of the final project results.

---

## Project Status

Complete.

The project includes:

- Custom PCPI SIMD vector co-processor design
- Standalone Verilog verification
- PicoRV32 PCPI integration
- Processor-level verification for VADD8, VSUB8, VAND, and VOR
- SiliconCompiler / SkyWater 130nm layout result
- GDS layout output and summary metrics
- Final report materials

---

## Project Goal

The main goal of this project is to extend the PicoRV32 RISC-V core with a small SIMD-style hardware accelerator. Instead of processing only one small data value at a time, the vector unit divides a 32-bit word into four 8-bit lanes and performs the same operation on all four lanes in parallel.

This type of design is useful for simple data-parallel workloads, such as image processing, signal processing, and embedded acceleration tasks.

---

## Design Overview

The design is based on the PicoRV32 RISC-V CPU core and a custom PCPI-based SIMD vector co-processor.

PicoRV32 provides the main processor datapath, register file, instruction fetch logic, and memory interface. The vector co-processor is connected externally through the Pico Co-Processor Interface. This keeps the base processor mostly unchanged while allowing custom instructions to be handled by a separate hardware module.

The custom vector module receives:

```text
pcpi_valid
pcpi_insn
pcpi_rs1
pcpi_rs2
```

It returns:

```text
pcpi_wr
pcpi_rd
pcpi_wait
pcpi_ready
```

When PicoRV32 encounters a supported custom instruction, the vector module decodes the instruction, performs the selected operation, and returns the result through `pcpi_rd`.

---

## Supported Operations

### VADD8

Performs four parallel 8-bit additions.

```text
rs1 = 32'h01020304
rs2 = 32'h05060708

result = 32'h06080A0C
```

Lane-by-lane result:

```text
04 + 08 = 0C
03 + 07 = 0A
02 + 06 = 08
01 + 05 = 06
```

### VSUB8

Performs four parallel 8-bit subtractions.

```text
rs1 = 32'h05060708
rs2 = 32'h01020304

result = 32'h04040404
```

### VAND

Performs a 32-bit bitwise AND operation.

```text
rs1 = 32'h01020304
rs2 = 32'h05060708

result = 32'h01020300
```

### VOR

Performs a 32-bit bitwise OR operation.

```text
rs1 = 32'h01020304
rs2 = 32'h05060708

result = 32'h0506070C
```

---

## Custom Instruction Encoding

The vector module uses the RISC-V `custom-0` opcode:

```text
opcode = 7'b0001011
```

The operation is selected using the `funct3` field:

```text
funct3 = 000  -> VADD8
funct3 = 001  -> VSUB8
funct3 = 010  -> VAND
funct3 = 011  -> VOR
```

The current design uses:

```text
funct7 = 0000000
```

---

## Folder Structure

Current project structure:

```text
507_project
├── README.md
├── picorv32_pcpi_vec.v
├── tb_pcpi_vec.v
├── tb_pcpi_vec
├── tb_pcpi_vec.vcd
├── screenshots
│   ├── full_custom_instruction_verification_passed.png
│   ├── siliconcompiler_flow_success.png
│   ├── siliconcompiler_summary_metrics.png
│   └── layout_picorv32_pcpi_vec.png
├── siliconcompiler
│   ├── picorv32_pcpi_vec.pkg.json
│   ├── picorv32_pcpi_vec.gds.gz
│   ├── picorv32_pcpi_vec.lyt
│   └── picorv32_pcpi_vec.lyp
└── picorv32
    ├── picorv32.v
    ├── picorv32_pcpi_vec.v
    ├── picorv32_vec_top.v
    ├── tb_picorv32_vec_top.v
    ├── tb_picorv32_vec_top.vcd
    ├── picorv32_vec_program_top.v
    ├── tb_picorv32_vec_program_top.v
    ├── tb_picorv32_vec_program_top.vcd
    ├── picorv32_vec_all_program_top.v
    ├── tb_picorv32_vec_all_program_top.v
    └── tb_picorv32_vec_all_program_top.vcd
```

Note: Files without `.v` or `.vcd`, such as `tb_pcpi_vec`, are simulation executables generated by Icarus Verilog.

---

## File Descriptions

### `picorv32_pcpi_vec.v`

This file contains the custom SIMD vector co-processor module. It uses PCPI-style signals to communicate with PicoRV32. It decodes the custom instruction fields and performs VADD8, VSUB8, VAND, or VOR.

### `tb_pcpi_vec.v`

This file is the standalone testbench for the vector co-processor. It directly drives the PCPI input signals and checks whether the vector unit produces the expected results.

### `picorv32/picorv32.v`

This is the original open-source PicoRV32 RISC-V CPU core.

### `picorv32/picorv32_vec_top.v`

This is the basic integration wrapper. It instantiates both the PicoRV32 CPU core and the custom PCPI vector co-processor.

### `picorv32/tb_picorv32_vec_top.v`

This is the basic integration testbench. It verifies that PicoRV32 and the custom PCPI vector unit can compile and simulate together.

### `picorv32/picorv32_vec_program_top.v`

This is the single-instruction processor-level test wrapper. It gives PicoRV32 a small program that executes one custom VADD8 instruction through PCPI.

### `picorv32/tb_picorv32_vec_program_top.v`

This is the testbench for the single VADD8 processor-level custom instruction test.

### `picorv32/picorv32_vec_all_program_top.v`

This is the full processor-level verification wrapper. It gives PicoRV32 a small program that executes all four custom SIMD instructions: VADD8, VSUB8, VAND, and VOR.

### `picorv32/tb_picorv32_vec_all_program_top.v`

This is the full processor-level verification testbench. It checks that all four custom instructions execute correctly and produce the expected results.

### `.vcd` files

The `.vcd` files are waveform files generated by the simulations. They can be opened with GTKWave if waveform inspection is needed, but the simulation results can also be verified from the terminal output.

---

## Standalone Simulation

The standalone simulation checks the vector module without the full PicoRV32 core.

To run the standalone simulation from the main project folder:

```bash
iverilog -o tb_pcpi_vec tb_pcpi_vec.v picorv32_pcpi_vec.v
vvp tb_pcpi_vec
```

Expected output:

```text
Test 1 VADD8 passed
Test 2 VSUB8 passed
Test 3 VAND passed
Test 4 VOR passed
Test 5 invalid instruction passed
PCPI vector unit testbench finished
```

This confirms that the vector unit correctly performs the basic operations before full processor integration.

---

## PicoRV32 Integration Simulation

After verifying the standalone vector unit, a basic top-level wrapper named `picorv32_vec_top.v` was created. This wrapper connects the PicoRV32 PCPI interface to the custom SIMD vector module.

To run the integration simulation, go into the `picorv32` folder:

```bash
cd picorv32
```

Then run:

```bash
iverilog -g2012 -o tb_picorv32_vec_top tb_picorv32_vec_top.v picorv32_vec_top.v picorv32.v picorv32_pcpi_vec.v
vvp tb_picorv32_vec_top
```

Expected output:

```text
VCD info: dumpfile tb_picorv32_vec_top.vcd opened for output.
PicoRV32 and PCPI vector unit integration simulation finished.
```

This confirms that the PicoRV32 core and the custom PCPI vector unit can compile and simulate together.

---

## Single Custom Instruction Execution Test

After the basic integration simulation passed, a processor-level custom instruction test was created using:

```text
picorv32_vec_program_top.v
tb_picorv32_vec_program_top.v
```

This test loads two 32-bit values into PicoRV32 registers, executes a custom VADD8 instruction through PCPI, and stores the result to a memory-mapped result register.

Test program behavior:

```text
x1 = 0x01020304
x2 = 0x05060708
VADD8 x3, x1, x2
store x3 to result register
```

Expected result:

```text
0x06080A0C
```

To run the test inside the `picorv32` folder:

```bash
iverilog -g2012 -o tb_picorv32_vec_program_top tb_picorv32_vec_program_top.v picorv32_vec_program_top.v picorv32.v picorv32_pcpi_vec.v
vvp tb_picorv32_vec_program_top
```

Expected output:

```text
Custom instruction execution test passed.
VADD8 result = 06080a0c
```

This confirms that PicoRV32 successfully executed a custom SIMD vector instruction through the PCPI interface.

---

## Full Custom Instruction Verification Test

After the basic VADD8 processor-level test passed, the verification was expanded to test all four custom SIMD instructions:

- VADD8
- VSUB8
- VAND
- VOR

This test is implemented using:

```text
picorv32_vec_all_program_top.v
tb_picorv32_vec_all_program_top.v
```

The PicoRV32 core executes each custom instruction through the PCPI interface and stores the results to memory-mapped result registers.

To run the test inside the `picorv32` folder:

```bash
iverilog -g2012 -o tb_picorv32_vec_all_program_top tb_picorv32_vec_all_program_top.v picorv32_vec_all_program_top.v picorv32.v picorv32_pcpi_vec.v
vvp tb_picorv32_vec_all_program_top
```

Expected output:

```text
VADD8 passed: result = 06080a0c
VSUB8 passed: result = 04040404
VAND passed: result = 01020300
VOR passed: result = 0506070c
All custom instruction execution tests passed.
```

This confirms that all four custom SIMD instructions execute correctly through the PicoRV32 PCPI interface.

---

## SiliconCompiler / SkyWater 130nm Layout Result

The custom PCPI SIMD vector module was processed using SiliconCompiler with the SkyWater 130nm flow. The run completed successfully with all flow steps passing.

Key run result:

```text
Progress: 19/19
Status: SUCCESS
Errors: 0
```

Generated layout/output files include:

```text
picorv32_pcpi_vec.pkg.json
picorv32_pcpi_vec.gds.gz
picorv32_pcpi_vec.lyt
picorv32_pcpi_vec.lyp
```

Important reported metrics:

```text
Cell area: 3364.480
Total area: 8699.290
Number of cells: 1372
Number of nets: 576
Number of pins: 136
Registers: 33
Utilization: 42.656%
Peak power: 0.746
IR drop: 0.081
Errors: 0
DRVs: 0
```

This confirms that the custom vector co-processor can be synthesized and laid out successfully using the SiliconCompiler / SkyWater 130nm flow.

---

## Final Results Summary

Standalone vector unit test:

```text
Passed
```

PicoRV32 integration compile/simulation test:

```text
Passed
```

Single custom instruction execution test:

```text
VADD8 passed
```

Full custom instruction execution test:

```text
VADD8 passed
VSUB8 passed
VAND passed
VOR passed
```

SiliconCompiler layout flow:

```text
19/19 steps completed
0 reported errors
```

Final conclusion:

The custom SIMD vector co-processor works correctly as a standalone module, can be connected to the PicoRV32 core through the PCPI interface, can execute all four custom vector instructions through PicoRV32, and can be synthesized and laid out using SiliconCompiler with the SkyWater 130nm flow.

---

## Project Repository

Team GitHub repository:

```text
https://github.com/Fst0016/507_Project
```

---

## Source Attribution

The baseline PicoRV32 core (`picorv32.v`) is from the open-source YosysHQ PicoRV32 repository. This project extends the baseline core by adding a custom PCPI-based SIMD vector co-processor, integration wrappers, and verification testbenches.

PicoRV32 source:

```text
https://github.com/YosysHQ/picorv32
```

---

## Team Notes

The main project implementation is complete. The standalone vector module, PicoRV32 integration simulation, VADD8 processor-level test, full four-operation processor-level verification, and SiliconCompiler layout flow all pass.

The repository contains the Verilog source files, testbenches, simulation waveform files, SiliconCompiler layout outputs, screenshots, and final report materials.
