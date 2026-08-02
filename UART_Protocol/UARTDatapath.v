module UARTDatapath(
    input clk,
    input reset,
    input [7:0] Bus,
    input tx_active,
    input rx_active,
    input write,
    input ld_data,
    input Rx,
    output busy,
    output  Ready,
    output frame_error,
    output Tx,
    output [7:0] data_out
    );
    
    wire tx_clk_en,rx_clk_en;
    reg [7:0] data_in;
    
    //Instantiation of Baud rate Generator
    BaudRateGenerator#(.CLK_FREQ(640),.BAUD_RATE(10)) Generator(clk,reset,tx_active,rx_active,tx_clk_en,rx_clk_en);
    
    //Instantiation of the UART TRANSMITTER
    UARTTransmitter Transmitter(clk,reset,write,tx_clk_en,data_in,Tx,busy);
    
    //Instantiation of UART Receiver
    UARTReceiver Receiver(clk,reset,rx_clk_en,Rx,Ready,frame_error,data_out);
    
    always @(posedge clk or posedge reset) begin 
        if(reset) begin
            data_in<=8'h00;
        end
        else if(ld_data) begin
            data_in<=Bus;
        end
    end
endmodule
