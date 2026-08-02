module BaudRateGenerator(
    input clk,
    input reset,
    input tx_active,
    input rx_active,
    output reg tx_clk_en,
    output reg rx_clk_en
    );
    parameter CLK_FREQ=100000000;
    parameter BAUD_RATE=9600;
    localparam TX_COUNTER_VALUE=(CLK_FREQ/(BAUD_RATE));
    localparam RX_COUNTER_VALUE=(CLK_FREQ/(BAUD_RATE*16));
    
    reg [$clog2(TX_COUNTER_VALUE)-1:0] tx_counter;
    reg [$clog2(RX_COUNTER_VALUE)-1:0] rx_counter;

   always @(posedge clk or posedge reset) begin
        if(reset)begin
            tx_counter<=0;
            tx_clk_en<=0;
        end
        else begin 
            if(tx_active) begin
                if(tx_counter== TX_COUNTER_VALUE-1) begin
                    tx_counter<=0;
                    tx_clk_en<=1;
                end 
                else begin
                    tx_counter<=tx_counter+1;
                    tx_clk_en<=0;
                end 
            end
            else begin
                tx_counter<=0;
                tx_clk_en<=0;
            end
       end
   end
   always @(posedge clk or posedge reset) begin
        if(reset)begin
            rx_counter<=0;
            rx_clk_en<=0;
        end
        else begin 
            if(rx_active) begin
                if(rx_counter== RX_COUNTER_VALUE-1) begin
                    rx_counter<=0;
                    rx_clk_en<=1;
                end 
                else begin
                    rx_counter<=rx_counter+1;
                    rx_clk_en<=0;
                end 
            end
            else begin
                rx_counter<=0;
                rx_clk_en<=0;
            end
       end
   end
endmodule
