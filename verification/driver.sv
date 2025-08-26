class processor_driver extends uvm_driver #(processor_transaction);
  // register in factory 
  `uvm_component_utils(processor_driver)      
  virtual processor_interface vif;
  
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	 // get db from agent
     if (!uvm_config_db #(virtual processor_interface) :: get (this, "", "vif", vif)) begin
       `uvm_fatal("NOVIF", "No virtual interface found for key 'vif' in driver")
     end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    //drive to interface
	forever begin
  processor_transaction tr;
// 1) fetch item
    @(posedge vif.clk);

    seq_item_port.get_next_item(tr);

    // 2) drive instruction onto interface
    vif.driver_cb.instr <= tr.instr;

    `uvm_info("Processor_DRIVER",
              $sformatf("Drove instruction %s", tr.convert2string()),
              UVM_MEDIUM)

    // 3) wait one cycle so DUT can execute it
//    @(posedge vif.clk);

    // 4) notify sequencer we're done
    seq_item_port.item_done();
    end
  endtask : run_phase

endclass 