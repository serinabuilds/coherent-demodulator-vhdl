# Coherent Demodulation in VHDL

A complete RTL implementation of a digital BPSK demodulator featuring carrier recovery using a Costas Loop architecture. This project is being developed in VHDL for FPGA implementation using Xilinx Vivado.

---

## Overview

This repository implements a fully digital BPSK receiver capable of recovering both the carrier phase and transmitted data. The design follows the classical Costas Loop architecture and is intended for FPGA deployment.

The objective is to translate a communication system typically modeled in MATLAB/Simulink into synthesizable VHDL while maintaining modularity and hardware efficiency.

---

## Features

- Digital Costas Loop implementation
- Carrier phase recovery
- BPSK demodulation
- Numerically Controlled Oscillator (NCO)
- CORDIC-based phase generation
- FIR Low-Pass Filters
- Loop Filter (PI Controller)
- Modular RTL architecture
- Vivado compatible

---

## System Parameters

| Parameter | Value |
|-----------|-------|
| Modulation | BPSK |
| Sampling Frequency | 640 kHz |
| Carrier Frequency | 64 kHz |
| Bit Rate | 4 kbps |
| Language | VHDL |
| Target Tool | Xilinx Vivado |

---

## Architecture

```
Received Signal
        │
        ▼
 ┌───────────────┐
 │   Mixer (I)   │◄──────── Cos(NCO)
 └───────────────┘
        │
        ▼
     FIR LPF
        │
        │
        ├─────────────┐
        │             │
        ▼             ▼
                  I × Q
        ▲             │
        │             ▼
     FIR LPF      Loop Filter
        ▲             │
        │             ▼
 ┌───────────────┐   NCO
 │   Mixer (Q)   │────┘
 └───────────────┘
        ▲
        │
     Sin(NCO)
```

---

## Project Structure

```
bpsk-demodulator-vhdl/
│
├── rtl/
│   ├── mixers/
│   ├── fir_filter/
│   ├── nco/
│   ├── cordic/
│   ├── loop_filter/
│   ├── demodulator/
│   └── top/
│
├── sim/
│
├── constraints/
│
├── docs/
│
├── images/
│
└── README.md
```

---

## Tools Used

- VHDL
- Xilinx Vivado
- Vivado DDS Compiler IP
- Vivado CORDIC IP
- MATLAB (for filter coefficient generation)

---

## Current Status

- [x] System architecture finalized
- [x] FIR filter design
- [x] NCO architecture
- [x] DDS integration
- [ ] Loop Filter
- [ ] RTL integration
- [ ] Functional simulation
- [ ] FPGA validation

---

## Future Improvements

- Adaptive loop bandwidth
- Fixed-point optimization
- Support for QPSK
- Timing optimization
- Hardware validation on FPGA

---

## Author

**Serina Sakhare**

B.Tech Electronics and Communication Engineering

Manipal Institute of Technology
