#include <stdio.h>
#include "nex-define.h"
#include "nex-bit.h"

void nx_printb(nx_ptrdiff_t n)
{
	for (nx_ptrdiff_t i = sizeof(nx_ptrdiff_t) * 8 - 1; i >= 0; i--) {
		printf("%ld", (n >> i) & 1); // Extracting individual bits
		if (i % 4 == 0)
			printf(" ");  // Adding spacing for readability
	}
	printf("\n");
}

nx_uint_t nx_even(nx_ptr_t n)
{
	return (*(nx_uchar_t *)n & 1) == 0;
}

void nx_swap(nx_ptr_t a, nx_ptr_t b, nx_size_t s)
{
	nx_uchar_t *x = (nx_uchar_t*)a;
	nx_uchar_t *y = (nx_uchar_t*)b;
	for (nx_size_t i = 0; i < s; i++) {
		x[i] ^= y[i];
		y[i] ^= x[i];
		x[i] ^= y[i];
	}
}

nx_size_t nx_nxt_pot(nx_size_t n)
{
	n--; // Handle exact powers of 2 correctly
	n |= n >> 1;
	n |= n >> 2;
	n |= n >> 4;
	n |= n >> 8;
	n |= n >> 16;
	return ++n; // Get next power of 2
}

nx_size_t nx_mod_pot(nx_size_t n1, nx_size_t n2)
{
	return n1 & (nx_nxt_pot(n2) - 1); // Only works for power-of-2 divisors
}

nx_size_t nx_exp_pot(nx_size_t n)
{
	return 1UL << n; // Equivalent to 2^n
}

nx_uint_t nx_is_pot(nx_size_t n)
{
	return (n > 0) && ((n & (n - 1)) == 0);
}

nx_size_t nx_mul_pot(nx_size_t n)
{
	return n << 1; // Equivalent to n * 2
}

nx_size_t nx_div_pot(nx_size_t n)
{
	return n >> 1; // Equivalent to n / 2
}

nx_size_t nx_bk_cnt(nx_ptr_t bts, nx_size_t s)
{
	nx_size_t c = 0;
	nx_uchar_t *p_bts = (nx_uchar_t*)bts;
	for(nx_size_t i = 0; i < s; i++) {
		nx_uchar_t b = p_bts[i];
		while (b) {
			b &= (b - 1);
			c++;
		}
	}
	return c;
}

