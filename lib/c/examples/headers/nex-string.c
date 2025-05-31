#include "nex-define.h"
#include "nex-misc.h"
#include "nex-string.h"
#include <stdio.h>
#include <stdlib.h>

nx_int_st nx_is_space(nx_char_t s)
{
        return s == ' ' || s == '\t' || s == '\v' || s == '\f';
}

nx_int_st nx_is_digit(nx_char_t s)
{
        return ! (s < '0' || s > '9');
}

nx_int_st nx_is_lower(nx_char_t s)
{
        return ! (s < 'a' || s > 'z');
}

nx_int_st nx_is_upper(nx_char_t s)
{
        return ! (s < 'A' || s > 'Z');
}

nx_int_st nx_is_alpha(nx_char_t s)
{
        return nx_is_upper(s) || nx_is_lower(s);
}

nx_int_st nx_is_alnum(nx_char_t s)
{
        return nx_is_alpha(s) || nx_is_digit(s);
}

nx_int_st nx_is_quote(nx_char_t s)
{
        return s == '"' || s == '\'' || s == '`';
}

nx_int_pst nx_atol(nx_int_ut l, nx_char_ppT c)
{
	if (l < 2) {
		fprintf(stderr, "Usage: %s <numbers>\n",  c[0]);
		return(NULL);
	}
	nx_int_pst p_num = (nx_int_pst)malloc(l * sizeof(nx_int_st));
	if (nx_mem_chk(p_num) == -1) /* Handle memory allocation failure here */
		return(NULL);
	for (nx_int_ut i = 1; i < l; i++)
			p_num[i] = atol(c[i]);
	return p_num;
}

nx_float_pt nx_atof(nx_int_ut l, nx_char_ppT c)
{
	if (l < 2) {
		fprintf(stderr, "Usage: %s <floats>\n",  c[0]);
		return(NULL);
	}
	nx_float_pt p_flt = (nx_float_pt)malloc(l * sizeof(nx_float_t));
	if (nx_mem_chk(p_flt) == -1) /* Handle memory allocation failure here */
		return(NULL);
	for (nx_int_ut i = 1; i < l; i++)
		p_flt[i] = atof(c[i]);
	return p_flt;
}

