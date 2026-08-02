module ALU_controller(
    input clk,input reset,
    input [18:0] instruction,
    input start,
    input [7:0] Zout,
    output [18:0] Bus,
    output ld_instn,
    output decode,
    output execute,
    output load_result
);
    localparam IDLE=3'h0,
               LOAD_INSTRUCTION=3'h1,
               DECODE=3'h2,
               EXECUTE=3'h3,
               WRITE_BACK=3'h4,
               DONE=3'h5;
     
    reg [2:0] state,next_state;
    
    assign Bus=instruction;
        
    assign ld_instn=(state==LOAD_INSTRUCTION)?1'b1:1'b0;
    assign decode=(state==DECODE)?1'b1:1'b0;
    assign execute=(state==EXECUTE)?1'b1:1'b0;
    assign load_result=(state==WRITE_BACK)?1'b1:1'b0;
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state<=IDLE;
            
        end
        else state<=next_state;
    end
    
    always @(*) begin
        next_state=state;
        case(state) 
            IDLE:begin
                if(start) next_state=LOAD_INSTRUCTION;
                else next_state=IDLE;
            end
            LOAD_INSTRUCTION:begin
   
               next_state=DECODE;
            end
            DECODE:begin
                next_state=EXECUTE;
            end
            EXECUTE:begin
                next_state=WRITE_BACK;
            end
            WRITE_BACK:begin
                next_state=DONE;
            end
            DONE:begin
      
                next_state=IDLE;
            end
            default:next_state=IDLE;
        endcase
    end
endmodule
