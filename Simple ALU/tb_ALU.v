module tb_ALU;
        reg clk,reset,start;
        reg [18:0] instruction;
        wire  [7:0] Zout;
        wire done;
        wire [18:0] Bus;
        wire ld_instn,decode,execute,load_result;

        ALU_controller Controller(.clk(clk),
                            .reset(reset),
                            .instruction(instruction),
                            .start(start),
                            .Zout(Zout),
                            .Bus(Bus),
                            .ld_instn(ld_instn),
                            .decode(decode),
                            .execute(execute),
                            .load_result(load_result));
        
        ALU_datapath Datapath(.clk(clk),
                            .reset(reset),
                            .Bus(Bus),
                            .ld_instn(ld_instn),
                            .decode(decode),
                            .execute(execute),
                            .load_result(load_result),
                            .Zout(Zout),
                            .done(done));
                            

       initial begin
            clk=0;
            reset=0;
            start=0;
            instruction=18'h00000;
       end
       always #5 clk=~clk;
       initial begin
            #15 reset=1;
            #10 reset=0;
            
            instruction=19'h00205;
            #10 start=1;
            #10 start=0;
            
            #100 $finish;
       end
        
    
endmodule