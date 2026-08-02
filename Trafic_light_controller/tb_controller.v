module tb_controller;
    reg clk,reset;
    wire [1:0] Signal;

    controller_FSM DUT(clk,reset,Signal);
    initial begin
        clk=0;
        reset=0;
    end
    always #5 clk=~clk;
    initial begin
        #15 reset=1;
        #10 reset=0;
        #200 reset=1;
        #10 reset=0;
        #1000 $finish;
    end
    initial begin
        $dumpfile("controller_FSM.vcd");
        $dumpvars(0,tb_controller);
    end
endmodule