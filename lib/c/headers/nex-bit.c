#include <limits.h>
#include "nex-bit.h"

#ifndef NEX_TARGET_LIMITS
	#define NEX_TARGET_LIMITS
	#if INT_MAX == 32767
		static const int NEX_TARGET_BITS[] = { 1, 2, 4, 8 };
		#define NEX_TARGET 15
	#elif INT_MAX == 2147483647
		#define NEX_TARGET 31
		static const int NEX_TARGET_BITS[] = { 1, 2, 4, 8, 16 };
	#elif INT_MAX == 9223372036854775807
		#define NEX_TARGET 63
		static const int NEX_TARGET_BITS[] = { 1, 2, 4, 8, 16, 32 };
	#else
		#error "Unsupported int size"
	#endif
	static const int NEX_TARGET_BITS_LENGTH = sizeof(NEX_TARGET_BITS) / sizeof(NEX_TARGET_BITS[0]);
#endif

int nx_bit_even(int i)
{
	return (i & 1) == 0;
}

int nx_bit_odd(int i)
{
	return (i & 1) == 1;
}

int nx_bit_abs(int i)
{
	return i < 0 ? -i : i;
}

int nx_bit_target(int b)
{
	return b == 0 ? 0 : 1 + ((b - 1) & NEX_TARGET);
}

int nx_bit_is(int b, int s)
{
	return (b & (1 << s)) != 0;
}

int nx_bit_off(int b, int s)
{
	return b & ~(1 << s);
}

int nx_bit_on(int b, int s)
{
	return b | (1 << s);
}

int nx_bit_flip(int b, int s)
{
	return b ^ (1 << s);
}

int nx_bit_diverge(int b, int s)
{
	return b ^ (b >> s);
}

int nx_bit_cascade(int b, int s)
{
	return b | (b >> s);
}

int nx_bit_move(int b, int s, int m)
{
	return nx_bit_is(b, s) ? nx_bit_off(nx_bit_on(b, m), s) : b;
}

int nx_bit_twos(int b)
{
	int s = ~b + 1;
	return b == 0 ? b : s * b;
}

int nx_bit_only(int b, int s, int m)
{
	return nx_bit_is(b, s) ? b : nx_bit_on(b, m);
}

int nx_bit_count(int b)
{
	int s = 0;
	while (b != 0) {
		b &= b - 1;
		s++;
	}
	return s;
}

int nx_bit_zeros(int b, int i, int s)
{
	int l = 0;
	while (i >= 0 && i <= NEX_TARGET && ((b >> i) & 1) == 0) {
		l++;
		i += s;
	}
	return l;
}

int nx_bit_leading(int b)
{
	return nx_bit_zeros(b, NEX_TARGET, -1);
}

int nx_bit_trailing(int b)
{
	return nx_bit_zeros(b, 0, 1);
}

int nx_bit_nextBit(int b)
{
	b--;
	for (int i = 0; i <  NEX_TARGET_BITS_LENGTH; ++i)
		b = nx_bit_cascade(b, NEX_TARGET_BITS[i]);
	return b + 1;
}

int nx_bit_modNextBit(int b, int s)
{
	return b == 0 ? 0 : 1 + ((b - 1) & nx_bit_nextBit(s) - 1);
}

int nx_bit32_left(int b, int s)
{
	return (b << (NEX_TARGET + 1 - s)) | (b >> s);
}

int nx_bit_right(int b, int s)
{
	return (b >> (NEX_TARGET + 1 - s)) | (b << s);
}

int nx_bit_parity(int b)
{
	for (int i = NEX_TARGET_BITS_LENGTH - 1; i >= 0; --i)
		b = nx_bit_diverge(b, NEX_TARGET_BITS[i]);
	return nx_bit_even(b);
}

int nx_bit_mix(int v, int i, int s)
{
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

