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

== 不解决冲突的五级流水线实现

=== 数据通路设计

#figure(  image("2024-05-24-11-46-36.png", width: 100%),  caption: "数据通路",) 

相较于之前单周期CPU的设计，流水线CPU的主要变化在于每个stage的值都需要保存，以便在下一个周期使用。这里我们实现一个5级流水线，分别是IF（Instruction Fetch）、ID（Instruction Decode）、EX（Execution）、MEM（Memory）、WB（Write Back）。在两个stage之间的寄存器用于存储这个stage产生的需要到后面stage使用的数据和信号，并且每个寄存器在CPU时钟周期的上升沿进行数据更新，达到了流水线的效果。上图中省略了一些具体的信号传递，在后面具体的模块解析中会进行详细的说明。

=== 模块代码

考虑到数据通路有了较大的变化，添加了许多寄存器，我们将原先的datapath.v直接写入CPU.v中，直接在CPU.v中实现整个CPU的数据通路。

==== IF 段

IF段的主要工作是根据PC值获取指令，由PC和IF/ID寄存器两个时序电路分隔开。需要传递到下个stage的数据有pc值和inst值。这里的PC_next由MEN stage中的NEXT_PC产生，inst通过ROM读入。PC一直保持能写状态，维持更新。

代码如下：
```v
 // IF stage
    wire [31:0] PC_next;
    REG32 PC(
        .clk(clk),
        .rst(rst),
        .CE(1'b1),
        .D(PC_next),
        .Q(PC_out)
    );

    // IF/ID latch
    reg [31:0] IF_ID_PC;
    reg [31:0] IF_ID_inst;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_PC <= 32'b0;
            IF_ID_inst <= 32'b0;
        end
        else begin
            IF_ID_PC <= PC_out;
            IF_ID_inst <= inst_field;
        end
    end
```

==== ID 段

ID 阶段需要进行寄存器的访问，立即数的生成和指令译码（即控制单元生成控制信号）。需要传递给ID/EX寄存器的数据有

`PC,inst,rs1_data,rs2_data,imm.write_data`

需要传递的控制信号有

`ALU_Control,wordtype,MemtoReg,Jump,Branch0,Branch1,RegWrite,MemRW,jalr,utype,ALUSrc_B`

根据上面描述，下面是ID段的代码：

```v
    // ID stage
    // SCPU_ctrl
    wire [3:0] ALU_Control;
    wire [2:0] ImmSel, wordtype;
    wire [1:0] MemtoReg;
    wire Jump, Branch0, Branch1, RegWrite, MemRW, jalr, utype, ALUSrc_B;

    SCPU_ctrl control(
        .OPcode(IF_ID_inst[6:2]),
        .Fun3(IF_ID_inst[14:12]),
        .Fun7(IF_ID_inst[30]),
        .MIO_ready(1'b1),
        .ImmSel(ImmSel),
        .ALUSrc_B(ALUSrc_B),
        .MemtoReg(MemtoReg),
        .Jump(Jump),
        .Branch0(Branch0),
        .Branch1(Branch1),
        .RegWrite(RegWrite),
        .MemRW(MemRW),
        .ALU_Control(ALU_Control),
        .jalr(jalr),
        .utype(utype),
        .wordtype(wordtype)
    );

    // IMMGEN
    wire [31:0] Imm_out;

    ImmGen ImmGen(
        .ImmSel(ImmSel),
        .inst_field(IF_ID_inst),
        .Imm_out(Imm_out)
    );

    // Register File
    wire [31:0] Rs1_data, Rs2_data;

    Regs Regs(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(IF_ID_inst[19:15]),
        .Rs2_addr(IF_ID_inst[24:20]),
        .Wt_addr(MEM_WB_wt_addr),
        .Wt_data(write_data),
        `RegFile_Regs_Arguments
        .RegWrite(MEM_WB_RegWrite),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data)
    );
