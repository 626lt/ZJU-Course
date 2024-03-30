`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/28 13:10:42
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU (
  input [31:0]  A,
  input [31:0]  B,
  input [3:0]   ALU_operation,
  output[31:0]  res,
  output        zero
);
// Your code
    reg [31:0] result;
    always @(*) begin
        case (ALU_operation)
            4'd0: result = A + B;   //ADD
            4'd1: result = A - B;   //SUB
            4'd2: result = A << B[4:0]; //SLL
            4'd3: result = $signed(A) < $signed(B) ? 32'b1 : 32'b0; //SLT
            4'd4: result = $unsigned(A) < $unsigned(B) ? 32'b1 : 32'b0; //SLTU
            4'd5: result = A ^ B;   //XOR
            4'd6: result = A >> B[4:0]; //SRL
            4'd7: result = $signed(A) >>> B[4:0]; //SRA
            4'd8: result = A | B;   //OR
            4'd9: result = A & B;   //AND
            default: result = 32'b0;
        endcase
    end
    assign res = result;
    assign zero = (result == 0);
endmodule
