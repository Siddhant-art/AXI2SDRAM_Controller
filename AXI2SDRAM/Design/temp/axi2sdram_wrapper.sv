`include "axil_slave_fsm.sv"
`include "fifo.sv"
`include "SDRAM_Controller.sv"

module AXI2SDRAM
	#(parameter 
				ADDR_WIDTH = 32,
                DATA_WIDTH = 32,
				SDRAM_ADDR_WIDTH = 13,
				SDRAM_DATA_WIDTH = 16,
				SDRAM_BANK_WIDTH = 2
	)
(
	
	input logic				SDRAM_CLK,						//Global clock signal for contoller
	input logic 				ACLK,							//Global Clock Signal for axi slave
	input logic 				ARESETn,						//global reset signal(active low)

	// write address signals
	input 	logic	[ADDR_WIDTH-1:0] 	AWADDR,
	input 	logic				AWVALID,
	output 	logic				AWREADY,
	
	// write data signals
	input 	logic 	[DATA_WIDTH-1:0] 	WDATA,
	input 	logic				WVALID,
	input 	logic 	[DATA_WIDTH/8-1:0]	WSTRB,
	output 	logic				WREADY,

	// write response signals
	output 	logic				BVALID,
	input 	logic				BREADY,
	output 	logic		[1:0]		BRESP,

	// Read address signals
	input 	logic 	[ADDR_WIDTH-1:0]	ARADDR,
	input  	logic 				ARVALID,
	output 	logic				ARREADY,

	// read data signals
	output 	logic				RVALID,
	input	logic 				RREADY,
	output	logic 	[DATA_WIDTH-1:0]	RDATA,
	output 	logic 	[1:0]			RRESP,


	//sdram controller output Signals

	output	logic 				sdram_clk_o,					//output clock to the sdram
	output 	logic				sdram_cke_o,
	output 	logic				sdram_cs_o,
	output 	logic				sdram_cas_o,
	output 	logic				sdram_ras_o,
	output 	logic				sdram_we_o,
	output 	logic	[SDRAM_BANK_WIDTH-1:0]	sdram_ba_o,						//two banks
	output 	logic	[SDRAM_ADDR_WIDTH-1:0] 	sdram_a_o,
	inout  	logic	[SDRAM_DATA_WIDTH-1:0]	sdram_dq_io,					//bidirectional port
	output 	logic	[1:0]			sdram_dqm_o 					//data mask

);

	
	wire AXIL_WR_ADDR_EN_q;	
	wire AXIL_WR_DATA_EN_q;
	wire AXIL_RD_ADDR_EN_q;	
	wire AXIL_RD_DATA_EN_q;

	wire SD_RD_ADDR_EN_q;
	wire SD_RD_DATA_EN_q;
	wire SD_WR_ADDR_EN_q;	
	wire SD_WR_DATA_EN_q;

	wire [ADDR_WIDTH-1:0] AXIL_WR_ADDR_IN_q;	
	wire [DATA_WIDTH-1:0] AXIL_WR_DATA_IN_q;
	wire [ADDR_WIDTH-1:0] AXIL_RD_ADDR_IN_q;	
	wire [DATA_WIDTH-1:0] AXIL_RD_DATA_OUT_q;

	wire [ADDR_WIDTH-1:0] SD_WR_ADDR_OUT_q;	
	wire [DATA_WIDTH-1:0] SD_WR_DATA_OUT_q;
	wire [ADDR_WIDTH-1:0] SD_RD_ADDR_OUT_q;	
	wire [DATA_WIDTH-1:0] SD_RD_DATA_IN_q;

	wire WADDR_FIFO_FULL_q;
	wire WADDR_FIFO_EMPTY_q;
	wire WDATA_FIFO_FULL_q;
	wire WDATA_FIFO_EMPTY_q;
	wire RADDR_FIFO_FULL_q;
	wire RADDR_FIFO_EMPTY_q;
	wire RDATA_FIFO_FULL_q;
	wire RDATA_FIFO_EMPTY_q;


		/* HOST INTERFACE */
	wire  [HADDR_WIDTH-1:0]   wr_addr;
	wire  [15:0]              wr_data;
	wire                      wr_enable;

	wire  [HADDR_WIDTH-1:0]   rd_addr;
	wire [15:0]               rd_data;
	wire                      rd_enable;
	wire                      rd_ready;

	wire                      busy;
	wire                      rst_n;
	wire                      clk;

	// /* SDRAM SIDE */
	// wire [SDRADDR_WIDTH-1:0] addr;
	// wire [BANK_WIDTH-1:0]    bank_addr;
	// wire [15:0]              data;
	// wire                     clock_enable;
	// wire                     cs_n;
	// wire                     ras_n;
	// wire                     cas_n;
	// wire                     we_n;
	// wire                     data_mask_low;
	// wire                     data_mask_high;


AXIL_Slave_FSM AXI_Slave(
        .s_axil_clk(ACLK),
        .s_axil_resetn(ARESETn),

        //Write address channel signals
        .s_axil_awaddr(AWADDR),
        .s_axil_awvalid(AWVALID),
        .s_axil_awready(AWREADY),  

        //write data channel signals 
        .s_axil_wdata(WDATA),
        .s_axil_wvalid(WVALID),
        .s_axil_wstrb(WSTRB),
        .s_axil_wready(WREADY),

        //write response signals
        .s_axil_bready(BREADY),
        .s_axil_bresp(BRESP),
        .s_axil_bvalid(BVALID),
     
        //Read address channel signals
        .s_axil_araddr(ARADDR),
        .s_axil_arvalid(ARVALID),
        .s_axil_arready(ARREADY),

        //Read data channel signals
        .s_axil_rdata(RDATA),
        .s_axil_rresp(RRESP),
        .s_axil_rvalid(RVALID),
        .s_axil_rready(RREADY),  

	.AXIL_WR_ADDR_EN(AXIL_WR_ADDR_EN_q),    
	.AXIL_WR_DATA_EN(AXIL_WR_DATA_EN_q),
	.AXIL_RD_ADDR_EN(AXIL_RD_ADDR_EN_q),    
	.AXIL_RD_DATA_EN(AXIL_RD_DATA_EN_q),

	.AXIL_WR_ADDR_IN(AXIL_WR_ADDR_IN_q),    
	.AXIL_WR_DATA_IN(AXIL_WR_DATA_IN_q),  
	.AXIL_RD_ADDR_IN(AXIL_RD_ADDR_IN_q), 
	.AXIL_RD_DATA_OUT(AXIL_RD_DATA_OUT_q),


	.WADDR_FIFO_FULL(WADDR_FIFO_FULL_q),
	.WADDR_FIFO_EMPTY(WADDR_FIFO_EMPTY_q),
	.WDATA_FIFO_FULL(WDATA_FIFO_FULL_q),
	.WDATA_FIFO_EMPTY(WDATA_FIFO_EMPTY_q),
	.RADDR_FIFO_FULL(RADDR_FIFO_FULL_q),
	.RADDR_FIFO_EMPTY(RADDR_FIFO_EMPTY_q),
	.RDATA_FIFO_FULL(RDATA_FIFO_FULL_q),
	.RDATA_FIFO_EMPTY(RDATA_FIFO_EMPTY_q)
        );

FIFO FIFO_inst(
	    .AXI_CLK(ACLK),
		.SD_CLK(SDRAM_CLK),
		.ARESETn(ARESETn),

		.AXIL_WR_ADDR_EN(AXIL_WR_ADDR_EN_q),	
		.AXIL_WR_DATA_EN(AXIL_WR_DATA_EN_q),
		.AXIL_RD_ADDR_EN(AXIL_RD_ADDR_EN_q),	
		.AXIL_RD_DATA_EN(AXIL_RD_DATA_EN_q),

		.SD_RD_ADDR_EN(SD_RD_ADDR_EN_q),	
		.SD_RD_DATA_EN(SD_RD_DATA_EN_q),
		.SD_WR_ADDR_EN(SD_WR_ADDR_EN_q),	
		.SD_WR_DATA_EN(SD_WR_DATA_EN_q),

		.AXIL_WR_ADDR_IN(AXIL_WR_ADDR_IN_q),	
		.AXIL_WR_DATA_IN(AXIL_WR_DATA_IN_q),
		.AXIL_RD_ADDR_IN(AXIL_RD_ADDR_IN_q),	
		.AXIL_RD_DATA_OUT(AXIL_RD_DATA_OUT_q),

		.SD_WR_ADDR_OUT(SD_WR_ADDR_OUT_q),	
		.SD_WR_DATA_OUT(SD_WR_DATA_OUT_q),
		.SD_RD_ADDR_OUT(SD_RD_ADDR_OUT_q),	
		.SD_RD_DATA_IN(SD_RD_DATA_IN_q),

		.WADDR_FIFO_FULL(WADDR_FIFO_FULL_q),
		.WADDR_FIFO_EMPTY(WADDR_FIFO_EMPTY_q),
		.WDATA_FIFO_FULL(WDATA_FIFO_FULL_q),
		.WDATA_FIFO_EMPTY(WDATA_FIFO_EMPTY_q),
		.RADDR_FIFO_FULL(RADDR_FIFO_FULL_q),
		.RADDR_FIFO_EMPTY(RADDR_FIFO_EMPTY_q),
		.RDATA_FIFO_FULL(RDATA_FIFO_FULL_q),
		.RDATA_FIFO_EMPTY(RDATA_FIFO_EMPTY_q)

);

module sdram_controller (
    /* HOST INTERFACE */
    wr_addr(wr_addr),
    wr_data(wr_data),
    wr_enable(wr_enable),

    rd_addr(rd_addr),
    rd_data(rd_data),
    rd_ready(rd_ready),
    rd_enable(rd_enable),

    busy(busy),
    rst_n(rst_n),
    clk(clk),

    /* SDRAM SIDE */
    addr(addr), 
    bank_addr(bank_addr), 
    data(data), 
    clock_enable(clock_enable), 
    cs_n(cs_n), 
    ras_n(ras_n), 
    cas_n(cas_n), 
    we_n(we_n),
    data_mask_low(data_mask_low), 
    data_mask_high(data_mask_high)
);


// SDRAM_Controller SDRAM_Master(
// 		//input from TB
// 		.SDRAM_CLK(SDRAM_CLK),
// 		.SDRAM_RESET(ARESETn),

// 		.SD_RD_ADDR_EN(SD_RD_ADDR_EN_q),	
// 		.SD_RD_DATA_EN(SD_RD_DATA_EN_q),
// 		.SD_WR_ADDR_EN(SD_WR_ADDR_EN_q),	
// 		.SD_WR_DATA_EN(SD_WR_DATA_EN_q),

// 		.SD_WR_ADDR_OUT(SD_WR_ADDR_OUT_q),	
// 		.SD_WR_DATA_OUT(SD_WR_DATA_OUT_q),
// 		.SD_RD_ADDR_OUT(SD_RD_ADDR_OUT_q),	
// 		.SD_RD_DATA_IN(SD_RD_DATA_IN_q),

// 		.WADDR_FIFO_FULL(WADDR_FIFO_FULL_q),
// 		.WADDR_FIFO_EMPTY(WADDR_FIFO_EMPTY_q),
// 		.WDATA_FIFO_FULL(WDATA_FIFO_FULL_q),
// 		.WDATA_FIFO_EMPTY(WDATA_FIFO_EMPTY_q),
// 		.RADDR_FIFO_FULL(RADDR_FIFO_FULL_q),
// 		.RADDR_FIFO_EMPTY(RADDR_FIFO_EMPTY_q),
// 		.RDATA_FIFO_FULL(RDATA_FIFO_FULL_q),
// 		.RDATA_FIFO_EMPTY(RDATA_FIFO_EMPTY_q),

// 		.sdram_clk_o(sdram_clk_o),					//output clock to the sdram
// 		.sdram_cke_o(sdram_cke_o),
// 		.sdram_cs_o(sdram_cs_o),
// 		.sdram_cas_o(sdram_cas_o),
// 		.sdram_ras_o(sdram_ras_o),
// 		.sdram_we_o(sdram_we_o),
// 		.sdram_ba_o(sdram_ba_o),						//two banks
// 		.sdram_a_o(sdram_a_o),
// 		.sdram_dq_io(sdram_dq_io),					
// 		.sdram_dqm_o(sdram_dqm_o) 					//data mask

// );


endmodule : AXI2SDRAM