```

需要注意的是，此时使用的数据应是上一个stage的数据，所以需要使用IF/ID寄存器中的数据。
另外在Regs中与写回相关的几个数据来自WB阶段，所以需要使用MEM/WB寄存器中的数据。

下面是ID/EX寄存器的代码：

```v
// ID/EX latch
    reg [31:0] ID_EX_data1;
    reg [31:0] ID_EX_data2;
    reg [4:0] ID_EX_wt_addr;
    reg [31:0] ID_EX_PC;
    reg [31:0] ID_EX_imm;

    reg [3:0] ID_EX_ALU_Control;
    reg ID_EX_ALUSrc_B;
    reg ID_EX_Jump;
    reg ID_EX_Branch0;
    reg ID_EX_Branch1;
    reg ID_EX_RegWrite;
    reg ID_EX_MemRW;
    reg ID_EX_jalr;
    reg [1:0] ID_EX_MemtoReg;
    reg [2:0] ID_EX_wordtype;
    reg ID_EX_utype;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            ID_EX_data1 <= 32'b0;
            ID_EX_data2 <= 32'b0;
            ID_EX_wt_addr <= 5'b0;
            ID_EX_PC <= 32'b0;
            ID_EX_imm <= 32'b0;
            ID_EX_ALU_Control <= 4'b0;
            ID_EX_ALUSrc_B <= 1'b0;
            ID_EX_Jump <= 1'b0;
            ID_EX_Branch0 <= 1'b0;
            ID_EX_Branch1 <= 1'b0;
            ID_EX_RegWrite <= 1'b0;
            ID_EX_MemRW <= 1'b0;
            ID_EX_jalr <= 1'b0;
            ID_EX_MemtoReg <= 2'b0;
            ID_EX_wordtype <= 3'b0;
            ID_EX_utype <= 1'b0;
        end
        else begin
            ID_EX_data1 <= Rs1_data;
            ID_EX_data2 <= Rs2_data;
            ID_EX_wt_addr <= IF_ID_inst[11:7];
            ID_EX_PC <= IF_ID_PC;
            ID_EX_imm <= Imm_out;
            ID_EX_ALU_Control <= ALU_Control;
            ID_EX_ALUSrc_B <= ALUSrc_B;
            ID_EX_Jump <= Jump;
            ID_EX_Branch0 <= Branch0;
            ID_EX_Branch1 <= Branch1;
            ID_EX_RegWrite <= RegWrite;
            ID_EX_MemRW <= MemRW;
            ID_EX_jalr <= jalr;
            ID_EX_MemtoReg <= MemtoReg;
            ID_EX_wordtype <= wordtype;
            ID_EX_utype <= utype;
        end
    end
```

==== EX 段

EX 段主要进行ALU计算，需要传递给EX/MEM寄存器的数据有 这阶段输出的值和下一阶段仍需要的前面传过来的值：

`pc,ALU_out,Rs2_data,imm,write_addr,zero`

这一阶段用掉的控制信号有`ALUSrc_B,ALU_Control`，因此需要传递到下一阶段的控制信号

`wordtype,MemtoReg,Jump,Branch0,Branch1,RegWrite,MemRW,jalr,utype`

下面是EX段的代码：

```v
    // EX stage
    // ALU
    wire [31:0] ALU_B;
    assign ALU_B = (ID_EX_ALUSrc_B) ? ID_EX_imm : ID_EX_data2;
    wire [31:0] ALU_out;
    wire zero;

    ALU ALU(
        .A(ID_EX_data1),
        .B(ALU_B),
        .ALU_operation(ID_EX_ALU_Control),
        .res(ALU_out),
        .zero(zero)
    );
```

需要注意的是使用的数据和信号都应该是上一阶段传递而来的即ID/EX寄存器中的数据。下面是EX/MEM寄存器的代码：

```v
    // EX/MEM latch
    reg [31:0] EX_MEM_ALU_out;
    reg [31:0] EX_MEM_data2;
    reg [4:0] EX_MEM_wt_addr;
    reg [31:0] EX_MEM_PC;
    reg [31:0] EX_MEM_imm;
    reg EX_MEM_zero;

    reg EX_MEM_Jump;
    reg EX_MEM_Branch0;
    reg EX_MEM_Branch1;
    reg EX_MEM_RegWrite;
    reg EX_MEM_MemRW;
    reg EX_MEM_jalr;
    reg EX_MEM_utype;
    reg [1:0] EX_MEM_MemtoReg;
    reg [2:0] EX_MEM_wordtype;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            EX_MEM_ALU_out <= 32'b0;
            EX_MEM_data2 <= 32'b0;
            EX_MEM_wt_addr <= 5'b0;
            EX_MEM_PC <= 32'b0;
            EX_MEM_imm <= 32'b0;
            EX_MEM_zero <= 1'b0;
            EX_MEM_Jump <= 1'b0;
            EX_MEM_Branch0 <= 1'b0;
            EX_MEM_Branch1 <= 1'b0;
            EX_MEM_RegWrite <= 1'b0;
            EX_MEM_MemRW <= 1'b0;
            EX_MEM_jalr <= 1'b0;
            EX_MEM_MemtoReg <= 2'b0;
            EX_MEM_wordtype <= 3'b0;
            EX_MEM_utype <= 1'b0;
        end
        else begin
            EX_MEM_ALU_out <= ALU_out;
            EX_MEM_data2 <= ID_EX_data2;
            EX_MEM_wt_addr <= ID_EX_wt_addr;
            EX_MEM_PC <= ID_EX_PC;
            EX_MEM_imm <= ID_EX_imm;
            EX_MEM_zero <= zero;
            EX_MEM_Jump <= ID_EX_Jump;
            EX_MEM_Branch0 <= ID_EX_Branch0;
            EX_MEM_Branch1 <= ID_EX_Branch1;
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_MemRW <= ID_EX_MemRW;
            EX_MEM_jalr <= ID_EX_jalr;
            EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            EX_MEM_wordtype <= ID_EX_wordtype;
            EX_MEM_utype <= ID_EX_utype;
        end
    end
