`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/06 13:44:39
// Design Name: 
// Module Name: TruthEvaluator_tb
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


module TruthEvaluator_tb;
    reg clk;
    reg truth_detection;
    wire trust_decision;

    TruthEvaluator m0(
        .clk(clk),
        .truth_detection(truth_detection),
        .trust_decision(trust_decision)
    );

    always #50 clk = ~clk;

    initial begin
        clk = 0;
        truth_detection = 0;#200;
        truth_detection = 1;#100;
        truth_detection = 0;#300;
        truth_detection = 1;#400;
        #100 $stop();
    end

    
endmodule
