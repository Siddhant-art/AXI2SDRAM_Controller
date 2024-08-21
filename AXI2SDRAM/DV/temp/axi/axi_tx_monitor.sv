class axi_tx_monitor extends uvm_monitor;

  // Collected Data handle
  axi_packet pkt;

  // Count packets collected
  int num_pkt_col;

  // analysis port for lab09*
  uvm_analysis_port#(axi_packet) item_collected_port;

  virtual interface axi_if vif;

  // component macro
  `uvm_component_utils_begin(axi_tx_monitor)
    `uvm_field_int(num_pkt_col, UVM_ALL_ON)
  `uvm_component_utils_end

  // component constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port",this);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!axi_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: connect_phase

  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = axi_packet::type_id::create("pkt", this);

      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_axi_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      item_collected_port.write(pkt);
      num_pkt_col++;
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: axi Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass : axi_tx_monitor
