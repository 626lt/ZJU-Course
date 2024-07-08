# Chapter 2 Instructions: Language of the Computer

## introduction

+ 计算机的语言
  + 指令
  + 指令集
+ 设计目标
  + 最大化performance
  + 最小化cost
  + 减少设计时间
+ 学习的指令集：RISC-V   

### 指令特征

![alt text](image.png)

指令集基本的结构：Operation 操作; Operand 操作数
+ 不同指令集，指令的编码可以不同。如 000 表示加法，这也叫指令的 Encoding.
+ 操作数位宽可以不同，可以是立即数/寄存器/内存。

### 处理器中内部存储的类型

+ stack
+ accumulator
+ general-purpose register
  + register-memory
  + register-register:load/store

#### 指令操作数中允许内存的数量

![alt text](image-1.png)

### variable

指令里的变量指向硬件
+ register
+ memory address
  + dispalcement 偏移量
  + immediate 立即数
+ stack

## operations

任何机器都要进行算术运算：
+ 一条指令只进行一次运算
+ 恰好三个变量
**设计原则1：simplicity favors regularity 简单源自规整**
+ 指令包含三个操作数 注意结果放在第一个位置，有利于解码

!!! example c & risc-v
    ```c
    A = B + C;
    ```
    ```risc-v
    add a0, b0, c0
    ```

!!! example 

    ```c
    f = (g + h) - (i + j);
    ```
    ```risc-v
    add t0, g, h
    add t1, i, j
    sub f, t0, t1
    ```
## operands 操作数

+ register operands 寄存器操作数
+ memory operands 内存操作数
+ constant or immediate operands 常数或立即数操作数

### register operands 寄存器操作数

+ Arithmetic instructions operands must be registers or immediate
  + risc-v: 32 个 registers `x0` - `x31`
  + 64-bits for each register in risc-v
+ Deisgn Principle 2: smaller is faster 
  寄存器不是越多越好，多了之后访问慢。
+ RISC-v register operand
  + size is 64 bits, which named doubleword

    |Name|Register Name|Usage|Preserved or call?原先的值是否要存起来，调用完是否要恢复原样|
    |:-|-|-|-|
    |x0|0|The constant value 0|n.a.|
    |x1(ra)|1|Return address(link register)|yes|
    |x2(sp)|2|Stack pointer|yes|
    |x3(gp)|3|Global pointer|yes|
    |x4(tp)|4|Thread pointer|yes|
    |x5-x7|5-7|Temporaries|no|
    |x8-x9|8-9|Saved|yes|
    |x10-x17|10-17|Arguments/results|no|
    |x18-x27|18-27|Saved|yes|
    |x28-x31|28-31|Temporaries|now|

    ![alt text](image-2.png)

    !!!info 为什么寄存器 `x0` 一直为 0
        Make the common fast. 因为经常有 0 参与计算，将其存在一个寄存器中，便于计算。

    !!! Example
        ``` C
        add x5, x20, x21
        add x6, x22, x23
        sub x19, x5, x6
        ```

### memory operands 内存操作数

+ advantage
  + 可以存储大量数据
  + 可以存储复杂数据结构
    + 数组、数据结构等

由于算术运算只能对寄存器操作数进行，所以要对内存的数据进行运算就要先把内存数据取出来，即需要load/store指令。

+ Data transfer instructions
  + Load: from memory to register; load doubleword ( ld )
  + store:from register to memory; store doubleword( sd )

+ Memory is byte addressed: Each address identifies an 8-bit byte
+ risc-v 是小端模式
  + Least-significant byte at least address of a word
  + 对应的是Big-endian模式：most-significant byte at least address
+ risc-v 不要求对齐
  + words align: 一个字是 4 字节，我们要求字的起始地址一定要是 4 的倍数。
  + 不对齐的好处是省空间

    !!! example
        ![alt text](image-4.png)第一个是对齐的，第二个是不对齐的。


#### endianess/byte order
![alt text](image-3.png)

!!! memory operands example

    ```c
    A[12] = h + A[8];(h -- x21 base address of A -- x22)
    ```
    ``` risc-v
    ld x9, 64(x22)
    add x9, x21, x9
    sd x9, 96(x22)
    ```
    地址是以字节为单位的，所以偏移8字节就是64位。
    load/store 是唯二可以访问memory的指令

!!! example 如何表示`g = h + A[i]`

    ![alt text](image-5.png)
    一个地址移8位，所以先乘8，再加上基地址。

### Registers vs. Memory

* Registers are faster to access than memory  
* Operating on memory data requires loads and stores  
* Compiler must use registers for variables as much as 
possible  
编译器尽量使用寄存器存变量。只有在寄存器不够用时，才会把不太用的值放回内存

### Constant or Immediate Operands

**Immediate**: Other method for adding constant  

