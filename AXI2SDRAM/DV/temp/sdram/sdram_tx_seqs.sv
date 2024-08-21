class sdram_base_seq extends uvm_sequence#(sdram_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(sdram_base_seq)

  // Constructor
  function new(string name="sdram_base_seq");
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

endclass : sdram_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 sdram_5_packets::get_type());
//
//------------------------------------------------------------------------------
class sdram_5_packets extends sdram_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(sdram_5_packets)

  // Constructor
  function new(string name="sdram_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing sdram_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask

endclass : sdram_5_packets

//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_012_seq - send random packets to channel 0, 1, 2 in order
//
//------------------------------------------------------------------------------
class sdram_012_seq extends sdram_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(sdram_012_seq)

  // Constructor
  function new(string name="sdram_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing sdram_012_SEQ", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b00;})
    `uvm_do_with(req, {req.addr == 2'b01;})
    `uvm_do_with(req, {req.addr == 2'b10;})
  endtask
  
endclass : sdram_012_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_1_seq - send a random packet to Channel 1
//
//------------------------------------------------------------------------------
class sdram_1_seq extends sdram_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(sdram_1_seq)

  // Constructor
  function new(string name="sdram_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing sdram_1_SEQ", UVM_LOW)
   `uvm_do_with(req, {req.addr == 2'b01;})
  endtask
  
endclass : sdram_1_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_111_seq - send three random packets to channel 1
//
//------------------------------------------------------------------------------
class sdram_111_seq extends sdram_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(sdram_111_seq)

  // Nested Sequence - executes sdram_1_seq three times
  sdram_1_seq addr_1_seq;

  // Constructor
  function new(string name="sdram_111_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing sdram_111_SEQ", UVM_LOW)
    repeat (3) 
    `uvm_do(addr_1_seq)
  endtask
  
endclass : sdram_111_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_incr_payload_seq - sends single packet with incrementing payload
//
//------------------------------------------------------------------------------
class sdram_incr_payload_seq extends sdram_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(sdram_incr_payload_seq)

  // Constructor
  function new(string name="sdram_incr_payload_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing sdram_INCR_PAYLOAD_SEQ", UVM_LOW)
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
endclass : sdram_incr_payload_seq
  
//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_rnd_seq
//
//------------------------------------------------------------------------------

class sdram_rnd_seq extends sdram_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(sdram_rnd_seq)

  // Parameter for this sequence
  rand int count;

  // Sequence Constraints
  constraint count_limit { count inside {[1:10]}; }

  // Constructor
  function new(string name="sdram_rnd_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Executing sdram_RND_SEQ %0d times...", count), UVM_LOW)
    repeat (count) begin
      `uvm_do(req)
    end
  endtask

endclass : sdram_rnd_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: six_sdram_seq
//
//------------------------------------------------------------------------------

class six_sdram_seq extends sdram_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(six_sdram_seq)

  // Parameter for this sequence
  sdram_rnd_seq yss;

  // Constructor
  function new(string name="six_sdram_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing SIX_sdram_SEQ" , UVM_LOW)
    `uvm_do_with(yss, {count==6;})
  endtask

endclass : six_sdram_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: sdram_exhaustive_seq
//
//------------------------------------------------------------------------------

class sdram_exhaustive_seq extends sdram_base_seq;

  // Required macro for sequences automation
  `uvm_object_utils(sdram_exhaustive_seq)

  // handles for all lab05 sequences
  sdram_012_seq y012;
  sdram_1_seq y1;
  sdram_111_seq y111;
  sdram_incr_payload_seq yinc;
  six_sdram_seq ysix;

  // Constructor
  function new(string name="sdram_exhaustive_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing sdram_EXHAUSTIVE_SEQ" , UVM_LOW)
    `uvm_do(y012)
    `uvm_do(y1)
    `uvm_do(y111)
    `uvm_do(yinc)
    `uvm_do(ysix)
  endtask

endclass : sdram_exhaustive_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: test_uvc_seq - sends packets to all 4 channels with
// incrementing payloads from 1 to 22. Used in Lab07
//
//------------------------------------------------------------------------------


class test_uvc_seq extends sdram_base_seq;

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

