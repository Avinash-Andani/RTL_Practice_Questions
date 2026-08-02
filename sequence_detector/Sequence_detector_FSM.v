module seq_detector(
    input clk,
    input reset,
    input input_bit,
    output reg detected,
    output reg [1:0] CurrState
);
    reg [1:0] state,next_state;
    localparam S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state<=S0;
            detected<=0;
        end 
        else state<=next_state;
    end

    always @(*) begin
        case(state)
            S0:begin
                if(input_bit) next_state=S1;
                else next_state=S0;
            end
            S1:begin
                if(input_bit) next_state=S1;
                else next_state=S2;
            end
            S2:begin
                if(input_bit) next_state=S3;
                else next_state=S0;
            end
            S3:begin
                if(input_bit) next_state=S1;
                else next_state=S2;
            end
            default:next_state=S0;
        endcase
    end

    always @(*) begin
        if(state==S3 && input_bit==1'b1) detected=1;
        else detected=0;
        CurrState=state;
    end

endmodule