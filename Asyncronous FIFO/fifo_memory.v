module fifo_memory #(
    parameter ADDR_WIDTH=3,
    parameter DATA_WIDTH=8
)(
    input wr_clk,
    input rd_clk,
    input wr_en,
    input rd_en,
    input [ADDR_WIDTH-1:0] wr_addr,
    input [ADDR_WIDTH-1:0] rd_addr,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data
    );
    
    reg [DATA_WIDTH-1:0] FIFO [0:(1<<ADDR_WIDTH)-1];    
    
    always @(posedge wr_clk) begin
        if(wr_en) begin
            FIFO[wr_addr]<=wr_data;
        end 
    end
    
    always @(posedge rd_clk) begin
        if(rd_en) begin
             rd_data<=FIFO[rd_addr];
        end
    end
    
    
endmodule
