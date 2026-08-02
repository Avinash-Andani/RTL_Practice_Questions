module UARTTransmitter(
    input clk,
    input reset,
    input write,
    input tx_clk_en,
    input [7:0] data_in,
    output reg tx,
    output busy
);
    localparam IDLE=1'b0,TRANSMIT=1'b1;
    reg state;
    reg [10:0] bit_frame;
    reg [3:0] counter;
    
    assign busy=(state==TRANSMIT);
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state<=IDLE;
            tx<= 1'b1;
            counter <= 4'h0;
        end
        else begin
            case(state)
                IDLE:begin
                    tx<=1'b1;
                    if(write) begin
                        bit_frame<={1'b1,(data_in),1'b0};
                        counter<=4'h0;
                        state<=TRANSMIT;
                    end
                    else state<=IDLE;
                end
                TRANSMIT:begin
                    if(tx_clk_en) begin
                        if(counter==4'd11) begin
                            state<=IDLE;
                        end
                        else begin
                            tx<=bit_frame[0];
                            bit_frame<={1'b1,bit_frame[10:1]};
                            counter<=counter+1;
                        end
                    end
                end
            endcase
            
        end
    end
endmodule