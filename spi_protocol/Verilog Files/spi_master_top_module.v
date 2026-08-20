module spi_master_top_module(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [7:0] data_in,
    input  wire CPOL,
    input  wire CPHA,
    input  wire miso,           // FIXED: Added the missing MISO input pin!

    output wire cs_n,           // Updated name: Active-low Chip Select
    output wire done_flag,      // Updated name
    output wire sclk,
    output wire mosi,
    output wire [7:0] data_out
);

    // Internal wires connecting the Controller (Brain) to the Datapath (Muscle)
    wire load_en;
    wire shift_en;
    wire sample_en;

    // --- Instantiation of the Universal Datapath ---
    // Notice how we map the generic "serial" ports to the Master's specific pins
    universal_datapath Datapath_Inst (
        .clk(clk),
        .rst(rst),
        .tx_data_in(data_in),   // Direct connection, no 'Bus' wire needed
        .serial_in(miso),       // For a Master, serial_in is connected to MISO
        .ld_data(load_en),      
        .sft_data(shift_en),
        .sample_data(sample_en),
        .serial_out(mosi),      // For a Master, serial_out is connected to MOSI
        .rx_data_out(data_out)
    );

    // --- Instantiation of the Master Controller ---
    master_controller Controller_Inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .CPOL(CPOL),
        .CPHA(CPHA),
        .load_en(load_en),
        .shift_en(shift_en),
        .sample_en(sample_en),
        .cs_n(cs_n),            
        .done_flag(done_flag),
        .sclk_out(sclk)         
    );

endmodule