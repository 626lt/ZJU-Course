#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

struct splayNode;
typedef struct splayNode *Position;
typedef struct splayNode *splayTree;

splayTree MakeEmpty(splayTree T);
Position Find(int x, splayTree T);
Position FindMin(splayTree T);
Position FindMax(splayTree T);
splayTree Insert(int x, splayTree T);
splayTree LL(splayTree T);
splayTree LR(splayTree T);
splayTree RL(splayTree T);
splayTree RR(splayTree T);
splayTree Delete(int x, splayTree T);
splayTree Rotate(splayTree T);
int Retrieve(Position P);
int Height(Position P);
int max(int a, int b);
void PrintTree( splayTree T );

struct splayNode
{
    int Element;
    splayTree Left;
    splayTree Right;
    splayTree Parent;
};
int main()
{
    int N;
    scanf("%d", &N);
    int i = 0;
    int in[N];
    int out[N];
    while(i < N){
        scanf("%d", &in[i]);
        i++;
    }
    i = 0;
    while(i < N){
        scanf("%d", &out[i]);
        i++;
    }
    splayTree T = NULL;
    // int temp;
    i = 0;
    while(i < N){
        T = Insert(in[i], T);
        // printf("insert %d\n", in[i]);
        i++;
    }
    // PrintTree(T);
    // printf("\n");
    //T = Find(2,T);
    i = 0;
    while(i < N){
        T = Delete(out[i], T);
        // printf("delete %d\n", num[i]);
        // PrintTree(T);
        // printf("\n* ");
        i++;
    }
    if(!T)printf("completely deleted!\n");
}

splayTree MakeEmpty(splayTree T)
{
    T = (splayTree)malloc(sizeof(struct splayNode));
    T->Element = -1;
    T->Left = T->Right = NULL;
    return T;
}



splayTree Insert(int x, splayTree T)
{
    if(T == NULL){
        T = (splayTree)malloc(sizeof(struct splayNode));
        T->Element = x;
        T->Left = T->Right = NULL;
        T->Parent = NULL;
        return T;
    }else if(x > T->Element){
        T->Right = Insert(x, T->Right);
        T->Right->Parent = T; 
        // if(Height(T->Right) - Height(T->Left) == 2){
        //     if(x < T->Right->Element){
        //         T = RL(T);
        //     }else if(x > T->Right->Element){
        //         T = RR(T);
        //     }
        // }
    }else if(x < T->Element){
        T->Left = Insert(x, T->Left);
        T->Left->Parent = T; 
        // if(Height(T->Left) - Height(T->Right) >= 2){
        //     if(x < T->Left->Element){
        //         T = LL(T);
        //     }else if(x > T->Left->Element){
        //         T = LR(T);
        //     }
        // }
    }
    return T;
}

splayTree LL(splayTree P)
{
    splayTree C;
    C = P->Left;
    P->Left = C->Right;
    if(P->Left)
    P->Left->Parent = P;
    C->Right = P;
    if(C->Right)
    C->Right->Parent = C;
    return C;
}
splayTree LR(splayTree G)
{
    //splayTree Parent = G->Left;
    // Parent = G->Left;
    // C = Parent->Right;
    // P->Right = C->Left;
    // G->Left = C->Right;
    // C->Right = G;
    // C->Left = P;
    // P->height = 
    // G->height = 
    // C->height = 
    splayTree GG = G->Parent;
    G->Left = RR(G->Left);
    G = LL(G);
    // if(GG)
    G->Parent = GG;
    return G;
}
splayTree RL(splayTree G)
{
    //splayTree P = G->Right;
    // P = G->Right;
    //C = P->Left;
    splayTree GG = G->Parent;
    G->Right = LL(G->Right);
    G = RR(G);
    G->Parent = GG;
    return G;
}
splayTree RR(splayTree P)
{
    splayTree C;
    C = P->Right;
    P->Right = C->Left;
    if(P->Right)
    P->Right->Parent = P;
    C->Left = P;
    if(C->Left)
    C->Left->Parent = C;
    return C;
}

