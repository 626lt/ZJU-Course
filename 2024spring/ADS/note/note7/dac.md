# devide and conquer

递归进行：
  + 把问题 divide 成一定数量的子问题
  + 递归地 conquer 子问题
  + 把字问题的解 combine 成原始问题的解

general recurrence :$T(N)=aT(N/b)+f(N)$ $f(N)$是合并子问题的时间复杂度

三个解决递归的方法

+ 代入法:先猜测$T(N)$的界，然后用数学归纳法证明，又叫瞎猜法。
+ 递归树法:边画边猜
+ 主方法(master method)：求偶法

## 代入法

先猜出一个界，然后用数学归纳法证明

!!! example

    ![alt text](image.png)
    ![alt text](image-1.png)
    这里归纳假设是严格小于等于，所以要证明$T(N)\leq cN^2$，而不是$T(N)\leq cN^2 + N$

## 递归树法

这个界不好猜，就画个树，就画一些情况看一下，然后猜测一个界，然后用代入法证明

!!! example

    ![alt text](image-2.png)
    ![alt text](image-3.png)

##  主方法

主方法有几种形式，是从推导的角度出发的，以下为了方便记忆和使用，直接给出最后的结论。

![alt text](image-4.png)