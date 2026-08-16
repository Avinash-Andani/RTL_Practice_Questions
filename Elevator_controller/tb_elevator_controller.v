`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 16.08.2026 15:36:39
// Design Name: Elevator Controller FSM Design
// Module Name: tb_elevator_controller
// Project Name: Elevator Controller

// Description: 
// This project implements a Finite State Machine (FSM) based Elevator Controller using Verilog HDL. 
// The controller compares the requested floor with the current floor and moves the elevator upward or downward. 
// After reaching the requested floor, it opens the door for one clock cycle and returns to the IDLE state.

//////////////////////////////////////////////////////////////////////////////////
module tb_elevator_controller;
    reg clk;
    reg reset;
    reg [2:0] request_floor;

    wire [2:0] current_floor;
    wire motor_up;
    wire motor_down;
    wire door_open;

    elevator_controller DUT (
        clk,
        reset,
        request_floor,
        current_floor,
        motor_up,
        motor_down,
        door_open
    );

    always #5 clk = ~clk;

    initial
    begin
        clk = 0;
        reset = 1;
        request_floor = 2'd0;

        // Apply Reset
        #20;
        reset = 0;

        #20;
        request_floor = 2'd3;

        #60;
        request_floor = 2'd1;

        #50;

        request_floor = 2'd0;

        #40;

        request_floor = 3'd4;

        #100;

        #20;
        $finish;
    end

    initial
    begin
        $monitor(
            "Time=%0t | Req=%0d | Current=%0d | UP=%b | DOWN=%b | DOOR=%b",
            $time,
            request_floor,
            current_floor,
            motor_up,
            motor_down,
            door_open
        );
    end

endmodule