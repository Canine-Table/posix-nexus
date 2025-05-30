#include "nex-define.h"

nx_char_t nx_db_char_f(nx_db_St *s, nx_char_t d)
{
	nx_char_t t = d;
	nx_db_f(s, _CHAR, (nx_void_pt)&t);
	return t;
}

nx_char_st nx_db_char_sf(nx_db_St *s, nx_char_st d)
{
	nx_char_st t = d;
	nx_db_f(s, S_CHAR, (nx_void_pt)&t);
	return t;
}

nx_char_ut nx_db_char_uf(nx_db_St *s, nx_char_ut d)
{
	nx_char_ut t = d;
	nx_db_f(s, U_CHAR, (nx_void_pt)&t);
	return t;
}

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

nx_short_st nx_dw_short_sf(nx_dw_St *s, nx_short_st d)
{
	nx_short_st t = d;
	nx_dw_f(s, S_SHORT, (nx_void_pt)&t);
	return t;
}

nx_short_ut nx_dw_short_uf(nx_dw_St *s, nx_short_ut d)
{
	nx_short_ut t = d;
	nx_dw_f(s, U_SHORT, (nx_void_pt)&t);
	return t;
}

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

nx_float_t nx_dd_float_f(nx_dd_St *s, nx_float_t d)
{
	nx_float_t t = d;
	nx_dd_f(s, _FLOAT, (nx_void_pt)&t);
	return t;
}

nx_int_st nx_dd_int_sf(nx_dd_St *s, nx_int_st d)
{
	nx_int_st t = d;
	nx_dd_f(s, S_INT, (nx_void_pt)&t);
	return t;
}

nx_int_ut nx_dd_int_uf(nx_dd_St *s, nx_int_ut d)
{
	nx_int_ut t = d;
	nx_dd_f(s, U_INT, (nx_void_pt)&d);
	return t;
}

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

