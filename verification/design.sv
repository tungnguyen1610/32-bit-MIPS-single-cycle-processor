interface processor_interface(input logic clk, input logic reset);

  // PC and instruction
  logic [31:0] pc;
  logic [31:0] instr;
         
  // data memory
  logic [31:0] aluout;
  logic [31:0] readdata;
  logic [31:0] writedata;          
  logic        memwrite;
  
  // Driver clocking blockpro (for TB)
  clocking driver_cb @(posedge clk);
    output  instr; 
    input  pc;
  endclocking: driver_cb;
    
  // Monitor clocking block (for TB)
  clocking monitor_cb @(negedge clk);
    input pc;
    input instr;
    input aluout;
    input readdata;
    input writedata;
    input memwrite;
  endclocking: monitor_cb;
  
  // -----------------
  // Modports
  // -----------------
  modport driver_if (clocking driver_cb);
  modport monitor_if (clocking monitor_cb);

  // DUT sees *raw signals*, not clocking blocks
  modport dut_if (
    input  clk, reset,
    output pc,
    input instr, 
    output memwrite,
    output aluout,
    output writedata,
    input readdata
  );

endinterface


module top(processor_interface.dut_if intf);
  mips u_mips (
    .clk      (intf.clk),
    .reset    (intf.reset),
    .pc       (intf.pc),
    .instr    (intf.instr),
    .memwrite (intf.memwrite),
    .aluout   (intf.aluout),   // assuming aluout = data write to data memory
    .writedata(intf.writedata),
    .readdata (intf.readdata)
  );
endmodule