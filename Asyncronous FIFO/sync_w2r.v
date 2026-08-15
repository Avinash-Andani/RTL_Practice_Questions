module sync_register #(
    parameter PTR_WIDTH=3
)(
    input clk,
    input rst,
    input [PTR_WIDTH:0] ptr_gray,
    output [PTR_WIDTH:0] ptr_gray_sync
);
    reg [PTR_WIDTH:0] sync_FF1,sync_FF2;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            sync_FF1<=0;
            sync_FF2<=0;
        end
        else begin
            sync_FF1<=ptr_gray;
            sync_FF2<=sync_FF1;
        end
    end
    assign ptr_gray_sync=sync_FF2;

endmodule