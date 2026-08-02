`timescale 1ns / 1ps
module tb_BaudRateGenerator;
    reg clk,reset,tx_active,rx_active;
    wire tx_clk_en,rx_clk_en;
    
    BaudRateGenerator#(.CLK_FREQ(640),.BAUD_RATE(10))DUT(clk,reset,tx_active,rx_active,tx_clk_en,rx_clk_en);
    
    initial begin
        clk=0;
        reset=0;
        tx_active=0;
        rx_active=0;
    end
    always #5 clk=~clk;
    initial begin
        #15;
        tx_active=1;
        rx_active=1;
        
        #1000;
        $finish;
    end
    
endmodule
