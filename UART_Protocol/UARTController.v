module UARTController(
    input clk,
    input reset,
    input start,
    input [1:0] mode,
    input busy,
    input Ready,
    input frame_error,
    output reg ld_data,
    output reg write,
    output reg tx_active,
    output reg rx_active
);
    localparam Idle=2'b00,
               Transmit=2'b01,
               Receive=2'b10,
               Full_duplex=2'b11;
    parameter IDLE=4'h0,
              LOAD_DATA=4'h1,
              START_TRANSMIT=4'h2,
              WAIT_TRANSMIT=4'h3,
              RECEIVE=4'h4,
              LOAD_FULL_DUPLEX=4'h5,
              START_FULL_DUPLEX=4'h6,
              WAIT_FULL_DUPLEX=4'h7,
              DONE=4'h8;
              
    reg [3:0] state,next_state;
    
    // state logic
    always @(posedge clk or posedge reset) begin
        if(reset) state<=IDLE;
        else state<=next_state;
    end
    
    //next_state logic
    always @(*) begin
        case(state) 
            IDLE:begin
                if(start) begin
                    case(mode) 
                        Idle:next_state=IDLE;
                        Transmit:next_state=LOAD_DATA;
                        Receive:next_state=RECEIVE;
                        Full_duplex:next_state=LOAD_FULL_DUPLEX;
                        default:next_state=IDLE;
                    endcase
                end
                else next_state=IDLE;
            end
            LOAD_DATA:begin
                next_state=START_TRANSMIT;
            end
            START_TRANSMIT:begin
                next_state=WAIT_TRANSMIT;
            end
            WAIT_TRANSMIT:begin
                if(!busy) next_state=DONE;
                else next_state=WAIT_TRANSMIT;
            end
            RECEIVE:begin
                if(Ready || frame_error) next_state=DONE;
                else next_state=RECEIVE;
            end
            LOAD_FULL_DUPLEX:begin
                next_state=START_FULL_DUPLEX;
            end
            START_FULL_DUPLEX:begin
                next_state=WAIT_FULL_DUPLEX;
            end
            WAIT_FULL_DUPLEX:begin
                if(!busy && (Ready||frame_error)) next_state=DONE;
                else next_state=WAIT_FULL_DUPLEX;
            end
            DONE:begin
                next_state=IDLE;
            end
            default:next_state=IDLE;
        endcase
    end
    
    //output logic
    always @(*) begin
                ld_data=0;
                write=0;
                tx_active=0;
                rx_active=0;
        case(state)
            LOAD_DATA:begin
                ld_data=1;
            end
            START_TRANSMIT:begin
                write=1;
                tx_active=1;
            end
            WAIT_TRANSMIT:begin
                tx_active=1;                
            end
            RECEIVE:begin
                rx_active=1;
            end
            LOAD_FULL_DUPLEX:begin
                ld_data=1;
            end
            START_FULL_DUPLEX:begin
                write=1;
                tx_active=1;
                rx_active=1;
            end
            WAIT_FULL_DUPLEX:begin
                tx_active=1;
                rx_active=1;
            end
        endcase
    end
    

endmodule