`timescale 1ps / 1ps
module testbench();
    reg clk_testbench;
    reg reset;
    wire [31:0] writedata, dataadr, pc, instr;
    wire memwrite;

    // Instantiate DUT with named connections
    top dut (
        .clk(clk_testbench),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite),
        .pc(pc),
        .instr(instr)
    );

    // Clock generation
    initial begin
        clk_testbench = 0;
        forever #10 clk_testbench = ~clk_testbench;
    end

    // Reset sequence
    initial begin
        reset = 1;
        #15 reset = 0;
    end

    // Debug printing only for first 10 time units
    always @(negedge clk_testbench) begin
        if ($time <= 500) begin
            $display("Time: %0t | PC: %08h | Instr: %08h | MemWrite: %b | Addr: %08h | WriteData: %08h",
                     $time, pc, instr, memwrite, dataadr, writedata);
        end
    end

    // Optional: still check for success/failure after that
    always @(negedge clk_testbench) begin
        if (memwrite) begin
            if (dataadr === 84 && writedata === 7) begin
                $display("✅ Simulation succeeded");
                $stop;
            end else if (dataadr !== 80) begin
                $display("❌ Simulation failed: Addr = %0d, WriteData = %0d", dataadr, writedata);
                $stop;
            end
        end
    end
endmodule
