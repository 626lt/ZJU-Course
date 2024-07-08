# The Processor

![alt text](image.png)

## Introduction

CPU performance factors

* Instruction count  
Determined by ISA and compiler  
如同样的功能用 Intel 和 RISC-V 的处理器实现，英特尔的指令用的更少（因为更复杂）
* CPI and Cycle time  
Determined by CPU *hardware*

### 指令执行

For every instruction, the first two steps are identical

* Fetch the instruction from the memory
* Decode and read the registers

Next steps depend on the instruction class  

* Memory-reference  
`load, store`
* Arithmetic-logical  
* branches  

PC = PC + 4 or target address

### CPU 组成部件

#### ALU

* Arithmetic Logic Unit
* ![alt text](image-2.png)

#### Memory

![alt text](image-3.png)

#### 寄存器组 register file

![alt text](image-4.png)

前面实验2已经实现过

#### Immediate Generation

输入指令产生立即数的逻辑功能
+ 根据指令类型(加载，存储或者分支指令)，产生相应的立即数 
  
转移指令偏移量左移位的功能
+ 立即数字段符号扩展为64位结果输出

![alt text](image-5.png)

![alt text](image-6.png)


### CPU Overview

![alt text](image-1.png)

* Use ALU to calculate
    * Arithmetic result
    * Memory address for load/store
    * Branch comparison  
    因为我们是单周期，因此 ALU 只能做比较，具体跳转的地址由单独的 Adder 计算。
* Access data memory for load/store
* PC $\leftarrow$ target address or PC + 4  

!!! Question
    为什么指令要和内存分开？  
    因为我们是单周期，我们无法在同一个周期内既读指令又读数据。

Can’t just join wires together -- *Use multiplexers*.  

### Logical Design Convention 设计公约

* Information encoded in binary
    * Low voltage = 0, High voltage = 1
    * One wire per bit
    * Multi-bit data encoded on multi-wire *buses*  
* Combinational element
    * Operate on data
    * Output is a function of input
* State (sequential) elements  
Store information

## Build a datapath

Elements that process data and addresses in the CPU.  

同类指令的 opcode 是一样的（I 型指令的里逻辑运算、load 指令、jal 不同），具体功能由 Func 决定。（因此不把所有操作编到 opcode 内）

### Instruction execution in RISC-V

* **Fetch**:
    * Take instructions from the instruction memory 
    * Modify PC to point the next instruction
* **Instruction decoding & Read Operand**: 
    * Will be translated into machine control command 
    * Reading Register Operands, whether or not to use 
* **Executive Control**:
    * Control the implementation of the corresponding ALU operation 
* **Memory access**:
    * Write or Read data from memory 
    * Only ld/sd
* **Write results to register**:
    * If it is R-type instructions, ALU results are written to rd
    * If it is I-type instructions, memory data are written to rd
* **Modify PC for branch instructions**

### Datapath

连线根据数据流图连接，按照上面的步骤实现。

## control unit

||ALUSrcB|MemtoReg|Reg Write|Mem Read|Mem Write|Branch|Jump|ALUOp1|ALUOp0|
|-|-|-|-|-|-|-|-|-|-|
|addi|1|00|1|1|0|0|0|1|1|
|jalr|1|10|1|1|0|0|1|0|1|
|lui|x|10|1|1|0|0|1|0|1|
|auipc|1|00|1|1|0|0|0|0|1|


### Exception

+ Exception 异常  同步的
  + 一般是CPU内部的错误，比如溢出，内存越界，未定义opcode等
+ Interrupt 中断  异步的
  + 一般是外部的错误，比如键盘输入，时钟中断等从外部的IO设备传来的信号

#### 处理 Exception

1. 保护CPU现场，进入异常 

+ Save PC of offending (or interrupted) instruction
  + In RISC-V: Supervisor Exception Program Counter(SEPC)
+ Save indication of the problem
  + In RISC-V: Supervisor Exception Cause Register(SCAUSE)
+ 64 bits, but most bits unused
e.g. Exception code field: 2 for undefined opcode, 12 for hardware malfunction...

2. 处理中断事件

+ Jump to handler，mtvec寄存器提供地址
+ Assume at 0000 0000 1C09 0000hex

3. 退出异常，恢复正常操作   

+ 当异常程序处理完成后，最终要从异常服务程序中退出，并返回主程序。 对于机器模式，使用MRET退出指令，返回到SEPC存储的pc地址开始执行。

### Risc-V Privileged

+ RISC-V Privileged Architecture
  + The machine level has the highest privileges
    + 是RISC-V硬件平台唯一的强制特权级别。
    + 机器模式可用于管理RISC-V上的安全执行环境

![alt text](image-7.png)
机器模式是一定要实现的

### RISC-V Privilege Modes Usage

+ Each privilege level has
  + a core set of privileged ISA extensions
    + with optional extensions and variants.

![alt text](image-8.png)