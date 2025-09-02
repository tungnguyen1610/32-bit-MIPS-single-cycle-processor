class processor_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(processor_scoreboard);

  uvm_analysis_imp #(processor_transaction,processor_scoreboard) mon_export;
  uvm_tlm_fifo #(processor_transaction) mon_fifo;
  bit [31:0] reg_mem [0:256];
  
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_export = new("mon_export", this);
    mon_fifo   = new("mon_fifo", this, 8);
    foreach(reg_mem[i]) reg_mem[i] = i;
  endfunction

  // This gets called by the monitor through the analysis imp
  virtual function void write (processor_transaction tr);
    void'(mon_fifo.try_put(tr));
  endfunction
  
virtual task run_phase (uvm_phase phase);
  processor_transaction expdata;
  bit [4:0] i1,i2;
  bit [31:0] actual;
  bit [15:0] immediate;
  forever begin
    if (!mon_fifo.is_empty()) begin
      mon_fifo.get(expdata);
      `uvm_info("SCOREBOARD", $sformatf("Instr: %0h", expdata.instr), UVM_LOW)
      if (expdata.instr_kind == processor_transaction :: R_TYPE) begin
      // R-type scoreboard
      // Source registers
      i1 = expdata.instr[25:21];
      i2 = expdata.instr[20:16];

      case(expdata.instr[5:0])
        // ADD
        6'b100000: begin
          actual = reg_mem[i1] + reg_mem[i2];
          if (actual == expdata.aluout) begin
            `uvm_info("SCOREBOARD", $sformatf("Addition PASS - Actual=%0d Expected=%0d",
                        actual, expdata.aluout), UVM_LOW)
            reg_mem[expdata.rd] = actual;
            `uvm_info("SCOREBOARD", $sformatf("Wrote %0d to R[%0d]", actual, expdata.rd), UVM_LOW)
          end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("Addition FAIL - Actual=%0d Expected=%0d",
                         actual, expdata.aluout))
          end
        end

        // SUB
        6'b100010: begin
          actual = reg_mem[i1] - reg_mem[i2];
          if (actual == expdata.aluout) begin
            `uvm_info("SCOREBOARD", $sformatf("Subtraction PASS - Actual=%0d Expected=%0d",
                        actual, expdata.aluout), UVM_LOW)
            reg_mem[expdata.rd] = actual;
            `uvm_info("SCOREBOARD", $sformatf("Wrote %0d to R[%0d]", actual, expdata.rd), UVM_LOW)
          end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("Subtraction FAIL - Actual=%0d Expected=%0d",
                         actual, expdata.aluout))
          end
        end

        // AND
        6'b100100: begin
          actual = reg_mem[i1] & reg_mem[i2];
          if (actual == expdata.aluout) begin
            `uvm_info("SCOREBOARD", $sformatf("AND PASS - Actual=%0d Expected=%0d",
               actual, expdata.aluout), UVM_LOW)
            reg_mem[expdata.rd] = actual;
            `uvm_info("SCOREBOARD", $sformatf("Wrote %0d to R[%0d]", actual, expdata.rd), UVM_LOW)
          end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("AND FAIL - Actual=%0d Expected=%0d",
                         actual, expdata.aluout))
          end
        end

        // OR
        6'b100101: begin
          actual = reg_mem[i1] | reg_mem[i2];
          if (actual == expdata.aluout) begin
            `uvm_info("SCOREBOARD", $sformatf("OR PASS - Actual=%0d Expected=%0d",
                        actual, expdata.aluout), UVM_LOW)
            reg_mem[expdata.rd] = actual;
            `uvm_info("SCOREBOARD", $sformatf("Wrote %0d to R[%0d]", actual, expdata.rd), UVM_LOW)
          end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("OR FAIL - Actual=%0d Expected=%0d",
                         actual, expdata.aluout))
          end
        end

        // SLT (set less than)
        6'b101010: begin
          actual = ($signed(reg_mem[i1])) < ($signed(reg_mem[i2])) ? 32'd1 : 32'd0;
          if (actual == expdata.aluout) begin
            `uvm_info("SCOREBOARD", $sformatf("SLT PASS - Actual=%0d Expected=%0d",
                        actual, expdata.aluout), UVM_LOW)
            reg_mem[expdata.rd] = actual;
            `uvm_info("SCOREBOARD", $sformatf("Wrote %0d to R[%0d]", actual, expdata.rd), UVM_LOW)
          end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("SLT FAIL - Actual=%0d Expected=%0d",
                         actual, expdata.aluout))
          end
        end

        default: begin
          `uvm_warning("SCOREBOARD", $sformatf("Unhandled funct code: %0b",
                          expdata.instr[5:0]))
        end
      endcase
    end
    
    else if (expdata.instr_kind == processor_transaction :: I_TYPE) begin
    // I - Type scoreboard
      // source reg
      i1 = expdata.instr[25:21];
      // dest reg
      i2 = expdata.instr[20:16];
      immediate=expdata.instr[15:0];
    case (expdata.instr[31:26])
      // ADDI
      6'b001000: begin
        actual = reg_mem[i1] + {{16{immediate[15]}},immediate};
        if (actual == expdata.aluout) begin
            `uvm_info("SCOREBOARD", $sformatf("Addition PASS - Actual=%0d Expected=%0d",
                        actual, expdata.aluout), UVM_LOW)
            reg_mem[expdata.rd] = actual;
            `uvm_info("SCOREBOARD", $sformatf("Wrote %0d to R[%0d]", actual, expdata.rd), UVM_LOW)          
      end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("Addition Immediate FAIL - Actual=%0d Expected=%0d",
                         actual, expdata.aluout))
          end          
      end
      // LW
      6'b100011: begin
      // Memory address in dmem
         actual = reg_mem[i1] + {{16{immediate[15]}},immediate};
        `uvm_info("SCOREBOARD", $sformatf("LW instruction pass - Read memory 0x%08h to R[%0d]", actual, expdata.rd), UVM_LOW)   
       	 reg_mem[i2]=expdata.readdata;
      end
      // SW 
      6'b101011: begin
      actual = reg_mem[i1] + {{16{immediate[15]}},immediate};
      `uvm_info("SCOREBOARD", $sformatf("SW instruction pass - Write to memory 0x%08h from R[%0d]", actual, expdata.rd), UVM_LOW) 
      end
      default: begin
        `uvm_warning("SCOREBOARD", $sformatf("Unhandled op code: %0b",
                                               expdata.instr[31:26]))
      end
    endcase
    end
      
    else begin
    
    end
  
  end
  else begin
      // wait a bit before polling again
      #1ns;
  end
 end
endtask

endclass
