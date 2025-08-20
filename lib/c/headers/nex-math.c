#include "nex-define.h"
#include "nex-math.h"

nx_dm_op_silM(add, add)

nx_d_isT nx_bkbc_isF(nx_d_pT b, nx_d_isT l)
{
	nx_d_isT n = 0;
	nx_D_PcT p = (nx_d_pcT)b;
	for (nx_d_isT i = 0; i < l; i++) {
		nx_d_cT c = p[i];
		while (c) {
			c &= (c - 1);
			n++;
		}
	}
	return n;
}

nx_d_T nx_swap_F(nx_d_pT a, nx_d_pT b, nx_d_isT s)
{
	nx_d_pcT x = (nx_d_pcT)a;
	nx_d_pcT y = (nx_d_pcT)b;
	for (nx_d_isT i = 0; i < s; i++) {
		x[i] ^= y[i];
		y[i] ^= x[i];
		x[i] ^= y[i];
	}
}

