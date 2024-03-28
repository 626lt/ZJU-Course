#include <stdio.h>
#include <stdlib.h>

#define MaxTrees 14
typedef int ElementType;

typedef struct BinNode *Position;
typedef struct Collection *BinQueue;
typedef struct BinNode *BinTree;  /* missing from p.176 */

struct BinNode 
{ 
	ElementType	    Element;
	Position	    LeftChild;
	Position 	    NextSibling;
} ;

struct Collection 
{ 
	int	    	CurrentSize;  /* total number of nodes */
	BinTree	TheTrees[ MaxTrees ];
} ;

BinTree CombineTrees(BinTree T1, BinTree T2)
{
    if (T1->Element > T2->Element)
        return CombineTrees(T2, T1);
    T2->NextSibling = T1->LeftChild;
    T1->LeftChild = T2;
    return T1;
}
Position FindMin(BinQueue H);

ElementType DeleteMin(BinQueue H)
{
    BinQueue H1, H2;
    Position Min;
    Min = FindMin(H);
    if (Min == NULL)
        return -1;
    int i;
    for(i=0; i < MaxTrees; i++)
    {
        if (H->TheTrees[i] == Min)
            break;
    }
}