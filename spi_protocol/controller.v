module controller(
    input clk,
    input rst,
    input start,
    input CPOL,
    input CPHA,

    output reg ld_data,
    output reg sft_data,
    output reg sample_data,
    output reg CS,
    output reg Done,
    output SCLK_line
);
    // clock edge generator//
    reg edge_counter_start;
    reg [3:0] edge_counter;
    reg toggle;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            edge_counter <= 0;
            toggle <= 0;
        end
        else if (state == IDLE) begin 
            toggle <= 0;
        end
        else begin
            if(edge_counter == 4'h5) begin
                edge_counter <= 0;
                toggle <= 1;
            end
            else begin
                edge_counter <= edge_counter + 1;
                toggle <= 0;
            end
        end
    end
    
    // SCLK generator
    reg SCLK;
    assign SCLK_line=SCLK;
    always @(posedge clk or rst) begin
        if(rst) begin
            SCLK<=CPOL;
        end
        else begin
            if(toggle) begin
                SCLK<=~SCLK;
            end
        end
    end

    // 16 SCLK cycle counter
    reg [3:0] SCLK_counter;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            SCLK_counter <= 0;
        end
        else if (toggle) begin // ONLY count when the metronome ticks!
            if(SCLK_counter == 4'hF) // (See Bug 3)
                SCLK_counter <= 0;
            else 
                SCLK_counter <= SCLK_counter + 1;
        end
    end

    // FSM to controller
    localparam IDLE = 2'b00,
                START=2'b01,
                TRANSFER=2'b10,
                DONE=2'b11;
    
    reg [1:0] state,next_state;
    wire even=~SCLK_counter[0];
    wire odd=SCLK_counter[0];


    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state<=IDLE;
            CS<=1;
            ld_data<=0;
            sft_data<=0;
            sample_data<=0;
            Done<=0;
            edge_counter_start<=0;
            SCLK<=CPOL;
        end
        else begin
            state<=next_state;
            case(state) 
                IDLE:begin
                    CS<=1;
                    ld_data<=0;
                    sft_data<=0;
                    sample_data<=0;
                    Done<=0;
                    SCLK<=CPOL;
                end
                START:begin
                    CS<=0;
                    ld_data<=1;
                    sft_data<=0;
                    sample_data<=0;
                end
                TRANSFER:begin
                    ld_data<=0;
                    sample_data<=0;
                    sft_data<=0;
                    edge_counter_start<=1;
                    if(toggle) begin
                        if(CPHA==0) begin
                            if(even) begin
                                sample_data<=1;
                                sft_data<=0;
                            end
                            if(odd) begin
                                sample_data<=0;
                                sft_data<=1;
                            end
                        end
                        if(CPHA==1) begin
                            if(even) begin
                                sample_data<=0;
                                sft_data<=1;
                            end
                            if(odd) begin
                                sample_data<=1;
                                sft_data<=0;
                            end
                        end
                    end
                end
                DONE:begin
                    CS<=1;
                    ld_data<=0;
                    sft_data<=0;
                    sample_data<=0;
                    Done<=1;
                end
            endcase
        end
    end
    always @(*) begin
        case(state) 
            IDLE:begin
                if(start) next_state=START;
                else next_state=IDLE;
            end
            START:begin
                next_state=TRANSFER;
            end
            TRANSFER:begin
                if(SCLK_counter==4'hf && toggle) begin
                    next_state=DONE;
                end
                else next_state=TRANSFER; 
            end
            DONE:begin
                next_state=IDLE;
            end
        endcase
    end
endmodule