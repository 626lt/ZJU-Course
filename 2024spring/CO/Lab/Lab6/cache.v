`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/10 20:08:49
// Design Name: 
// Module Name: cache
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
`define IDLE 2'd0
`define COMPARE_TAG 2'd1
`define ALLOCATE 2'd2
`define WRITE_BACK 2'd3

module cache(
    input        clk,
    input        rst,
    input [31:0] addr_cpu,
    input [31:0] data_cpu_write,
    input [127:0]data_mem_read,
    input [1:0]  memRW,
    input        ready_mem,
    output reg   memRW_out,
    output reg [31:0] data_cpu_read,
    output reg [127:0] data_mem_write,
    output reg [31:0] addr_mem,
    output reg ready,
    output reg [1:0] state
    );
    reg [153:0] cache_data [127:0][1:0]; // 128 sets, 2 ways 153:lru, 152:dirty, 151:valid, 150:128:tag, 127:0:data
    wire [1:0] offset = addr_cpu[1:0];
    wire [6:0] index = addr_cpu[8:2];
    wire [22:0] tag = addr_cpu[31:9];    
    // reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            state <= `IDLE;
        end
        else begin
            case (state)
                `IDLE: begin
                    memRW_out <= 0;
                    ready <= 0;
                    if(memRW == 1 || memRW == 2) begin
                        state <= `COMPARE_TAG;
                    end
                    else begin
                        state <= `IDLE;
                    end
                end
                `COMPARE_TAG: begin
                    // if valid and hit
                    if(cache_data[index][0][153] == 1'b1 && cache_data[index][0][150:128] == tag)begin
                        if (memRW == 2) begin
                            cache_data[index][0][(offset*32)+:32] <= data_cpu_write;
                            cache_data[index][0][152] <= 1'b1;
                            cache_data[index][0][151] <= 1'b1;
                        end else begin
                            data_cpu_read <= cache_data[index][0][(offset*32)+:32];
                        end
                        state <= `IDLE;
                        ready <= 1;
                    end
                    else if(cache_data[index][1][153] == 1'b1 && cache_data[index][1][150:128] == tag) begin
                        if (memRW == 2) begin
                            cache_data[index][1][(offset*32)+:32] <= data_cpu_write;
                            cache_data[index][1][152] <= 1'b1;
                            cache_data[index][1][151] <= 1'b1;
                        end else begin
                            data_cpu_read <= cache_data[index][1][(offset*32)+:32];
                        end
                        state <= `IDLE;
                        ready <= 1;
                    end
                    // miss
                    else begin
                        // if dirty
                        if(cache_data[index][0][152] == 1 || cache_data[index][1][152] == 1) begin
                            memRW_out <= 1;
                            state <= `WRITE_BACK;
                        end
                        // if not dirty
                        else begin
                            memRW_out <= 0;
                            state <= `ALLOCATE;
                        end
                        ready <= 0;
                    end
                end
                `ALLOCATE: begin
                    // if memory has read
                    if(ready_mem == 1)begin
                        if(cache_data[index][0][151] == 1)begin
                            cache_data[index][0][151] <= 0;
                            cache_data[index][1][153] <= 1;
                            cache_data[index][1][152] <= 0;
                            cache_data[index][1][151] <= 1;
                            cache_data[index][1][150:128] <= tag;
                            cache_data[index][1][127:0] <= data_mem_read;
                        end else begin
                            cache_data[index][1][151] <= 0;
                            cache_data[index][0][153] <= 1;
                            cache_data[index][0][152] <= 0;
                            cache_data[index][0][151] <= 1;
                            cache_data[index][0][150:128] <= tag;
                            cache_data[index][0][127:0] <= data_mem_read;
                        end
                        state <= `COMPARE_TAG;
                    end else begin // wait to memory read
                        if(cache_data[index][0][151] == 1) begin
                            addr_mem <= {cache_data[index][1][150:128], index, 2'b00};
                        end else begin
                            addr_mem <= {cache_data[index][0][150:128], index, 2'b01};
                        end
                        state <= `ALLOCATE;
                    end
                end
                `WRITE_BACK: begin
                    if(ready_mem == 1)begin
                        memRW_out <= 1;
                        if(cache_data[index][0][152] == 1)begin
                            addr_mem <= {cache_data[index][0][150:128], index, 2'b00};
                            data_mem_write <= cache_data[index][0][127:0];
                            cache_data[index][0][152] <= 0;
                            state <= `ALLOCATE;
                        end 
                        if(cache_data[index][1][152] == 1)begin
                            addr_mem <= {cache_data[index][1][150:128], index, 2'b01};
                            data_mem_write <= cache_data[index][1][127:0];
                            cache_data[index][1][152] <= 0;
                            state <= `ALLOCATE;
                        end
                    end       
                end
            endcase
        end
    end
endmodule
