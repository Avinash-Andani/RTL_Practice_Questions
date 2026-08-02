module SinglePortRAM;
    reg clk,write,read,cs;
    reg [9:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;
    integer k;

    single_port_RAM DUT(clk,write,read,cs,addr,data_in,data_out);
    initial begin
        clk=0;
        read=0;
        cs=1;
    end
    always #5 clk=~clk;
    initial begin
        write=1;
        addr=10'h000;
        data_in=8'h10;
        #10 write=0;
        read=1;
        addr=10'h000;
        #50 $finish;
    end
    initial begin
        $dumpfile("SinglePortRAM.vcd");
        $dumpvars(0,SinglePortRAM);
    end
endmodule