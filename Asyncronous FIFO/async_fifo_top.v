module async_fifo_top#(
    parameter ADDR_WIDTH=3,
    parameter DATA_WIDTH=8
)
(
    input wr_clk,
    input wr_rst,
    input rd_clk,
    input rd_rst,
    
    input wr_en,
    input rd_en,
    
    input [DATA_WIDTH-1:0] wr_data,
    output [DATA_WIDTH-1:0] rd_data,
    
    output full,
    output empty
);
    wire [ADDR_WIDTH-1:0] wr_addr,rd_addr;
    
    wire [ADDR_WIDTH:0] rd_ptr_gray,wr_ptr_gray;
    
    wire [ADDR_WIDTH:0] rd_ptr_gray_sync,wr_ptr_gray_sync;
    
    wire mem_wr_en;
    wire mem_rd_en;
    
    assign mem_wr_en = wr_en && !full;
    assign mem_rd_en = rd_en && !empty;

    
    //instantiation of FIFO
    fifo_memory FIFO(
                    wr_clk,
                    rd_clk,
                    mem_wr_en,
                    mem_rd_en,
                    wr_addr,
                    rd_addr,
                    wr_data,
                    rd_data
    );
    
    //instantiation of WRITE and FULL BLOCK
    fifo_write_ctrl WRITE_BLOCK(
                    wr_clk,
                    wr_rst,
                    wr_en,
                    rd_ptr_gray_sync,
                    wr_addr,
                    wr_ptr_gray,
                    full
     );
    
    //instantiation of the READ and EMOTY BLOCK 
    fifo_read_ctrl READ_BLOCK(
                    rd_clk,
                    rd_rst,
                    rd_en,
                    wr_ptr_gray_sync,
                    rd_addr,
                    rd_ptr_gray,
                    empty
    );
    
    //instantiation of the Synchronization register 
    sync_register sync_r2w(
                    wr_clk,
                    wr_rst,
                    rd_ptr_gray,
                    rd_ptr_gray_sync
    );
    
    sync_register sync_w2r(
                    rd_clk,
                    rd_rst,
                    wr_ptr_gray,
                    wr_ptr_gray_sync
    );
    
    

endmodule