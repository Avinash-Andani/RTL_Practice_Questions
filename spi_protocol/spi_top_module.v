module spi_top_module(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    input CPOL,
    input CPHA,
    output CS,
    output done,
    output SCLK,
    output MOSI,
    output [7:0] data_out
);
    wire [7:0] Bus;
    assign Bus=data_in;
    wire ld_data,sft_data,sample_data;
    

    //instatiation of datapath
    datapath B0(
        .clk(clk),
        .rst(rst),
        .Bus(Bus),
        .MISO(MISO),
        .ld_data(ld_data),
        .sft_data(sft_data),
        .sample_data(sample_data),
        .MOSI(MOSI),
        .rx_data_out(data_out)
    );

    //instatiation of controller
    controller  B1(
        .clk(clk),
        .rst(rst),
        .start(start),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .ld_data(ld_data),
        .sft_data(sft_data),
        .sample_data(sample_data),
        .CS(CS),
        .Done(done),
        .SCLK_line(SCLK)
    );




endmodule