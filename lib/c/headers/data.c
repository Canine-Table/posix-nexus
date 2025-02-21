#include <stdlib.h>

nex_node *create_nex_node(int d)
{
	nex_node *new_nex_node = (nex_node*)malloc(sizeof(nex_node));
	if (new_nex_node != NULL) {
		new_nex_node->data = d;
		new_nex_node->left = NULL;
		new_nex_node->right = NULL;
	}
	return new_nex_node;
}

