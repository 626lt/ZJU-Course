#import "template.typ": *
#import "@preview/tablex:0.0.8": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《计算机组成与设计》\ 实验报告

  #set text(font: ("Linux Libertine", "LXGW WenKai Mono"))
  #v(2cm)
  #set text(size: 15pt)
  #grid(
    columns: (80pt, 180pt),
    rows: (27pt, 27pt, 27pt, 27pt),
    [姓名：], [#uline[刘韬]],
    [学院：], [#uline[竺可桢学院]],
    [专业：], [#uline[人工智能]],
    [邮箱：], [#uline[3220103422\@zju.edu.cn]],
  )

  #v(2cm)
  #set text(size: 18pt)
  #grid(
    columns: (100pt, 200pt),
    [报告日期：], [#uline[#datetime.today().display()]],
  )

  #pagebreak()
]
#show:doc => jizu(doc)

= cache设计与实现

== 模块设计

=== cache参数
首先是cache的参数

#figure(  image("2024-06-10-23-33-27.png", width: 80%),  caption: "cache参数",) 

我们实现的是2-ways set cache.每一个block是4words.因此每个cacheline是128bits data + 23 bits tags + 1 bit valid + 1 bit dirty + 1 bit lru = 153 bits.那么我们cache就是初始化128组，每组2个cacheline，每个cacheline 153 bits。

=== cache实现
新建一个cache模块

```verilog
define IDLE 2'd0
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
    reg [153:0] cache_data [127:0][1:0]; // 128 sets, 2 ways 153:valid, 152:dirty, 151:lru, 150:128:tag, 127:0:data
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
                        if (memRW == 2) begin // Write
                            cache_data[index][0][(offset*32)+:32] <= data_cpu_write;
                            cache_data[index][0][152] <= 1'b1;
                            cache_data[index][0][151] <= 1'b1;
                            cache_data[index][1][151] <= 1'b0;
                        end else begin // Read
                            cache_data[index][0][151] <= 1'b1;
                            cache_data[index][1][151] <= 1'b0;
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
                            cache_data[index][0][151] <= 1'b0;
                        end else begin
                            cache_data[index][1][151] <= 1'b1;
                            cache_data[index][0][151] <= 1'b0;
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
                            addr_mem <= {cache_data[index][0][150:128], index, 2'b00};
                        end
                        state <= `ALLOCATE;
                    end
                end
                `WRITE_BACK: begin
                    if(ready_mem == 1)begin
                        if(cache_data[index][0][152] == 1)begin
                            addr_mem <= {cache_data[index][0][150:128], index, 2'b00};
                            data_mem_write <= cache_data[index][0][127:0];
                            cache_data[index][0][152] <= 0;
                            if(cache_data[index][1][152] == 0)begin
                                state <= `ALLOCATE;
                            end else
                                state <= `WRITE_BACK;
                        end 
                        else if(cache_data[index][1][152] == 1)begin
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
```

下面是cache的设计思路，我们基于下面的有限状态机进行设计。

#figure(  image("2024-06-10-23-49-27.png", width: 80%),  caption: "有限状态机",) 

整体的思路是根据请求判断是否命中，如果命中就执行请求，如果没有命中说明要去内存中找，这里先判断cache中是否与内存一致，如果不一致先写回内存，然后再去内存中找。注意要做整个block的替换。

==== IDLE

在IDLE状态下，cache不做任何事情，等待CPU给出memRW信号。这也是cache的初始状态。在接收到CPU的有效信号后，将状态转移到COMPARE_TAG状态。

==== COMPARE_TAG

这个状态首先根据Tag判断是否命中。如果命中，那么判断读写类型，如果是读的话就读入相应的数据，如果是写的话写入并且更新dirty_bits和lru_bits；如果没有命中，那么根据dirty位判断是否需要写回。如果需要写回，那么将状态转移到WRITE_BACK状态。如果不需要写回，那么将状态转移到ALLOCATE状态。

==== ALLOCATE

在这个状态下，cache等待memory的数据。如果memory的数据准备好了，那么我们需要从内存中将 addr 对应的块搬运到 cache 中来，并且更新dirty_bits和lru_bits。因此这里需要输出相应的mem_addr 但是如果对应组已经没有空闲位置，我们需要根据 LRU 策略将 一个块替换出去，即根据 151 位判断最近是否有访问过。如果memory的数据没有准备好，那么cache将继续等待。

==== WRITE_BACK

在这个状态下，cache等待memory的数据。如果memory的准备好了，那么将数据写入memory中，并且清空dirty_bits，这里同样要写入mem_addr 然后返回ALLOCATE。如果memory的数据没有准备好，那么cache将继续等待。

== 仿真测试

我们使用下面的testbench进行仿真测试

```verilog
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
```

我们包含了读miss，写miss，读hit，写hit，写miss的情况。我们可以看到仿真结果如下：

#figure(  image("2024-06-11-12-14-35.png", width: 100%),  caption: "仿真结果1",) 

首先进行reset，随后我们将memRW置1，这表示我们要进行读操作。接着我们将地址10000000送入，这表示我们要读的地址，对应第0组的块，tag是100000。由于此时cache中还没有任何的数据，所以是read miss。于是进入allocate阶段，我们将从memory中读到的数据写入cache，然后再回到compare tag阶段，将读到的数据输出。

接着读地址20000000的操作是相同的，那么现在有两个块中已经写入数据。然后我们验证前面的写操作是否有效，我们尝试读入这个块中的其他的字，读地址10000002，20000001，这两个满足read hit，可以看到我们读出的数据也是符合预期的。10000002对应的是第0组的tag为100000的第二个字，因此读出了22222222；20000001对应的是第1组的tag为200000的第一个字，因此读出了77777777。

随后我们测试write的功能，将memRW置为2表示写操作；我们将从CPU中得到的要写入的数据分别写入地址10000001和20000003，这两个地址对应的是第0组的tag为100000的第一个字和第1组的tag为200000的第三个字。可以看到我们写入的数据也是符合预期的。然后我们再次读取这两个地址，可以看到我们读出的数据也是是与传入的数据一致的。

#figure(  image("2024-06-11-12-39-18.png", width: 100%),  caption: "仿真结果2",) 

最后我们测试LRU替换策略，我们进行30000000地址的写，因为按照之前的操作，Index=0的组已经被填满，我们需要根据 LRU 策略选择一个块替换出去。这里因为 tag 为 100000 的块访问的时间更早，我们会选择驱赶这个块， 同时因为这个块已经被修改 (即脏位为 1), 在驱赶之前还要把数据写回到内存中。因此可以在第三个周期看到memRW_out被置为1，表示要写回内存。在第五个周期看到ready=1，说明已经完成了修改。然后我们再次读取30000000和30000001，可以看到我们读出的数据也是符合预期的。AAAAAAAA刚刚写入的数据，符合LRU策略。而DDDDDDDD是从磁盘中搬入的数据符合预期。

== 思考题

=== 思考题1

指令缓存在大多数情况下都是只读的，通常不需要考虑写回和写分配的问题。如果要修改指令也可以通过写操作来实现，但是要先将cpu暂停直到写操作完成为止。

=== 思考题2

带缓存的流水线发生缺失时应当阻塞流水线的运行，直到恢复正常为止。

== 心得体会

这下是真的完结了。本来没有打算写cache的，听牢Q说cache比较简单而且平时分确实有点欠缺于是就来写cache了。实际上也确实就是一个状态机的设计，如果按照ppt上的实现还要再另外创建模块，反倒不如直接用寄存器堆省事（x）。现在终于可以完结撒花开香槟了！（lhf：不，明天还有小测）计组的实验到这里完全结束，从开始基本模块的实现到单周期的实现，解决异常中断的实现，再到流水线不解决冲突和解决冲突，以及最后内存部分cache的实现，全部圆满完成，感恩助教，感恩老师，感恩马上要被卸载掉的vivado。

祝愿考试顺利，江湖路远，有缘再会！