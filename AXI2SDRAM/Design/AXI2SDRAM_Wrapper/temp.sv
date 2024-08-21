module fifo_sdram_cntrl#(parameter 
                            ADDR_WIDTH  = 32,
                            HADDR_WIDTH = 24
                )
(
    //signals w.r.t. FIFO Side    
    input   logic SD_clk,
    input   logic ARESETn,

    output  logic SD_RD_ADDR_EN,
    output  logic SD_RD_DATA_EN,
    output  logic SD_WR_ADDR_EN,  
    output  logic SD_WR_DATA_EN,

    output  logic SD_RW_EN,
    input   logic SD_RW_OUT,

    input   logic [ADDR_WIDTH-1:0] SD_WR_ADDR_OUT, 
    input   logic [ADDR_WIDTH-1:0] SD_WR_DATA_OUT,
    input   logic [ADDR_WIDTH-1:0] SD_RD_ADDR_OUT, 
    output  logic [ADDR_WIDTH-1:0] SD_RD_DATA_IN,         //sent from the controller to RD data fifo

    output  logic WADDR_FIFO_FULL,
    output  logic WADDR_FIFO_EMPTY,
    output  logic WDATA_FIFO_EMPTY,
    output  logic WDATA_FIFO_FULL,
    output  logic RADDR_FIFO_FULL,
    output  logic RADDR_FIFO_EMPTY,
    output  logic RDATA_FIFO_FULL,
    output  logic RDATA_FIFO_EMPTY,
    output  logic RW_FIFO_FULL,                    
    output  logic RW_FIFO_EMPTY ,



    //signals on contoller side
    output  [HADDR_WIDTH-1:0]       wr_addr,        
    output  [15:0]                  wr_data,
    output                          wr_enable,          

    output  [HADDR_WIDTH-1:0]       rd_addr,
    input   [15:0]                  rd_data,
    output                          rd_enable,
    input                           rd_ready,

    input                           busy
/*    output                          rst_n;
    output                          clk;*/


);
//    assign clk = SD_clk;

    // always@(posedge SD_clk) begin
    //     if(ARESETn) begin
    //         wr_addr     <= 'h0;
    //         wr_data     <= 'h0;
    //         wr_enable   <= 1'b0;
    //         rd_addr     <= 'h0;
    //         rd_enable   <= 1'b0;
    //     end
    //     else begin
            
    //     end


    // end

    
endmodule : fifo_sdram_cntrl
