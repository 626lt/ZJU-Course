`timescale 1ns / 1ps

module ALU_tb;
    reg [31:0]  A, B;
    reg [3:0]   ALU_operation;
    wire[31:0]  res;
    wire        zero;
    ALU ALU_u(
        .A(A),
        .B(B),
        .ALU_operation(ALU_operation),
        .res(res),
        .zero(zero)
    );

    initial begin
        A=32'hA5A5A5A5;
        B=32'h5A5A5A5A;
        ALU_operation =4'b0000;
        #100;
        ALU_operation =4'b0001;
        #100;
        ALU_operation =4'b0010;
        #100;
        ALU_operation =4'b0011;
        #100;
        ALU_operation =4'b0100;
        #100;
        ALU_operation =4'b0101;
        #100;
        ALU_operation =4'b0110;
        #100;
        ALU_operation =4'b0111;
        #100;
        ALU_operation =4'b1000;
        #100;
        ALU_operation =4'b1001;
        #100;
        
        // Overflow case
        ALU_operation = 4'b0000;     
        A=32'hFFFFFFFF;
        B=32'h00000001;
        #100;

        ALU_operation = 4'b0001;
        A=32'h00000001;
        B=32'h00000002;#100;
        A=32'h00000001;
        B=32'hFFFFFFFF;#100;

        ALU_operation = 4'b0010;
        A=32'h00001000;
        B=32'h00000004;#100;

        ALU_operation = 4'b0011;
        A=32'h00000001;
        B=32'h00000001;#100;
        A=32'hFFFFFFFF;
        B=32'h00000001;#100;
        A=32'h00000001;
        B=32'hFFFFFFFF;#100;


        ALU_operation = 4'b0100;
        A=32'h00000001;
        B=32'h00000001;#100;
        A=32'hFFFFFFFF;
        B=32'h00000001;#100;
        A=32'h00000001;
        B=32'hFFFFFFFF;#100;

        ALU_operation = 4'b0110;
        A=32'h00001000;
        B=32'h00000004;#100;

        ALU_operation = 4'b0111;
        A=32'hFFFF0000;
        B=32'h00000004;#100;
        A=32'h0FFF0000;#100;


    end
endmodule