```

==== MEM 段

MEM 段主要进行内存访问，涉及到内存访问的定义不在SCPU内部，因此我们只需要给出读取的地址，和写入的数据以及写使能即可。这里我们为了实现`lw,lb,lh,lbu,lhu`指令，对读入的数据和要给出的数据进行了一些处理，这里的处理与之前的单周期CPU的处理方式一致。主要是根据写入的数据的长度和写入的地址进行数据的处理。

```v
    // MEM stage
    // Memory
    wire [31:0] memory_in;
    assign memory_in = Data_in >> ({3'b000, EX_MEM_ALU_out[1:0]} << 2'b11);
    assign Addr_out = EX_MEM_ALU_out;
    //input
    always @(*) begin
        case(EX_MEM_wordtype)
            3'b000 : reg_in <= {{24{memory_in[7]}}, memory_in[7:0]}; //signed byte
            3'b100 : reg_in <= {24'b0, memory_in[7:0]}; //unsigned byte
            3'b001 : reg_in <= {{16{memory_in[15]}}, memory_in[15:0]}; //signed half
            3'b101 : reg_in <= {16'b0, memory_in[15:0]}; //unsigned half
            3'b010 : reg_in <= memory_in; //signed word
            default: reg_in <= 32'b0; 
        endcase
    end
    assign Mem_write = EX_MEM_MemRW;
    //store
    always @(*) begin
        case(EX_MEM_wordtype[2:0])
            3'b000 : begin
                case(EX_MEM_ALU_out[1:0])
                    2'b00 : begin
                        Data_out <= {24'b0, EX_MEM_data2[7:0]};
                        RAM_wt <= 4'b0001;
                    end
                    2'b01 : begin
                        Data_out <= {16'b0, EX_MEM_data2[7:0], 8'b0};
                        RAM_wt <= 4'b0010;
                    end
                    2'b10 : begin
                        Data_out <= {8'b0, EX_MEM_data2[7:0], 16'b0};
                        RAM_wt <= 4'b0100;
                    end
                    2'b11 : begin
                        Data_out <= {EX_MEM_data2[7:0], 24'b0};
                        RAM_wt <= 4'b1000;
                    end
                endcase
            end
            3'b001 : begin
                case(EX_MEM_ALU_out[1:0])
                    2'b00 : begin
                        Data_out <= {16'b0, EX_MEM_data2[15:0]};
                        RAM_wt <= 4'b0011;
                    end
                    2'b01 : begin
                        Data_out <= {8'b0, EX_MEM_data2[15:0], 8'b0};
                        RAM_wt <= 4'b0110;
                    end
                    2'b10 : begin
                        Data_out <= {EX_MEM_data2[15:0], 16'b0};
                        RAM_wt <= 4'b1100;
                    end
                    default : begin
                        Data_out <= 0;
                        RAM_wt <= 0;
                    end
                endcase
            end
            3'b010 : begin
                Data_out <= EX_MEM_data2;
                RAM_wt <= 4'b1111;
            end
            default : begin
                Data_out <= 0;
                RAM_wt <= 0;
            end
        endcase
    end
```

需要再次强调的是，这里使用的数据是这个周期读入的数据和上一个周期传递过来的数据，因此需要使用EX/MEM寄存器中的数据。

同时我们在这个阶段完成了`PC_next`的计算，模块实现如下:

```v
module PC_NEXT(
    input [31:0]current_PC,
    input [31:0]latch_PC,
    input [31:0]Imm,
    input [31:0]ALU_out,
    input zero,
    input Branch0,
    input Branch1,
    input Jump,
    input jalr,
    output [31:0]PC_next
    );
    wire [31:0] PC_imm;
    wire s4;
    assign s4 = (Branch0 & zero) | (Branch1 & ~zero);
    assign PC_imm = latch_PC + Imm;
    assign PC_next = (Jump == 1) ? ((jalr == 1) ? ALU_out : PC_imm) : ((s4 == 1) ? PC_imm : current_PC + 32'd4);
endmodule
```

这是对之前的单周期CPU中的计算下一PC值的改进，进行了模块的封装，也是因为此时写入rd数据的计算有所不同，这里计算得到的数据不能够进行复用。还需要注意的一点是这里用的PC+4是当前状态的PC而不是寄存器一级一级传递得到的PC，这样才是流水线CPU的实现。

下面是MEM/WB寄存器的代码：
```v
    // MEM/WB latch
    reg [31:0] MEM_WB_ALU_out;
    reg [31:0] MEM_WB_reg_in;
    reg [31:0] MEM_WB_imm;
    reg [31:0] MEM_WB_PC;
    reg [4:0] MEM_WB_wt_addr;
    
    reg MEM_WB_RegWrite;
    reg [1:0] MEM_WB_MemtoReg;
    reg MEM_WB_utype;

    wire [31:0] write_data;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            MEM_WB_ALU_out <= 32'b0;
            MEM_WB_reg_in <= 32'b0;
            MEM_WB_imm <= 32'b0;
            MEM_WB_PC <= 32'b0;
            MEM_WB_wt_addr <= 5'b0;
            MEM_WB_RegWrite <= 1'b0;
            MEM_WB_MemtoReg <= 2'b0;
            MEM_WB_utype <= 1'b0;
        end
        else begin
            MEM_WB_ALU_out <= EX_MEM_ALU_out;
            MEM_WB_reg_in <= reg_in;
            MEM_WB_imm <= EX_MEM_imm;
            MEM_WB_PC <= EX_MEM_PC;
            MEM_WB_wt_addr <= EX_MEM_wt_addr;
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
            MEM_WB_utype <= EX_MEM_utype;
        end
    end
```

==== WB 段

这一阶段进行寄存器堆的写回操作，先进行写回数据的计算与选择；根据`Risc-V 32I`中所列举的，写回寄存器的值有五个来源，分别是`alu_out,mem_out,pc+4,imm,pc+imm`，这里我们根据`MemtoReg`信号进行选择。同时我们需要根据`RegWrite`信号进行写入操作。最后的`imm`和`pc+imm`是为了实现 U-type 指令的，为此我们将其在`MemtoReg`中的编码统一，通过之前产生的额外信号`utype`进行区分。

```V
    // WB stage
    MUX4T1_32 m3(
        .I0(MEM_WB_ALU_out),
        .I1(MEM_WB_reg_in),
        .I2(MEM_WB_PC + 32'd4),
        .I3((MEM_WB_utype == 1) ? (MEM_WB_PC + MEM_WB_imm) : MEM_WB_imm),
        .s(MEM_WB_MemtoReg),
        .o(write_data)
    );
```

这里的write_data已经在前面接入了寄存器堆。

=== 仿真测试

使用提供的测试文件进行仿真，可以看到仿真结果如下：

#figure(  image("2024-06-02-02-39-32.png", width: 100%),)

查看`reg31`寄存器的值，可以看到结果是666，因此仿真验证通过。

=== 下板验证

将信号接入串口，通过串口查看输出结果，可以看到输出结果与仿真结果一致。

#figure(  image("2024-06-02-02-52-13.png", width: 100%), ) 

== 解决冲突的五级流水线实现

=== 模块实现

==== PC计算前移

首先是datapath发生的变化，我们将产生PC_next的部分前移到了ID阶段，这样我们就只需要等待一个周期就可以获得新的PC值，这样在执行分支指令和跳转指令的时候就只需要bubble一个周期，这在实现上提供了一些便利。

#figure(  image("2024-06-02-02-37-12.png", width: 100%),  caption: "修改后的流水线datapath",) 

==== 解决数据冲突（data hazard）

数据冲突发生的原因是：当前指令读取的寄存器值在上一条或者上上一条指令中发生了变化但还未来得及写回到寄存器堆中，这导致了数据的不一致。我们在检测到这种情况以后，可以通过暂停流水线即stall的方式进行解决，也可以直接将产生的数据通过forwarding的方式传递给需要的地方，这样就不需要暂停流水线，这样可以提高流水线的效率。我们采用forwarding的方式解决数据冲突：

我们的forwarding分为两个部分，一部分是传递给ALU的，用作数据处理的，另一部分是传递给Next_PC的，用来生成下一条指令的PC值，这一部分也涉及到了控制冲突的处理，我们统一放在下一部分进行讨论。解决ALU数据冲突的思路是：

+ 修改ALU的输入数据源，根据各阶段的MemtoReg信号和写回寄存器的地址，选择需要的数据源。当MEM阶段和EX阶段同时冲突时，选择EX阶段的数据，因为这是最新的数据。
+ 通过bubble_stop信号判断是否发生load-use的情况，如果发生了，就需要bubble一个周期，等待load指令加载完毕。
+ bubble的做法是暂停IF,ID两个阶段，并且把ID阶段的控制信号全部置0，后面的阶段照常进行。

对于第一部分，我们通过下面的方式检测是否发生数据冲突：
```v
module forwarding(
    input [4:0] EX_MEM_rd,
    input [4:0] MEM_WB_rd,
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg [1:0] forwardA,//00: no forward, 01: forward from MEM_WB, 10: forward from EX_MEM
    output reg [1:0] forwardB
);
    always @(*) begin
        if(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1))
            forwardA <= 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs1))
            forwardA <= 2'b01;
        else
            forwardA <= 2'b00;
        if(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))
            forwardB <= 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs2))
            forwardB <= 2'b01;
        else
            forwardB <= 2'b00;
        end
