module ALU_datapath(
    input clk,
    input reset,
    input [18:0] Bus,
    input ld_instn, 
    input decode,
    input execute,
    input load_result,
    output reg [7:0] Zout,
    output reg done
);
    localparam ADD =3'h0,
                SUB=3'h1,
                MUL=3'h2,
                AND=3'h3,
                OR=3'h4,
                XOR=3'h5,
                NOTA=3'h6,
                NOTB=3'h7;

    // instrution format |18  Operation  16|15   Operand_A    8|   Operand_B   (7-0)|
    reg [18:0] Instruction;
    reg [2:0] Operation;
    reg [7:0] Operand_A,Operand_B,Result;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            Instruction<=19'h00000;
            done<=0;
            Zout<=8'h00;
            Operation<=3'h0;
            Operand_A<=8'h00;
            Operand_B<=8'h00;
            Result<=8'h00;
        end
        else begin
            if(ld_instn) begin
                Instruction<=Bus;
                done<=0;
            end
            else if(decode) begin
                Operation<=Instruction[18:16];
                Operand_A<=Instruction[15:8];
                Operand_B<=Instruction[7:0];
            end
            else if(execute) begin
                case(Operation) 
                    ADD:Result<=Operand_A + Operand_B;
                    SUB:Result<=Operand_A - Operand_B;
                    MUL:Result<=Operand_A * Operand_B;
                    AND:Result<=Operand_A & Operand_B;
                    OR:Result<=Operand_A | Operand_B;
                    XOR:Result<=Operand_A ^ Operand_B;
                    NOTA:Result<=~Operand_A;
                    NOTB:Result<=~Operand_B;
                    default:Result<=8'h00;
                endcase
            end
            else if(load_result)begin
                Zout<=Result;
                done<=1;
            end
            else begin
                Zout<=8'h00;
                done<=0;
            end
        end
    end

endmodule