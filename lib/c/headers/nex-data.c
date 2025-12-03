#include <stdio.h>
#include "nex-define.h"
#include "nex-data.h"

nx_d_iuT nX256_c_stk_isF(nX256_d_cU *arr)
{
	nx_d_iuT i = (*arr)[0].uc;
	return i > 0 ? i < 254 ? i : 254 : 0;
}

nx_d_iuT nX256_i_stk_isF(nX256_d_cU *arr)
{
	nx_d_iuT i = nX256_c_stk_isF(arr);
	return i < 254 ? i : 0;
}

nx_d_cT nX256_a_stk_cF(nX256_d_cU *arr, nx_D_cT c)
{
	nx_d_isT i = nX256_c_stk_isF(arr);
	if (i > 253 || c == '\0')
		return '\0';
	i++;
	(*arr)[0].uc = i;
	(*arr)[i].c = c;
	(*arr)[i + 1].c = '\0';
	return c;
}

nx_d_cT nX256_g_stk_cF(nX256_d_cU *arr)
{
	nx_d_iuT i = nX256_i_stk_isF(arr);
	return i > 0 ? (*arr)[i].c : '\0';
}

nx_d_cT nX256_r_stk_cF(nX256_d_cU *arr)
{
	nx_d_iuT i = nX256_i_stk_isF(arr);
	if (i < 2)
		return '\0';
	nx_D_cT c = (*arr)[i].c;
	(*arr)[i--].c = '\0';
	(*arr)[0].uc = i;
	return c;
}

nx_d_cT nX256_f_stk_cF(nX256_d_cU *arr, nx_D_cT tf)
{
	nx_d_iuT i = nX256_i_stk_isF(arr);
	if (i < 2)
		return '\0';
	switch (tf) {
		case 'f': case 'n':
			for (nx_d_iuT j = 1; j <= i; ++j)
				printf("%c", (*arr)[j].c);
			if (tf == 'n')
				printf("\n");
			break;
		case 'F': case 'N':
			for (nx_d_iuT j = 1; j <= i; ++j) {
				printf("%c", (*arr)[j].c);
				(*arr)[j].c = '\0';
			}
			(*arr)[0].uc = 1;
			if (tf == 'N')
				printf("\n");
			break;
		case 't': case 'y':
			do {
				printf("%c", (*arr)[i].c);
			} while (--i > 0);
			if (tf == 'y')
				printf("\n");
			break;
		default:
			nx_d_cT c;
			while ((c = nX256_r_stk_cF(arr)) != '\0')
				printf("%c", c);
			if (tf == 'Y')
				printf("\n");
	}
	return '\0';
}