* Avoids the load instruction  
* Offer versions of the instruction   
***e.g.*** `addi x22, x22, 4`    
* **Design Principle 3 - Make the common case fast.**
* constant 0: a register `x0`    

!!! Summary

    ![alt text](image-6.png)

     * 为什么内存是 $2^{61}$ 个 doublewords?  
    可以表示的地址有这么多，因为我们以 64 位寄存器为基址，可以表示的双字就是 $2^{64}/2^3=2^{61}$ (这里 $2^3$ 表示 8 个字节，即双字). 即我们的 `load` 指令可以访问的范围有这么大。   

## 有符号数和无符号数

## Representing Instructions in the Computer

* All information in computer consists of binary bits.
* Instructions are encoded in binary  
called **machine code (机器码)**  
* Mapping registers into numbers  
0 for register `x0`, 31 for register `x31`. **e.t.c.**  
* RISC-V instructions   
32 位指令编码。所有指令都是规则化的，即一部分是 opcode, 一部分是 operands 等等。  

!!! summary

    ![alt text](image-7.png)

### R-format

![alt text](image-8.png)

* *opcode*: operaion code
* *rd*: destination register number
* *funct3*: 3-bit function code(additional opcode)   
例如，我们加法减法可以做成一个 opcode, 然后利用 funct 进行选择。
* *rs1/rs2*: the first/second source register number
* *funct7*: 7-bit function code(additional opcode)  

<u>**Design Principle 4 - Good design demands good compromises**</u>好的设计需要折中
+ risc-v所有指令都是32位的，这样可以方便解码。
  + 但这也导致了指令只能简单，不能太复杂。

### I-format  

![alt text](image-9.png)

* Immediate arithmetic and load instructions  
***e.g.*** `addi`, `ld`  
* *rs1*: source or base address register number
* *immediate*: constant operand, or offset added to base address  
将 rs2, funct7 合并了，得到 12 位立即数
![alt text](image-10.png)

### S-format
![alt text](image-11.png)
* *rs1*: base address register number
* *rs2*: source opearand register number
* immediate:  
Split so that *rs1* and *rs2* fields always in the same place.  
![alt text](image-12.png)

!!! summary Summary of R-, I-, S-type instruction format
    ![alt text](image-13.png)

!!! example
    ![alt text](image-14.png)
    ![alt text](image-15.png)
    sd 指令中立即数应为240，这里分成两段存储。240=111 10000，前7位存储在 imm[11:5]，后5位存储在 imm[4:0]。

### Stored program

+ 指令也是以数字的形式存储
+ 那么程序也可以像数字一样存储在内存中

![alt text](image-16.png)

### logical operations

![alt text](image-17.png)

sll: shift left logical
srl: shift right logical
sra: shift right arithmetic

#### shift

![alt text](image-18.png)

I型指令
为什么有funct6：移位用不到这么多位，最多也只要$2^6=64$位

#### AND

![alt text](image-19.png)

#### OR

![alt text](image-20.png)

#### XOR

![alt text](image-21.png)

#### NOT

通过异或实现，与全1异或

### Instructions for making decisions

#### Branch instructions

`beq reg1, reg2, Label` 如果相等就跳转
`bne reg1, reg2, Label` 如果不等就跳转

store 的立即数是作为数据的地址, beq 的立即数是作为运算的地址（加到 PC 上）因此二者的指令类型不同。

跳转的范围有限制，因为立即数只有 12 位。（PC 相对寻址，以当前程序位置为基准前后跳）

!!! example 基于跳转指令实现循环

    ![alt text](image-22.png)

#### More condition instructions

`blt rs1 rs2 L1` rs1 < rs2 跳转 branch less than
`bge rs1 rs2 L1` rs1 >= rs2 跳转 branch greater or equal

slt: set less than

`slt rd rs1 rs2` 如果 rs1 < rs2, rd = 1, 否则 rd = 0
R型指令

#### signed/unsigned

默认是有符号数的比较
+ Signed comparison: `blt`, `bge`
+ Unsigned comparison: `bltu`, `bgeu`

加i的指令是与立即数相关。

#### Case/switch

![alt text](image-23.png)
![alt text](image-24.png)
![alt text](image-25.png)
`jalr x1 100(x6)`后面就是要跳转到的位置，然后把返回地址即下一条指令的地址存到 x1 中。
`jal x1 addr`只有基地址，如果要用寄存器要用`jalr`指令。

#### basic block

![alt text](image-26.png)
中间没有跳转和被指向的位置，就是基本块。对于编译器而言，基本块是最好处理的

### Supporting Procedures in Computer Hardware

Procedure/function --- be used to structure programs
为了完成特定任务。易于理解，可以复用。

调用函数的步骤

