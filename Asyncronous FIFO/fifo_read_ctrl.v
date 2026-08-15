module fifo_read_ctrl#(
    parameter ADDR_WIDTH=3
)(
    input rd_clk,
    input rd_rst,
    input rd_en,
    
    input [ADDR_WIDTH:0] wr_ptr_gray_sync,
    output [ADDR_WIDTH-1:0] rd_addr,
    output reg [ADDR_WIDTH:0] rd_ptr_gray,
    output reg empty
);

    reg [ADDR_WIDTH:0] rd_ptr_bin;
    reg [ADDR_WIDTH:0] rd_ptr_bin_next;
    reg [ADDR_WIDTH:0] rd_ptr_gray_next;
    reg empty_next;
    
    assign rd_addr=rd_ptr_bin[ADDR_WIDTH-1:0];
    
    always @(*) begin
        rd_ptr_bin_next=rd_ptr_bin;
        
        if(rd_en && !empty) begin
            rd_ptr_bin_next=rd_ptr_bin+1;
        end
        
        rd_ptr_gray_next=(rd_ptr_bin_next>>1)^(rd_ptr_bin_next);
        
        empty_next=(rd_ptr_gray_next==wr_ptr_gray_sync);
    end
    
    always @(posedge rd_clk or posedge rd_rst) begin
        if(rd_rst) begin
            rd_ptr_bin<=0;
            rd_ptr_gray<=0;
            empty<=1;
        end
        else begin
            rd_ptr_bin<=rd_ptr_bin_next;
            rd_ptr_gray<=rd_ptr_gray_next;
            empty<=empty_next;
        end
    
    end


endmodule