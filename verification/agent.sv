class processor_agent extends uvm_agent;
  `uvm_component_utils(processor_agent);
   processor_sequencer sqr;
   processor_monitor mon;
   processor_driver drv;
   virtual processor_interface vif;
    
  function new (string name, uvm_component parent = null);
    super.new (name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr=processor_sequencer::type_id::create("sqr",this);
    mon=processor_monitor::type_id::create("mon",this);
    drv=processor_driver::type_id::create("drv",this);
    
    if (!uvm_config_db #(virtual processor_interface) :: get (this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "No virtual interface found for key 'vif' in agent")
     end
    uvm_config_db #(virtual processor_interface) :: set (this,"sqr","vif",vif);
  // When passing to monitor, pass the modport handle
    uvm_config_db#(virtual processor_interface.monitor_if)::set(this,"mon","vif",vif.monitor_if);
    uvm_config_db #(virtual processor_interface) :: set (this,"drv","vif",vif);    
  endfunction
   
  virtual function void connect_phase(uvm_phase phase);
    uvm_report_info("processor_agent::", "connect_phase, Connected driver to sequencer");
       drv.seq_item_port.connect(sqr.seq_item_export);    
  endfunction 
endclass 