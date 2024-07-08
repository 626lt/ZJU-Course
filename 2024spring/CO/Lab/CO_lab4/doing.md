+ R-Type: add, sub, and, or, xor, slt, srl, sll, sra, sltu
+ I-Type: addi, andi, ori, xori, srli, slti, slli, srai, sltiu, lb, lh, lw, lbu, lhu, jalr
+ S-Type: sb, sh, sw
+ B-Type: beq, bne, blt, bge, bltu, bgeu
+ J-Type: jal
+ U-Type: lui, auipc

一共需要37条

+ 立即数解析 ImmGen 代码与仿真
+ Datapath 基础待debug
+ SCPU_ctrl 代码仿真通过

数据存储模块 D_mem.coe 是RAM核
Block Memory Generator

指令存储模块 I_mem.coe 是ROM核
Block Memory Generator或Distributed Memory Generator
+ 只读存储器，不支持写操作
+ 输入地址，输出相应地址空间所存储的数据

作为指令代码的存储部件
+ 输入来自CPU的PC指针输出，PC_out；在时钟信号的作用
下输出对应的指令信息作为CPU的指令输入inst[31:0]
+ ROM能否被正确访问，输出的指令信息是否正确是CPU正
常运转的关键

ROM作为指令存储器

7000ns

SW LW

rd = res_alu or Memory_data or PC + 4 or Utype

PC = PC + 4 or jump
jump = PC + imm or rs1 + imm

s = branch0 & zero //beq
s = branch1 & !zero //bne
s = branch1 & !zero //blt A < B zero = 0
s = branch0 & zero //bge A >= B zero = 1
s = branch1 & !zero //bltu
s = branch0 & zero //bgeu

1bit = 1位
1byte也就是一个字节
一个address是16位也就是两个字节
lb byte就是lb这个位置的[7:0]位

sb 写不进去 但是 MemRW 是对的 RAM的问题


mret M 模式处理 trap 之后返回前一特权模式，并将 pc 设置为 mepc 寄存器的值

处理三种中断异常，那CSR也对应三种模式

CSR寄存器

mstatus 存储当前控制状态，这里简化为1是中断状态，0是正常状态
mtvec 存储中断向量表基地址，本次采用direct模式，存储中断处理程序的基地址
mcause 存储中断原因，最高位1代表异常，若为中断则为0。Exception code 记录异常类型 简化为01代表硬件中断，10代表非法指令，11代表ecall指令（异常） 00代表正常执行
mtval 在本实验中没啥用处，存储非法指令内容
mepc  trap 触发时将要执行的指令地址，在 mret 时作为返回地址。

异常信号控制，根据输入的一系列信号，以及内部寄存器的相应值，输出将要执行的指令地址，以及中断的写使能

0x02800993
0x06C00913
0x30591073
0x0EDCBE37
0x666E0E13
0x300E1EF3
0x01235937
0xBBB90913
0x30092F73
0x300FDDF3
0x01500D93
0x300DBEF3
0x30086F73
0x3007FDF3
0x30005EF3
0x30006E73
0x30007DF3
0x00000013
0x00000073
0x00000013
0x00666FB7
0x00000013
0x00000013
0x00000013
0x00000013
0x00000013
0xFEDFF06F
0xFEC98993
0x0149A023
0x0159A223
0x0169A423
0x0179A623
0x0189A823
0x0199AA23
0x30005A73
0x30505AF3
0x34105B73
0x34205BF3
0x34305C73
0x401BDE13
0x001E7E13
0x020E0063
0x0100006F
0x00000013
0x00000013
0x00000013
0x004B0E93
0x341E9073
0x00000A63
0x341B1073
0x00000013
0x00000013
0x00000263
0x0149AC83
0x0109AC03
0x00C9AB83
0x0089AB03
0x0049AA83
0x0009AA03
0x01498993
0x00000013
