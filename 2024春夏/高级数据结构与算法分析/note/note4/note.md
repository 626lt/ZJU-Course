# Leftist Heaps and Skew Heaps

## Leftist Heaps

+ Target: Speed up merging in $O(N)$.

Heap: 结构性质 + 顺序性质

+ Definition: The null path length, Npl(X), is the length of the shortest path from X to an external node. 定义 Npl(NULL) = -1.（内部结点：儿子的个数为2；外部结点：儿子的个数小于2）Npl(X)即 X到外结点的最短路径长度。

!!! note

    Npl(X) = min{Npl(C) + 1 for all C as children of X} 

+ 左偏树的定义：对任何堆中的结点X，左儿子的Npl大于等于右儿子的。

+ 定理：左偏树在右路径上有r个结点至少拥有$2^r -1$个结点。
证明：（数学归纳法）k = 0, 1平凡情况。假设$k\leq n$的时候成立，考虑$k = n+1$，右路径上有$n+1$个结点，那么根结点的右儿子的右路径上有$n$个结点，根据归纳假设，右儿子至少有$2^n-1$个结点。再者由于左儿子的Npl大于等于右儿子的Npl，

!!! note

    N个结点的左偏树的右路径中至多有$\lfloor log_2(N+1) \rfloor$个结点。

我们可以在右路径上完成所有的操作，这样可以保证最短。

!!! note

    插入是合并的特例，因此我们要考虑如何进行合并(merge)。



## Skew Heaps (斜堆)

