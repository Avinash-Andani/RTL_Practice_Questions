module spi_slave_top(
    input clk,            // sys_clk
    input rst,
    
    // SPI Configuration
    input CPOL,
    input CPHA,
    
    // FPGA System Interface
    input [7:0] tx_data,  // Data you want the slave to send to master
    output [7:0] rx_data, // Data the slave received from master
    output rx_done,       // Pulses high when rx_data is valid
    
    // Physical SPI Pins
    input CS,
    input SCLK,
    input MOSI,
    output MISO           // Note: Must be type 'wire' for Tri-State
);

    // --- Internal Wires ---
    wire internal_ld, internal_sft, internal_smp;
    wire safe_CS_internal;
    wire serial_out_wire;

    // --- MOSI Synchronizer ---
    // MOSI must also be synchronized to avoid metastability in the datapath
    reg [1:0] mosi_sync;
    always @(posedge clk or posedge rst) begin
        if(rst) mosi_sync <= 2'b00;
        else    mosi_sync <= {mosi_sync[0], MOSI};
    end
    wire safe_MOSI = mosi_sync[1];

    // --- Tri-State MISO Buffer ---
    // If CS is low (active), drive the wire. If high, disconnect (High-Z).
    assign MISO = (safe_CS_internal == 1'b0) ? serial_out_wire : 1'bz;

    // --- Instantiations ---
    universal_datapath Datapath_Inst (
        .clk(clk),
        .rst(rst),
        .tx_data_in(tx_data),
        .serial_in(safe_MOSI),      // Safe MOSI feeds the shift register
        .ld_data(internal_ld),
        .sft_data(internal_sft),
        .sample_data(internal_smp),
        .serial_out(serial_out_wire),// Feeds the Tri-State buffer
        .rx_data_out(rx_data)
    );

    slave_controller Controller_Inst(
        .clk(clk),
        .rst(rst),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .CS_pin(CS),
        .SCLK_pin(SCLK),
        .ld_data(internal_ld),
        .sft_data(internal_sft),
        .sample_data(internal_smp),
        .Done(rx_done),
        .safe_CS_out(safe_CS_internal) // Feeds the Tri-State buffer
    );

endmodule