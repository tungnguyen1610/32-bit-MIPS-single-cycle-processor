class processor_sequencer extends uvm_sequencer #(processor_transaction);

   `uvm_component_utils(processor_sequencer)
 
   function new(input string name, uvm_component parent=null);
      super.new(name, parent);
   endfunction : new
  

endclass : processor_sequencer