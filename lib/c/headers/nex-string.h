#ifndef NX_STRING_H
#define NX_STRING_H
#include <stdio.h>

#define NX_CLASS_DEF(D) nx_dd_ist nx_dd_##D##_isF(nx_db_cT s)
#define NX_BIN_PRINT_DEF(D1, D2) nx_d_t nx_##D1##_bprint_##D2##F(nx_##D1##_##D2##t n)
#define NX_BIN_PRINT_IMP(D1, D2, D3) NX_BIN_PRINT_DEF(D1, D2) \
{ \
	for (nx_dd_ist i = sizeof(nx_##D1##_##D2##t) * 8 - 1; i >= 0; i--) { \
		printf("%" #D3, (n >> i) & 1); \
		if (! NX_MOD_POT(i, 4)) \
			printf(" "); \
	} \
	printf("\n"); \
}

NX_BIN_PRINT_DEF(dd, is);
NX_BIN_PRINT_DEF(dw, ss);

NX_CLASS_DEF(bin);
NX_CLASS_DEF(oct);
NX_CLASS_DEF(dec);
NX_CLASS_DEF(lhex);
NX_CLASS_DEF(uhex);
NX_CLASS_DEF(islhex);
NX_CLASS_DEF(isuhex);
NX_CLASS_DEF(hex);
NX_CLASS_DEF(lower);
NX_CLASS_DEF(upper);
NX_CLASS_DEF(alpha);
NX_CLASS_DEF(alnum);

nx_dd_ist nx_dd_isnum_isF(nx_db_PcT);
nx_dd_E nx_dd_atolf_EF(nx_dd_pS, nx_db_PcT);

#endif
