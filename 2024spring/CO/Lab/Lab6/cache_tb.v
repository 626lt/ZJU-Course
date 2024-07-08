`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/10 22:06:00
// Design Name: 
// Module Name: cache_tb
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
`include "cache.v"

module cache_tb;
    reg clk;
    reg rst;
    reg [31:0] addr_cpu;
    reg [31:0] data_cpu_write;
    reg [127:0] data_mem_read;
    reg [1:0] memRW;
    reg ready_mem;
    wire memRW_out;
    wire [31:0] data_cpu_read;
    wire [127:0] data_mem_write;
    wire [31:0] addr_mem;
    wire ready;
    wire [1:0] state;
    
    initial begin
        $dumpfile("cache_tb.vcd");
        $dumpvars(0, cache_tb);

        clk = 1;
        rst = 1;
        memRW = 0;
        #10 rst = 0;
        ready_mem = 1;
        // Read miss
        addr_cpu = 32'h10000000;
        memRW = 1;
        data_mem_read = 128'h11111111222222223333333344444444;
        #40;
        // Read miss
        addr_cpu = 32'h20000000;
        data_mem_read = 128'h55555555666666667777777788888888;
        #40;
        // Read hit
        addr_cpu = 32'h10000002;#20;
        addr_cpu = 32'h20000001;#20;
        // Write Hit
        memRW = 2;
        addr_cpu = 32'h10000001;
        data_cpu_write = 32'hAAAAAAAA;
        #20;
        addr_cpu = 32'h20000003;
        data_cpu_write = 32'hFFFFFFFF;
        #20;
        // Read hit
        memRW = 1;
        addr_cpu = 32'h10000001;
        #20;
        addr_cpu = 32'h20000003;
        #20;
        // Write miss, write back and allocate
        memRW = 2;
        addr_cpu = 32'h30000000;
        data_cpu_write = 32'hAAAAAAAA;
        data_mem_read = 128'hBBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEE;
        #50;
        memRW = 1;
        addr_cpu = 32'h30000000;#20;
        addr_cpu = 32'h30000001;#20;
    end
    always begin
        #5 clk = ~clk;
    end

    cache cache_inst(
        .clk(clk),
        .rst(rst),
        .addr_cpu(addr_cpu),
        .data_cpu_write(data_cpu_write),
        .data_mem_read(data_mem_read),
        .memRW(memRW),
        .ready_mem(ready_mem),
        .memRW_out(memRW_out),
        .data_cpu_read(data_cpu_read),
        .data_mem_write(data_mem_write),
        .addr_mem(addr_mem),
        .ready(ready),
        .state(state)
    );
endmodule
