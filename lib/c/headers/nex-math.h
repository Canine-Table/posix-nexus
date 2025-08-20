#ifndef nx_Dm_math_H
#define nx_Dm_math_H

#define nx_dm_f2c_M(D) (((D) - 32) * 5 / 9)
#define nx_dm_c2f_M(D) (((D) * 9 / 5) + 32)

#define nx_dm_min_M(D1, D2) ((D1) < (D2) ? (D1) : (D2))
#define nx_dm_max_M(D1, D2) ((D1) > (D2) ? (D1) : (D2))
#define nx_dm_range_M(D1, D2, D3) ((D1) >= (D2) && (D1) <= (D3))

#define nx_dm_bw_cascade_M(D1, D2) ((D1) | (D1) >> (D2))
#define nx_dm_bw_diverge_M(D1, D2) ((D1) ^ (D1) >> (D2))
#define nx_dm_bw_beacon_M(D1, D2) ((D1) | (1 << (D2)))
#define nx_dm_bw_erase_M(D1, D2) ((D1) & ~(1 << (D2)))
#define nx_dm_bw_toggle_M(D1, D2) ((D1) ^ (1 << (D2)))
#define nx_dm_bw_spotlight_M(D1, D2) ((D1) ^ (1 << (D2)))

/*
#define nx_dm_tobin_M(D1)
BIN_PRINT_IMP(D1, D2, D3) NX_BIN_PRINT_DEF(D1, D2) \
{ \
	for (nx_dd_ist i = sizeof(nx_##D1##_##D2##t) * 8 - 1; i >= 0; i--) { \
		printf("%" #D3, (n >> i) & 1); \
		if (! NX_MOD_POT(i, 4)) \
			printf(" "); \
	} \
	printf("\n"); \
}
*/

#define nx_dm_op_M(D1, D2) nx_d_##D1##T nx_##D2##_##D1##F(nx_d_##D1##T a, nx_d_##D1##T b)

#define nx_dm_add_M(D1, D2) nx_dm_op_M(D1, D2) \
{ \
	while (b) { \
		nx_d_##D1##T c = (a & b) << 1; \
		a = a ^ b; \
		b = c; \
	} \
	return a; \
}

#define nx_dm_op_silM(D1, D2) \
	nx_dm_##D1##_M(ss, D2); \
	nx_dm_##D1##_M(su, D2); \
	nx_dm_##D1##_M(is, D2); \
	nx_dm_##D1##_M(iu, D2); \
	nx_dm_##D1##_M(ls, D2); \
	nx_dm_##D1##_M(lu, D2);

nx_dm_op_silM(op, add)

nx_d_isT nx_bkbc_isF(nx_d_pT, nx_d_isT);
nx_d_T nx_swap_F(nx_d_pT, nx_d_pT, nx_d_isT);

#endif

