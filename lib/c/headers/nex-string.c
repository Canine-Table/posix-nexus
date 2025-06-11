#include "nex-type.h"
#include "nex-math.h"
#include "nex-string.h"
#include <stdlib.h>

NX_CLASS_DEF(bin)
{
	return NX_IN_RANGE(s, '0', '1');
}

NX_CLASS_DEF(oct)
{
	return NX_IN_RANGE(s, '0', '7');
}

NX_CLASS_DEF(dec)
{
	return NX_IN_RANGE(s, '0', '9');
}

NX_CLASS_DEF(lhex)
{
	return NX_IN_RANGE(s, 'a', 'f');
}

NX_CLASS_DEF(uhex)
{
	return NX_IN_RANGE(s, 'A', 'F');
}

NX_CLASS_DEF(lower)
{
	return NX_IN_RANGE(s, 'a', 'z');
}

NX_CLASS_DEF(upper)
{
	return NX_IN_RANGE(s, 'A', 'Z');
}

NX_CLASS_DEF(islhex)
{
	return nx_dd_dec_isF(s) || nx_dd_lhex_isF(s);
}

NX_CLASS_DEF(isuhex)
{
	return nx_dd_dec_isF(s) || nx_dd_uhex_isF(s);
}

NX_CLASS_DEF(hex)
{
	return nx_dd_dec_isF(s) || nx_dd_lhex_isF(s) || nx_dd_uhex_isF(s);
}

NX_CLASS_DEF(alpha)
{
	return nx_dd_lower_isF(s) || nx_dd_upper_isF(s);
}

NX_CLASS_DEF(alnum)
{
	return nx_dd_dec_isF(s) || nx_dd_alpha_isF(s);
}

nx_dd_ist nx_dd_isnum_isF(nx_db_PcT c)
{
	nx_dd_iut i = 0, j = (c[0] == '+' || c[0] == '-') ? 1 : 0;
	nx_dd_ist k = 0, l = (c[0] == '-') ? -1 : 1;
	do {
		if (c[j] == '.' && k && ! i)
			i = l;
		else if (! nx_dd_dec_isF(c[j]))
			return(0);
		k = 1;
	} while (c[++j] != '\0');
	return (! j || c[j - 1] == '.') ? 0 : i + l;
}

nx_dd_E nx_dd_atolf_EF(nx_dd_pS s, nx_db_PcT c)
{

	nx_dd_ist e = nx_dd_isnum_isF(c);
	if (! e)
		return NX_DD_NT;
	if (NX_ABS(e) == 1) {
		if (atol(c) > NX_DD_MAX_IST) {
			nx_dd_iuF(s, atol(c));
			return NX_DD_IUT;
		}
		nx_dd_isF(s, atol(c));
		return NX_DD_IST;
	}
	nx_dd_fF(s, atof(c));
	return NX_DD_FT;
}

NX_BIN_PRINT_IMP(dd, is, d);
NX_BIN_PRINT_IMP(dw, ss, hd);

