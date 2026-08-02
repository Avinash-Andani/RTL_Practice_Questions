module DualPortRAM(
    input clk,
    input write1,
    input read1,
    input [9:0] addr1,
    input [7:0] data_in1,
    input write2,
    input read2,
    input [9:0] addr2,
    input [7:0] data_in2,
    input cs,
    output reg [7:0] data_out1,
    output reg [7:0] data_out2
);
    reg [7:0] Memory[0:1023];
    always @(posedge clk) begin
        if(cs)begin
            if(write1)
                Memory[addr1]<=data_in1;
            else if(read1)
                data_out1<=Memory[addr1];
        end
    end
    always @(posedge clk) begin
        if(cs)begin
            if(write2)
                Memory[addr2]<=data_in2;
            else if(read2)
                data_out2<=Memory[addr2];
        end
    end

endmodule