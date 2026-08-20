module tb_spi_top_module;
    reg clk,rst,CPOL,CPHA;
    reg [7:0] master_data_in,slave_data_in;
    reg start;

    wire cs_line,sclk_line,mosi_line,master_tx_done,slave_rx_done,miso_line;
    wire [7:0] slave_data_out;

    top_spi_module DUT(
        .clk(clk),
        .rst(rst),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .master_data_in(master_data_in),
        .slave_data_in(slave_data_in),
        .start(start),
        .cs_line(cs_line),
        .sclk_line(sclk_line),
        .mosi_line(mosi_line),
        .master_tx_done(master_tx_done),
        .slave_rx_done(slave_rx_done),
        .miso_line(miso_line),
        .slave_data_out(slave_data_out)
    );

    initial begin
        clk=0;
        rst=0;
        CPOL=0;
        CPHA=0;
        master_data_in=8'h0a;
        slave_data_in=8'h0b;
    end
    always #5 clk=~clk;
    initial begin
        #15 rst=1;
        #10 rst=0;
        #10;
        start=1;
        #10 start=0;

        #1200;
        $finish;
    end
    initial begin
        $dumpfile("spi_top_module.vcd");
        $dumpvars(0,tb_spi_top_module);
    end

endmodule