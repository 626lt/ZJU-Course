module Fadder(
        input clk,
        input rst,
        input [31:0] A,
        input [31:0] B,
        input start,
        output [31:0] result,
        output finish
    );
    reg [2:0] state;
    reg sign,sign1,sign2;
    reg [7:0] exp,exp1,exp2;
    reg [24:0] frac,frac1,frac2;

    localparam 
        S0 = 3'b000, //check denormal number
        S1 = 3'b001, //
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100,
        S5 = 3'b101;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            result <= 0;
            finish <= 0;
        end
        if(start)begin
            sign1 <= A[31];
            exp1 <= A[30:23];
            frac1 <= {2'b01, A[22:0]};
            sign2 <= B[31];
            exp2 <= B[30:23];
            frac2 <= {2'b01, B[22:0]};
            state <= S0;
            finish <= 0;
        end
        else if(~finish)begin
            case(state)
                S0: begin
                    if(exp1 == 8'b0 || exp1 == 8'b11111111)begin
                        exp <= exp1;
                        frac <= frac1;
                        sign <= sign1;
                        state <= S5;
                    end
                    else if(exp2 == 8'b0 || exp2 == 8'b11111111)begin
                        exp <= exp2;
                        frac <= frac2;
                        sign <= sign2;
                        state <= S5;
                    end
                    else begin
                        state <= S1;
                    end
                end
                S1: begin
                    if(exp1 == exp2)begin
                        state <= S2;
                    end
                    else if(exp1 > exp2)begin
                        exp2 <= exp2 + 1;
                        frac2 <= frac2 >> 1;
                        if(frac2 == 0)begin
                            exp <= exp1;
                            frac <= frac1;
                            state <= S5;
                        end
                    end
                    else begin
                        exp1 <= exp1 + 1;
                        frac1 <= frac1 >> 1;
                        if(frac1 == 0)begin
                            exp <= exp2;
                            frac <= frac2;
                            state <= S5;
                        end
                    end
                end
                S2: begin
                    if(sign1 ^ sign2 == 0)begin//same sign
                        sign <= sign1;
                        frac <= frac1 + frac2;
                    end
                    else if(sign1 == 1)begin
                        sign <= (frac2 > frac1) ? 0 : 1;
                        frac <= (frac2 > frac1) ? (frac2 - frac1) : (frac1 - frac2);
                    end
                    else begin
                        sign <= (frac2 > frac1) ? 1 : 0;
                        frac <= (frac2 > frac1) ? (frac2 - frac1) : (frac1 - frac2);
                    end
                    exp <= exp1;
                    state <= S3;
                end
                S3: begin
                    if(frac[24] == 1) begin
                        exp <= exp + 1;
                        frac <= frac >> 1;
                    end
                    else if(frac[23] == 0)begin
                        exp <= exp -1;
                        frac <= frac << 1;
                    end
                    else begin
                        state <= S4;
                    end
                end
                S4: begin
                    state <= S5;
                end
                S5: begin
                    result <= {sign, exp, frac[22:0]};
                    finish <= 1;
                end
            endcase
        end
    end
endmodule