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