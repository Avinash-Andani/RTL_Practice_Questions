`timescale 1ns / 1ps
module tb_async_FIFO;

    parameter ADDR_WIDTH = 3;
    parameter DATA_WIDTH = 8;

    reg wr_clk;
    reg rd_clk;
    reg wr_rst;
    reg rd_rst;

    reg wr_en;
    reg rd_en;

    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;

    wire full;
    wire empty;

    async_fifo_top #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .wr_clk(wr_clk),
        .wr_rst(wr_rst),
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    always #5 wr_clk = ~wr_clk;
    always #12 rd_clk = ~rd_clk;

    initial begin
        wr_clk  = 1'b0;
        rd_clk  = 1'b0;
        wr_rst  = 1'b1;
        rd_rst  = 1'b1;
        wr_en   = 1'b0;
        rd_en   = 1'b0;
        wr_data = 8'h00;
    end

    initial begin
        #20;
        wr_rst = 1'b0;
        rd_rst = 1'b0;
    end

    initial begin
        #25;

        @(posedge wr_clk);
        #1;
        wr_en   = 1'b1;
        wr_data = 8'h01;

        @(posedge wr_clk);
        #1;
        wr_data = 8'h02;

        @(posedge wr_clk);
        #1;
        wr_data = 8'h03;
        
        @(posedge wr_clk);
        #1;
        wr_data = 8'h04;
        
        @(posedge wr_clk);
        #1;
        wr_data = 8'h05;
        
        @(posedge wr_clk);
        #1;
        wr_data = 8'h06;
        
        @(posedge wr_clk);
        #1;
        wr_data = 8'h07;
        
        @(posedge wr_clk);
        #1;
        wr_data = 8'h08;
        
        @(posedge wr_clk);
        #1;
        wr_en = 1'b0;
    end

    initial begin
        #25;

        wait(empty == 1'b0);

        @(posedge rd_clk);
        #1;
        rd_en = 1'b1;

        @(posedge rd_clk);
        #1;
        rd_en = 1'b0;

        wait(empty == 1'b0);

        @(posedge rd_clk);
        #1;
        rd_en = 1'b1;

        @(posedge rd_clk);
        #1;
        rd_en = 1'b0;

        wait(empty == 1'b0);

        @(posedge rd_clk);
        #1;
        rd_en = 1'b1;

        @(posedge rd_clk);
        #1;
        rd_en = 1'b0;
    end

    initial begin
        #300;
        $finish;
    end

endmodule