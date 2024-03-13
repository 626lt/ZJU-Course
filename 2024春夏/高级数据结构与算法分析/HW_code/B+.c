#include<stdio.h>
#include<stdlib.h>
#include<string.h>
typedef struct BNode *BTree;
struct BNode{
    int key[4];
    BTree child[4];
    BTree parent;
    int num;
    int isleaf;
};

BTree insert(int X, BTree T);
BTree delete(int X, BTree T);
void print(BTree T);
int findkey(BTree T);

BTree root = NULL;

int main()
{
    int N;
    scanf("%d", &N);
    
    for(int i = 0;i < N;i++)
    {  
        int temp;
        scanf("%d", &temp);
        root = insert(temp, root);
        // print(root);
        // printf("\n-------\n");
    }
    print(root);
    return 0;
}

BTree insert(int X, BTree T)
{
    
    if(T == NULL)
    {
        T = (BTree)malloc(sizeof(struct BNode));
        memset(T->key,-1000,sizeof(int));
        T->key[0] = X;
        T->num = 1;
        T->isleaf = 1;
        T->parent = NULL;
    }
    else if(T->isleaf == 1)//T是叶子结点
    {
        int temp = T->key[0];
        int i = T->num - 1;
        
        while(i >= 0)//检测重复元素
        {
            if(X == T->key[i])
            {
                printf("Key %d is duplicated\n", X);
                return T;
            }
            i--;
        }
        
        i = T->num - 1;

        while(i >= 0 && X < T->key[i])
        {
            T->key[i + 1] = T->key[i];
            i--;
        }
        T->key[i + 1] = X;
        T->num++;
        //如果叶子爆了，就要分裂
        if(T->num == 4){
            BTree S = (BTree)malloc(sizeof(struct BNode));
            S->isleaf = 1;
            S->num = 2;
            S->key[0] = T->key[2];
            S->key[1] = T->key[3];
            T->num = 2;
            if(T->parent == NULL)//特殊情况，既是叶子也是根
            {
                BTree Root = (BTree)malloc(sizeof(struct BNode));
                Root->isleaf = 0;
                Root->num = 2;
                Root->child[0] = T;
                Root->child[1] = S;
                Root->key[1] = findkey(S);
                T->parent = Root;
                S->parent = Root;
                T = Root;
            }
            else if(T->parent)//T不是根结点，就维护父结点
            {
                S->parent = T->parent;
                int j = T->parent->num - 1;
                while(j > 0 && findkey(T) < T->parent->key[j])
                {
                    T->parent->key[j + 1] = T->parent->key[j];
                    T->parent->child[j + 1] = T->parent->child[j];
                    j--;
                }
                T->parent->key[j+1] = findkey(S);
                T->parent->child[j + 1] = S;
                T->parent->num++;
                }
        }
    }
    else if(T->isleaf == 0)
    {
        int i = T->num - 1;
        while(i > 0 && X < T->key[i])//T->key[i]是第i个子树中的最小值
        {
            i--;
        }
        T->child[i] = insert(X, T->child[i]);
        //如果内部结点爆了，也要分裂
        if(T->num == 4)
        {
            BTree S = (BTree)malloc(sizeof(struct BNode));
            S->isleaf = 0;
            S->num = 2;
            S->child[0] = T->child[2];
            T->child[2]->parent = S;
            S->child[1] = T->child[3];
            T->child[3]->parent = S;
            S->key[1] = findkey(S->child[1]);
            T->num = 2;
            if(T->parent == NULL)//T是根结点，长高
            {
                BTree Root = (BTree)malloc(sizeof(struct BNode));
                Root->isleaf = 0;
                Root->num = 2;
                Root->child[0] = T;
                Root->child[1] = S;
                Root->key[1] = findkey(S);
                T->parent = Root;
                S->parent = Root;
                T = Root;
            }else if(T->parent)//T不是根结点，就维护父结点
            {
                
                int j = T->parent->num - 1;
                while(j > 0 && findkey(T) < T->parent->key[j])
                {
                    T->parent->key[j + 1] = T->parent->key[j];
                    T->parent->child[j + 1] = T->parent->child[j];
                    j--;
                }
                T->parent->key[j + 1] = findkey(S);
                T->parent->child[j + 1] = S;
                S->parent = T->parent;
                T->parent->num++;
            }
        }
    }
    return T;
}

int findkey(BTree T)
{
    if(T->isleaf == 1)
    {
        return T->key[0];
    }
    else
    {
        return findkey(T->child[0]);
    }
}

void print(BTree T)
{
    //printf("\n________\n");
    int font,rear;
    BTree queue[1000005];
    font = rear = 0;
    queue[rear++] = T;
    int t = -1000;
    while(font < rear)
    {
        BTree temp = queue[font++];
        if(temp->isleaf != 0){
            for(int i = 0;i < temp->num;i++)
            {
                if(i == 0){
                    if(temp->key[i] < t)
                    {
                        printf("\n");
                    }
                    printf("[");
                    printf("%d", temp->key[i]);
                    t = temp->key[i];
                }
                else{
                    printf(",%d", temp->key[i]);
                    t = temp->key[i];
                }
            }
        }
        else if(temp->isleaf == 0)
        {
            for(int i = 1;i < temp->num;i++)
            {
                if(i == 1){
                    if(temp->key[i] < t)
                    {
                        printf("\n");
                    }
                    printf("[");
                    printf("%d", temp->key[i]);
                    t = temp->key[i];
                }
                else{
                    printf(",%d", temp->key[i]);
                    t = temp->key[i];
                }
            }
        }
        printf("]");
        for(int i = 0;i < temp->num;i++)
        {
            if(temp->child[i] != NULL)
            {
                queue[rear++] = temp->child[i];
            }
        }
    }
}