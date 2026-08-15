module Booth_multiplier(
    input clk,
    input reset,
    input [3:0] Multiplicand_M,
    input [3:0] Multiplier_Q,
    input start,
    output reg [7:0] Result // Expanded to 8 bits to fit product
);
    reg [3:0] Accumulator;
    reg Q_1;
    reg [3:0] Q, M;
    reg [2:0] counter;
    
    localparam IDLE            = 3'h0,
               LOAD_A_M_Q      = 3'h1,
               CHECK_Q         = 3'h2,
               ADD             = 3'h3,
               SUB             = 3'h4,
               RIGHT_SHIFT     = 3'h5,
               COUNTER_REACHED = 3'h6;
               
    reg [2:0] state, next_state;
    
    // 1. Next State Logic (Combinational)
    always @(*) begin
        case(state) 
            IDLE: begin
                if(start) next_state = LOAD_A_M_Q;
                else      next_state = IDLE;
            end
            LOAD_A_M_Q: begin
                next_state = CHECK_Q;
            end
            CHECK_Q: begin
                case({Q[0], Q_1})
                    2'b00, 2'b11: next_state = RIGHT_SHIFT;
                    2'b01:        next_state = ADD;
                    2'b10:        next_state = SUB;
                    default:      next_state = CHECK_Q;
                endcase
            end
            ADD: begin
                next_state = RIGHT_SHIFT;
            end
            SUB: begin
                next_state = RIGHT_SHIFT;
            end
            RIGHT_SHIFT: begin
                if(counter == 3'd3) begin // 4 iterations (0, 1, 2, 3)
                     next_state = COUNTER_REACHED;
                end
                else begin
                    next_state = CHECK_Q;
                end
            end
            COUNTER_REACHED: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
    
    // 2. Sequential Logic (State Updates & Data Path)
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state       <= IDLE;
            Accumulator <= 4'h0;
            Q           <= 4'h0;
            M           <= 4'h0;
            Q_1         <= 1'b0;
            counter     <= 3'h0;
            Result      <= 8'h0;
        end
        else begin
            state <= next_state; // Advance state
            
            case(state)
                IDLE: begin
                    // Wait for start
                end
                LOAD_A_M_Q: begin
                    Accumulator <= 4'h0;
                    Q           <= Multiplier_Q;
                    M           <= Multiplicand_M;
                    Q_1         <= 1'b0; // Corrected initial value
                    counter     <= 3'h0;
                end
                ADD: begin
                    Accumulator <= Accumulator + M;
                end
                SUB: begin
                    Accumulator <= Accumulator - M; // Simplified syntax
                end
                RIGHT_SHIFT: begin
                    // Arithmetic right shift preserving the sign bit
                    {Accumulator, Q, Q_1} <= {Accumulator[3], Accumulator, Q};
                    counter               <= counter + 1'b1;
                end
                COUNTER_REACHED: begin
                    Result <= {Accumulator, Q}; // Combine into final 8-bit result
                end
            endcase
        end
    end

endmodule
