#include <limits.h>
#include "NX-db.h"
#include "NX-dw.h"

unsigned short NX_set_s1dBBBBF(
	NX_dwwS *r,
	const unsigned char a,
	const unsigned char b,
	const unsigned char c,
	const unsigned char d
) {
	NX_set_b1wBBF(r->l, a, b);
	NX_set_b1wBBF(r->h, c, d);
	const unsigned long t = NX_get_l1DF(r);
	r->l = (unsigned short)(t & (UCHAR_MAX << CHAR_BIT));
	r->h = (unsigned short)((t >> (CHAR_BIT * 2)) & (UCHAR_MAX << CHAR_BIT));
	return r->h;
}

unsigned short NX_set_s1dBBBBF(
	NX_dwwS *r,
	const unsigned char a,
	const unsigned char b,
	const unsigned char c,
	const unsigned char d
){
	/* Set low and high words using the w‑tier setter */
	NX_set_b1wBBF(&r->l, a, b);
	NX_set_b1wBBF(&r->h, c, d);

	/* Return high byte of high word (your convention) */
	return r->h.h;
}


unsigned short NX_set_s1dSBBF(
	NX_dwwS *r,
	const unsigned short a,
	const unsigned char b,
	const unsigned char c
) {
	return 
NX_set_s1dSSF(r, a, NX
}

unsigned short NX_set_s1dSSF(
	NX_dwwS *r,
	const unsigned short a,
	const unsigned short b
){
	/* Decompose each short into its w‑tier struct */
	NX_set_b1wVF(&r->l, a);
	NX_set_b1wVF(&r->h, b);

	return r->h.h;
}

unsigned short NX_set_s1dLF(
	NX_dwwS *r,
	const unsigned long a
){
	const unsigned short lo = (unsigned short)(a & USHRT_MAX);
	const unsigned short hi = (unsigned short)((a >> (CHAR_BIT * 2)) & USHRT_MAX);

	NX_set_b1wVF(&r->l, lo);
	NX_set_b1wVF(&r->h, hi);

	return r->h.h;
}

