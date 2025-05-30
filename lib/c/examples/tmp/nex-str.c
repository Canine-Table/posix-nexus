#include <stdio.h>
#include <stdlib.h>
#include "nex-define.h"
#include "nex-misc.h"
#include "nex-str.h"

nx_ptrdiff_t *nx_atol(nx_sint_t l, nx_Char_t **c)
{
	if (l < 2) {
		fprintf(stderr, "Usage: %s <numbers>\n",  c[0]);
		return(NULL);
	}
	nx_ptrdiff_t *p_num = (nx_ptrdiff_t*)malloc(l * sizeof(nx_sint_t));
	if (nx_mem_chk(p_num) == -1) /* Handle memory allocation failure here */
		return(NULL);
	for (nx_uint_t i = 1; i < l; i++)
		p_num[i] = atol(c[i]);
	return p_num;
}

nx_dbl_t *nx_atof(nx_sint_t l, nx_Char_t **c)
{
	if (l < 2) {
		fprintf(stderr, "Usage: %s <floats>\n",  c[0]);
		return(NULL);
	}
	nx_dbl_t *p_flt = (nx_dbl_t*)malloc(l * sizeof(nx_dbl_t));
	if (nx_mem_chk(p_flt) == -1) /* Handle memory allocation failure here */
		return(NULL);
	for (nx_uint_t i = 1; i < l; i++)
		p_flt[i] = atof(c[i]);
	return p_flt;
}

