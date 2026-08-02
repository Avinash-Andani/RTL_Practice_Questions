module tb_vending_machine;
    reg clk,reset;
    reg [3:0] coin;
    wire dispense;

    vending_machine_FSM DUT(clk,reset,coin,dispense);
    initial begin
        clk=0;
        reset=0;
        coin=4'h0;
    end
    always #5 clk=~clk;
    initial begin
        #15 reset=1;
        #10 reset=0;

        #10 coin=4'h5;
        #10 coin=4'h5;
        #10 coin=4'h5;

        #50 $finish;
    end
    initial begin
        $dumpfile("vending_machine.vcd");
        $dumpvars(0,tb_vending_machine);
    end

endmodule