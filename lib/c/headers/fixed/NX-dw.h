#ifndef NX_dw_H
#define NX_dw_H

typedef struct {
	NX_wbbS l;
	NX_wbbS h;
} NX_dwwS;

unsigned short NX_set_s1dBBBBF(
	NX_dwwS*,
	const unsigned char,
	const unsigned char,
	const unsigned char,
	const unsigned char
);

unsigned short NX_set_s1dSBBF(
	NX_dwwS*,
	const unsigned short,
	const unsigned char,
	const unsigned char
);

unsigned short NX_set_s1dSSF(
	NX_dwwS*,
	const unsigned short,
	const unsigned short
);

unsigned short NX_set_s1dLF(
	NX_dwwS*,
	const unsigned long
);

unsigned long NX_get_lVVF(
	const unsigned short,
	const unsigned short
);

unsigned long NX_get_l1DF(
	const NX_dwwS*
);

#endif

