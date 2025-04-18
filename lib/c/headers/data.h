#ifndef NX_DATA_H
#define NX_DATA_H

typedef struct {
    int d;
    struct NexNode *l;
    struct NexNode *r;
} nx_nd_s;
nx_nd_s* new_nx_node(int);

#include "data.c"
#endif

