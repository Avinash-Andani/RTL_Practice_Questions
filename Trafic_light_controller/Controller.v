module Timer(
    input clk,
    input reset,
    input start,
    output reg Timer_done
);
    reg running;
    parameter width=4;
    reg [width-1:0] counter;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            counter<={width{1'b0}};
            Timer_done<=0;
            running<=0;
        end
        else begin
            if(start && !running) begin
                running<=1;
                counter<={width{1'b0}};
                Timer_done<=0;
            end
            if(running) begin
                if(counter=={width{1'b1}})begin
                    counter<={width{1'b0}};
                    Timer_done<=1;
                    running<=0;
                end
                else begin
                    counter<=counter+1;
                    Timer_done<=0;
                end
            end
        end
    end
endmodule

module controller_FSM(
    input clk,
    input reset,
    output reg [1:0] Signal
);
    localparam RED =2'b00,GREEN=2'b01,YELLOW=2'b10;
    reg [1:0] state,next_state;
    wire timer_done;
    reg start;

    Timer T(clk,reset,start,timer_done);

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state<=2'b00;
            Signal<=2'b00;
        end
        else begin
            state<=next_state;
        end
    end
    always @(*) begin
        case(state)
            RED:begin
                if(timer_done) next_state=GREEN;
                else next_state=RED;
            end
            GREEN:begin
                if(timer_done) next_state=YELLOW;
                else next_state=GREEN;
            end
            YELLOW:begin
                if(timer_done) next_state=RED;
                else next_state=YELLOW;
            end
            default:begin
                next_state=RED;
            end
        endcase
    end
    always @(*) begin
        case(state)
            RED:begin
                start=1;
                Signal=RED;
            end
            GREEN:begin
                start=1;
                Signal=GREEN;
            end
            YELLOW:begin
                start=1;
                Signal=YELLOW;
            end
            default:begin
                start=0;
                Signal=RED;
            end
        endcase
    end
endmodule