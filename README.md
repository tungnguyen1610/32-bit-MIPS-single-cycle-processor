# 32-bit MIPS Single-Cycle Processor Design and Verification  

## Table of Contents
- [Overview](#overview)  
- [Getting Started](#getting-started)  
  - [Prerequisites](#prerequisites)  
  - [IDE](#ide)  
- [Design Specification](#design-specification)  
- [Instruction Sets](#instruction-sets)  
- [Inputs and Outputs](#inputs-and-outputs)  
- [Verification Functionality and Test Cases](#verification-functionality-and-test-cases)  
- [Coverage Bins](#coverage-bins)  
- [Layered Testbench](#layered-testbench)  
- [Conclusion](#conclusion)  
- [References](#references)  

---

## Overview  
The **32-bit MIPS single-cycle processor** integrates core components such as the ALU, register file, instruction memory, data memory, and control units into a cohesive architecture.  

Verification of the design follows **UVM methodology**, utilizing advanced techniques like **Constrained Random Verification (CRV)** to assess instruction functionality.  

---

## Getting Started  

### Prerequisites  
- SystemVerilog  
- UVM Framework  

### IDE  
- [EDA Playground](https://www.edaplayground.com/) (or any preferred simulator)  

---

## Design Specification  
The processor under test is a **32-bit, single-cycle MIPS processor**, supporting:  
- **R-type instructions**  
- **I-type instructions**  
- **J-type instructions**  

**Design flow chart**: 
https://tungnguyen1610.github.io/Tung_Blog/digital-design/single-cycle-processor.html

### Verification Flow  
1. **Instruction-level Verification:**  
   - Each instruction type is verified using constrained random verification (CRV).  
   - Current implementation includes verification of **R-type** and **I-type** instructions.  

2. **System-level Validation:**  
   - Identify instructions with data dependencies (e.g LOAD,STORE)
   - Hardcoded sequences of instructions are loaded into instruction memory.  
   - The execution validates overall processor functionality.  

---

## Instruction Sets  
1. **R-type**  
2. **I-type**  
3. **J-type**  
https://max.cs.kzoo.edu/cs230/Resources/MIPS/MachineXL/InstructionFormats.html

---

## Inputs and Outputs  

| Name       | Direction | Width | Description                          |  
|------------|-----------|-------|--------------------------------------|  
| Clk         | input    | 32    | Clock signal  
| Reset         | input    | 32    | Reset signal             
| PC         | Output    | 32    | Program Counter            |  
| instr      | In-out    | 32    | Current instruction                  |  
| aluout     | Output    | 32    | ALU result                           |  
| readdata   | Input    | 32    | Data read from memory                |  
| writedata  | output     | 32    | Data to be written to memory         |  
| memwrite   | output     | 1     | Memory write enable                  |  

---

## Verification Functionality and Test Cases  

### Scope  
- Verify individual instructions for correctness.  

### Method  
- **Constrained Random Testing (CRT)**  

### Process  
1. Sequence generates randomized instructions.  
2. Driver processes and sends them to the DUT through the virtual interface.  
3. Monitor observes results and forwards them to scoreboard & subscriber.  
4. Scoreboard checks correctness by comparing DUT output vs. expected results.  

### Considerations  
- Easy to automate and streamline testing.  
- Current approach does not capture data dependency between instructions.  

---

## Coverage Bins 
- **Objective:** Validate complete functional behavior of the processor.
- **Bins:**
  - Assign coverage bins for each instruction type.
  - Bins cover the opcode ranges and specific configurations for different instructions.
  - Track coverage to ensure all aspects of the processor design are thoroughly tested.

| Instruction             | Opcode (6b) | Funct (6b, R-type only) | Signal Coverage Bins                  |
|--------------------------|-------------|-------------------------|----------------------------------------|
| ADD (R-type)             | 000000      | 100000 (0x20)          | [32'h0000_0020 : 32'h0000_0020]        |
| SUB (R-type)             | 000000      | 100010 (0x22)          | [32'h0000_0022 : 32'h0000_0022]        |
| AND (R-type)             | 000000      | 100100 (0x24)          | [32'h0000_0024 : 32'h0000_0024]        |
| OR (R-type)              | 000000      | 100101 (0x25)          | [32'h0000_0025 : 32'h0000_0025]        |
| SLT (R-type)             | 000000      | 101010 (0x2A)          | [32'h0000_002A : 32'h0000_002A]        |
| ADDI (I-type)            | 001000 (0x08)| —                      | [32'h2000_0000 : 32'h2000_FFFF]        |
| LW (I-type)              | 100011 (0x23)| —                      | [32'h8C00_0000 : 32'h8C00_FFFF]        |
| SW (I-type)              | 101011 (0x2B)| —                      | [32'hAC00_0000 : 32'hAC00_FFFF]        |

---

## Layered Testbench  

The verification environment follows **UVM methodology**, ensuring modularity and scalability.  

### Components  

1. **Processor Testbench Package**  
   - Consolidates all testbench modules. 

2. **testbench**
   - Clock, reset initialization
   - Instantiate DUT
   - Set config database to uvm_test_top  

2. **Processor Test**  
   - Extends `uvm_test`.  
   - Builds the environment and launches test sequences.
   - Set internal database, virtual interface handle available pass it down to all components below uvm_test_top  

3. **Processor Top**  
   - Instantiates DUT and interface.  
   - Connects all verification components.  

4. **Processor Environment**  
   - Contains agent, monitor, subscriber, and scoreboard.
   - Get interface from the configuration database   

5. **Processor Agent**  
   - Manages driver and sequencer.  

6. **Processor Interface**  
   - Connects DUT and testbench (signals, clock, reset, etc).  

7. **Processor Monitor**  
   - Observes DUT outputs and forwards results through analysis port

8. **Processor Driver**  
   - Drives signals into DUT.  

9. **Processor Scoreboard**  
   - Compares DUT results vs. expected outputs.  

10. **Processor Sequence**  
    - Defines transactions between sequencer, driver, and scoreboard.  

11. **Processor Subscriber**  
    - Tracks line and functional coverage.  
    - Generates reports.  

---

## Conclusion  
This project demonstrates the **design and verification** of a **32-bit single-cycle MIPS processor** using **SystemVerilog and UVM**.  

- Instruction functionality verified via constrained randomization.  
- Environment structured with a modular UVM testbench.  
- Preliminary results show correct R-type instruction execution.  

### Future Work  
- Improve coverage for data dependencies and corner cases.  
- Expand toward **pipelined MIPS architecture** for timing analysis.  

---

## References  
1. Digital Design and Computer Architecture - David Money Harros & Sarah L. Harris 
2. UVM 1.2 User Guide.  
3. EDA Playground Documentation.  
