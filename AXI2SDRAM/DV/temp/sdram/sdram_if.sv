interface sdram_if (input CLK, input CKE, input reset_n );

   // SDRAM Signals
 logic          RAS;
 logic          CAS;
 logic          WE;
 logic  [11:0]  A;   // needs to be change
 logic          BA;
 logic  [15:0]  DQ;
 logic  [1:0]   DQM;

endinterface : sdram_if

