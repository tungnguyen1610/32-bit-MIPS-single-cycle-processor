module top(
    input wire clk, reset,
    output [31:0] writedata, dataadr,
    output memwrite,
    output [31:0] instr,
    output [31:0] pc  // ⬅️ Add these outputs
);

wire [31:0] readdata;

// instantiate processor and memories
mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);
imem imem (pc[7:2], instr);
dmem dmem (clk, memwrite, dataadr, writedata, readdata);

endmodule
