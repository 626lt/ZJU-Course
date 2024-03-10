#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <time.h>
#define INF INT_MAX
#define max(a, b) ((a) > (b) ? (a) : (b))

typedef struct Node Node;
struct Node {
    int key, size, cnt;
    Node *child[2]; // child[0]: left child, child[1]: right child
    Node *parent;
};

typedef struct SplayTree SplayTree;
struct SplayTree {
    Node *root;
};

// void fprint_tree(Node *p) {
//     if (p == NULL) return;
//     fprint_tree(p->child[0]);
//     fprintf(stderr, "%d(%d, par:%d)[%d, %d] ", p->key, p->cnt, p->parent != NULL ? p->parent->key : -1,
//                 p->child[0] != NULL ? p->child[0]->key : -1, p->child[1] != NULL ? p->child[1]->key : -1);
//     fprint_tree(p->child[1]);
// }

Node *newNode(int key) {
    Node *p = (Node *)malloc(sizeof(Node));
    p->key = key;
    p->size = 1;
    p->cnt = 1;
    p->child[0] = p->child[1] = NULL;
    p->parent = NULL;
    return p;
}

int getSize(Node *p) {
    return p == NULL ? 0 : p->size;
}

int getPosition(Node *p) {
    if (p->parent == NULL) return -1;
    return p == p->parent->child[1];
}

void maintain(Node *p) {
    if (p == NULL) return;
    p->size = p->cnt + getSize(p->child[0]) + getSize(p->child[1]);
}

void rotate(Node *p) {
    if (p->parent == NULL) return;
    Node *p_parent = p->parent;
    int type = getPosition(p); // 0: left rotate, 1: right rotate
    p_parent->child[type] = p->child[type ^ 1];
    p->child[type ^ 1] = p_parent;
    if (p_parent->parent != NULL) {
        p_parent->parent->child[getPosition(p_parent)] = p;
    }
    p->parent = p_parent->parent;
    p_parent->parent = p;
    if (p_parent->child[type]) {
        p_parent->child[type]->parent = p_parent;
    }
    maintain(p_parent);
    maintain(p);
}

void splay(SplayTree *tree, Node *p) {
    for (Node *par = p->parent; par != NULL; rotate(p), par = p->parent) {
        if (par->parent != NULL) {
            rotate(getPosition(p) == getPosition(par) ? par : p);
        }
    }
    tree->root = p;
}

void insert(SplayTree *tree, int key) {
    if (tree->root == NULL) {
        tree->root = newNode(key);
        return;
    }
    Node *p = tree->root, *par = NULL;
    while (p != NULL) {
        par = p;
        if (key < p->key) {
            p = p->child[0];
        } else if (key > p->key) {
            p = p->child[1];
        } else {
            p->cnt++;
            maintain(p);
            splay(tree, p);
            return;
        }
    }
    p = newNode(key);
    p->parent = par;
    if (key <= par->key) {
        par->child[0] = p;
    } else {
        par->child[1] = p;
    }
    splay(tree, p);
}

int query_kth(SplayTree *tree, int k) {
    Node *p = tree->root;
    while (p != NULL) {
        if (k <= getSize(p->child[0])) {
            p = p->child[0];
        } else if (k > getSize(p->child[0]) + p->cnt) {
            k -= getSize(p->child[0]) + p->cnt;
            p = p->child[1];
        } else {
            break;
        }
    }
    if (p == NULL) return INF;
    splay(tree, p);
    return p->key;
}

void erase(SplayTree *tree, int key) {
    Node *p = tree->root;
    while (p != NULL) {
        if (key == p->key) {
            break;
        } else if (key < p->key) {
            p = p->child[0];
        } else {
            p = p->child[1];
        }
    }
    if (p == NULL) return;
    splay(tree, p);
    if (p->cnt > 1) {
        p->cnt--;
        maintain(p);
        return;
    } else if (p->child[0] == NULL || p->child[1] == NULL) {
        Node *q = p->child[0] ? p->child[0] : p->child[1];
        if (q != NULL) {
            q->parent = NULL;
        }
        free(p);
        tree->root = q;
        return;
    } else {
        p->child[0]->parent = p->child[1]->parent = NULL;
        tree->root = p->child[0];
        query_kth(tree, getSize(p->child[0]));
        tree->root->child[1] = p->child[1];
        p->child[1]->parent = tree->root;
        maintain(tree->root);
    }
}

void free_tree(Node *p) {
    if (p == NULL) return;
    free_tree(p->child[0]);
    free_tree(p->child[1]);
    free(p);
}

int main() {
    int n;
    freopen("testdata.txt", "r", stdin);    
    freopen("splay.txt", "a", stdout);
    scanf("%d", &n);
    int *arr_ins = (int *)malloc(n * sizeof(int));
    int *arr_era = (int *)malloc(n * sizeof(int));
    for (int i = 0; i < n; ++i) {
        scanf("%d", &arr_ins[i]);
    }
    for (int i = 0; i < n; ++i) {
        scanf("%d", &arr_era[i]);
    }
    SplayTree *tree = (SplayTree *)malloc(sizeof(SplayTree));
    tree->root = NULL;

    clock_t start, end;
    double duration;

    start = clock();

    int t = 10;
    for (int k = 0; k < t; ++k) {
        for (int i = 0; i < n; ++i) {
            insert(tree, arr_ins[i]);
        }
        for (int i = 0; i < n; ++i) {
            erase(tree, arr_era[i]);
        }
    }

    end = clock();
    duration = (double)(end - start) / CLOCKS_PER_SEC;

    printf("%d\n%lf\n", n, duration / t);

    // free_tree(tree->root);
    return 0;
}