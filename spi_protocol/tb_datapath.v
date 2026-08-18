module tb_datapath;
    reg clk;
    reg rst;
    reg [7:0] Bus;
    reg MISO;
    reg ld_data;
    reg sft_data;
    reg sample_data;
    wire MOSI;
    wire [7:0] rx_register;

    datapath DUT(
        clk,
        rst,
        Bus,
        MOSI,
        ld_data,
        sft_data,
        sample_data,
        MOSI,
        rx_register
    );
    initial begin
        clk=0;
        rst=0;
        Bus=8'haa;
        MISO=0;
        ld_data=0;
        sft_data=0;
        sample_data=0;
    end
    always #5 clk=~clk;
    initial begin
        #15 rst=1;
        #10 rst=0;
        ld_data=1;
        
        #10;
        ld_data=0;
        sft_data=1;
        sample_data=1;

        #80;
        sft_data=0;
        sample_data=0;
    


        #100 $finish;

    end
    initial begin
        $dumpfile("datapath.vcd");
        $dumpvars(0,tb_datapath);
    end
endmodule