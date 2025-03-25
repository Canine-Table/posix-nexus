#ifndef NEX_DATA_H
#define NEX_DATA_H

typedef struct NexArr {
    int sz;
    har *arr;
} NexArr;

typedef struct NexNode {
    int data;
    struct NexNode *left;
    struct NexNode *right;
} NexNode;
NexNode* create_nex_node(int);

#include "data.c"
#endif

