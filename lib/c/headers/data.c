#include <stdlib.h>

nx_nd_s *new_nx_node(int d)
{
	nx_nd_s *nx_nd = (nx_nd_s*)malloc(sizeof(nx_nd_s));
	if (nx_nd != NULL) {
		nx_nd->d = d;
		nx_nd->l = NULL;
		nx_nd->r = NULL;
	}
	return nx_nd;
}

