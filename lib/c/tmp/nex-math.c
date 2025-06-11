#include "nex-define.h"
#include "nex-math.h"

NX_ROUND(s, floor, S_INT, <, -1, 0);
NX_ROUND(s, ceil, S_INT, >, 1, 0);
NX_ROUND(s, round, S_INT, <, 0, -0.5);
NX_ROUND(u, floor, U_INT, <, -1, 0);
NX_ROUND(u, ceil, U_INT, >, 1, 0);
NX_ROUND(u, round, U_INT, >, 0, 0.5);
nx_int_st nx_dd_trunc_sf(nx_dd_St *s)
{
	if (s->type == _FLOAT)
		return (s->data._FLOAT > 0) ? nx_dd_floor_sf(s) : nx_dd_ceil_sf(s);
	return (s->type == S_INT) ? s->data.S_INT : nx_dd_int_sf(s, s->data.U_INT);
}


