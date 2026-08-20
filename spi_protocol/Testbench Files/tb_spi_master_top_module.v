module tb_top_module;
    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    reg CPOL;
    reg CPHA;
    wire CS;
    wire done;
    wire SCLK;
    wire MOSI;
    wire [7:0] data_out;

    spi_top_module DUT(
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .CS(CS),
        .done(done),
        .SCLK(SCLK),
        .MOSI(MOSI),
        .data_out(data_out)
    );

    initial begin
        clk=0;
        rst=0;
        data_in=8'h1a;
        CPOL=0;
        CPHA=1;
        start=0;
    end
    always #5 clk=~clk;
    initial begin
        #15 rst=1;
        #10 rst=0;

        #10 start=1;
        #10 start=0;

        #1200;
        $finish;
    end
    initial begin
        $dumpfile("top_module.vcd");
        $dumpvars(0,tb_top_module);
    end


endmodule