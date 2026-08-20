module universal_datapath(
    input clk,
    input rst,
    input [7:0] tx_data_in,
    input serial_in,     
    input ld_data,
    input sft_data,
    input sample_data,
    output serial_out,   
    output reg [7:0] rx_data_out
);

    reg [7:0] tx_reg;
    reg [7:0] rx_reg;

    // Output the Most Significant Bit (MSB) first
    assign serial_out = tx_reg[7]; 

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            tx_reg <= 8'h00;
            rx_reg <= 8'h00;
            rx_data_out <= 8'h00;
        end 
        else begin
            // Transmit Logic (Shift Out)
            if(ld_data) begin
                tx_reg <= tx_data_in;
            end 
            else if(sft_data) begin
                tx_reg <= {tx_reg[6:0], 1'b0};
            end

            // Receive Logic (Sample In)
            if(sample_data) begin
                rx_reg <= {rx_reg[6:0], serial_in};
                rx_data_out <= {rx_reg[6:0], serial_in}; // Expose to main system
            end
        end
    end
endmodule