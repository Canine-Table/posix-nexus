#ifndef NX_DATA_H
#define NX_DATA_H

#define NX_STK_DEF(D1, D2, D3, D4) nx_void_t nx_##D1##_##D2##_##D3##_init##D4##f(nx_##D1##_##D2##_##D3##D4##St *s, nx_##D2##D4##t d)
#define NX_STK_INIT(D1, D2, D3, D4) NX_STK_DEF(D1, D2, D3, D4) \
{ \
	s->size = sizeof(s->data[0]); \
	s->len = d / s->size; \
	s->top = 0; \
}
#define NX_STK_ST(D1, D2, D3, D4, D5) \
	typedef struct { \
		nx_int_st size, len, top; \
		nx_##D2##_##D5##t data; \
	} nx_##D1##_##D2##_##D3##D4##St; \
	NX_STK_DEF(D1, D2, D3, D4)

NX_STK_ST(dd, int, stk, _s, ps);
NX_STK_ST(dd, int, stk, _u, pu);
NX_STK_ST(dd, float, stk, _, p);
NX_STK_ST(db, char, stk, _s, ps);
NX_STK_ST(db, char, stk, _u, pu);
NX_STK_ST(db, char, stk, _, p);
NX_STK_ST(dw, short, stk, _s, ps);
NX_STK_ST(dw, short, stk, _u, pu);

#endif
