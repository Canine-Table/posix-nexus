#include <stdlib.h>

NexNode *create_nex_node(int d)
{
	NexNode *new_nex_node = (NexNode*)malloc(sizeof(NexNode));
	if (new_nex_node != NULL) {
		new_nex_node->data = d;
		new_nex_node->left = NULL;
		new_nex_node->right = NULL;
	}
	return new_nex_node;
}

