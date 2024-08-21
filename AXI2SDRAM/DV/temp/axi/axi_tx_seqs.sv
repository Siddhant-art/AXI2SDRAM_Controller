class axi_base_seq extends uvm_sequence#(axi_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_base_seq)

  // Constructor
  function new(string name="axi_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : axi_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: axi_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 axi_5_packets::get_type());
//
//------------------------------------------------------------------------------
class axi_5_packets extends axi_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(axi_5_packets)

  // Constructor
  function new(string name="axi_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask

endclass : axi_5_packets

//------------------------------------------------------------------------------
//
// SEQUENCE: axi_012_seq - send random packets to channel 0, 1, 2 in order
//
//------------------------------------------------------------------------------
class axi_012_seq extends axi_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_012_seq)

  // Constructor
  function new(string name="axi_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_012_SEQ", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b00;})
    `uvm_do_with(req, {req.addr == 2'b01;})
    `uvm_do_with(req, {req.addr == 2'b10;})
  endtask
  
endclass : axi_012_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: axi_1_seq - send a random packet to Channel 1
//
//------------------------------------------------------------------------------
class axi_1_seq extends axi_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_1_seq)

  // Constructor
  function new(string name="axi_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_1_SEQ", UVM_LOW)
   `uvm_do_with(req, {req.addr == 2'b01;})
  endtask
  
endclass : axi_1_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: axi_111_seq - send three random packets to channel 1
//
//------------------------------------------------------------------------------
class axi_111_seq extends axi_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_111_seq)

  // Nested Sequence - executes axi_1_seq three times
  axi_1_seq addr_1_seq;

  // Constructor
  function new(string name="axi_111_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_111_SEQ", UVM_LOW)
    repeat (3) 
    `uvm_do(addr_1_seq)
  endtask
  
endclass : axi_111_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: axi_incr_payload_seq - sends single packet with incrementing payload
//
//------------------------------------------------------------------------------
class axi_incr_payload_seq extends axi_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_incr_payload_seq)

  // Constructor
  function new(string name="axi_incr_payload_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_INCR_PAYLOAD_SEQ", UVM_LOW)
    // simple solution using constraint
    //`uvm_do_with(req, {foreach (payload[i]) payload[i] == i ; })
    // intended solution using create and send macros
    `uvm_create(req)
    assert(req.randomize());
    for (int i=0;i<req.length;i++)
      req.payload[i] = i;
    req.set_parity();  // recalculate parity taking into account parity_type
    `uvm_send(req)
  endtask
endclass : axi_incr_payload_seq
  
//------------------------------------------------------------------------------
//
// SEQUENCE: axi_rnd_seq
//
//------------------------------------------------------------------------------

class axi_rnd_seq extends axi_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(axi_rnd_seq)

  // Parameter for this sequence
  rand int count;

  // Sequence Constraints
  constraint count_limit { count inside {[1:10]}; }

  // Constructor
  function new(string name="axi_rnd_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Executing axi_RND_SEQ %0d times...", count), UVM_LOW)
    repeat (count) begin
      `uvm_do(req)
    end
  endtask

endclass : axi_rnd_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: six_axi_seq
//
//------------------------------------------------------------------------------

class six_axi_seq extends axi_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(six_axi_seq)

  // Parameter for this sequence
  axi_rnd_seq yss;

  // Constructor
  function new(string name="six_axi_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing SIX_axi_SEQ" , UVM_LOW)
    `uvm_do_with(yss, {count==6;})
  endtask

endclass : six_axi_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: axi_exhaustive_seq
//
//------------------------------------------------------------------------------

class axi_exhaustive_seq extends axi_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(axi_exhaustive_seq)

  // handles for all lab05 sequences
  axi_012_seq y012;
  axi_1_seq y1;
  axi_111_seq y111;
  axi_incr_payload_seq yinc;
  six_axi_seq ysix;

  // Constructor
  function new(string name="axi_exhaustive_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_EXHAUSTIVE_SEQ" , UVM_LOW)
    `uvm_do(y012)
    `uvm_do(y1)
    `uvm_do(y111)
    `uvm_do(yinc)
    `uvm_do(ysix)
  endtask

endclass : axi_exhaustive_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: test_uvc_seq - sends packets to all 4 channels with
// incrementing payloads from 1 to 22. Used in Lab07
//
//------------------------------------------------------------------------------


class test_uvc_seq extends axi_base_seq;

  `uvm_object_utils(test_uvc_seq)

  // Constructor
  function new(string name="test_uvc_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing TEST_OVC_SEQ", UVM_LOW)
    `uvm_create(req)
    req.packet_delay = 1;
    for (int ad=0; ad < 4; ad++) begin // address loop
      req.addr = ad;
      for (int lgt=1; lgt < 23; lgt++) begin // length loop
        req.length = lgt;
        req.payload = new[lgt];
        for (int pld = 0; pld < lgt; pld++)
          req.payload[pld] = pld;
        randcase
          20 : req.parity_type = BAD_PARITY;
          80 : req.parity_type = GOOD_PARITY;
        endcase
         req.set_parity();
        `uvm_send(req)
      end  // length loop
    end  // address loop
  endtask

endclass : test_uvc_seq

