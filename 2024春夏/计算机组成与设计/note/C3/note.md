## 1.Introduction

Instructions can be divided into 3 categories
+ memory-reference instructions: lw, sw 读取和存储(load word，stop word)
+ arithmetic-logical instructions：e.g. add, sub, and, or, xor, slt(比较指令) 需要 ALU 进行计算
+ control flow instructions：e.g. beq, bne, jal;分支指令，跳转指令，也要用到 ALU

## 数的表示(Numbers)

### 有符号数和无符号数(sign and unsigned numbers)

+ 无符号数：unsigned number 所有的位数都代表着实际大小的数值，n位二进制数表示范围是：$0 \to 2^n-1$
+ 有符号数：一般是最高位表示符号，0为正，1为负。n位二进制数表示范围是：$-2^{n-1} \to 2^{n-1}-1$
  + $(1000 0000)_2 = -128$
  + $(0111 1111)_2 = 127$
+ 补码和反码：
  + 1‘s complement: 反码，符号位不变，其余位取反
  + 2‘s complement: 补码，符号位不变，其余位取反加1  
+ Two‘s Biased notation
  + $[x]_b = 2^n + x$
  + 需要这一移码的原因是希望比较大小的时候，可以直接比较二进制数的大小，带着符号位比较。
  ![alt text](image.png)

### 位扩展(Extension)

+ 位扩展：将低位的符号位扩展到高位，保持数值不变

## Arithmetic(算术运算)

+ Addition：直接加
+ Subtraction
  + 直接减
  + 加上 2‘s complement
+  overflow：溢出 $C_n \oplus C_{n-1}$
+  ![alt text](image-1.png)

串行进位加法器的速度受到进位的限制，以下几个是加速的方法：(fast adder)
+ Carry look-ahead adder
  + Calculating the carries before the sum is ready
+ Carry skip adder
  + Accelerating the carry calculation by skipping some blocks
+ Carry select adder
  + Calculate two results and use the correct one

<!-- #### Carry look-ahead adder
+ Given Stage i from a Full Adder, we know that there will be a carry generated when $A_i = B_i =$ "1", whether or not there is a carry-in.当两个加数都是1的时候一定会有进位发生，不管输入的进位有没有。
+ 替代的方案是，there will be a carry propagated if the
“half-sum” is "1" and a carry-in, $C_i$ occurs, then $C_{i+1}$=1
+ <img src = image-2.png width = 20%>
+ generate, denoted as Gi . propagate, denoted as Pi
+ In the carry lookahead adder, in order to reduce the length of the carry chain, Ci is changed to a more global function spanning multiple cells
+ ![alt text](image-3.png) -->

### Multiplication（乘法）
无符号乘法：
以64位乘法器为例：
version1:
<center><img src = image-4.png width = 60%></center>
流程图
<center><img src = image-5.png width = 60%></center>
这要求64次迭代，每次包含加法，移位，比较。很大！很慢！

version2:
实际上的加法只发生在64bit的结果上，所以只需要一个64位的ALU，我们用移位结果来代替移位被乘数。
![alt text](image-6.png)
![alt text](image-7.png)

verison3:
这比version2少用一个寄存器。结果128位，开始高64位设0，低64位放乘数，每次判断最低位是否为1，是的话就给高位加上被乘数，然后右移一次。如果是0，那直接右移即可。
![alt text](image-8.png)
+ Set product register to '0'
+ Load lower bits of productregister with multiplier
+ Test least significant bit of product register

Signed Multiplication（有符号乘法）:

version1:
+ 存下符号位
+ 把有符号数转化为无符号数
+ 作无符号乘法
+ 再把符号位转化回去

version2（改进版本）:Booth's Algorithm

![alt text](image-10.png)

如果乘数里有一串的1，就加上1变成一个高位的1，然后再减去一个1.这样做的优化在于，减少了加法的次数。尽管这并不一定能带来多高的优化，但好处是把符号位一起处理了。操作是根据最后一位和上一个最后一位的值来决定的。
![alt text](image-11.png)

faster multiplication:
之前的算法都是用一个ALU反复计算，下面的操作就是用成本换速度，多个ALU同时进行，可以加速。
![alt text](image-12.png)

#### RISC-V Multiplication
+ Four multiply instructions: 
  + mul: multiply  给出低64位的积
    + Gives the lower 64 bits of the product  
  + mulh:multiply high 给出高64位的积
    + Gives the upper 64 bits of the product, assuming the operands are signed 
  + mulhu: multiply high unsigned 无符号数高64位
    + Gives the upper 64 bits of the product, assuming the operands are unsigned 
  + mulhsu: multiply high signed/unsigned 一个有符号一个无符号
    + Gives the upper 64 bits of the product, assuming one operand is signed and the other unsigned 
  + Use mulh result to check for 64-bit overflow 取高64位检查溢出情况。

### Division（除法）

Dividend (被除数) $\div$ Divisor (除数)
算法1：
+ 把除数放到高位，被除数放在remainder（余数）寄存器的低位
+ 每一次把除数右移，商左移
+ 被除数 = 除数 * 商 + 余数
  
每次做减法，如果结果大于0，那么把商置1，小于0，商置0，然后把除数加回去。

![alt text](image-13.png)

!!! example
    ![alt text](image-14.png)
