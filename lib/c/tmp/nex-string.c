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


nx_int_st nx_tok_num(nx_char_pT tok)
{
	nx_int_st i = 0, j = 0;
	do {
		if (tok[i] == '.' && ! j)
			j = 1;
		else if (! nx_is_digit(tok[i]))
			return(0);
	} while (tok[++i] != '\0');
	return(j + 1);
}

nx_int_pst nx_atol(nx_int_st l, nx_char_ppT c)
{
	if (l < 1) {
		fprintf(stderr, "Usage: %s <numbers>\n",  c[0]);
		return(NULL);
	}
	nx_int_pst p_num = (nx_int_pst)malloc(l * sizeof(nx_int_st));
	if (nx_mem_chk(p_num) == -1) /* Handle memory allocation failure here */
		return(NULL);
	nx_int_st i = 0, j = 0;
	for (; i < l; i++) {
		if (nx_tok_num(c[i]) == 1)
			p_num[j++] = atol(c[i]);
	}
	return p_num;
}

nx_float_pt nx_atof(nx_int_st l, nx_char_ppT c)
{
	if (l < 1) {
		fprintf(stderr, "Usage: %s <floats>\n",  c[0]);
		return(NULL);
	}
	nx_float_pt p_flt = (nx_float_pt)malloc(l * sizeof(nx_float_t));
	if (nx_mem_chk(p_flt) == -1) /* Handle memory allocation failure here */
		return(NULL);
	nx_int_st i = 0, j = 0;
	for (; i < l; i++) {
		if (nx_tok_num(c[i]))
			p_flt[j++] = atof(c[i]);
	}
	return p_flt;
}

