[![Choaib ELMADI - RISC-V](https://img.shields.io/badge/Choaib_ELMADI-RISC--V-8800dd)](https://elmadichoaib.vercel.app) ![Status - Building](https://img.shields.io/badge/Status-Building-2bd729) ![Platform - DE2-SoC](https://img.shields.io/badge/Platform-DE--2_SoC-f7d620)

# RISC-V Processor on DE-2 SoC FPGA

Welcome to the `risc-v-on-de2-soc-fpga` repository! This project implements a simplified RISC-V processor architecture using Verilog and is deployed on the DE-2 SoC FPGA development board.

## Repository Structure

The repository is structured as follows:

- **Single Cycle Processor**: Contains the implementation of the single-cycle RISC-V CPU and its modules.

<div align="center">

![Single Cycle Processor](./Images/1-%20single-cycle-processor.png)

</div>

- **Multi Cycle Processor**: Contains the implementation of the multi-cycle RISC-V CPU and its modules.

<div align="center">

![Multi Cycle Processor](./Images/2-%20multi-cycle-processor.png)

</div>

- **Pipelined Processor**: _Coming soon..._

<div align="center">

![Pipelined Processor](./Images/3-%20pipelined-processor.png)

</div>

- **Images**: Visuals, diagrams, and waveform screenshots related to the design and simulation.

- **Resources**:

  - `Digital Design and Computer Architecture RISC-V Edition.pdf`
  - `Getting Started with FPGAs.pdf`
  - `Project Plan.pdf`

![Note](https://img.shields.io/badge/NOTE:-fb151a)

The `cpu.v` module is the top-level design and contains the instantiations of `datapath.v` and `control_unit.v`. These two modules further instantiate all the lower-level building blocks like the ALU, register file, memory, multiplexers, etc., to complete the processor architecture.

## Tools Used

- **Quartus Prime** – For writing, compiling, and deploying Verilog code.
- **ModelSim** – For simulation and debugging.
- **DE-2 SoC FPGA Board** – As the hardware target platform.

## Goal of the Project

The main objective is to understand and implement the internal working of a RISC-V CPU on an FPGA, focusing on datapath design, instruction decoding, and memory access.

## Related Work

If you're new to Verilog or want to brush up on the basics, check out this repo: [Getting Started with Verilog](https://github.com/Choaib-ELMADI/getting-started-with-verilog)

If you're looking for a deeper dive into processor architecture, including detailed experiments and more advanced implementations, check out: [RISC-V Deep Dive on FPGA](https://github.com/Choaib-ELMADI/risc-v-deep-dive-on-fpga)
