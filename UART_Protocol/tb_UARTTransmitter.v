`timescale 1ns / 1ps
module tb_UARTTransmitter;
    reg clk,reset,tx_active,rx_active;
    reg write;
    reg [7:0] data_in;
    wire tx_clk_en,rx_clk_en;
    wire tx,busy;

    BaudRateGenerator#(.CLK_FREQ(160),.BAUD_RATE(10)) Generate(clk,reset,tx_active,rx_active,tx_clk_en,rx_clk_en);
    
    UARTTransmitter DUT(clk,reset,write,tx_clk_en,data_in,tx,busy);
    
    initial begin
        clk=0;
        reset=0;
        tx_active=0;
        rx_active=0;
        write=0;
    end
    always #5 clk=~clk;
    initial begin
        #15 reset=1;
        #10 reset=0;
        tx_active=1;
        #10 data_in=8'h1a;
        #10 write=1;
        #10 write=0;
        
        #2000 $finish;
    
    end
    
endmodule
