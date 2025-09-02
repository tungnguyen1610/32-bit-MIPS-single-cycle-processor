class processor_transaction extends uvm_sequence_item;

  rand bit [31:0] instr;   // ✅ must be `rand` if you want constrained-random
  `uvm_object_utils(processor_transaction)

  // -------------------------
  // Observed fields (filled by monitor)
  // -------------------------
       bit [31:0] aluout;    // ALU output from DUT
       bit [4:0]  rd;        // destination register index
       bit [31:0] rd_value;  // value written to that register
 	   bit [31:0] memaddr;		 // Data memory address
  	   bit [31:0] memval;          // memory value
  	   bit memwrite;
  	   bit [31:0]readdata;
  // define type of instructions
  typedef enum {R_TYPE, I_TYPE} instr_kind_e ;
  rand instr_kind_e instr_kind ;  
  
  // ✅ constraint syntax must use braces
    constraint rtype_c {
      if (instr_kind == R_TYPE) { 
    instr[31:26] == 6'b000000; // opcode = R-type
    instr[5:0] inside {6'b100000, // ADD
                       6'b100010, // SUB
                       6'b100100, // AND
                       6'b100101, // OR
                       6'b101010  // SLT
                      };
      } 
         else if (instr_kind == I_TYPE) {
      instr[31:26] inside {6'b001000, // ADDI
                           6'b100011, // LW
                           6'b101011  // SW
                          };
           instr[15:0] < 256;  // restrict immediate value used to calculate memory address 
      // fu< nct field unused in I-type → can randomize freely
    }
  }
              
  // -> forces R-type instructions

  function new (string name = "processor_transaction");
      super.new(name);
  endfunction

  // Utility method to pretty-print
  function string convert2string();
    if (instr_kind==R_TYPE)  begin
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
    end
    else begin
        return $sformatf(
      "instr=0x%08h opcode=%0b rs=%0d rt=%0d immediate=0x%04h aluout=0x%08h reg_value=0x%08h memwrite=%d memaddr=0x%08h memvalue=0x%08h readdata=0x%08h",
       instr,
       instr[31:26],  // opcode
       instr[25:21],  // rs
       instr[20:16],  // rt
       instr[15:0], //immediate value
       aluout,
       rd_value,
       memwrite,
       memaddr,   
       memval,
       readdata
    );
    end
      
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
      // Replace instr_kind = R_Type / I_Type depends on specification
      assert(tr.randomize() with {instr_kind==R_TYPE;});
      start_item(tr);
      finish_item(tr);
    end
  endtask

endclass : processor_seq