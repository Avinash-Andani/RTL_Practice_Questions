module UARTReceiver(
    input        clk,
    input        reset,
    input        rx_clk_en,   
    input        Rx,
    output reg   Ready,   
    output reg   frame_error,
    output reg [7:0] data
);

    localparam IDLE  = 2'b00,
               START = 2'b01,
               DATA  = 2'b10,
               STOP  = 2'b11;

    reg [1:0] state, next_state;

    reg rx_ff1, rx_sync, rx_sync_prev;

    always @(posedge clk) begin
        rx_ff1  <= Rx;
        rx_sync <= rx_ff1;
    end

    always @(posedge clk) begin
        rx_sync_prev <= rx_sync;
    end

    wire start_edge = rx_sync_prev & ~rx_sync;

    reg [3:0] samp_counter;  
    reg [3:0] bit_counter;   
    reg [7:0] shift_reg;
    reg       start_confirmed; 


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            samp_counter <= 4'd0;
            bit_counter  <= 4'd0;
            shift_reg    <= 8'd0;
            data         <= 8'd0;
            Ready        <= 1'b0;
            frame_error  <= 1'b0;
            start_confirmed <= 1'b0;
        end
        else begin
            state <= next_state;
            Ready <= 1'b0;

            case (state)

                IDLE: begin
                    if (start_edge)
                        samp_counter <= 4'd0; 
                end

                START: begin
                    if (rx_clk_en) begin
                        if (samp_counter == 4'd8) begin
                            
                            start_confirmed <= ~rx_sync;
                            samp_counter <= samp_counter + 4'd1;
                        end
                        else if (samp_counter == 4'd15) begin
                            samp_counter <= 4'd0;   
                            bit_counter  <= 4'd0;   
                        end
                        else
                            samp_counter <= samp_counter + 4'd1;
                    end
                end

                DATA: begin
                    if (rx_clk_en) begin
                        if (samp_counter == 4'd8) begin
                            
                            shift_reg <= {rx_sync, shift_reg[7:1]};
                            samp_counter <= samp_counter + 4'd1;
                        end
                        else if (samp_counter == 4'd15) begin
                            samp_counter <= 4'd0;
                            bit_counter  <= bit_counter + 4'd1;
                        end
                        else
                            samp_counter <= samp_counter + 4'd1;
                    end
                end
                STOP: begin
                    if (rx_clk_en) begin
                        if (samp_counter == 4'd8) begin
                            if (rx_sync) begin
                                data        <= shift_reg;
                                Ready       <= 1'b1;  
                                frame_error <= 1'b0;
                            end
                            else begin
                                frame_error <= 1'b1;   
                            end
                            samp_counter <= samp_counter + 4'd1;
                        end
                        else if (samp_counter == 4'd15) begin
                            samp_counter <= 4'd0;
                        end
                        else
                            samp_counter <= samp_counter + 4'd1;
                    end
                end

                default: ; 

            endcase
        end
    end

   
    always @(*) begin
        next_state = state; 

        case (state)

            IDLE: begin
                if (start_edge)
                    next_state = START;
            end

            START: begin
                
                if (rx_clk_en && samp_counter == 4'd15)
                    next_state = start_confirmed ? DATA : IDLE;
            end

            DATA: begin
                if (rx_clk_en && samp_counter == 4'd15 && bit_counter == 4'd7)
                    next_state = STOP;
            end

            STOP: begin
                if (rx_clk_en && samp_counter == 4'd15)
                    next_state = IDLE;
            end

            default: next_state = IDLE;

        endcase
    end

endmodule
