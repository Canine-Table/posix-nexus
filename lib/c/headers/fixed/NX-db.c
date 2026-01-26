#include <limits.h>
#include "NX-db.h"

unsigned char NX_set_b1wBBF(NX_wbbS *r, const unsigned char a, const unsigned char b)
{
	const unsigned short s = NX_get_vBBF(a, b);
	r->l = (unsigned char)(s & UCHAR_MAX);
	r->h = (unsigned char)((s >> CHAR_BIT) & UCHAR_MAX);
	return r->h;
}

unsigned char NX_set_b1wVF(NX_wbbS *r, const unsigned short a)
{
	r->l = (unsigned char)(a & UCHAR_MAX);
	r->h = (unsigned char)((a >> CHAR_BIT) & UCHAR_MAX);
	return r->h;
}

unsigned short NX_get_vBBF(const unsigned char a, const unsigned char b)
{
	return ((unsigned short)b << CHAR_BIT) | (unsigned short)a;
}

unsigned short NX_get_v1WF(const NX_wbbS *r)
{
	return NX_get_vBBF(r->l, r->h);
}


unsigned char NX_add_b1w1W1WF(
  NX_wbbS *r,
  const NX_wbbS *a,
  const NX_wbbS *b) {
	/* Load 16‑bit values from the struct pairs */
	const unsigned short av = NX_get_vBBF(a->l, a->h);
	const unsigned short bv = NX_get_vBBF(b->l, b->h);
	
	/* Perform the addition */
	const unsigned short cv = (unsigned short)(av + bv);

	/* Store result back into r */
	/* Return the high byte (carry/overflow indicator) */
	return NX_set_b1wVF(r, cv);
}

unsigned char NX_sub_b1w1W1WF(
  NX_wbbS *r,
  const NX_wbbS *a,
  const NX_wbbS *b) {

	/* Load 16‑bit values from the struct pairs */
	const unsigned short av = NX_get_vBBF(a->l, a->h);
	const unsigned short bv = NX_get_vBBF(b->l, b->h);

	/* Perform the subtraction */
	const unsigned short cv = (unsigned short)(av - bv);

	/* Store result back into r */
	/* Return the high byte (borrow indicator) */
	return NX_set_b1wVF(r, cv);
}

unsigned char NX_mul_b1w1W1WF(
  NX_wbbS *r,
  const NX_wbbS *a,
  const NX_wbbS *b
) {
	const unsigned short av = NX_get_vBBF(a->l, a->h);
	const unsigned short bv = NX_get_vBBF(b->l, b->h);

	const unsigned long cv = (unsigned long)av * (unsigned long)bv;

	const unsigned short low = (unsigned short)(cv & USHRT_MAX);

	return NX_set_b1wVF(r, low);
}

unsigned char NX_div_b1w1W1WF(
	NX_wbbS *r,
	const NX_wbbS *a,
	const NX_wbbS *b
){
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* Division by zero → not actionable → return input */
	if (bv == 0)
		return NX_set_b1wVF(r, av);

	/* Quotient always fits in the same width */
	const unsigned short q = (unsigned short)(av / bv);

	return NX_set_b1wVF(r, q);
}

unsigned char NX_swap_b1w1wF(
	NX_wbbS *a,
	NX_wbbS *b
){
	/* Not actionable: same pointer */
	if (a == b)
		return a->h;

	/* Extract values */
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* Perform swap */
	NX_set_b1wVF(a, bv);
	NX_set_b1wVF(b, av);

	/* Successful → return second argument's value */
	return b->h;
}

unsigned char NX_cmp_b1W1WF(
	const NX_wbbS *a,
	const NX_wbbS *b
) {
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* equal */
	if (av == bv)
		return 0;

	/* greater */
	if (av > bv)
		return 1;

	/* less */
	return UCHAR_MAX;
}

unsigned char NX_min_b1w1W1WF(
	NX_wbbS *r,
	const NX_wbbS *a,
	const NX_wbbS *b
){
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* choose the smaller value */
	const unsigned short mv = (av <= bv) ? av : bv;

	/* store and return high byte */
	return NX_set_b1wVF(r, mv);
}

unsigned char NX_max_b1w1W1WF(
	NX_wbbS *r,
	const NX_wbbS *a,
	const NX_wbbS *b
){
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* choose the greater value */
	const unsigned short mv = (av >= bv) ? av : bv;

	/* store and return high byte */
	return NX_set_b1wVF(r, mv);
}

unsigned char NX_clamp_b1w1W1W1WF(
	NX_wbbS *r,
	const NX_wbbS *x,
	const NX_wbbS *lo,
	const NX_wbbS *hi
) {
	const unsigned short xv  = NX_get_v1WF(x);
	const unsigned short lov = NX_get_v1WF(lo);
	const unsigned short hiv = NX_get_v1WF(hi);

	/* enforce lower bound */
	const unsigned short t = (xv < lov) ? lov : xv;

	/* enforce upper bound */
	const unsigned short c = (t > hiv) ? hiv : t;

	return NX_set_b1wVF(r, c);
}

unsigned char NX_zero_b1wF(NX_wbbS *r)
{
	r->l = 0;
	r->h = 0;
	return 0;
}

unsigned char NX_satAdd_b1w1W1WF(
	NX_wbbS *r,
	const NX_wbbS *a,
	const NX_wbbS *b
){
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* full-width sum to detect overflow */
	const unsigned long sum = (unsigned long)av + (unsigned long)bv;

	/* saturate at USHRT_MAX */
	const unsigned short sv =
		(sum > (unsigned long)USHRT_MAX)
		? (unsigned short)USHRT_MAX
		: (unsigned short)sum;

	return NX_set_b1wVF(r, sv);
}


unsigned char NX_satSub_b1w1W1WF(
	NX_wbbS *r,
	const NX_wbbS *a,
	const NX_wbbS *b
){
	const unsigned short av = NX_get_v1WF(a);
	const unsigned short bv = NX_get_v1WF(b);

	/* saturate at zero */
	const unsigned short sv =
		(av < bv)
		? (unsigned short)0
		: (unsigned short)(av - bv);

	return NX_set_b1wVF(r, sv);
}

unsigned char NX_inc_b1w1WF(
	NX_wbbS *r,
	const NX_wbbS *x
){
	const unsigned short xv = NX_get_v1WF(x);

	/* saturate at USHRT_MAX */
	const unsigned short iv =
		(xv == (unsigned short)USHRT_MAX)
		? xv
		: (unsigned short)(xv + 1);

	return NX_set_b1wVF(r, iv);
}

unsigned char NX_dec_b1w1WF(
	NX_wbbS *r,
	const NX_wbbS *x
){
	const unsigned short xv = NX_get_v1WF(x);

	/* saturate at zero */
	const unsigned short dv =
		(xv == 0)
		? 0
		: (unsigned short)(xv - 1);

	return NX_set_b1wVF(r, dv);
}

