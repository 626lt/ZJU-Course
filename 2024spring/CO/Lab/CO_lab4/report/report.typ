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
    [报告日期：], [#uline[2024年5月3日]],
  )

  #pagebreak()
]
#show:doc => jizu(doc)

== SCPU实现

这是4-3的实验报告。在本节中实现了全部的 SCPU 指令集，包括：
#block(
  width: 100%,
  fill: luma(240),
  inset: 10pt,
  radius: 10pt,
  grid(
    gutter: 0.5em,
    columns: 2,
    [R-Type:],
    [add, sub, and, or, xor, slt, srl, sll, sra, sltu],
    [I-Type:],
    [addi, andi, ori, xori, srli, slti, slli, srai, sltiu, lb, lh, lw, lbu, lhu, jalr],
    [S-Type:],
    [sb, sh, sw],
    [B-Type:],
    [beq, bne, blt, bge, bltu, bgeu],
    [J-Type:],
    [jal],
    [U-Type:],
    [lui, auipc],
  )
)

=== 模块实现

==== datapath

首先给出 SCPU 的数据通路图，如下所示：

#figure(  image("2024-05-08-00-24-00.png", width: 100%),  caption: "datapath（不含中断）",) 

数据流主要由PC和寄存器文件。其中PC的值来源于`PC+4,PC+imm,rs1 + imm`，根据一系列的判断信号进行选择，具体逻辑不在这里展开，下面结合具体的指令进行说明。另一部分是写到寄存器的值，来源是`ALU_res,memory,PC+4,PC+imm`，也是根据一系列的判断信号进行选择。另外涉及位长的转换也是通过代码实现的。

接着根据datapath将SCPU的各个元件进行连接：使用了提供的头文件`"Lab4_header.vh"`，其中使用到的元件包括`ImmGen,MUX,ALU,REG32,Regs`，其中`ImmGen`用于生成立即数，`MUX`用于选择输入，`ALU`用于进行运算，`REG32`用于存储PC的值，`Regs`用于存储寄存器的值。`ImmGen`是本次实验新实现的，其余都是之前实验完成的，就不再赘述。

以下是`ImmGen`的代码：
```verilog
`include "Lab4_header.vh"

