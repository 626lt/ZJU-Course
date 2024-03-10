#include<stdio.h>
#include<stdlib.h>
#include<time.h>
double duration,ticks;
clock_t start,stop;
typedef struct node *Node;
struct node
{
    int data;
    Node left;
    Node right;
};

Node createNode(int data)
{
    Node newNode = (Node)malloc(sizeof(struct node));
    newNode->data = data;
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;
}

Node findMin(Node root)
{
    while(root->left != NULL)
    {
        root = root->left;
    }
    return root;
}

void insert(Node *root, int data)
{
    if(*root == NULL)
    {
        *root = createNode(data);
    }
    else if(data <= (*root)->data)
    {
        insert(&(*root)->left, data);
    }
    else
    {
        insert(&(*root)->right, data);
    }
}

void delete(Node *root, int data)
{
    if(*root == NULL)
    {
        return;
    }
    else if(data < (*root)->data)
    {
        delete(&(*root)->left, data);
    }
    else if(data > (*root)->data)
    {
        delete(&(*root)->right, data);
    }
    else
    {
        if((*root)->left == NULL && (*root)->right == NULL)
        {
            free(*root);
            *root = NULL;
        }
        else if((*root)->left == NULL)
        {
            Node temp = *root;
            *root = (*root)->right;
            free(temp);
        }
        else if((*root)->right == NULL)
        {
            Node temp = *root;
            *root = (*root)->left;
            free(temp);
        }
        else
        {
            Node temp = findMin((*root)->right);
            (*root)->data = temp->data;
            delete(&(*root)->right, temp->data);
        }
    }
}

void test(int N, int *input, int *erase)
{
    Node root = NULL;
    for(int i = 0; i < N; i++)
    {
        insert(&root, input[i]);
    }
    for(int i = 0; i < N; i++)
    {
        delete(&root, erase[i]);
    }
}

int main()
{
    freopen("ran_ran.txt", "r", stdin);    
    freopen("BST.txt", "a", stdout);
    int N;
    scanf("%d", &N);
    int *arr_ins = (int *)malloc(N * sizeof(int));
    int *arr_era = (int *)malloc(N * sizeof(int));
    for (int i = 0; i < N; ++i) {
        scanf("%d", &arr_ins[i]);
    }
    for (int i = 0; i < N; ++i) {
        scanf("%d", &arr_era[i]);
    }
    
    int t = 10;
    start = clock();
    for(int i = 0; i < t ; i++)
    {
        test(N, arr_ins, arr_era);
    }
    stop = clock();
    duration = (double)(stop - start) / CLOCKS_PER_SEC;
    
    printf("%d\n%lf\n", N, duration / t);
    return 0;
}