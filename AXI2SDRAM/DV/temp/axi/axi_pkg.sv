package axi_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"


typedef uvm_config_db#(virtual axi_if) axi_vif_config;
`include "axi_packet.sv"
`include "axi_tx_monitor.sv"
`include "axi_tx_sequencer.sv"
`include "axi_tx_seqs.sv"
`include "axi_tx_driver.sv"
`include "axi_tx_agent.sv"
`include "axi_env.sv"

endpackage