int max(int a, int b)
{
    return (a>b)?a:b;
}


splayTree Delete(int x, splayTree T)
{
    T = Find(x, T);
    // printf("found %d\n", x);
    // PrintTree(T);
    splayTree right = T->Right;
    splayTree left = T->Left;
    if(right == NULL && left != NULL){//only left child
        T = T->Left;
        T->Parent = NULL;
    }else if(right != NULL && left == NULL){//only right child
        T = T->Right;
        T->Parent = NULL;
    }else if(right == NULL && left == NULL){//no child
        T = NULL;
    }else{//two children
        if(T->Left->Right != NULL){//T->Left is not the max
            T = FindMax(left);
            T->Right = right;
            T->Left = left;
            right->Parent = T;
            left->Parent = T;
        }else{//T->Left is already the max
            T->Left->Right = right;
            right->Parent = T->Left;
            T = T->Left;
            T->Parent = NULL;
        }
    }
    return T;
}

splayTree FindMax(splayTree T)
{
    splayTree G = T->Parent;
    splayTree temp = T;
    while(temp->Right){
        temp = temp->Right;
    }
    if(temp->Parent != G){
        // T->Parent->Right = NULL;
        temp->Parent->Right = temp->Left;
        if(temp->Left)
        temp->Left->Parent = temp->Parent;
        temp->Parent = NULL;
    }else{//T->Left is just the max, no need to fix T->Parent->Right
        temp->Parent = NULL;
    }
    
    return temp;
}

splayTree Find(int x, splayTree T)
{
    if(T){
        if(x > T->Element){
            T = Find(x, T->Right);
        }else if(x < T->Element){
            T = Find(x, T->Left);
        }else{
            while(T->Parent){
                T = Rotate(T);
            }
        }
    }else{
        assert(0);//x not found, error
    }
    return T;
}

splayTree Rotate(splayTree T)
{
    if(T->Parent->Parent == NULL){//zig
        if(T->Parent->Left == T){//L zig
            T = LL(T->Parent);
            T->Parent = NULL;
        }else{//R zig
            T = RR(T->Parent);
            T->Parent = NULL;
        }
    }else{//zigzag
        splayTree GG = T->Parent->Parent->Parent;
        if(T->Parent->Parent->Left == T->Parent && T->Parent->Left == T){//LL zigzig
            T->Parent = LL(T->Parent->Parent);
            T = LL(T->Parent);
            T->Parent = GG;
            if(GG){
                if(GG->Element > T->Element){
                    GG->Left = T;
                }else{
                    GG->Right = T;
                }
            }
            // T->Parent = GG;
            // GG->Left = T;
        }else if(T->Parent->Parent->Right == T->Parent && T->Parent->Right == T){//RR zigzig
            T->Parent = RR(T->Parent->Parent);
            T = RR(T->Parent);
            T->Parent = GG;
            if(GG){
                if(GG->Element > T->Element){
                    GG->Left = T;
                }else{
                    GG->Right = T;
                }
            }
        }else if(T->Parent->Parent->Left == T->Parent && T->Parent->Right == T){//LR zigzag
            T = LR(T->Parent->Parent);
            if(GG){
                if(GG->Element > T->Element){
                    GG->Left = T;
                }else{
                    GG->Right = T;
                }
            }            
            T->Parent = GG;
        }else if(T->Parent->Parent->Right == T->Parent && T->Parent->Left == T){//RL zigzag
            T = RL(T->Parent->Parent);
            T->Parent = GG;
            if(GG){
                if(GG->Element > T->Element){
                    GG->Left = T;
                }else{
                    GG->Right = T;
                }
            }  
        }
    }
    return T;
}

void PrintTree( splayTree T )
        {
            if( T != NULL )
            {
                printf( "%d ", T->Element );
                PrintTree( T->Left );
                PrintTree( T->Right );
            }
        }
