`timescale 1ns / 1ps
module tb_booth_multiplier;
    reg clk,reset,start;
    reg [3:0] Multiplicand_M,Multiplier_Q;
    wire [3:0] Result;
    
    Booth_multiplier DUT(.clk(clk),
                        .reset(reset),
                        .Multiplicand_M(Multiplicand_M),
                        .Multiplier_Q(Multiplier_Q),
                        .start(start),
                        .Result(Result));
      
     initial begin
        clk=0;
        reset=0;
        Multiplicand_M=4'h0;
        Multiplier_Q=4'h0;
        start=0;
     end
     always #5 clk=~clk;
     initial begin
        #15 reset=1;
        #10 reset=0;
        
        #10 
        Multiplicand_M=4'h2;
        Multiplier_Q=4'b1110;
        #10 start=1;
        #10 start=0;
        #500 $finish;
     end
    
endmodule
