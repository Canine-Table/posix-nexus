#ifndef NEX_DATA_H
#define NEX_DATA_H

typedef struct nex_node {
    int data;
    struct nex_node *left;
    struct nex_node *right;
} nex_node;
nex_node* create_nex_node(int);

#include "data.c"
#endif

