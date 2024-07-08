/*算法分析3 动态规划*/

# Dynamic Programming

idea：只解一次子问题，然后用表保存结果
+ 使用表替代递归

## 1. Fibonacci Numbers： $F(N) = F(N-1) + F(N-2)$

### 1.1 Recursive Algorithm

```c
int fib(int N) {
    if(N <= 1) return 1;
    return fib(N-1) + fib(N-2);
}
```

复杂度 $T(N) \geq T(N-1) + T(N-2) \Rightarrow T(N)\geq F(N)$

![alt text](image.png)

递归的问题在于递归计算是爆炸的，因此我们记录最近两次的结果来避免重复计算。

### 1.2 Dynamic Programming

```c
int fib(int N){
    int i, Last, NextToLast, Answer;
    if(N <= 1) return 1;
    Last = NextToLast = 1;
    for(i = 2; i <= N; i++){
        Answer = Last + NextToLast;
        NextToLast = Last;
        Last = Answer;
    }
    return Answer;
}
```

复杂度 $O(N)$ 很明显，这样记录大大减小了复杂度。

!!! note

    状态转移方程：参数N。

    + 参数用来描述当前子问题，比如规模
    + 参数最好能保证一定的递增性，这样能保证子问题的规模都能在范围内

## 2. Ordering Matrix Multiplication

不知道怎么设计状态转移方程时，想想最后一步会怎么做

!!! example

        假设我们乘以下4个矩阵
        $M_{1[10\times 20]} * M_{2[20\times 50]} * M_{3[50\times 1]} * M_{4[1\times 100]}$
        比较以下乘法顺序：
        1. $M_1 * (M_2 * (M_3 * M_4))$
        开销是：50*1*100 + 20*50*100 + 10*20*100 = 125000

定义 $b_n$ 为计算 $M_1 * M_2 * \cdots M_n$ 的不同方式数目。那么 $b_2 = 1$，$b_3 = 2$，$b_4 = 5$。
记 $M_{ij} = M_i*\cdots*M_j$. 那么 $M_{1n} = M1*\cdots M_n = M_{1i}* M_{in}$

最优子结构：不一定一直成立 tips：假如用子问题的次优解作为原问题的最优解一部分，考虑最优解替换，看原问题的最优解是否会变差。
增加一个约束让最优子结构失效：左乘的次数不能超过k次，在本题中是因为一个子问题的最优解的取值会影响到另一个子问题的最优解是否能取。
状态一般要体现状态规模，比如矩阵的规模，让某个参数递增，这样能保证子问题的规模都能在范围内

!!! info

    没思路的时候先写个 F(N);

## 3. Optimal Binary Search Tree

满足最优子结构
约束：左儿子的根不能超过两个距离

principle：重叠子问题

## 4. All-Pairs Shortest Path

1.5h

## 5. Product Assembly
