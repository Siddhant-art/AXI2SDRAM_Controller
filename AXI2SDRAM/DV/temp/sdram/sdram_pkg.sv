package sdram_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"


typedef uvm_config_db#(virtual sdram_if) sdram_vif_config;
`include "sdram_packet.sv"
`include "sdram_tx_monitor.sv"
`include "sdram_tx_sequencer.sv"
`include "sdram_tx_seqs.sv"
`include "sdram_tx_driver.sv"
`include "sdram_tx_agent.sv"
`include "sdram_env.sv"

endpackage
