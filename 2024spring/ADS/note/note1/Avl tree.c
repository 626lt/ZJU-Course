#include<stdio.h>
#include<stdlib.h>

#define ElementType int
#define Max(x,y) ((x) > (y)? (x) : (y))
struct Avlnode;
typedef struct Avlnode *AvlTree;
typedef struct Avlnode *position;
position SingleRotateWithLeft(position T1);
position SingleRotateWithRight(position T1);
position DoubleRotateWithLeft(position T1);
position DoubleRotateWithRight(position T1);

struct Avlnode{
    ElementType Element;
    AvlTree Left;
    AvlTree Right;
    int Height;
};

int Height(position P)
{
    if(P == NULL)
        return -1;
    else
        return P->Height;
}

AvlTree insert(ElementType X, AvlTree T)
{
    if(T == NULL)
    {
        T = malloc(sizeof(struct Avlnode));
        T->Element = X;
        T->Height = 0;
        T->Left = NULL;
        T->Right = NULL;
    }
    else if(X < T->Element)/*插入到左子树*/
    {
        T->Left = insert(X, T->Left);
        /*维护BF*/
        if(Height(T->Left)-Height(T->Right) == 2)
        {
            if(X < T->Left->Element)
                T = SingleRotateWithLeft(T);
            else
                T = DoubleRotateWithLeft(T);
        }
    }
    else if(X > T->Element)/*插入到右子树*/
    {
        T->Right = insert(X, T->Right);
        /*维护BF*/
        if(Height(T->Left)-Height(T->Right) == -2)
        {
            if(X > T->Right->Element)
                T = SingleRotateWithRight(T);
            else
                T = DoubleRotateWithRight(T);
        }
    }

    T->Height = Max(Height(T->Left),Height(T->Right)) + 1;
    return T;
}

position SingleRotateWithLeft(position T1)
{
    position T2;
    T2 = T1->Left;
    T1->Left = T2->Right;
    T2->Right = T1;

    T1->Height = Max(Height(T1->Left), Height(T1->Right)) + 1;
    T2->Height = Max(Height(T2->Left), T1->Height) + 1;
    return T2; 
}

position SingleRotateWithRight(position T1)
{
    position T2;
    T2 = T1->Right;
    T1->Right = T2->Left;
    T2->Left = T1;

    T1->Height = Max(Height(T1->Left), Height(T1->Right)) + 1;
    T2->Height = Max(T1->Height, Height(T2->Right)) + 1;
    return T2; 
}

position DoubleRotateWithLeft(position T1)
{
    T1->Left = SingleRotateWithRight(T1->Left);
    return SingleRotateWithLeft(T1);
}

position DoubleRotateWithRight(position T1)
{
    T1->Right = SingleRotateWithLeft(T1->Right);
    return SingleRotateWithRight(T1);
}

int main()
{
    int n;
    scanf("%d",&n);
    AvlTree T = NULL;
    while(n>0)
    {
        n--;
        int X;
        scanf("%d",&X);
        T = insert(X,T);
    }
    printf("%d",T->Element);

    return 0;
}