class processor_env extends uvm_env ;
  `uvm_component_utils(processor_env);
   processor_agent agt;
   processor_scoreboard scb;
   processor_subscriber sub;
   virtual processor_interface vif;
   
   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   //Build phase - Construct agent and get virtual interface handle from test and pass down to agent
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    agt=processor_agent::type_id::create("agt",this);
    //scoreboard 
    scb=processor_scoreboard::type_id::create("scb",this);
    //subscriber
    sub=processor_subscriber::type_id::create("sub",this);
      if (!uvm_config_db #(virtual  processor_interface)::get(this,"","vif",vif) ) begin 
        `uvm_fatal("NOVIF", "No virtual interface found for key 'vif' in processor_env") 
      end
    
        // Set config db for env
    uvm_config_db #(virtual  processor_interface)::set(this,"agt","vif",vif);
    endfunction
  
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    // later connect  analysis port to subscriber and scoreboard
    agt.mon.ap.connect(scb.mon_export);
    agt.mon.ap.connect(sub.analysis_export);
  endfunction 
  
endclass