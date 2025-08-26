class processor_monitor extends uvm_monitor; 
`uvm_component_utils(processor_monitor)      
  
  virtual processor_interface.monitor_if vif;
  //Analysis port
  uvm_analysis_port#(processor_transaction) ap;
  
  function new(string name, uvm_component parent = null);
     super.new(name, parent);
     //Create Analysis port here
     ap=new("ap",this);
   endfunction: new

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(virtual processor_interface.monitor_if)::get(this, "", "vif", vif)) begin
    `uvm_fatal("NOVIF", "No virtual interface found for key 'vif' in monitor")
  end

endfunction


  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      processor_transaction tr;
      int value;
      tr = processor_transaction::type_id::create("tr", this);

      @(this.vif.monitor_cb);

      tr.instr = this.vif.monitor_cb.instr; // extend later to capture outputs
      tr.aluout=this.vif.monitor_cb.aluout;
      tr.rd=this.vif.monitor_cb.instr[15:11];
      // get register value
      uvm_hdl_read($sformatf("testbench.dut.u_mips.dp.rf.rf[%0d]", tr.rd), value);
      tr.rd_value = value;      
      ap.write(tr);
      `uvm_info("Processor_MONITOR",
                $sformatf("Sampled transaction %s", tr.convert2string()),
                UVM_MEDIUM)
    end
  endtask

endclass