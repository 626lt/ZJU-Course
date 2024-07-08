/*算法分析1*/

# 回溯法

idea：对有限解的情况，枚举所有可能的解，找到满足约束条件的解。非常暴力、非常直观、非常通用。缺点是效率比较低，时间复杂度较高

Backtracking 的思想是可以提前地排除一些解，从而减少搜索的时间。这种方法的优势在于，可以在搜索的过程中，提前判断某个分支不可能产生最终解，从而减少搜索的时间。这种提前的排除操作被称为剪枝。

以下是形式化描述

>我们已经有部分解 $(x_1,\cdots,x_i)$ 其中每个 $x_i\in S_k$。然后我们添加 $x_{i+1}\in S_{i+1}$ 并且检查 $(x_1,\cdots,x_i,x_{i+1})$ 是否满足约束。如果满足，我们继续递归地添加下一个 $x$，否则我们删除当前的 $x_{i+1}$ 并且尝试其他的 $x_{i+1}$。如果所有的 $x_{i+1}\in S_{i+1}$ 都不满足约束，那么回溯到前一种部分解 $(x_1,\cdots,x_{i-1})$ (即删除 $x_i$)。

!!! example 8皇后问题

    Find a placement of  8 queens on an 8  8 chessboard such that no two queens attack.
    Two queens are said to attack iff they are in the same row, column, diagonal, or antidiagonal of the chessboard.
    ![alt text](image.png)
    对n个皇后的情况，解空间的大小是 $n!$ 

!!! note method

    take the problem of 4 queens as an example
    Step1: construct a game tree
    ![alt text](image-1.png)
    Step2: perform depth-first search (post-order traversal) to examine the paths

!!! note

    + 实际上并没有这样的树被构建，这只是一个抽象的概念。
    + 实际上可以用别的搜索来进行，这是一个灵活的选择。

!!! example The Turnpike Reconstruction Problem

    Given N points on the x-axis with coordinates $x_1 <  x_2 < \cdots < x_N$ .  Assume that $x_1 = 0$.  There are$ N ( N – 1 ) / 2 $distances between every pair of points.
    Given $N ( N – 1 ) / 2 distances$.  Reconstruct a point set from the distances.
    
    〖Example〗Given D = { 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7, 8, 10 }
        Step 1:  N ( N – 1 ) / 2 = 15  implies  N =  6
        Step 2:  x1 = 0  and  x6 = 10
        Step 3: find the next largest distance and check
        ![alt text](image-3.png)
        ![alt text](image-2.png)

重建问题的代码描述  
```c
    bool Reconstruct ( DistType X[ ], DistSet D, int N, int left, int right )
    { /* X[1]...X[left-1] and X[right+1]...X[N] are solved */
        bool Found = false;
        if ( Is_Empty( D ) )
            return true; /* solved */
        D_max = Find_Max( D );
        /* option 1：X[right] = D_max */
        /* check if |D_max-X[i]|\in D is true for all X[i]’s that have been solved */
        OK = Check( D_max, N, left, right ); /* pruning */
        if ( OK ) { /* add X[right] and update D */
            X[right] = D_max;
            for ( i=1; i<left; i++ )  Delete( |X[right]-X[i]|, D);
            for ( i=right+1; i<=N; i++ )  Delete( |X[right]-X[i]|, D);
            Found = Reconstruct ( X, D, N, left, right-1 );
            if ( !Found ) { /* if does not work, undo */
                for ( i=1; i<left; i++ )  Insert( |X[right]-X[i]|, D);
                for ( i=right+1; i<=N; i++ )  Insert( |X[right]-X[i]|, D);
            }
        }
        /* finish checking option 1 */
        if ( !Found ) { /* if option 1 does not work */
            /* option 2: X[left] = X[N]-D_max */
            OK = Check( X[N]-D_max, N, left, right );
            if ( OK ) {
                X[left] = X[N] – D_max;
                for ( i=1; i<left; i++ )  Delete( |X[left]-X[i]|, D);
                for ( i=right+1; i<=N; i++ )  Delete( |X[left]-X[i]|, D);
                Found = Reconstruct (X, D, N, left+1, right );
                if ( !Found ) {
                    for ( i=1; i<left; i++ ) Insert( |X[left]-X[i]|, D);
                    for ( i=right+1; i<=N; i++ ) Insert( |X[left]-X[i]|, D);
                }
            }
            /* finish checking option 2 */
        } /* finish checking all the options */
        
        return Found;
    }
```

A template
```c
    bool Backtracking ( int i )
    {   Found = false;
        if ( i > N )
            return true; /* solved with (x1, …, xN) */
        for ( each xi  Si ) { 
            /* check if satisfies the restriction R */
            OK = Check((x1, …, xi) , R ); /* pruning */
            if ( OK ) {
                Count xi in;
                Found = Backtracking( i+1 );
                if ( !Found )
                    Undo( i ); /* recover to (x1, …, xi-1) */
            }
            if ( Found ) break; 
        }
        return Found;
    }
```
注：回溯的效率跟S的规模、约束函数的复杂性、满足约束条件的结点数相关。
约束函数决定了剪枝的效率，但是如果函数本身太复杂也未必合算。
满足约束条件的结点数最难估计，使得复杂度分析很难完成。

![alt text](image-4.png)

倾向于对第一种情况剪枝，因为一旦成功获得的收益是巨大的，一次少了一半。

## Tic-tac-toe: Minimax Strategy

Use an evaluation function to quantify the "goodness" of a position.  For example:
$$ f(P) = W_{computer} - W_{human} $$
where W is the number of potential wins at position P.这就是指假如一方不再下了，另一方能赢的可能性。
![alt text](image-5.png)
The human is trying to minimize the value of the position P, while the computer is trying to maximize it.

