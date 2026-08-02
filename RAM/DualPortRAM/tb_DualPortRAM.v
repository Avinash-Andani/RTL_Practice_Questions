module tb_DualPortRAM;
    reg clk,write1,read1,write2,read2,cs;
    reg [7:0] data_in1,data_in2;
    reg [9:0] addr1,addr2;
    wire [7:0] data_out1,data_out2;
    integer k;

    DualPortRAM DUT(clk,write1,read1,addr1,data_in1,write2,read2,
    addr2,data_in2,cs,data_out1,data_out2);

    initial begin
        clk=0;
        cs=1;
    end
    always #5 clk=~clk;
    initial begin
        for(k=0;k<10;k=k+1) 
            DUT.Memory[k]= #10 k*10;
        #10 read1=1;addr1=10'h000;read2=1;addr2=10'h001;
        
        #10 $finish;
    end
    initial begin
        $dumpfile("DualPortRAM.vcd");
        $dumpvars(0,tb_DualPortRAM);
    end

endmodule