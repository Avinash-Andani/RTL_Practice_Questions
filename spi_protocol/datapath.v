module datapath(
    input clk,
    input rst,
    input [7:0] Bus,
    input MISO,
    input ld_data,
    input sft_data,
    input sample_data,
    output  MOSI,
    output [7:0] rx_data_out
);
    reg [7:0] tx_register,rx_register;

    assign MOSI=tx_register[0];
    assign rx_data_out=rx_register;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            tx_register<=8'h00;
            rx_register<=8'h00;
        end
        else begin
            if(ld_data)begin
                tx_register<=Bus;
            end 
            else if(sft_data) begin
                tx_register<={tx_register[7],tx_register[7:1]};
            end

            if(sample_data) begin
                rx_register <= {rx_register[6:0], MISO};
            end
        end
    end

endmodule