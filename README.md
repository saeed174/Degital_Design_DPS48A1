# DSP Verilog Project

## Overview

This project implements and verifies a Digital Signal Processing (DSP) block using Verilog HDL. The DSP module performs arithmetic and logical operations on configurable inputs based on a specified `OPMODE`. It includes support for pipeline control, carry propagation, and output chaining for complex DSP applications.

A comprehensive testbench (`DSP_tb`) validates the functional behavior of the DSP unit under various control and data configurations.

---

## Features

- Parameterized input sizes:
  - A, B, D: 18-bit
  - C, PCIN, PCOUT: 48-bit
  - BCIN, BCOUT: 18-bit
- Output:
  - M: 36-bit
  - P: 48-bit
- Control:
  - OPMODE (8-bit): Determines the operation performed
  - Full pipelining control: CEA, CEB, CEC, etc.
  - Asynchronous resets and synchronous enables
  - Carry input/output propagation

---

## File Structure

```bash
.
├── DSP.v          # DSP module (core logic)
├── DSP_tb.v       # Testbench for simulation
├── Pipeline_Mux.v # Helper module for pipelining
├── Buffer.v       # Helper module for conditional tri-state output
├── README.md      # Project documentation
└── waveform/      # (Optional) Simulation results and waveform captures
```

---

## Helper Modules

This project uses the following additional modules:

- **Pipeline_Mux**: A parameterized register pipeline module with configurable reset behavior and optional enable signal.
- **Buffer**: A module that enables or disables its output based on a control signal, using tri-state logic.

These modules are used internally to improve modularity, flexibility, and configurability of the DSP design.

---

## Simulation & Testing

The project includes a detailed testbench (`DSP_tb.v`) that:

- Initializes and resets the DSP module
- Applies various input combinations
- Randomizes control signals
- Compares actual outputs against expected values
- Displays error messages and stops simulation on mismatches

### Running the Testbench

You can simulate the design using any Verilog simulator such as:

- **ModelSim/QuestaSim**
- **Icarus Verilog**
- **Vivado Simulator**

#### Example (with Icarus Verilog):

```bash
iverilog -o dsp_test DSP.v DSP_tb.v Pipeline_Mux.v Buffer.v
vvp dsp_test
```

---

## Customization

- To extend the test cases, add more `OPMODE` configurations in `DSP_tb.v`.
- You can optionally log outputs to a file or view them in waveform viewers (e.g., GTKWave).

---

## Requirements

- Verilog-2001 compatible simulator
- Optional: GTKWave for waveform viewing

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## Author

**saeed174**

---

## Acknowledgements

- Inspired by Xilinx DSP48E1 architecture
- Built for educational and prototyping purposes
