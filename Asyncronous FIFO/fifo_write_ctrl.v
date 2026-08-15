module fifo_write_ctrl #(
    parameter ADDR_WIDTH = 3
)(
    input  wr_clk,
    input  wr_rst,
    input  wr_en,

    input  [ADDR_WIDTH:0] rd_ptr_gray_sync,

    output [ADDR_WIDTH-1:0] wr_addr,
    output reg [ADDR_WIDTH:0] wr_ptr_gray,
    output reg full
);
    reg [ADDR_WIDTH:0] wr_ptr_bin;
    reg [ADDR_WIDTH:0] wr_ptr_bin_next;
    reg [ADDR_WIDTH:0] wr_ptr_gray_next;
    reg full_next;


    assign wr_addr = wr_ptr_bin[ADDR_WIDTH-1:0];


    always @(*) begin
        wr_ptr_bin_next = wr_ptr_bin;
        if (wr_en && !full)
            wr_ptr_bin_next = wr_ptr_bin + 1'b1;
        wr_ptr_gray_next =
            (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;
        full_next =(wr_ptr_gray_next =={~rd_ptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1],rd_ptr_gray_sync[ADDR_WIDTH-2:0]});

    end

    always @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
            full        <= 1'b0;    
                    
        end
        else begin
            wr_ptr_bin  <= wr_ptr_bin_next;
            wr_ptr_gray <= wr_ptr_gray_next;
            full        <= full_next;
        end
    end
endmodule