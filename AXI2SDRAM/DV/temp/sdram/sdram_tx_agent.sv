class sdram_tx_agent extends uvm_agent;

  // predeclared field inherited from uvm_agent determines whether an agent is active or passive.
  // uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  sdram_tx_monitor   monitor;
  sdram_tx_sequencer sequencer;
  sdram_tx_driver    driver;
  
  // component macro
  `uvm_component_utils_begin(sdram_tx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = sdram_tx_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = sdram_tx_sequencer::type_id::create("sequencer", this);
      driver = sdram_tx_driver::type_id::create("driver", this);
    end
  endfunction : build_phase

  // UVM connect_phase
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) 
      // connect the driver to the sequencer 
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

  // start_of_simulation
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH) 
  endfunction : start_of_simulation_phase

  // Assign the virtual interfaces of the agent's children
  function void assign_vi(virtual interface sdram_if vif);
    monitor.vif = vif;
    if (is_active == UVM_ACTIVE) 
      driver.vif = vif;
  endfunction : assign_vi

endclass : sdram_tx_agent

