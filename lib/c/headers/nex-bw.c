#include <limits.h>
#include "nex-bw.h"

#ifndef NEX_targetLimits_G
#define NEX_targetLimits_G

#if ULONG_MAX == 0xFFFFFFFFul
	#define NX_top_LC 31ul
	static const unsigned long NX_bits_LC[] = { 1ul, 2ul, 4ul, 8ul, 16ul };
#elif ULONG_MAX == 0xFFFFFFFFFFFFFFFFul
	#define NX_top_LC 63ul
	static const unsigned long NX_bits_LC[] = { 1ul, 2ul, 4ul, 8ul, 16ul, 32ul };
#else
	#error "Unsupported unsigned long size"
#endif

static const unsigned int NX_bitln_IC =
	sizeof(NX_bits_LC) / sizeof(NX_bits_LC[0]);

#endif

unsigned long NX_bwEven_lLF(
	const unsigned long l
) {
	return (l & 1ul) == 0ul;
}

unsigned long NX_bwOdd_lLF(
	const unsigned long l
) {
	return (l & 1ul) == 1ul;
}

unsigned long NX_bwTarget_lLF(
	const unsigned long l
) {
	return l == 0ul ? 0ul : 1ul + ((l - 1ul) & NX_top_LC);
}

unsigned long NX_bwIs_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return (b & (1ul << s)) != 0ul;
}

unsigned long NX_bwOff_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return b & ~(1ul << s);
}

unsigned long NX_bwOn_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return b | (1ul << s);
}

unsigned long NX_bwFlip_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return b ^ (1ul << s);
}

unsigned long NX_bwDiverge_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return b ^ (b >> s);
}

unsigned long NX_bwCascade_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return b | (b >> s);
}

unsigned long NX_bwMove_lLLLF(
	const unsigned long b,
	const unsigned long s,
	const unsigned long m
) {
	return NX_bwIs_lLLF(b, s)
		? NX_bwOff_lLLF(NX_bwOn_lLLF(b, m), s)
		: b;
}

unsigned long NX_bwTwos_lLF(const unsigned long b)
{
	unsigned long s = ~b + 1ul;
	return b == 0ul ? 0ul : s * b;
}

unsigned long NX_bwOnly_lLLLF(
	const unsigned long b,
	const unsigned long s,
	const unsigned long m
) {
	return NX_bwIs_lLLF(b, s)
	? b
	: NX_bwOn_lLLF(b, m);
}

unsigned long NX_bwCount_lLF(const unsigned long b)
{
	unsigned long s = 0ul;
	unsigned long v = b;

	while (v != 0ul) {
		v &= v - 1ul;
		s++;
	}

	return s;
}

unsigned long NX_bwZeros_lLLLF(
	const unsigned long b,
	const unsigned long i,
	const unsigned long s
) {
	unsigned long l = 0ul;
	long idx = (long)i;  // signed for stepping in either direction

	while (idx >= 0 && idx <= NX_top_LC && ((b >> idx) & 1ul) == 0ul) {
		l++;
		idx += (long)s;
	}
	return l;
}

unsigned long NX_bwLeading_lLF(const unsigned long b)
{
	return NX_bwZeros_lLLLF(b, NX_top_LC, (unsigned long)-1);
}

unsigned long NX_bwTrailing_lLF(const unsigned long b)
{
	return NX_bwZeros_lLLLF(b, 0ul, 1ul);
}

unsigned long NX_bwModNextBit_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	return b == 0ul
		? 0ul
		: 1ul + ((b - 1ul) & (NX_bwNextBit_lLF(s) - 1ul));
}

unsigned long NX_bwNextBit_lLF(const unsigned long b)
{
	unsigned long v = b - 1ul;
	for (unsigned int i = 0; i < NX_bitln_IC; ++i)
		v = NX_bwCascade_lLLF(v, NX_bits_LC[i]);
	return v + 1ul;
}

unsigned long NX_bwLeft_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	unsigned long v1 = b << (NX_top_LC + 1ul - s);
	unsigned long v2 = b >> s;
	return v1 | v2;
}

unsigned long NX_bwRight_lLLF(
	const unsigned long b,
	const unsigned long s
) {
	unsigned long v1 = b >> (NX_top_LC + 1ul - s);
	unsigned long v2 = b << s;
	return v1 | v2;
}

unsigned long NX_bwParity_lLF(
	const unsigned long b
) {
	unsigned long v = b;
	for (unsigned int i = NX_bitln_IC - 1; i >= 0; --i)
		v = NX_bwDiverge_lLLF(v, NX_bits_LC[i]);
	return NX_bwEven_lLF(v);
}

int nx_bw_mix(
	int v, int i, int s
) {
	/* Start with XOR of inputs */
	unsigned int h = (unsigned int)v ^ ((unsigned int)i * 0x9E3779B1u) ^ (unsigned int)s;
	/* Murmur3-style avalanche, but using only unsigned int */
	h ^= h >> 16;
	h *= 0x85EBCA6Bu;
	h ^= h >> 13;
	h *= 0xC2B2AE35u;
	h ^= h >> 16;
	return (int)h;
}

