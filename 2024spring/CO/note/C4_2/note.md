#### scpu实现中的提出的issue

1. 最长的延迟路径决定了时钟周期
2. 针对不同的指令改变时钟周期是走不通的
3. 违反了设计原则：让最common的情况最快
4. 使用流水线的方式来加速

### overview

核心思路：在完成另一个指令的进程之前开启下一个指令的进程
也就是说不同的指令可以重叠（overlapped）在同一个时间进行
目的是为了给CPU提速

![alt text](image.png)

一个生动的图解：当元件空闲以后，我们就可以开始下一个指令的进程，这样就可以提高CPU的效率

#### 流水线的好处

1. 不能够提高单个指令的执行速度，但是可以提高整体的效率
2. 提高元件的利用效率，在单位时间内

### 五级流水线的设计

1. IF: Instruction Fetch from memory
2. ID: Instruction Decode & Register Read
3. EX: Execute operation or calculate address
4. MEM: Access data memory operand
5. WB: Write result back to register

### 流水线的性能 与SCPU比较

![alt text](image-1.png)

这张图是一个比较直观的比较，流水线可以在指令执行的第一步结束以后就开始下一个指令的执行，这样我们可以把时钟周期定义为第一步的时间，两条指令之间的延迟就只有第一步时间的延迟。

流水线加速：

1. 如果所有的阶段时间一样多，那么流水线指令间隔时间为非流水线执行时间/阶段数
2. 理想情况下，加速是阶段数
3. 如果阶段时间不一样多的话，那么流水线指令间隔时间为最长阶段时间，加速效果会减弱
4. 加速是提升了整体的效率，但是单个指令的执行时间不会减少，会因为有等待时间而增加。

### 流水线datapath

实际上流水线的datapath与单周期的datapath的区别在于流水线的每个stage之间都需要寄存器来存储数据；因此这也限制了流水线的周期数，因为寄存器的读写也是存在延迟的，不能够无限的增加，这样同样会产生很大的开销。

### 流水线的性能issue

1. latency: 流水线中单条指令的执行时间往往不会减少，相反会增加
2. imbalance: 要保证各个阶段的时间差不多，否则也会导致性能下降
3. Overhead: 需要增加寄存器，增加控制逻辑，增加开销
4. pipeline hazard: 数据冒险是流水线性能的主要障碍
5. 流水线的指令间隔是最长的阶段的间隔，等待这一间隔的延时和向阶段间寄存器读写的延时会导致流水线的性能下降

### Hazards

1. Structure hazards

目标resource被多个指令同时使用，比如内存，ALU等

2. Data hazards

Need to wait for previous instruction to complete its data read/write

3. hazards

Deciding on control action depends on previous instruction

#### structure hazards

Instruction fetch would have to stall for that cycle

Hence, pipelined datapaths require separate instruction/data memories 指令memory和数据memory分开

register conflicts : 上升沿写入，下降沿读取

![alt text](image-2.png)

#### Data hazards

另一种register conflicts：数据依赖 

An instruction depends on completion of data access by a previous instruction ( Data hazard )

![alt text](image-3.png)

#### Control hazards

Conflict occurs when PC update

流水线的工作原理是：Must increment and store the PC every clock. But branch instructions may change the PC

此时，改变的PC值没到ID步骤，就无效。the instructions fetched behind the branch are invalid !

### Hazards resolution

> The simplest way to "fix" hazards is to stall the pipeline

Stall means suspending the pipeline for some instructions by one or more clock cycles.

The stall delays all instructions issued after the instruction that was stalled, while other instructions in the pipeline go on proceeding.

A pipeline stall is also called a pipeline bubble or simply bubble.

No new instructions are fetched during a stall

在某条指令stall以后，后面的指令（已经被fetch）会继续执行，但是不会再fetch新的指令

什么时候stall？

Stall = control hazard || structural hazard || data hazard

Control hazard:Instruction in IF/ID or ID/EX or EX/MEM is a Branch or JMP

Data hazard:

RD of Instruction in EX/MEM == Rs1 or Rs2 of instruction in ID/EX
RD of Instruction in MEM/WB == Rs1 or Rs2 of instruction in ID/EX

如何实现stall？

软件层面：编译器可以在编译的时候就解决这个问题，增加nop指令，空出这一段时间。

硬件层面：ADD Hardware Interlock
+ Add extra hardware to detect stall situations
  + Watches the instruction field bits
  + Looks for “read versus write” conflicts in particular pipe stages
  + Basically, a bunch of careful “case logic” 
+  Add extra hardware to push bubbles thru pipe
+  Can just let the instruction you want to stall GO FORWARD through the pipe. but, TURN OFF the bits that allow any results to get written into the machine state
+   So, the instruction “executes” (it does the work), but doesn’t “save
  
实现stall的方法：

添加stall control logic
![alt text](image-4.png)

![alt text](image-5.png)

![alt text](image-6.png)

### Pipeline Hazards

#### Structural hazards

Multiple accesses to memory

+ Split instruction and data memory / multiple memory port / instruction buffer
+ Memory bandwidth need to be improved by 5 folds.

Multiple accesses to the register file

+ Double bump 读写分开

Not fully pipelined functional units

#### Data hazards

An instruction depends on completion of data access by a previous instruction

+ Forwarding
Use result when it is computed
Don’t wait for it to be stored in a register
Requires extra connections in the datapath

![alt text](image-7.png)

![alt text](image-8.png)

这里sub需要用到ld读出的值，因此必须要停一个周期让MEM读出的结果输入到EX阶段

![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)

#### Control hazards

![alt text](image-12.png)