endmodule
```

如果ID段的读取的寄存器和EX或MEM阶段要写入的寄存器一致，并且这个寄存器不是0号寄存器，那么就发生了数据冲突，这时我们就需要进行forwarding。这个模块传出的信号告知具体是哪个地方发生了冲突。

我们发现，这里的写回值不仅仅是ALU_OUT这一个来源，还有可能是PC+4(跳转指令)，imm(lui)，PC+imm(U-type指令)，而这恰好是由MemtoReg信号控制的，而这个信号在原本不处理冲突的流水线设计中，直到最后一个WB阶段才会被使用，现在我们提前利用这个信号，将每个阶段中的产生的需要写回的值，也就是目标寄存器应该变成的值，传递给需要的阶段，那么这样就解决了数据冲突。

```v
MUX4T1_32 m3(
    .I0(MEM_WB_ALU_out),
    .I1(MEM_WB_reg_in),
    .I2(MEM_WB_PC + 32'd4),
    .I3((MEM_WB_utype == 1) ? (MEM_WB_PC + MEM_WB_imm) : MEM_WB_imm),
    .s(MEM_WB_MemtoReg),
    .o(write_data)
);

wire [31:0] EX_MEM_write_data;
MUX4T1_32 m4(
    .I0(EX_MEM_ALU_out),
    .I1(32'b0),
    .I2(EX_MEM_PC + 32'd4),
    .I3((EX_MEM_utype == 1) ? (EX_MEM_PC + EX_MEM_imm) : EX_MEM_imm),
    .s(EX_MEM_MemtoReg),
    .o(EX_MEM_write_data)
);

MUX4T1_32 ALU_A(
        .I0(ID_EX_data1),
        .I1(write_data), // MEM_WB_data_out
        .I2(EX_MEM_write_data),
        .I3(32'b0),
        .s(forwardA),
        .o(ALU_data_A)
    );

wire [31:0] ALU_data_B0;
MUX4T1_32 ALU_B(
    .I0(ID_EX_data2),
    .I1(write_data),
    .I2(EX_MEM_write_data),
    .I3(32'b0),
    .s(forwardB),
    .o(ALU_data_B0)
);
```

上面的m3和m4两个模块是用来选择需要写回的数据的，这里的write_data是在WB阶段产生的，而EX_MEM_write_data是在MEM阶段产生的，下面是根据forward的结果选择需要的数据。

以上的处理可以解决大部分的数据冲突，但是还有一种数据冲突是必须要bubble_stop才可以解决的。
load-use类的数据冲突，即在load指令后面的指令中使用了load指令的结果，这种情况下，我们需要bubble直到数据写回，这样才能保证数据的正确性。因为读取地址的产生在ID阶段，但是要到MEM阶段才能得到数据，这样就会导致数据的不一致。我们在ID阶段检测是否发生了这种情况，如果发生了，就需要bubble直到数据写回，这里就没有使用forwarding的方式，而是直接bubble。

```v
assign bubble_stop = (ID_EX_Mem_read && (ID_EX_wt_addr == IF_ID_inst[19:15] 
|| ID_EX_wt_addr == IF_ID_inst[24:20]))                        
||((EX_MEM_Mem_read) && (EX_MEM_wt_addr == IF_ID_inst[19:15] || EX_MEM_wt_addr == IF_ID_inst[24:20]))
|| (branch && ID_EX_RegWrite && ID_EX_wt_addr != 0 && (ID_EX_wt_addr == IF_ID_inst[19:15] || ID_EX_wt_addr == IF_ID_inst[24:20]));
```

上面的代码利用了MEM_read信号，这个信号是在cpu_ctrl模块中产生的，当load指令的时候，这个信号会被置为1，这样我们就可以检测是否发生了load-use类的数据冲突。我们检测一个周期和两个周期前发生load指令的情况，这样就可以保证数据的正确性。最后一部分是下面控制冲突中需要用到的bubble_stop信号。

这里的时序更新如下:
```v
always @(posedge clk or posedge rst) begin
    if(rst)begin
        ...
    end
    else begin
        else begin 
            if (bubble_stop) begin
                PC_out <= PC_out;

                IF_ID_PC <= IF_ID_PC;
                IF_ID_inst <= IF_ID_inst;

                ID_EX_ALU_Control <= 4'b0;
                ID_EX_ALUSrc_B <= 1'b0;
                ID_EX_Jump <= 1'b0;
                ID_EX_Branch0 <= 1'b0;
                ID_EX_Branch1 <= 1'b0;
                ID_EX_RegWrite <= 1'b0;
                ID_EX_MemRW <= 1'b0;
                ID_EX_jalr <= 1'b0;
                ID_EX_MemtoReg <= 2'b0;
                ID_EX_wordtype <= 3'b0;
                ID_EX_utype <= 1'b0;
                ID_EX_rs1 <= 5'b0;
                ID_EX_rs2 <= 5'b0;
                ID_EX_Mem_read <= 1'b0;
            end
            ...
        end
    end
end
```

#figure(  image("2024-06-02-03-21-25.png", width: 100%),)
实际上，在上上个指令load的情况中，我们可以不stop，而是直接forward，但是为了实现的方便，我们在这里stop一个周期。 

==== 解决控制冲突（control hazard）

我们还生成了一个branch信号来表示是否进行跳转指令，即B,jal,jalr的时候，branch信号为1。解决控制冲突的思路是：

生成branch信号后，此时跳转指令在ID阶段，我们保持PC更新，等到下一个时钟上升沿到来时，我们根据branch信号的值来决定PC_next的值。这里分为跳转和不跳转的两种情况；如果跳转的话，那么PC_next的值就是跳转的地址，否则的，PC_next的值就是current_PC。这是因为由于跳转指令进入ID阶段以后，在同时PC是按照上一个的PC_next来变化的，也就是说这条指令是下一条指令，如果不做跳转的话就应该按照顺序来执行这一条指令。另外如果遇到前面的数据冲突的情况，就还需要bubble一个周期。在branch信号为1时，PC继续更新，IF_ID_inst的值变为nop，这是为了清空流水线，等到跳转指令结束以后才能继续流水线。

    + 在数据冲突并且不跳转的情况下，PC将会停留三个周期；
    + 在数据冲突且跳转的情况下，PC将会停留两个周期；
    + 在数据不冲突且不跳转的情况下，PC将会停留两个周期；
    + 在数据不冲突且跳转的情况下，PC将会停留一个周期。

下面是PC_next的模块中的forwarding：因为b-type指令是否跳转需要根据寄存器值的比较来进行判断，因此这里也需要用到forwarding。除此以外，跳转指令的目标地址的计算也是根据当前的PC值和imm值来进行计算的，这样就需要将imm值进行forwarding。下面是PC_next模块的代码：

```v
// PC_NEXT
    wire [31:0] jal_addr,jalr_addr;
    wire [31:0] reg1,reg2;
    assign reg1 = (branch && EX_MEM_RegWrite && (EX_MEM_wt_addr != 0) && (EX_MEM_wt_addr == IF_ID_inst[19:15])) ? EX_MEM_write_data 
    : (branch && MEM_WB_RegWrite && (MEM_WB_wt_addr != 0) && (MEM_WB_wt_addr == IF_ID_inst[19:15])) ? write_data : Rs1_data;
    assign reg2 = (branch && EX_MEM_RegWrite && (EX_MEM_wt_addr != 0) && (EX_MEM_wt_addr == IF_ID_inst[24:20])) ? EX_MEM_write_data 
    : (branch && MEM_WB_RegWrite && (MEM_WB_wt_addr != 0) && (MEM_WB_wt_addr == IF_ID_inst[24:20])) ? write_data : Rs2_data;
    assign jal_addr = IF_ID_PC + Imm_out;
    assign jalr_addr = reg1 + Imm_out;

    assign s3 = (Branch0 & zero) | (Branch1 & ~zero);
    assign PC_next = (s3 == 1) ? jal_addr 
                   : (Jump == 1) ? ((jalr == 1) ? jalr_addr : (jal_addr))
                   : (branch == 1) ? PC_out
                    : (PC_out + 32'd4);
```

上面的代码中，与之前同样的方式决定了reg1和reg2的值，并且计算了跳转地址。我们这里的zero是通过一个ALU计算得到的，这个ALU计算的输入是ID阶段的数据。对于这个PC_next的值，s3代表我们要进行分支跳转，那么跳转地址就是jal_addr；如果是跳转指令，那么要根据是JAL还是JALR来决定跳转地址；这里的branch信号是在cpu_ctrl模块中产生的，当发生分支指令的时候，或者跳转指令的时候，我们暂停PC，并且将IF_ID_PC的值变为nop，即暂停一个周期。当下一个时钟上升沿到来时，cpu_ctrl模块会检测到这个nop，然后将PC_next的值变为PC+4，此时的PC值是上一条指令执行的结果，这样就实现了跳转。

==== 时序逻辑调整

前文讨论了forwarding的方法和计算PC值的模块。要解决流水线的冲突，我们还需要对时序逻辑进行调整，对时序的更新。之前已经展示了bubble_stop信号的处理，我们还生成了一个branch信号来表示是否进行跳转指令，对于这二者的优先级，我们优先处理bubble_stop，这是因为还有load-use的情况，这种冲突一定是发生在分支指令之前的，而且stall一个周期对指令的执行没有影响，而且这样可以保证数据的正确性。因此我们在处理时序逻辑的时候，优先处理bubble_stop，然后再处理branch信号。branch信号做的事情是解析跳转指令后，ID阶段的下个周期将被清空，这样就可以保证不会多执行一条指令。

```v
if (bubble_stop) begin
    ...
end
else if (branch) begin
    PC_out <= PC_next;

    IF_ID_PC <= PC_out;
    IF_ID_inst <= 32'h00000013;

    ID_EX_data1 <= Rs1_data;
    ID_EX_data2 <= Rs2_data;
    ID_EX_wt_addr <= IF_ID_inst[11:7];
    ID_EX_PC <= IF_ID_PC;
    ID_EX_imm <= Imm_out;
    ID_EX_ALU_Control <= ALU_Control;
    ID_EX_ALUSrc_B <= ALUSrc_B;
    ID_EX_Jump <= Jump;
    ID_EX_Branch0 <= Branch0;
    ID_EX_Branch1 <= Branch1;
    ID_EX_RegWrite <= RegWrite;
    ID_EX_MemRW <= MemRW;
    ID_EX_jalr <= jalr;
    ID_EX_MemtoReg <= MemtoReg;
    ID_EX_wordtype <= wordtype;
    ID_EX_utype <= utype;
    ID_EX_rs1 <= IF_ID_inst[19:15];
    ID_EX_rs2 <= IF_ID_inst[24:20];
    ID_EX_Mem_read <= mem_read;
end
else begin
    ...     //正常更新流水线
end
```

=== 仿真测试

为了测试我们的冲突解决策略是否正常实现，我们分别使用了尽可能多的冲突和单周期CPU的测试文件进行测试。前者可以验证我们解决冲突的策略和过程是否符合预期，后者说明我们的流水线和单周期CPU可以实现同样的功能。

==== 冲突测试

以下是仿真代码：
```v
test1:
    addi x1, x0, 1
    addi x2, x0, 1
    addi x4, x0, 5
fibonacci:
    add x3, x1, x2
    add x1, x2, x3
    add x2, x1, x3
    addi x4, x4, -1
    bne x0, x4, fibonacci
    addi x5, x0, 0x63D
    bne x2, x5, fail

test2:
    addi x1, x0, 5
    addi x2, x0, 0
    addi x3, x0, 0x100
    addi x5, x0, 4
memcpy:
    beq x1, x0, exit1 
    lw x4, 0(x2)
    sub x4, x4, x3
    sw x4, 0(x3)
    add x2, x2, x5
    add x3, x3, x5
    addi x1, x1, -1
    bne x1, x0, memcpy
exit1:
    addi x1, x0, 5
    addi x2, x0, 0
    addi x3, x0, 0x100
    addi x5, x0, 4
memcmp:
    beq x1, x0, test3
    lw x4, 0(x2)
    sub x4, x4, x3
    lw x6, 0(x3)
    add x2, x2, x5
    add x3, x3, x5
    addi x1, x1, -1
    bne x4, x6, fail
    j memcmp
    

test3:
    lui x1, 0xDEADB     # 0xDEADB000
    ori x2, x0, 0xEF    # 0x000000EF
    add x3, x1, x2      # 0xDEADB0EF
    sub x1, x2, x1      # 0x215250EF
    addi x2, x0, 1      # 0x00000001
    srl x4, x3, x2      # 0x6F56D877
    and x2, x1, x4      # 0x21525067
    lui x1, 0x21525     # 0x21525000
    addi x1, x1, 0x67   # 0x21525067
    bne x2, x1, fail
    addi x1, x0, 0xbc
    jalr x1, x1, 0
    addi x2, x0, 0xbc
    bne x1, x2, fail

pass:
    j pass


fail:
    j fail

```

上面的测试代码如果没有异常，应该会进入pass标签，地址是0xc4，如果有异常，会进入fail标签，地址是0xc8。以下是仿真结果：

#figure(  image("2024-06-05-15-51-02.png", width: 100%),  caption: "仿真分析1",) 

我们是通过forwarding的方式进行，所以对data hazard并不会改变PC流，其显示与单周期相同。我们分析PC流发生变化，的指令部分。我们可以看到在PC_out = 20的时候，PC停留了一个周期，这是因为 PC_out = 1C的指令是bne x0,x4,-16，并且这条指令还用到了前一条指令，这是发生了数据冲突，因此bubble了一个周期等待所需要的值计算完毕，进行判断，然后进行了跳转。

#figure(  image("2024-06-05-15-11-03.png", width: 100%),  caption: "仿真分析2",) 

上面是进行循环计算斐波那契数列，直到reg4为0。

#figure(  image("2024-06-05-15-11-47.png", width: 100%),  caption: "仿真分析3",) 

上图中，PC_out = 20 停留了三个周期，注意看下面的IF_ID_inst，在跳转指令停留了两个周期，这是因为发生了数据冲突，进行了bubble_stop，接下来进行了跳转判断，将IF_ID_inst置为nop，决定是不跳转，所以PC_out还是之前的PC，整体来看就是PC_out停留了三个周期。

#figure(  image("2024-06-05-15-17-16.png", width: 100%),  caption: "仿真分析4",) 

#figure(  image("2024-06-05-15-17-29.png", width: 100%),  caption: "仿真分析5",) 

#figure(  image("2024-06-05-15-17-42.png", width: 100%),  caption: "仿真分析6",) 

#figure(  image("2024-06-05-15-17-53.png", width: 100%),  caption: "仿真分析7",) 

#figure(  image("2024-06-05-15-18-06.png", width: 100%),  caption: "仿真分析8",) 

#figure(  image("2024-06-05-15-18-18.png", width: 100%),  caption: "仿真分析9",) 

#figure(  image("2024-06-05-15-18-30.png", width: 100%),  caption: "仿真分析10",) 

#figure(  image("2024-06-05-15-19-06.png", width: 100%),  caption: "仿真分析11",)

#figure(  image("2024-06-05-15-21-12.png", width: 100%),  caption: "仿真分析12",) 

上面的几张仿真包括了部分循环，PC的变化已经在前面写出，我们看到在最后的PC值是在0xc4，是pass标签的位置，因此我们实现的PCPU通过冲突仿真测试。

==== CPU功能测试

这里使用和单周期CPU同样的验收代码进行测试，我们可以看到最后reg31的值是666，说明验收通过。

#figure(  image("2024-06-05-15-36-39.png", width: 100%),  caption: "功能仿真",) 

这里我们与5-1中不解决冲突的比较，可以发现5-1的指令流中插入了大量的nop，到最后完成全部测试时，已经过了58000ns，我们解决了冲突，花费的时间是19700ns，这比单周期CPU通过测试花费的时间略长，原因是为了数据的正确性，采用了stall的方式。在实际实现时，时钟频率一定是流水线的可以比单周期的要快；这是因为单周期的最长路径经历了流水线的五个阶段，而流水线将五个阶段拆分，使得各部分在周期内独立更新，而不用等到全部执行完毕再做更新，这样的时钟延迟会更低，因此即使我们添加了一些stall使得整体的用时增加，但是在实际实现中，pcpu是效率更高的。

=== 下板验证

#figure(  image("2024-06-05-15-45-12.png", width: 100%),  caption: "下班验证",) 

接入串口看到reg31的值是666，说明通过测试。

== 思考题

=== 思考题1

==== TP-0

这段指令在我的pcpu中运行不存在冲突，没有出现使用未写回的数据的情况，因此不会发生data hazard。
总共12条指令，需要15.5个周期，不存在冲突的情况，采用下降沿写回的方式，所以最后WB阶段只用半个周期，考虑到完整的周期，所以总共需要16个周期。CPI为16/12=1.3333。

==== TP-1

```yasm
addi    x1, x0, 1
addi    x2, x1, 2
addi    x3, x1, 3
addi    x4, x3, 4
```
第二条与第一条指令冲突，第三条与第一条指令冲突，第四条与第三条冲突，都是发生了数据冲突，在我的流水线中使用forwarding解决，因此不会发生bubble，CPI为8/4=2。

=== 思考题2

==== 支持forwarding

#figure(  image("2024-06-06-14-18-56.png", width: 100%),  caption: "思考题",) 

完成所有的指令使用了13个周期，这里stall了两个周期等待load指令执行完毕。


== 实验总结

PCPU是计组中最抓马的一个实验了，相比较开始写SCPU时候的茫然，写PCPU时已经对整体架构比较熟悉了，datapath也是在之前的基础上进行了较大的修改，进行了阶段的分割和阶段寄存器的添加。调试的过程很痛苦，vivado的仿真也很麻烦，好在最后全部都完成了，也顺利地通过了验收代码的测试。相较于5-1的实现，我在这里整合了所有的时序逻辑，方便修改和调整。也重构了PC_next的计算，使得计算的过程更加清晰。但是我的实现也是存在一些问题的，比如忽略了资源的开销和延迟，尽管能够成功地运行，但仍旧有很多需要改进的地方。

不过，计组课的实验就到这里了，提前开个香槟吧，感觉后面看时间安排决定要不要写cache了，感谢调到多次崩溃的vivado，感谢助教，感谢老师，感谢熬了好几个大夜最终完成的自己。（补写思考题的时候vivado又爆了。。。）

#figure(image("Q.jpg", width: 50%),caption: "这里有点空，总得放点什么（逃")

