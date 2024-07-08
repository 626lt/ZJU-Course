/*�����Ƿ���*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define M 3
#define ElementType int
typedef struct BPlusNode *BNode;
struct BPlusNode {
    int key[M+1];//����M����ֵ
    BNode child[M+1];//����M�����ӽ��
    BNode next;//ָ����һ��Ҷ�ӽ��
    BNode parent;//ָ�򸸽��
    int num;//��ǰ���ļ�ֵ����
    int isleaf;//�Ƿ���Ҷ�ӽ��
};
BNode insert(ElementType X, BNode T);
int findmin(BNode T);
int main()
{
    int N;
    scanf("%d", &N);
    BNode T = NULL;
    for(int i = 0;i < N;i++)
    {  
        int temp;
        scanf("%d", &temp);
        T = insert(temp, T);
    }
}

int findmin(BNode T)
{
    if(T->isleaf == 1)
        return T->key[0];
    else
        return findmin(T->child[0]);
}

/*
�Է�Ҷ�ӽ��T��T->key[0] = 0, T->key[1] = T->child[1]->key[0];T->key[2] = T->child[2]->key[0];
*/
BNode insert(ElementType X, BNode T)
{
    if(T == NULL){
        T = malloc(sizeof(struct BPlusNode));
        T->key[0] = X;
        T->num = 1;
        T->isleaf = 1;
        T->next = NULL;
        T->parent = NULL;
    }
    else if(T->isleaf == 1){
        int i = T->num -1,temp = T->key[0];
        while (i >= 0 && X < T->key[i])
        {
            T->key[i+1] = T->key[i];
            i--;
        }
        T->key[i+1] = X;
        T->num++;
        if (T->num == M + 1)//Ҷ�ӷ���
        {
            BNode S = malloc(sizeof(struct BPlusNode));
            S->isleaf = 1;
            S->next = T->next;
            T->next = S;
            S->num = 0;
            for(int j = 0;j < (M + 1) / 2;j++)
            {
                S->key[j] = T->key[j + (M + 1) /2];
                S->num++;
            }
            T->num = (M + 1) / 2;
            //ά�������
            S->parent = T->parent;
            S->parent->num++;
            int j = T->parent->num - 1;
            while(T->parent->key[j] > temp && j > 0)
            {
                T->parent->key[j+1] = T->parent->key[j];
                j--;
            }
            T->parent->key[j+1] = S->key[0];
            T->parent->child[j+1] = S;
            T->parent->key[j] = T->key[0];
            T->parent->child[j] = T;
        }
    }
    else if(T->isleaf == 0){//�Է�Ҷ�ӽ�㣬�����ҵ�����λ�á�
        int i = T->num -1;
        while(i >= 0 && X < T->key[i])
            i--;
        T->child[i+1] = insert(X, T->child[i+1]);//�ݹ����
        if(T->num == M + 1){//��Ҷ�ӽ�����
            BNode S = malloc(sizeof(struct BPlusNode));
            S->isleaf = 0;
            S->num = 2;
            S->child[0] = T->child[2];
            S->child[1] = T->child[3];
            S->key[1] = findmin(S->child[1]);
            T->key[1] = findmin(T->child[1]);
            T->num = 2;
            S->child[0]->parent = S;    
            S->child[1]->parent = S;
            //����Ǹ���㣬��Ҫ���ѳ���
            if(T->parent == NULL){
                BNode root = malloc(sizeof(struct BPlusNode));
                root->isleaf = 0;
                root->parent = NULL;
                root->num = 2;
                root->child[0] = T;
                root->child[1] = S;
                root->key[1] = findmin(root->child[1]);
                T->parent = root;
                S->parent = root;
                return root;
            }
            // ������Ǹ���㣬��ô���뼴�ɣ��������Ҫ���Ѿ�˦���������
            else if(T->parent){
                T->parent->num++;
                int j = T->parent->num - 1;
                int temp = findmin(T);
                while(T->parent->key[j] > temp && j > 0)
                {
                    T->parent->key[j+1] = T->parent->key[j];
                    j--;
                }
                T->parent->key[j+1] = findmin(S);
                T->parent->child[j+1] = S;
                T->parent->key[j] = findmin(T);
                T->parent->child[j] = T;
            }
        }
    }
    return T;
}