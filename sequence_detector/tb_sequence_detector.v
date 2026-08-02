module tb_sequence_detector;
    reg clk;
    reg reset;
    reg input_bit;
    wire detected;
    wire [1:0] curr_state;

    seq_detector DUT(clk,reset,input_bit,detected,curr_state);
    initial begin
        clk=0;
        reset=0;
    end
    always #5 clk=~clk;
    initial begin
        #15 reset=1;
        #10 reset=0;
        #10 input_bit=1;
        #10 input_bit=1;
        #10 input_bit=0;
        #10 input_bit=1;
        #10 input_bit=1;
        #10 input_bit=0;
        #10 input_bit=1;
        #10 input_bit=1;
        #10 input_bit=0;
        #10 input_bit=1;
        #10 input_bit=1;
        #10 input_bit=1;

        #10 $finish;
    end
    initial begin
        $dumpfile("seq_detector.vcd");
        $dumpvars(0,tb_sequence_detector);
    end
endmodule
