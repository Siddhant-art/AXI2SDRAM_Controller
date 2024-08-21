class axi_tx_sequencer extends uvm_sequencer #(axi_packet);

  axi_packet  packet;  

  `uvm_component_utils(axi_tx_sequencer)

  function new(string name, uvm_component parent);   
    super.new(name, parent);     // important!!
  endfunction

  // start_of_simulation
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : axi_tx_sequencer


