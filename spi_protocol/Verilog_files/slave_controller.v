module slave_controller(
    input clk,          // Fast internal FPGA sys_clk
    input rst,
    input CPOL,
    input CPHA,
    
    // Asynchronous physical pins
    input CS_pin,       
    input SCLK_pin,     
    
    // Outputs to the Datapath
    output reg ld_data,
    output reg sft_data,
    output reg sample_data,
    
    // Outputs to the Top Module
    output reg Done,
    output safe_CS_out  // Sent to top module to control MISO Tri-State
);

    // --- 1. The 2-Flop Synchronizers ---
    reg [1:0] cs_sync;
    reg [1:0] sclk_sync;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cs_sync   <= 2'b11; // Default CS is HIGH (idle)
            sclk_sync <= 2'b00; // Default SCLK assumes 0 (will adapt)
        end else begin
            cs_sync   <= {cs_sync[0], CS_pin};
            sclk_sync <= {sclk_sync[0], SCLK_pin};
        end
    end

    wire safe_CS   = cs_sync[1];
    wire safe_sclk = sclk_sync[1];
    assign safe_CS_out = safe_CS;

    // --- 2. The Edge Detectors ---
    reg prev_cs;
    reg prev_sclk;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            prev_cs   <= 1'b1;
            prev_sclk <= 1'b0;
        end else begin
            prev_cs   <= safe_CS;
            prev_sclk <= safe_sclk;
        end
    end

    // 1-tick pulses for the FSM to watch
    wire cs_falling_edge = prev_cs & ~safe_CS;
    wire sclk_rising     = ~prev_sclk & safe_sclk;
    wire sclk_falling    = prev_sclk & ~safe_sclk;

    // --- 3. The Boolean Edge Router (CPOL/CPHA) ---
    wire rule_A = (CPOL == CPHA);
    wire do_sample = rule_A ? sclk_rising : sclk_falling;
    wire do_shift  = rule_A ? sclk_falling : sclk_rising;

    // --- 4. The FSM ---
    localparam IDLE     = 2'b00,
               START    = 2'b01,
               TRANSFER = 2'b10,
               DONE     = 2'b11;
               
    reg [1:0] state, next_state;
    reg [3:0] bit_counter;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            bit_counter <= 0;
            ld_data <= 0;
            sft_data <= 0;
            sample_data <= 0;
            Done <= 0;
        end 
        else if (safe_CS == 1'b1) begin
            // Asynchronous reset for the transaction if CS goes high
            state <= IDLE;
            bit_counter <= 0;
            ld_data <= 0;
            sft_data <= 0;
            sample_data <= 0;
            Done <= 0;
        end 
        else begin
            state <= next_state;
            
            // Default datapath controls to 0 to create 1-tick pulses
            ld_data <= 0;
            sft_data <= 0;
            sample_data <= 0;
            Done <= 0;

            case(state)
                IDLE: begin
                    bit_counter <= 0;
                end
                
                START: begin
                    ld_data <= 1; // Pulse load to grab FPGA data
                end
                
                TRANSFER: begin
                    if (do_sample) begin
                        sample_data <= 1;
                        bit_counter <= bit_counter + 1;
                    end
                    if (do_shift) begin
                        sft_data <= 1;
                    end
                end
                
                DONE: begin
                    Done <= 1; // Pulse Done flag
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE:     if(cs_falling_edge) next_state = START;
            START:    next_state = TRANSFER;
            TRANSFER: if(bit_counter == 4'h8) next_state = DONE;
            DONE:     next_state = IDLE;
        endcase
    end

endmodule