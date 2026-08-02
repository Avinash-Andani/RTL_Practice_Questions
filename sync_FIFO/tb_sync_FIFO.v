module tb_sync_FIFO;
    parameter width=8;
    parameter depth=15;
    reg clk;
    reg reset;
    reg cs;
    reg write;
    reg read;
    reg [width-1:0] write_data;
    wire  [width-1:0] data_read;
    wire full;
    wire empty;

    sync_FIFO DUT(clk,reset,cs,write,read,write_data,data_read,full,empty);

    initial begin
        clk=0;
        reset=0;
        write=0;
        read=0;
    end
    always #5 clk=~clk;
    initial begin
        #15 reset=1;
        #10 reset=0;
        #10 cs=1;
        #10 write=1;
        #10 write_data=8'h00;
        #10 write_data=8'h01;
        #10 write_data=8'h02;
        #10 write_data=8'h03;
        #10 write_data=8'h04;
        #10 write_data=8'h05;
        #10 write_data=8'h06;
        #10 write_data=8'h07;

        #10 write=0;

        #10 read=1;
        #10 read=0;

    end
    initial begin
        $dumpfile("sync_FIFO.vcd");
        $dumpvars(0,tb_sync_FIFO);
    end



endmodule