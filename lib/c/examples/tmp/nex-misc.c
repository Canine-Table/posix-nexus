#include <stdio.h>
#include "nex-define.h"
#include "nex-misc.h"

nx_ptrdiff_t nx_mem_chk(nx_ptr_t p)
{
	if (p == NULL) {
		fprintf(stderr, "Memory allocation failed!\n");
		return(-1);  /* Return an error indicator */
	}
	return(0);  /* Memory allocation was successful */
}

