`include "adder.v"
`include "alu.v"
`include "flopr.v"
`include "maindec.v"
`include "mux.v"
`include "regfile.v"
`include "shift.v"
`include "signext.v"
`include "aludec.v"
`include "controller.v"
`include "datapath.v"
`include "imem.v"
`include "dmem.v"
`include "mips.v"

	import uvm_pkg::*;
  `include "uvm_macros.svh"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "subscriber.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

//`include "testbench_pkg.sv"

module testbench;
  import uvm_pkg::*;
    logic clk_testbench;
    logic reset;
	
    // virtual interface
    processor_interface vif(.clk(clk_testbench),
                            .reset(reset));
    top dut (.intf(vif));
 	
  	// set inital value for register
  	initial begin
  	dut.u_mips.dp.rf.init_regfile(); // hierarchical path to regfile inside datapath	
	end
  
    // Clock generation
    initial begin
        clk_testbench = 0;
        forever #10 clk_testbench = ~clk_testbench;
    end

    // Reset sequence
    initial begin
        reset = 1;
      repeat (1) @(posedge clk_testbench);
        reset = 0;
    end

  initial begin
  	 //Pass above physical interface to test top
    //(which will further pass it down to env->agent->drv/sqr/mon
    uvm_config_db #(virtual processor_interface)::set (null,"uvm_test_top","vif",vif); 
 
    run_test("processor_base_test");
  end
  
  /*
    // Debug printing
        // connect DUT
	imem imem (vif.pc[7:2], vif.instr);
	dmem dmem (clk_testbench, vif.memwrite, vif.dataaddr, vif.writedata, vif.readdata);
    always @(negedge clk_testbench) begin
        if ($time <= 500) begin
            $display("Time: %0t | PC: %08h | Instr: %08h | MemWrite: %b | Addr: %08h | WriteData: %08h",
                     $time, vif.pc, vif.instr, vif.memwrite, vif.dataaddr, vif.writedata);
        end
    end

    // Success/failure checker
    always @(negedge clk_testbench) begin
        if (vif.memwrite) begin
            if (vif.dataaddr === 84 && vif.writedata === 7) begin
                $display("✅ Simulation succeeded");
                $stop;
            end else if (vif.dataaddr !== 80) begin
                $display("❌ Simulation failed: Addr = %0d, WriteData = %0d", 
                         vif.dataaddr, vif.writedata);
                $stop;
            end
        end
    end
    */
  
endmodule
