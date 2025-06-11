#include "nex-type.h"
#include "nex-string.h"
#include "nex-math.h"

NX_BADD_IMP(dd, is)
NX_BADD_IMP(dw, ss)
NX_BSUB_IMP(dd, is)
NX_BSUB_IMP(dw, ss)

nx_dd_ist nx_dd_bkbc_isF(nx_d_pt b, nx_dd_ist l)
{
	nx_dd_ist n = 0;
	nx_db_PcT p = (nx_db_pct)b;
	for(nx_dd_ist i = 0; i < l; i++) {
		nx_db_ct c = p[i];
		while (c) {
			c &= (c - 1);
			n++;
		}
	}
	return n;
}