module ImmGen(
  input [2:0]   ImmSel,
  input [31:0]  inst_field,
  output reg [31:0]  Imm_out
);

    always @(*) begin
        case(ImmSel)
            `IMM_SEL_I: Imm_out = {{20{inst_field[31]}}, inst_field[31:20]};
            `IMM_SEL_S: Imm_out = {{20{inst_field[31]}}, inst_field[31:25], inst_field[11:7]};
            `IMM_SEL_B: Imm_out = {{19{inst_field[31]}}, inst_field[31], inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0};
            `IMM_SEL_J: Imm_out = {{11{inst_field[31]}}, inst_field[31], inst_field[19:12], inst_field[20], inst_field[30:21], 1'b0};
            `IMM_SEL_U: Imm_out = {inst_field[31:12], 12'b0};
            default: Imm_out = 32'b0;
        endcase
    end

endmodule
```

这是根据上面`DataPath`图连线的代码：

```verilog
`include "Lab4_header.vh"

module DataPath(
    input clk,
    input rst,
    input [31:0]inst_field,
    input [31:0]Data_in,
    input [3:0]ALU_Control,
    input [2:0]ImmSel,
    input [1:0]MemtoReg,
    input ALUSrc_B,
    input Jump,
    input Branch0,
    input Branch1,
    input RegWrite,
    input jalr,
    input [2:0] wordtype, // 0:byte 1:half 2:word 最高位0 signed 1 unsigned
    input utype,
    `RegFile_Regs_Outputs
    output reg [3:0] RAM_wt,//RAM 写使能
    output [31:0]PC_out,
    output [31:0]Data_out,
    output [31:0]ALU_out,
    output [31:0]Reg_in
);

    wire [31:0] Imm_out;
    wire [31:0] Rs1_data, Rs2_data;
    wire [31:0] memory_in;
    reg [31:0] reg_in,data_temp;
    wire zero, s4;
    wire [31:0] o0 ,o1, o2, o3, o4, o5;
    wire [31:0] c0, c1;
    
    ImmGen ImmGen(
        .ImmSel(ImmSel),
        .inst_field(inst_field),
        .Imm_out(Imm_out)
    );

    assign c0 = PC_out + 32'd4;
    assign c1 = PC_out + Imm_out;
    assign s4 = (Branch0 & zero) | (Branch1 & ~zero);
    assign Data_out = data_temp;
    assign Reg_in = reg_in;
    assign memory_in = Data_in >> ({3'b000, ALU_out[1:0]} << 2'b11);


    //input
    always @(*) begin
        case(wordtype)
            3'b000 : reg_in <= {{24{memory_in[7]}}, memory_in[7:0]}; //signed byte
            3'b100 : reg_in <= {24'b0, memory_in[7:0]}; //unsigned byte
            3'b001 : reg_in <= {{16{memory_in[15]}}, memory_in[15:0]}; //signed half
            3'b101 : reg_in <= {16'b0, memory_in[15:0]}; //unsigned half
            3'b010 : reg_in <= memory_in; //signed word
            default: reg_in <= 32'b0; 
        endcase
    end
    //store
    always @(*) begin
        case(wordtype[2:0])
            3'b000 : begin
                case(ALU_out[1:0])
                    2'b00 : begin
                        data_temp <= {24'b0, Rs2_data[7:0]};
                        RAM_wt <= 4'b0001;
                    end
                    2'b01 : begin
                        data_temp <= {16'b0, Rs2_data[7:0], 8'b0};
                        RAM_wt <= 4'b0010;
                    end
                    2'b10 : begin
                        data_temp <= {8'b0, Rs2_data[7:0], 16'b0};
                        RAM_wt <= 4'b0100;
                    end
                    2'b11 : begin
                        data_temp <= {Rs2_data[7:0], 24'b0};
                        RAM_wt <= 4'b1000;
                    end
                endcase
            end
            3'b001 : begin
                case(ALU_out[1:0])
                    2'b00 : begin
                        data_temp <= {16'b0, Rs2_data[15:0]};
                        RAM_wt <= 4'b0011;
                    end
                    2'b01 : begin
                        data_temp <= {8'b0, Rs2_data[15:0], 8'b0};
                        RAM_wt <= 4'b0110;
                    end
                    2'b10 : begin
                        data_temp <= {Rs2_data[15:0], 16'b0};
                        RAM_wt <= 4'b1100;
                    end
                    default : begin
                        data_temp <= 0;
                        RAM_wt <= 0;
                    end
                endcase
            end
            3'b010 : begin
                data_temp <= Rs2_data;
                RAM_wt <= 4'b1111;
            end
            default : begin
                data_temp <= 0;
                RAM_wt <= 0;
            end
        endcase
    end

    MUX2T1_32 m0(
        .I0(Rs2_data),
        .I1(Imm_out),
        .s(ALUSrc_B),
        .o(o0)
    );

    MUX4T1_32 m1(
        .I0(ALU_out),
        .I1(reg_in),
        .I2(c0),
        .I3(o2),
        .s(MemtoReg),
        .o(o1)
    );

    MUX2T1_32 m2(
        .I0(Imm_out),
        .I1(c1),
        .s(utype),
        .o(o2)
    );

    MUX2T1_32 m3(
        .I0(c1),
        .I1(ALU_out),
        .s(jalr),
        .o(o3)
    );

    MUX2T1_32 m4(
        .I0(c0),
        .I1(c1),
        .s(s4),
        .o(o4)
    );

    MUX2T1_32 m5(
        .I0(o4),
        .I1(o3),
        .s(Jump),
        .o(o5)
    );

    Regs Regs(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(inst_field[19:15]),
        .Rs2_addr(inst_field[24:20]),
        .Wt_addr(inst_field[11:7]),
        .Wt_data(o1),
        `RegFile_Regs_Arguments
        .RegWrite(RegWrite),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data)
    );

    ALU ALU(
        .A(Rs1_data),
        .B(o0),
        .ALU_operation(ALU_Control),
        .res(ALU_out),
        .zero(zero)
    );

    REG32 PC(
        .clk(clk),
        .rst(rst),
        .CE(1'b1),
        .D(o5),
        .Q(PC_out)
    );

endmodule
```
上面代码中的`memory_in`是根据读写信号的具体位置进行转换的，因为读入的指令都是一个字长的，需要移动到正确的位置。并且根据写的类型进行扩展。几个选择器是根据下面模块给的信号进行选择的。

==== CPU_ctrl

第二部分是CPU_ctrl模块，用于控制datapath中的各个元件。根据输入的指令，输出一系列的控制信号，这一部分是通过组合逻辑实现的，没有涉及时序问题：

```verilog
`include "Lab4_header.vh"

module SCPU_ctrl(
    input [4:0]OPcode,
    input [2:0]Fun3,
    input Fun7,
    input MIO_ready, // CPU_wait
    output reg [2:0]ImmSel,
    output reg ALUSrc_B, // ALUB的值，0为Rs2，1为Imm
    output reg [1:0]MemtoReg, // 写回寄存器堆的值，00为ALUout，01为Memout，10为PC+4，11为Utype的值
    output reg Jump, // 是否跳转
    output reg Branch0, // beq,bge,bgeu
    output reg Branch1, // bne,blt,bltu
    output reg RegWrite, // 是否写回寄存器堆
    output reg MemRW, // 是否读写内存
    output reg [3:0]ALU_Control,// ALU的操作
    output reg jalr, // 是否是jalr
    output reg utype, // Utype的类型，0为lui即imm<<12，1为auipc即PC+imm<<12 我的实现是在生成立即数的时候就进行移位
    output reg [2:0] wordtype, // 0:byte 1:half 2:word 最高位0 signed 最高位1 unsigned
    output reg CPU_MIO
);
    reg [1:0] ALU_op;
    `define CPU_ctrl_signals {ALUSrc_B, MemtoReg, RegWrite, MemRW, Branch1, Branch0, Jump, ALU_op}
    always @(*) begin
        case (OPcode)
            /* R-type */
            `OPCODE_ALU : begin
                ImmSel <= 3'b000;
                `CPU_ctrl_signals <= 10'b0_00_1_0_00_0_10;
                jalr <= 1'b0;
                utype <= 1'b0;
                wordtype <= 3'b000;
            end 
            /* I-type */
            `OPCODE_ALU_IMM : begin
                ImmSel <= `IMM_SEL_I;
                `CPU_ctrl_signals <= 10'b1_00_1_0_00_0_11;
                jalr <= 1'b0;
                utype <= 1'b0;
                wordtype <= 3'b000;
            end
            `OPCODE_LOAD : begin
                ImmSel <= `IMM_SEL_I;
                `CPU_ctrl_signals <= 10'b1_01_1_0_00_0_00;
                jalr <= 1'b0;
                utype <= 1'b0;
                case (Fun3)
                    `FUNC_BYTE : wordtype <= 3'b000;
                    `FUNC_HALF : wordtype <= 3'b001;
                    `FUNC_WORD : wordtype <= 3'b010;
                    `FUNC_BYTE_UNSIGNED : wordtype <= 3'b100;
                    `FUNC_HALF_UNSIGNED : wordtype <= 3'b101;
                    default: wordtype <= 3'b000;
                endcase
            end
            `OPCODE_JALR : begin
                ImmSel <= `IMM_SEL_I;
                `CPU_ctrl_signals <= 10'b1_10_1_0_00_1_00;
                jalr <= 1'b1;
                utype <= 1'b0;
                wordtype <= 3'b000;
            end
            /* S-type */
            `OPCODE_STORE : begin
                ImmSel <= `IMM_SEL_S;
                `CPU_ctrl_signals <= 10'b1_00_0_1_00_0_00;
                jalr <= 1'b0;
                utype <= 1'b0;
                case(Fun3)
                    `FUNC_BYTE : wordtype <= 3'b000;
                    `FUNC_HALF : wordtype <= 3'b001;
                    `FUNC_WORD : wordtype <= 3'b010;
                    default: wordtype <= 3'b000;
                endcase
            end
            /* B-type */
            `OPCODE_BRANCH : begin
                ImmSel <= `IMM_SEL_B;
                case (Fun3)
                    `FUNC_EQ : `CPU_ctrl_signals <= 10'b0_00_0_0_01_0_01;
                    `FUNC_NE : `CPU_ctrl_signals <= 10'b0_00_0_0_10_0_01;
                    `FUNC_LT : `CPU_ctrl_signals <= 10'b0_00_0_0_10_0_01;
                    `FUNC_GE : `CPU_ctrl_signals <= 10'b0_00_0_0_01_0_01;
                    `FUNC_LTU : `CPU_ctrl_signals <= 10'b0_00_0_0_10_0_01;
                    `FUNC_GEU : `CPU_ctrl_signals <= 10'b0_00_0_0_01_0_01;
                    default: `CPU_ctrl_signals <= 10'b0_00_0_0_00_0_00;
                endcase
                jalr <= 1'b0;
                utype <= 1'b0;
                wordtype <= 3'b000;
            end
            /* J-type */
            `OPCODE_JAL : begin
                ImmSel <= `IMM_SEL_J;
                `CPU_ctrl_signals <= 10'b0_10_1_0_00_1_00;
                jalr <= 1'b0;
                utype <= 1'b0;
                wordtype <= 3'b000;
            end
            /* U-type */
            `OPCODE_LUI : begin
                ImmSel <= `IMM_SEL_U;
                `CPU_ctrl_signals <= 10'b0_11_1_0_00_0_00;
                jalr <= 1'b0;
                utype <= 1'b0;
                wordtype <= 3'b000;
            end
            `OPCODE_AUIPC : begin
                ImmSel <= `IMM_SEL_U;
                `CPU_ctrl_signals <= 10'b0_11_1_0_0_00_00;
                jalr <= 1'b0;
                utype <= 1'b1;
                wordtype <= 3'b000;
            end
            default: ImmSel <= 3'b0;
        endcase

        case (ALU_op)
            2'b00 : ALU_Control <= `ALU_OP_ADD;
            2'b01 : begin
                case (Fun3)
                    `FUNC_EQ : ALU_Control <= `ALU_OP_SUB;
                    `FUNC_NE : ALU_Control <= `ALU_OP_SUB;
                    `FUNC_LT : ALU_Control <= `ALU_OP_SLT;
                    `FUNC_GE : ALU_Control <= `ALU_OP_SLT;
                    `FUNC_LTU : ALU_Control <= `ALU_OP_SLTU;
                    `FUNC_GEU : ALU_Control <= `ALU_OP_SLTU;
                    default: ALU_Control <= `ALU_OP_SUB;
                endcase
            end
            /* R-type */
            2'b10 : begin 
                case (Fun3)
                   `FUNC_ADD : ALU_Control <= (Fun7 == 1'b0) ? `ALU_OP_ADD : `ALU_OP_SUB; 
                   `FUNC_SL : ALU_Control <= `ALU_OP_SLL; 
                   `FUNC_SLT : ALU_Control <= `ALU_OP_SLT;
                   `FUNC_SLTU : ALU_Control <= `ALU_OP_SLTU;
                   `FUNC_XOR : ALU_Control <= `ALU_OP_XOR;
                   `FUNC_SR : ALU_Control <= (Fun7 == 1'b0) ? `ALU_OP_SRL : `ALU_OP_SRA;
                   `FUNC_OR : ALU_Control <= `ALU_OP_OR;
                   `FUNC_AND : ALU_Control <= `ALU_OP_AND;
                    default: ALU_Control <= `ALU_OP_ADD;
                endcase
            end 
            2'b11 : begin
                case (Fun3)
                    `FUNC_ADD : ALU_Control <= `ALU_OP_ADD;
                    `FUNC_SL : ALU_Control <= `ALU_OP_SLL;
                    `FUNC_SLT : ALU_Control <= `ALU_OP_SLT;
                    `FUNC_SLTU : ALU_Control <= `ALU_OP_SLTU;
                    `FUNC_XOR : ALU_Control <= `ALU_OP_XOR;
                    `FUNC_SR : ALU_Control <= (Fun7 == 1'b0) ? `ALU_OP_SRL : `ALU_OP_SRA;
                    `FUNC_OR : ALU_Control <= `ALU_OP_OR;
                    `FUNC_AND : ALU_Control <= `ALU_OP_AND;
                    default: ALU_Control <= `ALU_OP_ADD;
                endcase
            end
            default: ALU_Control <= `ALU_OP_ADD;
        endcase
        CPU_MIO <= 1'b0;
    end

endmodule
```

为了支持全部的指令，在所给的接口上加了`Branch0,Branch1,jalr,utype,wordtype`几个包括跳转信号、位宽信号。


=== 仿真测试

==== IMM

===== 测试代码

使用的仿真测试代码是给出的，如下：

```verilog
`timescale 1ns/1ps

`include "Lab4_header.vh"
`include "../source/ImmGen.v"

module ImmGen_tb();
  reg [2:0]   ImmSel;
  reg [31:0]  inst_field;
  wire[31:0]  Imm_out;

  ImmGen m0 (.ImmSel(ImmSel), .inst_field(inst_field), .Imm_out(Imm_out));

`define LET_INST_BE(inst) \
  inst_field = inst; \
  #5;

  initial begin
    $dumpfile("ImmGen.vcd");
    $dumpvars(1, ImmGen_tb);

    #5;
    /* Test for I-Type */
    ImmSel = `IMM_SEL_I;
    `LET_INST_BE(32'h3E810093);   //addi x1, x2, 1000
    `LET_INST_BE(32'h00A14093);   //xori x1, x2, 10
    `LET_INST_BE(32'h00116093);   //ori x1, x2, 1
    `LET_INST_BE(32'h00017093);   //andi x1, x2, 0
    `LET_INST_BE(32'h01411093);   //slli x1, x2, 20
    `LET_INST_BE(32'h00515093);   //srli x1, x2, 5
    `LET_INST_BE(32'h41815093);   //srai x1, x2, 24
    `LET_INST_BE(32'hFFF12093);   //slti x1, x2, -1
    `LET_INST_BE(32'h3FF13093);   //sltiu x1, x2, 1023
    `LET_INST_BE(32'h0E910083);   //lb x1, 233(x2)

    #20;
    /* Test for S-Type */
    ImmSel = `IMM_SEL_S;
    `LET_INST_BE(32'hFE110DA3);   //sb x1, -5(x2)
    `LET_INST_BE(32'h00211023);   //sh x2, 0(x2)
    `LET_INST_BE(32'h00C0A523);   //sw x12, 10(x1)

    #20;
    /* Test for B-Type */
    ImmSel = `IMM_SEL_B;
    `LET_INST_BE(32'hFE108AE3);   //beq x1, x1, -12
    `LET_INST_BE(32'h00211463);   //bne x2, x2, 8
    `LET_INST_BE(32'h0031CA63);   //blt x3, x3, 20
    `LET_INST_BE(32'hFE4256E3);   //bge x4, x4, -20

    #20;
    /* Test for J-Type */
    ImmSel = `IMM_SEL_J;
    `LET_INST_BE(32'hF9DFF06F);   //jal x0, -100
    `LET_INST_BE(32'h3FE000EF);   //jal x1, 1023 NOTE: does ImmGen output 1023?

    ImmSel = `IMM_SEL_U;
    `LET_INST_BE(32'h003e8537); //lui x10, 1000
    `LET_INST_BE(32'h003e8517); //auipc x10, 1000

    #20;
    #50; $finish();
  end
endmodule
```

===== 仿真波形

#figure(  image("2024-05-08-15-20-25.png", width: 100%),  caption: "Imm仿真1",) 

- I-type 立即数，有符号拓展到32位

#figure(  image("2024-05-08-15-23-37.png", width: 100%),  caption: "Imm仿真2",)

- S-type,B-type

#figure(  image("2024-05-08-15-25-27.png", width: 100%),  caption: "Imm仿真3",) 

- B-type,J-type 
 
与所给的标准仿真波形进行对比，发现仿真结果正确

==== SCPU仿真

===== 测试代码

仿真指令与所给的测试代码一致，最后结果是`reg_31`的值为`666`。为了简化，建立了一个由SCPU，RAM，ROM组成的测试平台testbench，如下：

```verilog
module testbench(
    input clk,
    input rst
);

    /* SCPU ???? */
    wire [31:0] Addr_out;
    wire [31:0] Data_out;       
    wire        CPU_MIO;
    wire        MemRW;
    wire [31:0] PC_out;
    wire [3:0]  RAM_wt;
    /* RAM ?? */
    wire [31:0] douta;
    /* ROM ?? */
    wire [31:0] spo;
                                        
    SCPU u0(
        .clk(clk),.rst(rst),
        .Data_in(douta),
        .MIO_ready(CPU_MIO),
        .inst_in(spo),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .CPU_MIO(CPU_MIO),
        .MemRW(MemRW),
        .RAM_wt(RAM_wt),
        .PC_out(PC_out)
    );

    myRAM2 u1(
        .clka(~clk),
        .wea({4{MemRW}} & RAM_wt),
        .addra(Addr_out[11:2]),
        .dina(Data_out),
        .douta(douta)
    );

    myROM3 u2(
        .a(PC_out[11:2]),
        .spo(spo)
    );

endmodule
```
使用的测试代码如下：
```v
module testbench_tb();

    reg clk;
    reg rst;

    testbench m0(.clk(clk), .rst(rst));

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        #5;
        rst = 1'b0;
    end

    always #50 clk = ~clk;
endmodule
```
指令都已经写入ROM中了，所以只需要给时钟信号就可以让CPU开始工作了。

===== 仿真波形

根据验收代码的要求，我们只需要看最后Reg31的结果即可，如下：

#figure(  image("2024-05-08-22-31-05.png", width: 100%),  caption: "SCPU仿真",) 

可以看到仿真结果正确，最后Reg31的值为0x666。并且从PC的地址也可以看出，顺利进入了dummy死循环。

//#figure(  image("2024-05-08-22-32-41.png", width: 100%),  caption: "SCPU仿真",) 


// 下面具体分析每条指令所做的操作：

// #figure(  image("2024-05-08-22-35-44.png", width: 100%),  caption: "SCPU分析1",) 

// #grid(
//     columns: (60pt, 100pt,2000pt),
//     column-gutter: 10pt,
//     align: (left, left, left),
//   rows: (27pt, 27pt, 27pt, 27pt),
//   [PC],[汇编指令],[具体作用],
//   [00000000], [auipc x1, 0],[x1 = PC + 0 << 12],
//   [00000004], [j     start],[PC = 00000028,跳转到start位置],
//   [00000028], [bnez  x1, dummy],[检查x1是否为0，如果不为0就跳转到dummy死循环],
//   [0000002C], [beq   x0, x0, pass_0],[跳转到pass_0位置，说明通过了第0个测试],
//   [0000003C], [li    x31, 1],[测试中Reg31的值用来表示测试的阶段],
//   [00000040], [bne   x0, x0, dummy],[测试bne],
//   [00000044], [bltu  x0, x0, dummy],[测试bltu],
//   [00000048], [li    x1, -1],[x1=FFFFFFFF],
//   [0000004C], [xori  x3, x1, 1],[检验xor指令]
// )

#pagebreak()
=== 下板处理

重新切换回Lab2完成的实验平台，将实现好的SCPU替换掉原来的CPU，然后生成bit文件，进行下板验证，下板过程中我使用串口来显示寄存器的值和一些中间信号。

以下是在最后进入dummy死循环后的寄存器的值：

#figure(  image("2024-05-08-23-07-34.png", width: 100%),  caption: "SCPU下板结果",) 

可以看到最后Reg31的值为0x666，而且也进入了dummy死循环。说明下板验证也同样正确。

#pagebreak()
== 中断处理

中断处理在SCPU的基础上增加了特权级寄存器，并通过特权集寄存器的读写实现了`csrrw,csrrs,csrrc,csrrwi,csrrsi,csrrci,ecall,meret`等指令，并且编写了trap程序用于处理中断异常。我们实现的是整个流程，具体的异常处理略过。

=== 模块实现

==== CSR 寄存器

实现逻辑分为两部分，一部分用于接受`CSR`指令，另一部分用于处理中断。首先是`CSR`指令的实现，主要是根据`CSR`指令的不同模式实现读和写的操作，具体的实现如下：

```verilog
module CSRRegs(
    input clk, rst,
    input[11:0] read_addr, write_addr,       // 读写 CSR 寄存器的地址
    input[31:0] write_data,              // 写入 CSR 寄存器的数据
    input csr_w,                    // 写使能
    input[1:0] csr_wsc_mode,        // 写入 CSR 寄存器的模式
    input by_en, // 旁路使能
    input [31:0] by_mstatus, by_mtvec, by_mcause, by_mtval, by_mepc, // 旁路输入，用于中断修改寄存器的值
    output [31:0] read_data,           // 读出 CSR 寄存器的数据
    output [31:0] mstatus_o,
    output [31:0] mtvec_o,
    output [31:0] mcause_o,
    output [31:0] mtval_o,
    output [31:0] mepc_o
);
    reg [31:0] mstatus;   // MSTATUS
    reg [31:0] mtvec;      // MTVEC 
    reg [31:0] mcause;     // MCAUSE 
    reg [31:0] mtval;      // MTVAL 
    reg [31:0] mepc;      // MEPC 
    
    assign mstatus_o = mstatus;
    assign mtvec_o = mtvec;
    assign mcause_o = mcause;
    assign mtval_o = mtval;
    assign mepc_o = mepc;

    // reg [31:0] mstatus, mtvec, mcause, mtval, mepc;
    // read_data
    
    assign read_data  =  (read_addr == 12'h300) ? mstatus :
                    (read_addr == 12'h305) ? mtvec :
                    (read_addr == 12'h342) ? mcause :
                    (read_addr == 12'h343) ? mtval :
                    (read_addr == 12'h341) ? mepc : 0;
    
    // write_data
    always @(posedge clk or posedge rst) begin
        if(rst == 1) begin
            mstatus <= 0;
            mtvec <= 32'h50; // to modify
            mcause <= 0;
            mtval <= 0;
            mepc <= 0;
        end
        else begin 
            if (csr_w == 1 && write_data != 0) begin
                case(read_addr)
                    12'h300: mstatus <= (csr_wsc_mode == 2'b01) ? write_data : 
                                        (csr_wsc_mode == 2'b10) ? (write_data | mstatus) : 
                                        (csr_wsc_mode == 2'b11) ? (~write_data & mstatus) : mstatus;
                    12'h305: mtvec <= (csr_wsc_mode == 2'b01) ? write_data : 
                                        (csr_wsc_mode == 2'b10) ? (write_data | mtvec) : 
                                        (csr_wsc_mode == 2'b11) ? (~write_data & mtvec) : mtvec;
                    12'h342: mcause <= (csr_wsc_mode == 2'b01) ? write_data :
                                        (csr_wsc_mode == 2'b10) ? (write_data | mcause) : 
                                        (csr_wsc_mode == 2'b11) ? (~write_data & mcause) : mcause;
                    12'h343: mtval <= (csr_wsc_mode == 2'b01) ? write_data :
                                        (csr_wsc_mode == 2'b10) ? (write_data | mtval) : 
                                        (csr_wsc_mode == 2'b11) ? (~write_data & mtval) : mtval;
                    12'h341: mepc <= (csr_wsc_mode == 2'b01) ? write_data :
                                        (csr_wsc_mode == 2'b10) ? (write_data | mepc) : 
                                        (csr_wsc_mode == 2'b11) ? (~write_data & mepc) : mepc;
                endcase
            end
            else if(by_en == 1)begin
                mstatus <= by_mstatus;
                //mtvec <= by_mtvec;
                mcause <= by_mcause;
                mtval <= by_mtval;
                mepc <= by_mepc;
            end 
        end
    end

endmodule 
```

和之前Regs的实现一样，写部分使用时序完成，读部分使用组合逻辑，外部输入的写数据通过`csr_wsc_mode`来选择不同的模式与原值进行运算最后写回。除此以外还有一个`by_en`信号，用于中断时的寄存器修改。这样可以方便批量修改寄存器的值。

==== RV_INT

这个模块接受SCPU_ctrl产生的异常信号与硬件输入的INT中断信号，然后给出外界寄存器使能和要改变的PC值来改变PC流进入中断异常处理程序，我的实现是在这个模块的内部实例化CSRRegs模块，用于修改特权级寄存器的值。实际上这一部分也可以接到整个datapath上。

```v
module RV_INT(
    input       clk,
    input       rst,
    input       INT,              // 外部中断信号
    input       ecall,            // ECALL 指令
    input       mret,             // MRET 指令
    input       illegal_inst,     // 非法指令信号
    input       l_access_fault,   // 数据访存不对
    input       j_access_fault,   // 跳转地址不对
    input [31:0] inst_field,       // 指令
    input [31:0] pc_current,      // 当前指令 PC 
    // CSRRegs 操作----------------
    input [11:0] read_addr, write_addr,       // 读写 CSR 寄存器的地址
    input [31:0] write_data,              // 写入 CSR 寄存器的数据
    input csr_w,                    // 写使能
    input [1:0] csr_wsc_mode,        // 写入 CSR 寄存器的模式
    output[31:0] read_data,           // 读出 CSR 寄存器的数据
    // ----------------
    output reg en,              // 用于控制寄存器堆、内存等器件的写使能，同时改变PC
    output reg [31:0] pc,              // 将执行的指令 PC 
    output  [31:0] mstatus,    // MSTATUS 寄存
    output  [31:0] mtvec,      // MTVEC 寄存
    output  [31:0] mcause,     // MCAUSE 寄存
    output  [31:0] mtval,      // MTVAL 寄存
    output  [31:0] mepc       // MEPC 寄存
    // output  [31:0] csrout      // 读出 CSR 寄存器的
);
// 用于处理中断，中断的pc?
// mret 要做的事情是mstatus = 0，mcause =0，输出PC= mepc
// ecall : mepc = ecall的PC, mcause = 2'b11
// illegal_inst : mcause = 2'b10

    
    reg [31:0] by_mstatus, by_mtvec, by_mcause, by_mtval, by_mepc;
    // 关闭写使
   // assign csrout = read_data;

    CSRRegs CSRRegs(
        .clk(clk),
        .rst(rst),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .write_data(write_data),
        .csr_w(csr_w),
        .csr_wsc_mode(csr_wsc_mode),
        .by_en(~en & ~mret),
        .by_mstatus(by_mstatus),
        .by_mtvec(by_mtvec),
        .by_mcause(by_mcause),
        .by_mtval(by_mtval),
        .by_mepc(by_mepc),
        .read_data(read_data),
        .mstatus_o(mstatus),
        .mtvec_o(mtvec),
        .mcause_o(mcause),
        .mtval_o(mtval),
        .mepc_o(mepc)
    );
    
    
    // 保存中断异常的相关信号
    always @ (*) begin
        en <= ~(mret | INT | ecall | illegal_inst | l_access_fault | j_access_fault);
            if (mstatus == 1)begin // 如果正在中断，那就不接受新的中断，此时是 trap 处理
                // 中断处理 等待mret信号 具体处理由软件实现即 trap 程序
                if (mret == 1) begin
                    by_mstatus <= 0;
                    by_mcause <= 0;
                    pc <= mepc;
                end
                // else pc <= pc_current;
            end
            else begin
                if (~en && mret == 0) begin // 这表示从正常发生中,然后将pc转到 trap 处理程序
                    by_mstatus <= 1;
                    by_mcause <= (ecall == 1) ? 2'b11 : (illegal_inst == 1) ? 2'b10 : (INT == 1) ? 2'b01 : 2'b00;
                    by_mtval <= inst_field;
                    by_mepc <= pc_current;
                    pc <= mtvec;
                end
            end       
    end
endmodule
```

以下是几个特权寄存器的作用：
- mstatus 存储当前控制状态，这里简化为1是中断状态，0是正常状态
- mtvec 存储中断向量表基地址，本次采用direct模式，存储中断处理程序的基地址
- mcause 存储中断原因，最高位1代表异常，若为中断则为0。Exception code 记录异常类型 简化为01代表硬件中断，10代表非法指令，11代表ecall指令（异常） 00代表正常执行
- mtval 存储非法指令内容
- mepc  trap 触发时将要执行的指令地址，在 mret 时作为返回地址。

==== 中断处理程序 trap

这一部分由软件实现，以下是我编写的trap汇编代码：

```asm
addi x19, x0, 40 
addi x18, x0, trap
csrrw x0, 0x305, x18 # mtvec = trap

csr_test:
    lui x28, 0x0EDCB
    addi x28, x28, 0x666
    csrrw x29, 0x300, x28 # m tstatus = 0x0EDCB666
    lui x18, 0x1235
    addi x18, x18, -1093 # x18 = 0x01234BBB
    csrrs x30, 0x300, x18 # mtstatus = 0x0FFFFFFF
    csrrwi x27, 0x300, x31 # mtstatus = 31, x27 = 0xFFFFFFFF
    addi x27, x0, 0b10101
    csrrc x29, 0x300, x27 # mtstatus = 0x0000000A, x29 = 0x31
    csrrsi x30, 0x300, x16 # mtstatus = 0x0000001A, x30 = 0xC
    csrrci x27, 0x300, x15 # mtstatus = 0x00000010, x27 = 0x1C
    csrrwi x29, 0x300, x0 # mtstatus = 0x00000010, x29 = 0x10
    csrrsi x28, 0x300, x0 # mtstatus = 0x00000010, x28 = 0x10
    csrrci x27, 0x300, x0 # mtstatus = 0x00000010, x27 = 0x10

Exception_test:
    nop # INT test # 
    ecall # 
    nop # illegal instruction
    lui x31, 0x666
    
dummy:
    nop
    nop
    nop
    nop
    nop
    jal x0, dummy

trap:
    addi x19, x19, -20
    sw x20, 0(x19)
    sw x21, 4(x19)
    sw x22, 8(x19)
    sw x23, 12(x19)
    sw x24, 16(x19)

    csrrwi x20, 0x300, x0 # mstatus
    csrrwi x21, 0x305, x0 # mtvec
    csrrwi x22, 0x341, x0 # mepc
    csrrwi x23, 0x342, x0 # mcause
    csrrwi x24, 0x343, x0 # mtval

    srai x28, x23, 1 
    andi x28, x28, 1 # x28 = 1 异常， x28 = 0 中断
    beq x28, x0, Interruption
    jal x0, Exception
    nop
    nop
    nop

Exception:
    addi x29, x22, 4
    csrrw x0, 0x341, x29 # mepc = mepc + 4
    beq x0, x0, ret

Interruption:
    nop
    nop
    beq x0, x0, ret

ret:
    lw x24, 16(x19)
    lw x23, 12(x19)
    lw x22, 8(x19)
    lw x21, 4(x19)
    lw x20, 0(x19)
    addi x19, x19, 20
    nop #mret
```

前一部分是对特权寄存器的测试，后一部分异常处理程序。测试时使用的也是上面代码生成的指令。

=== 仿真测试

==== 测试代码

在testbench中添加了一个INT输入，用于表示外部中断信号。仿真代码与之前相同。

==== 仿真波形

#figure(  image("2024-05-08-23-39-13.png", width: 100%),  caption: "中断仿真",)  

首先是全局的仿真波形，寄存器堆中的三个凹代表了三次中断异常的过程。第一次是ecall指令，第二次是非法指令，第三次是INT中断。最后进入了dummy死循环。

接下来分析前面的测试程序；

#figure(  image("2024-05-08-23-40-10.png", width: 100%),  caption: "中断仿真",) 

- 前两条指令是先写入内存指针，用于开辟栈空间，第二个是将trap处理程序的位置写入mtvec寄存器
- 接下来的几条指令都是对特权寄存器的测试，通过csrrw,csrrs,csrrc,csrrwi,csrrsi,csrrci指令对特权寄存器进行读写操作可以看到与预期一致（在汇编代码中写出预期结果）

下面分析异常处理程序：

如果接收到异常中断信号，就跳转到mtvec位置，然后开辟栈指针，将要使用的寄存器的值存入，然后将csr寄存器保存下来，然后判断异常类型，如果是异常就跳转到异常处理程序，如果是中断就直接返回。
中断与异常处理的区别在于中断mepc不变，异常mepc+4。即中断返回到中断发生的地方，异常返回到异常发生的下一条指令，跳过异常指令。

=== 下板验证

#figure(  image("2024-05-08-23-49-09.png", width: 80%),  caption: "中断验证1",) 
此时是ecall指令，接下来要跳转到trap处理程序。其pc为6C

#figure(  image("2024-05-08-23-51-18.png", width: 80%),  caption: "中断验证2",)

观察此时CSR寄存器的值，可以看到mstatus = 1，mtvec = 6C，mcause = 3，mtval = 0，mepc = 48，随后继续程序，直到mret指令。

#figure(  image("2024-05-08-23-52-48.png", width: 80%),  caption: "中断验证3",)

mret指令，此时的mepc变为4C，与预期相符合，到了原来异常指令的下一条。

#figure(  image("2024-05-08-23-54-26.png", width: 80%),  caption: "中断验证4",) 

可以看到，返回后的pc = 4C，说明程序正确，同时这也是一条非法指令，接下来再次进入trap处理程序。

#figure(  image("2024-05-08-23-56-11.png", width: 80%),  caption: "中断验证5",) 

这次是非法指令，mcause = 2，mtval = 00000007，mepc = 4C，接下来继续程序，直到mret指令。

#figure(  image("2024-05-08-23-57-11.png", width: 80%),  caption: "中断验证6",) 

可以看到，此时的mepc变为50，与预期相符合，到了原来异常指令的下一条。

接下来再进行一次硬件中断。输入前的pc为50，最后mret时pc也为50，说明中断处理程序正确。

#figure(  image("2024-05-08-23-58-52.png", width: 80%),  caption: "中断验证7",) 

综合以上，我们的trap程序是正确的。

#pagebreak()

== 思考题

不能得到，第一条指令执行后，x6 = 0xDEADB000，但是在I-type的立即数生成中使用的是有符号扩展，得到的立即数是0xFFFFFEEF，所以最后的结果应该是，x6 = 0xDEADAEEF。

解决方式可以是给前面的立即数加1即第一条指令改为`lui t0,0xDEADC`这样就抵消了后面位扩展带来的影响。

== 实验总结

在报告截止的前一天晚上调通了所有的程序，然后拖延症导致报告在截止前还没写完（悲）。但其实报告的内容也并没有很详尽，如果对每一条指令都进行详尽的分析会使得报告的篇幅巨长，所以只对关键的部分进行了分析，比如4-3的最后Reg31值应该是666，4-4的中断处理关键点的特权寄存器的值，这些我认为是最重要的部分。其实开始的时候是想过分析每一条指令的，但是写不动了（摊），写了一半又都注释掉了。一开始其实是按照4-1，4-2的顺序完成的，但是后来在修改数据通路的时候发现给的数据通路并不能满足要求，而且要改的地方很多，所以就推翻重做了，直接画了个新的数据通路，然后增加了拓展指令的控制信号。

在做的过程中有很多波折，这次实验前前后后应该做了半个月，在五一之前花了两天把4-3完成，然后在五一结束以后两天把中断写完。两部分都遇到了仿真顺利但是下板爆炸的情况。其中第一次的问题是RAM不知道出了什么问题，重新生成一下下板就通过了（白白查了3个小时的信号）。第二次的问题是CPU_ctrl没有完善，在新增了中断的指令和CSR指令后，没有把全部的信号都约束上，这样就导致一些信号还是上一条指令的值或者是一些未知的值，这就导致了上板后的结果不对。最后这些问题也都得到了解决。另外在修改代码的过程中也思考了关于时序和组合的问题，很多时候也许是时序的问题导致了下板时候与仿真不同，因此修改后的时序与组合的逻辑相对而言更加清晰。

这次对硬件的debug真的是相当痛苦，真的很需要耐心，好在最后都顺利完成了。这次要使用掉一天的自由时间，希望下次流水线能够在ddl之前完成，不能再拖了！