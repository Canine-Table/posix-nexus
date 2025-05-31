#include "nex-define.h"

NX_TYPE(db, char, _, _CHAR);
NX_TYPE(db, char, _u, U_CHAR);
NX_TYPE(db, char, _s, S_CHAR);
nx_void_t nx_db_f(nx_db_St *s, nx_db_Et e, nx_void_pt d)
{
	s->type = e;
	switch (e) {
		case _CHAR:
			s->data._char = *(nx_char_t*)d;
			break;
		case U_CHAR:
			s->data.u_char = *(nx_char_ut*)d;
			break;
		case S_CHAR:
			s->data.s_char = *(nx_char_st*)d;
			break;
	}
}

NX_TYPE(dw, short, _u, U_SHORT);
NX_TYPE(dw, short, _s, S_SHORT);
nx_void_t nx_dw_f(nx_dw_St *s, nx_dw_Et e, nx_void_pt d)
{
	s->type = e;
	switch (e) {
		case U_SHORT:
			s->data.u_short = *(nx_short_ut*)d;
			break;
		case S_SHORT:
			s->data.s_short = *(nx_short_st*)d;
			break;
	}
}

NX_TYPE(dd, int, _u, U_INT);
NX_TYPE(dd, float, _, _FLOAT);
NX_TYPE(dd, int, _s, S_INT);
nx_void_t nx_dd_f(nx_dd_St *s, nx_dd_Et e, nx_void_pt d)
{
	s->type = e;
	switch (e) {
		case _FLOAT:
			s->data._float = *(nx_float_t*)d;
			break;
		case U_INT:
			s->data.u_int = *(nx_int_ut*)d;
			break;
		case S_INT:
			s->data.s_int = *(nx_int_st*)d;
			break;
	}
}

