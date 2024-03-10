#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <time.h>
#define INF INT_MAX
#define max(a, b) ((a) > (b) ? (a) : (b))

typedef struct Node Node;
struct Node {
    int key, height, size, bfactor;
    Node *child[2]; // child[0]: left child, child[1]: right child
};

typedef struct AVLTree AVLTree;
struct AVLTree {
    Node *root;
};

Node *newNode(int key) {
    Node *p = (Node *)malloc(sizeof(Node));
    p->key = key;
    p->child[0] = p->child[1] = NULL;
    p->height = 0;
    p->bfactor = 0;
    p->size = 1;
    return p;
}

int getHeight(Node *p) {
    return p == NULL ? -1 : p->height;
}

int getSize(Node *p) {
    return p == NULL ? 0 : p->size;
}

void maintain_info(Node *p) {
    if (p == NULL) return;
    p->height = max(getHeight(p->child[0]), getHeight(p->child[1])) + 1;
    p->bfactor = getHeight(p->child[0]) - getHeight(p->child[1]);
    p->size = 1 + getSize(p->child[0]) + getSize(p->child[1]);
}

/*
 * type = 0: right rotate
 * type = 1: left  rotate
 */
Node *rotate(Node *p, int type) {
    Node *q = p->child[type];
    p->child[type] = q->child[type ^ 1];
    q->child[type ^ 1] = p;
    maintain_info(p);
    maintain_info(q);
    return q;
}

Node *maintain(Node *p) {
    if (p == NULL) return p;
    maintain_info(p);
    if (p->bfactor > 1) {
        if (getHeight(p->child[0]->child[0]) >= getHeight(p->child[0]->child[1])) {
            // LL Rotate
            return rotate(p, 0);
        } else {
            // LR Rotate
            p->child[0] = rotate(p->child[0], 1);
            return rotate(p, 0);
        }
    } else if (p->bfactor < -1) {
        if (getHeight(p->child[1]->child[1]) >= getHeight(p->child[1]->child[0])) {
            // RR Rotate
            return rotate(p, 1);
        } else {
            // RL Rotate
            p->child[1] = rotate(p->child[1], 0);
            return rotate(p, 1);
        }
    }
    return p;
}

Node *insert(Node *p, int key) {
    if (p == NULL) return newNode(key);
    if (key <= p->key) {
        p->child[0] = insert(p->child[0], key);
    } else {
        p->child[1] = insert(p->child[1], key);
    }
    return maintain(p);
}

Node *erase_max(Node *p) {
    if (p == NULL) return p;
    if (p->child[1] == NULL) {
        Node *q = p->child[0];
        free(p);
        return q;
    } else {
        p->child[1] = erase_max(p->child[1]);
        return maintain(p);
    }
}

Node *erase(Node *p, int key) {
    if (p == NULL) return p;
    if (key < p->key) {
        p->child[0] = erase(p->child[0], key);
    } else if (key > p->key) {
        p->child[1] = erase(p->child[1], key);
    } else {
        if (p->child[0] == NULL || p->child[1] == NULL) {
            Node *q = p->child[0] ? p->child[0] : p->child[1];
            free(p);
            return q;
        } else {
            Node *q = p->child[0];
            while (q->child[1]) q = q->child[1];
            p->key = q->key;
            p->child[0] = erase_max(p->child[0]);
        }
    }
    return maintain(p);
}

void fprint_tree(Node *p) {
    if (p == NULL) return;
    fprint_tree(p->child[0]);
    fprintf(stderr, "%d ", p->key);
    fprint_tree(p->child[1]);
}

void free_tree(Node *p) {
    if (p == NULL) return;
    free_tree(p->child[0]);
    free_tree(p->child[1]);
    free(p);
}

int main() {
    freopen("testdata.txt", "r", stdin);
    freopen("avl.txt", "a", stdout);
    int n;
    scanf("%d", &n);
    int *arr_ins = (int *)malloc(n * sizeof(int));
    int *arr_era = (int *)malloc(n * sizeof(int));
    for (int i = 0; i < n; ++i) {
        scanf("%d", &arr_ins[i]);
    }
    for (int i = 0; i < n; ++i) {
        scanf("%d", &arr_era[i]);
    }
    AVLTree *avl = (AVLTree *)malloc(sizeof(AVLTree));
    avl->root = NULL;

    clock_t start, end;
    double duration;

    start = clock();

    int t = 10;
    for (int k = 0; k < t; ++k) {
        for (int i = 0; i < n; ++i) {
            avl->root = insert(avl->root, arr_ins[i]);
        }
        for (int i = 0; i < n; ++i) {
            avl->root = erase(avl->root, arr_era[i]);
        }
    }

    end = clock();
    duration = (double)(end - start) / CLOCKS_PER_SEC;

    printf("%d\n%lf\n", n, duration / t);

    // free_tree(avl->root);
    return 0;
}