1. Place Parameters in a place where the procedure can access them (in registers x10~x17)
传参
2. Transfer control to the procedure
控制权给子程序
3. Acquire the storage resources needed for the procedure
4. Perform the desired task
5. Place the result value in a place where the calling program can access it
6. Return control to the point of origin (address in x1)

#### Procedure call instructions

`jal` jump and link
`jal x1, ProcedureLabel` 
+ Address of following instruction put in x1,x1实际上是PC+4作为下一条指令的位置
+ Jump to ProcedureLabel

`jalr` jump and link register
`jalr x0 0(x1)`
+ Like jal, but jumps to 0 + address in x1
+ Use x0 as rd (x0 cannot be changed)
+ Can also be used for computed jump

不能用 `jal` 跳回来，跳进函数的地址的是固定的, `Label` 一定。但是跳回来的地址不一定，要用 `x1` 存储才能跳回。

#### Registers for procedure calling

+ x10~ x17: eight argument registers to pass parameters or return values 
+ x1: one return address register to return to origin point
  
#### Stack:Ideal data structure for spilling registers

栈是从高地址开始放的，sp（stack pointer）一个指向栈顶的指针。
+ push ：sp = sp - 8
+ pop ：sp = sp + 8

!!! example

    ![alt text](image-27.png)
    ![alt text](image-28.png)
    ![alt text](image-29.png)
    汇编指令的前三行就是开辟栈顶空间，然后把要用的寄存器的值存到栈中，最后再恢复。

|Name|Register Name|Usage|Preserved or call?|
|:-|-|-|-|
|x0(zero)|0|The constant value 0|n.a.|
|x1(ra)|1|Return address(link register)|yes|
|x2(sp)|2|Stack pointer|yes|
|x3(gp)|3|Global pointer|yes|
|x4(tp)|4|Thread pointer|yes|
|x5-x7(t0-t2)|5-7|Temporaries|no|
|x8(s0/fp)|8|Saved/frame pointer|yes|
|x9(s1)|9|Saved|yes|
|x10-x17(a0-a7)|10-17|Arguments/results|no|
|x18-x27(s2-s11)|18-27|Saved|yes|
|x28-x31(t3-t6)|28-31|Temporaries|no|
|PC| - |Auipc(Add Upper Immediate to PC)|yes|

* `t0~t6` 临时寄存器，不需要在函数中保存 
* `s0~s11` saved registers  
标有 Preserved 表明我们需要在函数开始时保存该寄存器的值，并在离开函数前恢复寄存器的值。
![alt text](image-30.png)
寄存器一般靠堆栈保存, sp 靠加减保存。

!!! example Nested Procedure 嵌套程序

    ![alt text](image-32.png)

![alt text](image-31.png)

+ C语言变量对应的寄存器
![alt text](image-33.png)
x8/fp 用来存储栈帧指针，x3/gp 用来存储全局指针。
因为sp始终是在变化的，就用两个新的指针来固定位置，从而方便读取
![alt text](image-34.png)

### Communicating with People

* Byte-encoded character sets  
***e.g.*** ASCII, Latin-1
* Unicode: 32-bit character set  
***e.g.*** UTF-8, UTF-16 

编码中有不同长度的数据，因此也需要有不同长度的 load 和 store.  

* Load byte/halfword/word: *Sign extend* to 64 bits in rd    
我们的寄存器是 64 位的，因此需要扩充。
    * `lb rd, offset(rs1)`
    * `lh rd, offset(rs1)`
    * `lw rd, offset(rs1)` 
    * `ld rd, offset(rs1)` 

    !!! Example
        同样是取 A[4] 的值，不同的数据类型 offset 不同。`char` 为 4, `short int` 为 8, `int` 为 16.  

* Load byte/halfword/word unsigned: *0 extend* to 64 bits in rd
    * `lbu rd, offset(rs1)`
    * `lhu rd, offset(rs1)`
    * `lwu rd, offset(rs1)`
* Store byte/halfword/word: Store rightmost 8/16/32 bits  
    * `sb rs2, offset(rs1)`
    * `sh rs2, offset(rs1)`
    * `sw rs2, offset(rs1)`
存储就不需要考虑扩充问题，我们不做运算，只是把对应部分放到对应位置。  
offset 可以是 3. 因为 RISC-V 是可以不对齐的。（实际上 sh offset 一般是 2 的倍数, sw 是 4 的倍数）  

#### string

表示字符串有下面三种方式：

1. 在字符串开头放长度
2. 使用一个伴随变量
3. 使用一个特殊的结束符

!!! example

    ![alt text](image-35.png)
    ![alt text](image-36.png)
    对于一个 leaf procedure(不再调用其他 procedure) 编译器要尽可能用完所有的临时寄存器，再去用其他的寄存器。
    为什么强调 leaf procedure? - 因为对于非 leaf 的函数，可能临时变量会被调用后的函数改变，这样就不能继续用了。

