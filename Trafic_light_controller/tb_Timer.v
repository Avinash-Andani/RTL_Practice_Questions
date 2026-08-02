module tb_Timer;
    reg clk,reset,start;
    wire Timer_done;

    Timer DUT(clk,reset,start,Timer_done);
    initial begin
        clk=0;
        reset=0;
    end
    always #2 clk=~clk;
    initial begin
        #15 reset=1;
        #10 reset=0;
        #10 start=1;
        #10 start=0;
        #100 $finish;
    end
    initial begin
        $dumpfile("Timer.vcd");
        $dumpvars(0,tb_Timer);
    end
endmodule