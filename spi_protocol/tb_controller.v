module tb_controller;
    reg clk,rst,start,CPOL,CPHA;
    reg [7:0] data_in;
    
    wire ld_data,sft_data,sample_data,CS,SCLK,Done;
    wire [7:0] Bus;

    controller DUT(
        clk,
        rst,
        data_in,
        start,CPOL,CPHA,
        ld_data,
        sft_data,
        sample_data,
        Bus,
        CS,
        Done,
        SCLK
    );
    initial begin
        clk=0;
        rst=0;
        start=0;
        data_in=8'h11;
    end
    always #5 clk=~clk;
    initial begin
        #15 rst=1;
        #10 rst=0;

        data_in=8'haa;

        #10;
        start=1;
        CPOL=0;
        CPHA=0;

        #10 ;
        start=0;
        #2000;
        $finish;

    end
    initial begin
        $dumpfile("controller.vcd");
        $dumpvars(0,tb_controller);
    end

endmodule