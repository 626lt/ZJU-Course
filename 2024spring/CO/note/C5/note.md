cache相关：

1. block: 缓存的最小单位，一般是2的幂次方大小，一般是64B，可能有复数个words
2. hit：在cache中找到了所需的数据，在upper level中找到了所需的数据
   + hit ratio: hit次数/总次数 指令一般是0.9，数据一般是0.6
   + hit time：一部分是访问的时间，一部分是决定是否命中的时间
3.  Miss：block copied from lower level to upper level
   + Time taken: miss penalty
   + Miss ratio: miss次数/总次数 = 1-hit ratio


SRAM：速度快，成本高
DRAM：速度低，容量大
Flash：
Disk：最便宜，最慢，机械装置

一个block在upper level中的位置通过取模的方式确定
tag:存在cache中的地址，是higher-bits
Valid bit: 0表示是空的，1表示有数据。初始化为0

32位中，一个byte = 8 bits；一个word = 4 bytes = 32 bits

16KB data，4-word block，32bit address

Valid + Tag + Data
+ Valid: 1 bit
+ Tag: 32-10-4 = 18 bits
+ Data: 4*32 = 128 bits

需要 16KB/16 = 1K blocks INdex bits = 10
Tag = address - INdex - Offset = 32-10-4 = 18

64 blocks, block size is 16 bytes, 1200 map to.

1200 / 16 = 75 说明是在第75个block，在cache里是 75 mod 64 = 11

cache是为了解决速度
virtual memory是为了size

计组 https://classroom.zju.edu.cn/livingpage?course_id=49844&sub_id=857587&tenant_code=112 期中