算法2:
改进：divisor右移就相当于remainder左移，这次我们除数不动，每次左移remainder会空出一位，正好存储商。这样就不需要再额外寄存器。

!!! example
    ![alt text](image-15.png)

带符号的除法：要求余数和被除数符号相同。
除零会产生溢出，由软件检测。

#### RISC-V Division
+ Four instructions: 
  +  div, rem: signed divide, remainder 
  +  divu, remu: unsigned divide, remainder
+ Overflow and division-by-zero don’t produce errors
  + Just return defined results
  + Faster for the common case of no error

### 浮点数(Floating Point Numbers)

表示方法： $\pm 1.xxxxxxx_2\times 2^{yyy}$
由符号位(sign)，尾数(fraction,more accuracy)，指数位(exponent,wider range)组成。
|       | S |   exp   |     frac     |
|:------|---|---------|-----------: |
| Float | 1 |    8    |     23      |
| Double | 1 |    11    |     52      |

$X = (-1)^S\times(1+Fraction)\times2^{(Exponent-Bias)}$
+ S:sign bit($0\Rightarrow$non-negative, $1\Rightarrow$negative)
+ 规格化的(normalized)significand：$1\leq |significand |< 2$
  + 尾数实际上是有先导1的，所以不用存储，运算时要记得加上。
  + 即frac实际值为（1.frac）
+  Exponent: excess representation: actual exponent + Bias
   + Ensures exponent is unsigned
   + Single: Bias = 127; Double: Bias = 1203

!!! info 另一种记忆方法（from Q）
    Normalized form: $N=(-1)^S\times M\times 2^E$  

    * S: sign. $S=1$ indicates the number is negative.
    * M: 尾数. Normally, $M=1.frac=1+frac$.
    * E: 阶码. Normally, $E=exp-Bias$ where $Bias=127$ for floating point numbers. $Bias = 1023$ for double. 

Denormal number 非规格化数
+ Exponent = 00...0，hidden bit = 0，没有前导1.
+ $X = (-1)^S\times(0+Fraction)\times2^{(1-Bias)}$
+ 此时指数是1-bias = -126/-1022，当frac = 0时，表示0
+ Exponent = 11...1，当frac = 0时，表示无穷大，否则表示NaN。
![alt text](image-16.png)

#### 浮点数的表示范围

+ 单精度 
  + 最小
    + Exponent: 00000001 actual exponent = 1 – 127 = –126
    + Fraction: 000...00  significand = 1.0
    + $±1.0 × 2^{–126} ≈ ±1.2 × 10^{–38}$
  + 最大
    + Exponent: 11111110 actual exponent = 254 – 127 = 127
    + Fraction: 111...11  significand = 1.11111111111111111111111
    + $±(2.0) × 2^{127} ≈ ±3.4 × 10^{38}$
+ 双精度
  + 最小
    + Exponent: 00000000001 actual exponent = 1 – 1023 = –1022
    + Fraction: 000...00  significand = 1.0
    + $±1.0 × 2^{–1022} ≈ ±2.2 × 10^{–308}$
  + 最大
    + Exponent: 11111111110 actual exponent = 2046 – 1023 = 1023
    + Fraction: 111...11  significand = 1.
    + $±(2.0) × 2^{1023} ≈ ±1.8 × 10^{308}$

#### 浮点数的精度(precision)

所有尾数都是有意义的
+ 单精度:approx %2^-23$ 约为7位十进制有效数字
+ 双精度:approx %2^-52$ 约为16位十进制有效数字

#### Limitation

+ overflow: The number is too big to be represented
+ underflow: The number is too small to be represented

#### 浮点数加法

+ Alignment 接码对齐
  + 小的往大的变，减小精度损失
+ The proper digits have to be added 
+ Addition of significands 
+ Normalization of the result 
+ Rounding

!!! example
    ![alt text](image-17.png)

FP Adder Hardware

![alt text](image-18.png)

step 1 在选择指数大的，并进行对齐。同时尾数可能还要加上前导 1.
step 3 是对结果进行标准化。
蓝色线为控制通路，黑色线为数据通路。

#### Floating-Point Multiplication

$(s_1\cdot 2^{e_1}) \cdot (s_2\cdot 2^{e_2}) = (s_1\cdot s_2)\cdot 2^{e_1+e_2}$

* Add exponents
* Multiply the significands
* Normalize
* Over/Underflow?  
有的话要抛出异常，通过结果的指数判断。
* Rounding
* Sign

注意 Exponet 中是有 Bias 的，两个数的 exp 部分相加后还要再减去 Bias. 

!!! example
    ![alt text](image-19.png)

**Data Flow**

![alt text](image-20.png)

* 右边往回的箭头: Rounding 后可能会进位。
* Incr 用于标准化结果，与右侧 Shift Right 配合。

#### Accurate Arithmetic

!!! note quesion

    ![alt text](image-22.png)
    由于精度对齐和四舍五入，两次的结果不一样。

* Extra bits of precision (guard, round, sticky)
    * guard, round  
    为了保证四舍五入的精度。  
    结果没有，只在运算的过程中保留。
    
        !!! Example
            ![alt text](image-21.png)
              
    * sticky  
    末尾如果不为全 0, 则 sticky 位为 1, 否则为 0.

损失不会超过 0.5 个 ulp. 