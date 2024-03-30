`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/05 16:40:20
// Design Name: 
// Module Name: Regs
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


module Regs(
    input clk,
    input rst,
    input [4:0] Rs1_addr, 
    input [4:0] Rs2_addr, 
    input [4:0] Wt_addr, 
    input [31:0]Wt_data, 
    input RegWrite, 
    output [31:0] Rs1_data, 
    output [31:0] Rs2_data,
    output [31:0] Reg00,
    output [31:0] Reg01,
    output [31:0] Reg02,
    output [31:0] Reg03,
    output [31:0] Reg04,
    output [31:0] Reg05,
    output [31:0] Reg06,
    output [31:0] Reg07,
    output [31:0] Reg08,
    output [31:0] Reg09,
    output [31:0] Reg10,
    output [31:0] Reg11,
    output [31:0] Reg12,
    output [31:0] Reg13,
    output [31:0] Reg14,
    output [31:0] Reg15,
    output [31:0] Reg16,
    output [31:0] Reg17,
    output [31:0] Reg18,
    output [31:0] Reg19,
    output [31:0] Reg20,
    output [31:0] Reg21,
    output [31:0] Reg22,
    output [31:0] Reg23,
    output [31:0] Reg24,    
    output [31:0] Reg25,
    output [31:0] Reg26,
    output [31:0] Reg27,
    output [31:0] Reg28,
    output [31:0] Reg29,
    output [31:0] Reg30,
    output [31:0] Reg31
);
// Your code here
    reg [31:0] Regdata[1:31];
    integer i;

    always @(posedge clk) begin
        if (rst)
            for (i=1; i<32; i=i+1)
                Regdata[i] <= 0;
        else
            if (RegWrite && Wt_addr != 0)
                Regdata[Wt_addr] <= Wt_data;
    end
    assign Rs1_data = (Rs1_addr ==0) ? 0 : Regdata[Rs1_addr];
    assign Rs2_data = (Rs2_addr ==0) ? 0 : Regdata[Rs2_addr];
    assign Reg00 = 0;
    assign Reg01 = Regdata[1];
    assign Reg02 = Regdata[2];
    assign Reg03 = Regdata[3];
    assign Reg04 = Regdata[4];
    assign Reg05 = Regdata[5];
    assign Reg06 = Regdata[6];
    assign Reg07 = Regdata[7];
    assign Reg08 = Regdata[8];
    assign Reg09 = Regdata[9];
    assign Reg10 = Regdata[10];
    assign Reg11 = Regdata[11];
    assign Reg12 = Regdata[12];
    assign Reg13 = Regdata[13];
    assign Reg14 = Regdata[14];
    assign Reg15 = Regdata[15];
    assign Reg16 = Regdata[16];
    assign Reg17 = Regdata[17];
    assign Reg18 = Regdata[18];
    assign Reg19 = Regdata[19];
    assign Reg20 = Regdata[20];
    assign Reg21 = Regdata[21];
    assign Reg22 = Regdata[22];
    assign Reg23 = Regdata[23];
    assign Reg24 = Regdata[24];
    assign Reg25 = Regdata[25];
    assign Reg26 = Regdata[26];
    assign Reg27 = Regdata[27];
    assign Reg28 = Regdata[28];
    assign Reg29 = Regdata[29];
    assign Reg30 = Regdata[30];
    assign Reg31 = Regdata[31];


endmodule