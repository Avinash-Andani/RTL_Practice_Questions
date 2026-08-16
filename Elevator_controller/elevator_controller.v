//////////////////////////////////////////////////////////////////////////////////

// Create Date: 16.08.2026 15:36:39
// Design Name: Elevator Controller FSM Design
// Module Name: elevator_controller
// Project Name: Elevator Controller

// Description: 
// This project implements a Finite State Machine (FSM) based Elevator Controller using Verilog HDL. 
// The controller compares the requested floor with the current floor and moves the elevator upward or downward. 
// After reaching the requested floor, it opens the door for one clock cycle and returns to the IDLE state.

//////////////////////////////////////////////////////////////////////////////////
module elevator_controller(
    input clk,
    input reset,
    input [2:0] request_floor,
    output reg [2:0] current_floor,
    output reg motor_up,
    output reg motor_down,
    output reg door_open
);
   localparam IDLE = 2'b00,
               MOVE_UP = 2'b01,
               MOVE_DOWN = 2'b10,
               OPEN_DOOR = 2'b11;
   
    reg [1:0] state;
    
    always @(posedge clk or posedge reset)begin
        if(reset)begin
            state <= IDLE;
            current_floor <= 2'd0;
            motor_up <= 0;
            motor_down <= 0;
            door_open<= 0;
       end
       else begin
          case(state)
                IDLE:begin
                    motor_up <= 0;
                    motor_down <= 0;
                    door_open <= 0;
                    if(request_floor > current_floor) state <= MOVE_UP;
                    else if(request_floor < current_floor) state <= MOVE_DOWN;
                end
                MOVE_UP:begin 
                    motor_up <= 1;
                    motor_down <= 0;
                    door_open <= 0;
                    current_floor <= current_floor + 1;
                    if(current_floor + 1 == request_floor) state <= OPEN_DOOR;
               end
               MOVE_DOWN:begin 
                    motor_up <= 0;
                    motor_down <= 1;
                    door_open <= 0;
                    current_floor <= current_floor - 1;
                    if(current_floor -1 == request_floor)state <= OPEN_DOOR;
               end
               OPEN_DOOR:begin
                    motor_up<= 0;
                    motor_down <= 0;
                    door_open <= 1;
                    state <= IDLE;
               end
           endcase
        end
     end
 endmodule
    
