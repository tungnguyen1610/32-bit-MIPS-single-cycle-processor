# Makefile for MIPS Processor Design

# Compiler and flags
IVERILOG = iverilog
VVP = vvp
FLAGS = -Wall -Wimplicit

# Output binary name
OUT = top_mips.vvp

# Source files
SRCS = testbench.v \
       alu.v adder.v aludec.v controller.v datapath.v dmem.v \
       flopr.v imem.v maindec.v mux.v regfile.v shift.v signext.v \
       mips.v top_module.v

# Default target
all: compile run

# Compile target
compile:
	$(IVERILOG) -o $(OUT) $(SRCS) $(FLAGS)

# Run simulation
run:
	$(VVP) $(OUT)

# Clean build files
clean:
	rm -f $(OUT)

# Phony targets
.PHONY: all compile run clean