module top_spi_module(
    //common inputs
    input clk,
    input rst,
    input CPOL,
    input CPHA,

    //master-side inputs
    input [7:0] master_data_in,
    input start,
    //master outputs
    output cs_line,
    output sclk_line,
    output mosi_line,
    output master_tx_done,
    output [7:0] master_data_out,

    //slave side inputs
    input [7:0] slave_data_in,
    //slave outputs
    output [7:0] slave_data_out,
    output slave_rx_done,
    output miso_line
);

    spi_master_top_module spi_master(
        .clk(clk),
        .rst(rst),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .start(start),
        .data_in(master_data_in),
        .miso(miso_line),
        .cs_n(cs_line),
        .done_flag(master_tx_done),
        .sclk(sclk_line),
        .mosi(mosi_line),
        .data_out(master_data_out)
    );

    spi_slave_top spi_slave(
        .clk(clk),
        .rst(rst),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .tx_data(slave_data_in),
        .rx_data(slave_data_out),
        .rx_done(slave_rx_done),
        .CS(cs_line),
        .SCLK(sclk_line),
        .MOSI(mosi_line),
        .MISO(miso_line)
    );

endmodule