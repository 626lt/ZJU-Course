io 三个特征：

+ Behaviour: Input,Output,storage
+ Partner: 与人交互，与machine交互
+ Data rate：峰值速率

I/O性能评估：
+ throughtput: 吞吐量
  + 数据大小
  + 任务个数
+ 响应速度：workstation PC
+ both throughput and response time（ATM）

I/O很重要但是很容易被忽略

I/O对于系统的整体速度提升也很重要：Amdahl's Law

## Disk storage and dependability

+ floppy disk
+ hard disk：larger，higher density，higher data rate， more than one platter
  
The organization of hard disk:
+ platters:disk consists of a collection of platters, each of which has two recordable disk surfaces
+ tracks: each disk surface is divided into concentric circles
+ sectors: each track is in turn divided into sectors, which is the smallest unit that can be read or written

To access data of disk:
+ seek:position read/write head over the proper track（寻道时间，一般是大头）
  + minium seek time
  + maximum seek time
  + average seek time(3-14ms)
+ Rotational latency: wait for the desired sector to rotate under the read/write head（旋转延迟，）
  + average rotational latency: 1/2 * rotation period
+ Transfer time: time to transfer a sector(1 KB/sector) function of rotation speed, Transfer rate of today’s drives - 30 to 80 MBytes/second（传输时间）
+ Disk controller: which controls the transfer between the disk and the memory

Disk dependability:可依赖性

评价：

+ MTTF: Mean Time To Failure 平均无故障时间
+ MTTR: Mean Time To Repair 平均修复时间
+ MTBF: Mean Time Between Failure = MTTF + MTTR 平均故障间隔时间
+ Availability: A = MTTF/(MTTF + MTTR) 可用性

提高MTTF方法：
+ Fault avoidance:使用指令来避免故障
+ Fault tolerance:容错，使用冗余来避免故障
+ Fault forecasting:预测故障，提前维护

The hamming SEC code
+ Hamming distance
  + Number of bits that are different between two bit patterns
+ Minimum distance = 2 provides single bit error detection
  + E.g. parity code
+ Minimum distance = 3 provides single error correction, 2 bit error detection

Use arrays of disks to improve dependability

Array Reliability:
+ reliability of N disks = Reliability of 1 disk / N
+ Arrays without redundancy too unreliable

解决方案：Redundant Arrays of Inexpensive Disks（RAID）


小测2:

第一题：1. 计算一下cpi，有stall和没有stall(perfect CPI)；类似作业题5.10 指令miss的概率和data概率然后计算 2.double clock rate 计算cpi
第二题：根据pipline算时钟周期(最长阶段)，执行100条指令需要多少周期 n+k-1；单周期/pipline 执行100条的比；每秒钟执行多少指令;
给了一段code，问data hazard，第一问插nop；第二问调整顺序，让插入的nop减少；第三问根据插入的nop计算cpi，注意区分double dump，考试的时候一般按照double dump计算；第四问：load use data 的 cpi比率
画图题，forwarding，hazard detection.
第三题：cache 算block size，num of block(Index/ n-way set);访问地址走一遍\<index,tag,data\> Hit/miss
第四题：虚拟内存，页表，计算内存最大容量；页表多大，虚拟地址位数()-页内偏移量（页大小决定16kB=2^14）= 虚拟页的位数再乘以每个页表大小