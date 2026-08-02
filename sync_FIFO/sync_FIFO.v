module sync_FIFO#(
    parameter width=8,
    parameter depth=16
)(
    input clk,
    input reset,
    input cs,
    input write_en,
    input read_en,
    input [width-1:0] data_in,
    output reg [width-1:0] data_out,
    output  full,
    output  empty
);
    reg [width-1:0] RegFile[0:depth-1];
    reg [($clog2(depth)):0] wr_pt,rd_pt;

    integer k;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            for(k=0;k<depth;k=k+1)begin
                RegFile[k]<=0;
            end
            wr_pt<=0;
            rd_pt<=0;
            data_out<=0;
        end
        else begin
            if(cs) begin
                if(write_en && !full)begin
                    RegFile[wr_pt]<=data_in;
                    wr_pt<=wr_pt+1'b1;
                end
                else if(read_en && !empty)begin
                    data_out<=RegFile[rd_pt];
                    rd_pt<=rd_pt+1'b1;
                end
            end
        end
    end
    assign full=(rd_pt=={~wr_pt[4],wr_pt[3:0]});
    assign empty=(rd_pt==rd_pt);

endmodule