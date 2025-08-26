class processor_transaction extends uvm_sequence_item;

  rand bit [31:0] instr;   // ✅ must be `rand` if you want constrained-random
  `uvm_object_utils(processor_transaction)

  // -------------------------
  // Observed fields (filled by monitor)
  // -------------------------
       bit [31:0] aluout;    // ALU output from DUT
       bit [4:0]  rd;        // destination register index
       bit [31:0] rd_value;  // value written to that register
  
  // ✅ constraint syntax must use braces
    constraint rtype_c {
    instr[31:26] == 6'b000000; // opcode = R-type
    instr[5:0] inside {6'b100000, // ADD
                       6'b100010, // SUB
                       6'b100100, // AND
                       6'b100101, // OR
                       6'b101010  // SLT
                      };
  } 
  // -> forces R-type instructions

  function new (string name = "processor_transaction");
      super.new(name);
  endfunction

  // Utility method to pretty-print
  function string convert2string();
    return $sformatf(
      "instr=0x%08h opcode=%0b rs=%0d rt=%0d rd=%0d funct=%0b aluout=0x%08h reg_index=%d rd_val=0x%08h",
       instr,
       instr[31:26],  // opcode
       instr[25:21],  // rs
       instr[20:16],  // rt
       instr[15:11],  // rd
       instr[5:0],    // funct
       aluout,
       instr[15:11], 
       rd_value
    );
  endfunction

endclass : processor_transaction

class processor_seq extends uvm_sequence #(processor_transaction);

  `uvm_object_utils(processor_seq)

  function new (string name = "processor_seq");
    super.new(name);
  endfunction

  task body();
    processor_transaction tr;
    repeat (30) begin
      tr = processor_transaction::type_id::create("tr");
      assert(tr.randomize());
      start_item(tr);
      finish_item(tr);
    end
  endtask

endclass : processor_seq