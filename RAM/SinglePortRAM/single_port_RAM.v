module single_port_RAM(
    input clk,
    input write,
    input read,
    input cs,
    input [9:0] addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] Memory[0:1023];
    always @(posedge clk) begin
        if(cs) begin
            if(write) Memory[addr]<=data_in;
            else if(read) data_out<=Memory[addr];
        end
        else begin
            data_out<=8'hxx;
        end
    end
endmodule