module vending_machine_FSM(
    input clk,
    input reset,
    input [3:0] coin,
    output reg  dispense
);
    reg [1:0] state,next_state;
    reg [3:0] collected_amt;

    localparam IDLE=2'b00,COLL_5=2'b01,COLL_10=2'b10,COLL_15=2'b11;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state<=IDLE;
            dispense<=0;
            collected_amt<=4'h0;
        end
        else state<=next_state;
    end

    always @(*) begin
        case(state)
            IDLE:begin
                if(coin==4'h5) next_state=COLL_5;
                else if(coin==4'ha) next_state=COLL_10;
                else next_state=IDLE;
            end
            COLL_5:begin
                if(coin==4'h5) next_state=COLL_10;
                else if(coin==4'ha) next_state=COLL_15;
                else next_state=COLL_5;
            end
            COLL_10:begin
                if(coin==4'h5) next_state=COLL_15;
                else if(coin==4'ha) next_state=COLL_15;
                else next_state=COLL_10;
            end
            COLL_15:begin
                next_state=IDLE;
            end
        endcase
    end

    always @(*) begin
        case(state)
            IDLE:begin
                dispense<=0;
                collected_amt<=4'h0;
            end
            COLL_5:begin
                dispense<=0;
                collected_amt<=4'h5;
            end
            COLL_10:begin
                dispense<=0;
                collected_amt<=4'ha;
            end
            COLL_15:begin
                collected_amt<=4'hf;
            end
            default:begin
                dispense<=0;
                collected_amt<=4'h0;
            end
        endcase
        dispense = (state == COLL_15);
    end

endmodule