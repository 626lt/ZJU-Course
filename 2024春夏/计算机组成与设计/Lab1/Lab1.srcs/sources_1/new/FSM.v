`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 20:11:50
// Design Name: 
// Module Name: FSM
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


module TruthEvaluator(
    input  clk,
    input  truth_detection,
    output trust_decision
);
    // State definition
    localparam HIGHLY_TRUSTWORTHY = 2'b00;   
    localparam TRUSTWORTHY = 2'b01;
    localparam SUSPICIOUS = 2'b10;
    localparam UNTRUSTWORTHY = 2'b11;
    reg [1:0]state = 2'b00;
    
    // initial begin
    //     state = 2'b00;
    // end

    always @(posedge clk) begin
        if(truth_detection) begin
            case(state)
                HIGHLY_TRUSTWORTHY: state <= HIGHLY_TRUSTWORTHY;
                TRUSTWORTHY: state <= HIGHLY_TRUSTWORTHY;
                SUSPICIOUS: state <= TRUSTWORTHY;
                UNTRUSTWORTHY: state <= SUSPICIOUS;
                default: state <= 2'b00;
            endcase
        end
        else begin
            case(state)
                HIGHLY_TRUSTWORTHY: state <= TRUSTWORTHY;
                TRUSTWORTHY: state <= SUSPICIOUS;
                SUSPICIOUS: state <= UNTRUSTWORTHY;
                UNTRUSTWORTHY: state <= UNTRUSTWORTHY;
                default: state <= 2'b00;
            endcase
        end
    end
    
    assign trust_decision = (state[1] == 1'b0); 
endmodule

