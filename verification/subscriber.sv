class processor_subscriber extends uvm_subscriber#(processor_transaction);

  `uvm_component_utils(processor_subscriber)

  // Extracted instruction fields
  bit [5:0] funct;
  bit [5:0] opcode;
  bit [4:0] rs, rt, rd;

  // Covergroup definition
  covergroup cover_processor;

    // Instruction type (funct for R-type)
    coverpoint funct {
      bins Addition     = {6'b100000}; // ADD
      bins Subtraction  = {6'b100010}; // SUB
      bins AndOp        = {6'b100100}; // AND
      bins OrOp         = {6'b100101}; // OR
      bins SltOp        = {6'b101010}; // SLT
    }

    // Registers used as sources (rs, rt) and destination (rd)
    coverpoint rs {
      bins low_regs  = {[0:7]};
      bins mid_regs  = {[8:23]};
      bins high_regs = {[24:31]};
    }

    coverpoint rt {
      bins low_regs  = {[0:7]};
      bins mid_regs  = {[8:23]};
      bins high_regs = {[24:31]};
    }

    coverpoint rd {
      bins low_regs  = {[0:7]};
      bins mid_regs  = {[8:23]};
      bins high_regs = {[24:31]};
    }

    // Cross coverage
    cross funct, rs, rt;   // Which instructions exercised with which regs
    cross funct, rd;       // Which destination registers got results

  endgroup

  function new (string name, uvm_component parent);
    super.new(name,parent);
    cover_processor = new();
  endfunction

  virtual function void write (processor_transaction t);
    `uvm_info("APB_SUBSCRIBER", $psprintf("Subscriber received transaction %s", t.convert2string()), UVM_NONE);
    opcode = t.instr[31:26];
    rs     = t.instr[25:21];
    rt     = t.instr[20:16];
    rd     = t.instr[15:11];
    funct  = t.instr[5:0];
    cover_processor.sample();
  endfunction

endclass
