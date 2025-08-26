class processor_base_test extends uvm_test;
  `uvm_component_utils(processor_base_test);
  
  processor_env env;
  virtual processor_interface vif;
  
  function new(string name = "processor_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
          // "this" is a parent handle (in component hierachy)
    env=processor_env::type_id::create("env",this);
      if (!uvm_config_db #(virtual  processor_interface)::get(this,"","vif",vif) ) begin 
    `uvm_fatal("NOVIF", "No virtual interface found for key 'vif' in processor_test")
      end 
    // Set config db for env
    uvm_config_db #(virtual  processor_interface)::set(this,"env","vif",vif);
    endfunction
  
  // [Recommended] By this phase, the environment is all set up so its good to just print the topology for debug
      virtual function void end_of_elaboration_phase (uvm_phase phase);
         uvm_top.print_topology ();
      endfunction
  
    task run_phase( uvm_phase phase );
    processor_seq item;
        phase.raise_objection(this, "Starting processor_base_test");
      item= processor_seq::type_id::create("processor_seq");
      $display("%t Starting sequence processor_seq run_phase",$time);
    	item.start(env.agt.sqr);
    	#100ns;
      phase.drop_objection( this , "Finished processor_seq in main phase" );    endtask
  
endclass : processor_base_test