#include <stdio.h>
#include "nex-define.h"
#include "nex-misc.h"

nx_int_st nx_mem_chk(nx_void_pt p)
{
	if (p == NULL)
		return(-1);  /* Return an error indicator */
	return(0);  /* Memory allocation was successful */
}

