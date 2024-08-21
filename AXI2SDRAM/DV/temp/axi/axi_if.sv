interface axi_if (input clock, input reset );

   // Read address channel signals
 logic   [3:0]   ARID;
 logic   [31:0]  ARADDR;
 logic   [3:0]   ARLEN;
 logic   [2:0]   ARSIZE;
 logic   [1:0]   ARBURST;
 logic   [1:0]   ARLOCK;
 logic   [3:0]   ARCACHE; 
 logic   [2:0]   ARPROT;
 logic           ARVALID;
 logic           ARREADY;

   // Write address channel signals
 logic   [3:0]   AWID;
 logic   [31:0]  AWADDR;
 logic   [3:0]   AWLEN;
 logic   [2:0]   AWSIZE;
 logic   [1:0]   AWBURST;
 logic   [1:0]   AWLOCK;
 logic   [3:0]   AWCACHE; 
 logic   [2:0]   AWPROT;
 logic           AWVALID;
 logic           AWREADY;

   // Read data channel signals
 logic   [3:0]   RID;
 logic   [31:0]  RDATA;
 logic   [1:0]   RRESP;
 logic           RLAST;
 logic           RVALID;
 logic           RREADY;

   // Write data channel signals
 logic   [3:0]   WID;
 logic   [31:0]  WDATA;
 logic   [3:0]   WSTRB;
 logic           WLAST;
 logic           WVALID;
 logic           WREADY;

   // Write response channel signals
 logic   [3:0]   BID;
 logic   [1:0]   BRESP;
 logic           BVALID;
 logic           BREADY;
  


endinterface : axi_if

