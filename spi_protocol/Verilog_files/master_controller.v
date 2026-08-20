module master_controller(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire CPOL,
    input  wire CPHA,

    // Datapath Control Pulses
    output reg  load_en,
    output reg  shift_en,
    output reg  sample_en,
    
    // External SPI & System Signals
    output reg  cs_n,       // _n indicates Active-Low
    output reg  done_flag,
    output wire sclk_out
);

    // --- FSM State Definitions ---
    localparam IDLE     = 2'b00,
            START    = 2'b01,
            TRANSFER = 2'b10,
            DONE     = 2'b11;
            
    reg [1:0] state, next_state;

    // --- 1. The Metronome (Baud Rate Generator) ---
    reg [3:0] baud_counter;
    reg sclk_tick; // Replaces 'toggle' to be more descriptive

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            baud_counter <= 0;
            sclk_tick    <= 0;
        end
        else if (state == IDLE || state == DONE) begin 
            baud_counter <= 0;
            sclk_tick    <= 0;
        end
        else begin
            if(baud_counter == 4'h5) begin // Adjust for desired SPI speed
                baud_counter <= 0;
                sclk_tick    <= 1; // 1-tick pulse
            end
            else begin
                baud_counter <= baud_counter + 1;
                sclk_tick    <= 0;
            end
        end
    end
    
    // --- 2. 16-Edge Tracker ---
    reg [3:0] edge_count;
    wire even_edge = ~edge_count[0];
    wire odd_edge  =  edge_count[0];

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            edge_count <= 0;
        end
        else if (state == IDLE || state == DONE) begin
            edge_count <= 0; 
        end
        else if (sclk_tick) begin // Only count when metronome ticks
            if(edge_count == 4'hF) 
                edge_count <= 0;
            else 
                edge_count <= edge_count + 1;
        end
    end

    // --- 3. SCLK Generator (Fixed Multiple Driver Bug) ---
    reg internal_sclk;
    assign sclk_out = internal_sclk;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            internal_sclk <= CPOL;
        end
        else if (state == IDLE || state == DONE) begin
            internal_sclk <= CPOL; // Safely forces SCLK to idle state here
        end
        else if (state == TRANSFER && sclk_tick) begin
            internal_sclk <= ~internal_sclk; // Flip SCLK on every tick
        end
    end

    // --- 4. FSM Sequential Logic ---
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state       <= IDLE;
            cs_n        <= 1;
            load_en     <= 0;
            shift_en    <= 0;
            sample_en   <= 0;
            done_flag   <= 0;
        end
        else begin
            state <= next_state;
            
            // Default outputs to 0
            load_en   <= 0;
            shift_en  <= 0;
            sample_en <= 0;
            done_flag <= 0;
            
            case(state) 
                IDLE: begin
                    cs_n <= 1; // Sleep
                end
                
                START: begin
                    cs_n    <= 0; // Wake up slave
                    load_en <= 1; // Load data into datapath
                end
                
                TRANSFER: begin
                    cs_n <= 0; // Keep chip select active
                    
                    if(sclk_tick) begin
                        if(CPHA == 0) begin
                            if(even_edge) sample_en <= 1;
                            if(odd_edge)  shift_en  <= 1;
                        end
                        else if(CPHA == 1) begin
                            if(even_edge) shift_en  <= 1;
                            if(odd_edge)  sample_en <= 1;
                        end
                    end
                end
                
                DONE: begin
                    cs_n      <= 1; // Deselect slave
                    done_flag <= 1; // Alert main system
                end
            endcase
        end
    end

    // --- 5. FSM Next-State Logic ---
    always @(*) begin
        next_state = state; 
        
        case(state) 
            IDLE: begin
                if(start) next_state = START;
            end
            START: begin
                next_state = TRANSFER;
            end
            TRANSFER: begin
                // Wait for the 15th edge AND the final metronome tick to complete it
                if(edge_count == 4'hF && sclk_tick) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule