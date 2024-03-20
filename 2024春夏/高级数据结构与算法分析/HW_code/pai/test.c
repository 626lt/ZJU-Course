#include <stdio.h>
#include <stdlib.h>
typedef struct Treenode *node;
struct Treenode
{
    int key[3];
    node first;
    node second;
    node third;
    node father;
    int size;
    int isleaf;
};
node Btree;
void insert_B(int num);
void findkey(node parent, node now, int num);
int findmin(node root);
void Print();
int main()
{
    int n;
    scanf("%d", &n);
    int key;
    for (int i = 0; i < n; i++)
    {
        scanf("%d", &key);
        insert_B(key);
    }
    Print();
}
void insert_B(int num)
{
    if (num < 0)
    {
        return;
    }
    if (Btree == NULL)
    {
        Btree = (struct Treenode *)malloc(sizeof(struct Treenode));
        Btree->key[0] = num;
        Btree->key[1] = -1;
        Btree->key[2] = -1;
        Btree->size = 1;
        Btree->father = NULL;
        Btree->isleaf = 1;
        Btree->first = Btree->second = Btree->third = NULL;
        return;
    }
    node now = Btree;
    node parent = Btree->father;
    while (!now->isleaf)
    {
        parent = now;
        if (num < now->key[0])
        {
            now = now->first;
        }
        else if (num == now->key[0])
        {
            printf("Key %d is duplicated\n", num);
            return;
        }
        else if (num > now->key[0] && (now->key[1] < 0 || num < now->key[1]))
        {
            now = now->second;
        }
        else if (num > now->key[1])
        {
            now = now->third;
        }
        else
        {
            printf("Key %d is duplicated\n", num);
            return;
        }
    }
    if (now->size <= 2)
    {
        for (int i = 0; i < 2; i++)
        {
            if (now->key[i] == num)
            {
                printf("Key %d is duplicated\n", num);
                return;
            }
        }
        int i = (now->size) - 1;
        for (; i >= 0; i--)
        {
            if (now->key[i] < num)
            {
                break;
            }
            now->key[i + 1] = now->key[i];
        }
        now->key[++i] = num;
        now->size++;
        if (parent == NULL)
        {
            return;
        }
        int min = parent->first->key[0];
        if (parent->second == now)
        {
            parent->key[0] = now->key[0];
        }
        else if (parent->third == now)
        {
            parent->key[1] = now->key[0];
        }
        else if (parent->first == now && min == num)
        {
            findkey(parent, now, num);
        }
    }
    else if (now->size == 3)
    {
        int a[4], i;
        a[0] = now->key[0];
        a[1] = now->key[1];
        a[2] = now->key[2];
        for (i = 2; i >= 0; i--)
        {
            if (a[i] == num)
            {
                printf("Key %d is duplicated\n", num);
                return;
            }
            else if (a[i] < num)
            {
                break;
            }
            else
            {
                a[i + 1] = a[i];
            }
        }
        a[++i] = num;
        node new = (struct Treenode *)malloc(sizeof(struct Treenode));
        node node1 = NULL, node2 = NULL;
        now->key[0] = a[0];
        now->key[1] = a[1];
        now->key[2] = -1;
        now->size = 2;
        new->key[0] = a[2];
        new->key[1] = a[3];
        new->key[2] = -1;
        new->size = 2;
        new->father = now->father;
        new->first = new->second = new->third = NULL;
        new->isleaf = 1;
        node tmp = now;
        while (tmp)
        {
            if (parent == NULL)
            {
                node root = (struct Treenode *)malloc(sizeof(struct Treenode));
                root->father = NULL;
                root->key[0] = findmin(new);
                root->key[1] = root->key[2] = -1;
                root->isleaf = 0;
                root->first = now;
                root->second = new;
                root->third = NULL;
                root->size = 2;
                new->father = now->father = root;
                Btree = root;
                return;
            }
            else if (parent->size == 2)
            {
                parent->size++;
                if (parent->first == now)
                {
                    parent->third = parent->second;
                    parent->second = new;
                    parent->key[0] = new->key[0];
                    parent->key[1] = parent->third->key[0];
                    if (num == now->key[0])
                    {
                        findkey(parent, now, num);
                    }
                }
                else if (parent->second == now)
                {
                    parent->third = new;
                    parent->key[0] = now->key[0];
                    parent->key[1] = new->key[0];
                }
                return;
            }
            else if (parent->size == 3)
            {
                node1 = parent;
                node2 = (struct Treenode *)malloc(sizeof(struct Treenode));
                node1->isleaf = node2->isleaf = 0;
                node1->size = node2->size = 2;
                if (parent->first == now)
                {
                    node2->first = parent->second;
                    node2->second = parent->third;
                    node2->third = node1->third = NULL;
                    node1->first = now;
                    node1->second = new;
                    now->father = new->father = node1;
                    node2->father = node1->father;
                    node2->first->father = node2->second->father = node2;
                }
                else if (parent->second == now)
                {
                    node2->first = new;
                    node2->second = parent->third;
                    node2->third = node1->third = NULL;
                    node1->first = parent->first;
                    node1->second = now;
                    now->father = node1;
                    new->father = node2;
                    node2->father = node1->father;
                    node2->first->father = node2->second->father = node2;
                }
                else if (parent->third == now)
                {
                    node2->first = now;
                    node2->second = new;
                    node2->third = node1->third = NULL;
                    now->father = new->father = node2;
                    node2->father = parent;
                }
                node2->key[0] = findmin(node2->second);
                node1->key[0] = findmin(node1->second);
                node2->key[1] = node1->key[1] = node2->key[2] = node1->key[2] = -1;
                tmp = parent;
                parent = parent->father;
                now = node1;
                new = node2;
            }
        }
    }
    return;
}
void findkey(node parent, node now, int num)
{
    now = parent;
    parent = parent->father;
    while (parent)
    {
        if (parent->second == now)
        {
            parent->key[0] = num;
            return;
        }
        else if (parent->third == now)
        {
            parent->key[1] = num;
            return;
        }
        else if (parent->first == now)
        {
            now = parent;
            parent = parent->father;
        }
    }
}
int findmin(node root)
{
    while (!root->isleaf)
    {
        root = root->first;
    }
    return root->key[0];
}
void Print()
{
    if (!Btree)
    {
        return;
    }
    node now = Btree;
    node queue[100000];
    int front = 0;
    int rear = 0;
    queue[rear++] = now;
    int curnum = 1;
    int nextnum = 0;
    while (front != rear)
    {
        now = queue[front++];
        if (!now->isleaf)
        {
            curnum--;
            printf("[%d", now->key[0]);
            if (now->first)
            {
                queue[rear++] = now->first;
                nextnum++;
            }
            if (now->key[1] != -1)
            {
                printf(",%d]", now->key[1]);
            }
            else
                printf("]");
            if (now->second)
            {
                queue[rear++] = now->second;
                nextnum++;
            }
            if (now->third)
            {
                queue[rear++] = now->third;
                nextnum++;
            }
            if (curnum == 0)
            {
                printf("\n");
                curnum = nextnum;
                nextnum = 0;
            }
        }
        else
        {
            printf("[%d", now->key[0]);
            if (now->key[1] != -1)
            {
                printf(",%d", now->key[1]);
            }
            if (now->key[2] != -1)
            {
                printf(",%d]", now->key[2]);
            }
            else
            {
                printf("]");
            }
        }
    }
    printf("\n");
}