### RISC-V Addressing for Wide Immediate and Addresses

+ 大部分的常数都是很小的
  + 12-bit immediate is sufficient
+ 对于偶有的32位常数
  ![alt text](image-37.png)
  `lui reg, imm` 可以把 20 位的常数放到寄存器中。(U-type)
  ![alt text](image-38.png)低位要填充0

!!! note load a 32-bit constant
    ![alt text](image-39.png)
    `lui` 是把 PC 的高 20 位加上一个立即数，然后存到寄存器中。  
    `addi` 是把寄存器的值加上一个立即数，然后存到另一个寄存器中。

#### Branch Addressing

SB-type
![alt text](image-40.png)
* PC-relative addressing  
$Target\ address = PC + Branch\ offset = PC + immediate \times 2$  
这里低位会默认补 0. 这样可以把地址范围扩大一倍。

#### jump Addressing

Jump and link (jal) target uses 20-bit immediate for larger range

UJ format: `jal x0, 2000` 只有jal

![alt text](image-41.png)

![alt text](image-42.png)

!!! example show branch offset in machine language

    ![alt text](image-43.png)
    ![alt text](image-44.png)


#### RISC-V Addressing Summary

寻址方式是指令集的核心区别。

* **立即数寻址** `addi x5, x6, 4`
* **寄存器寻址** `add x5, x6, x7`
* **基址寻址** `ld x5,100(x6)`
* **PC 相对寻址** `beq x5,x6,L1`

![alt text](image-45.png)

## summary

![alt text](image-46.png)
![alt text](image-47.png)
![alt text](image-48.png)
![alt text](image-49.png)
![alt text](image-50.png)
![alt text](image-51.png)
![alt text](image-52.png)

Decoding Machine Language

根据opcode 判断具体指令种类，然后再根据func3, func7 等判断具体操作。

## Parallelism and Instructions: Synchronization

* Two processors sharing an area of memory
    * P1 writes, then P2 reads
    * Data race if P1 and P2 don’t synchronize
        * Result depends of order of accesses
* Hardware support required
    * **Atomic** read/write memory operation
    * No other access to the location allowed between the read and 
    write
* Could be a single instruction
    * **e.g.*** **atomic swap** of register ↔ memory
    * Or an atomic pair of instructions

Load reserved: `lr.d rd,(rs1)`  
把地址 rs1 的值放到寄存器 rd 中，同时

Store conditional: `sc.d rd,(rs1),rs2`
把寄存器 rs2 的值放入地址 rs1.  
如果成功那么 rd 里面是 0. 如果上条指令 load 后，这个地方的值被改变了，那么就失败了，返回 0. 

!!! example

    ![alt text](image-53.png)

## Translating and starting a program

![alt text](image-54.png)

### Producing an Object Module

Provides information for building a complete program from the pieces(Header).  

![alt text](image-55.png)

* Text segment: translated instructions
* Static data segment: data allocated for the life of the program
* Relocation info: for contents that depend on absolute location of loaded program
* Symbol table: global definitions and external refs
* Debug info: for associating with source code

### Link

Object modules(including library routine) $\rightarrow$ executable program

* Place code and data modules symbolically in memory
* Determine the addresses of data and instruction labels
* Patch both the internal and external references (Address of invoke)

### Loading a Program

Load from image file on disk into memory

1. Read header to determine segment sizes
2. Create virtual address space
3. Copy text and initialized data into memory  
Or set page table entries so they can be faulted in
4. Set up arguments on stack
5. Initialize registers (including sp, fp, gp)
6. Jump to startup routine  
Copies arguments to x10, … and calls main
pWhen main returns, do exit syscall

### Dynamic Linking

Only link/load library procedure when it is called.  
静态链接已经编入文件了，动态链接是在运行时链接，可以用到最新的代码  

* Requires procedure code to be relocatable
* Avoids image bloat caused by static linking of all 
(transitively) referenced libraries
* Automatically picks up new library versions

#### lazy linkage

![alt text](image-56.png)

### Arrays versus Pointers

指针是可以改变的，但是数组首地址不能改变，因此翻译成汇编的结果也有所不同。

![alt text](image-57.png)

### Instruction Set Extensions

* M: integer multiply, divide, remainder
* A: atomic memory operations
* F: single-precision floating point
* D: double-precision floating point
* C: compressed instructions  
16 位的指令，用于低成本产品（嵌入式）

**Fallacies** (谬误)

* Powerful instruction $\Rightarrow$ higher performance
* Use assembly code for high performance
* Backward compatibility $\Rightarrow$ instruction set doesn’t change  

**Pifalls** (陷阱) 

* Sequential words are not at sequential addresses (应该 +4)
* Keeping a pointer to an automatic variable after procedure returns 