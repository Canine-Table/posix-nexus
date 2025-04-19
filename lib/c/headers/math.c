#include <stdio.h>

nx_f128_t nx_floor(nx_f128_t n)
{
	nx_s64_t i = (nx_s64_t)n;
	return (n < i) ? (i - 1) : i;
}

nx_f128_t nx_ceiling(nx_f128_t n)
{
	nx_s64_t i = (nx_s64_t)n;
	return (n > i) ? (i + 1) : i;
}

nx_f128_t nx_round(nx_f128_t n)
{
	return (nx_s64_t)nx_floor(0.5 + n);
}

nx_f128_t nx_trunc(nx_f128_t n)
{
	return (n > 0) ? nx_floor(n) : nx_ceiling(n);
}

nx_f128_t nx_fmod(nx_f128_t n1, nx_f128_t n2)
{
	return (n2 == 0) ? NX_NAN : n1 - nx_trunc(n1 / n2) * n2;
}

nx_f128_t nx_factoral(nx_f128_t fc)
{
	if (fc <= 0)
		return 0;
	if (fc < 2)
		return 1;
	nx_f128_t n = 1;
	do {

	
		n = n * fc;
	} while (--fc > 0);
	return n;
}

nx_f128_t nx_power(nx_f128_t b, nx_f128_t e)
{
	if (b == 0)
		return 0;
	if (e == 0)
		return 1;
	int d = 0;
	nx_f128_t p;
	if (e < 0) {
		d = 1;
		e = e * -1;
	}
	for (p = 1; e > 0; e--)
		p = p * b;
	if (d)
		return 1.0 / p;
	return p;
}


nx_f128_t nx_fibonacci(nx_f128_t n)
{
	if (n <= 0)
		return -1;
	if (n == 1)
		return 0;
	if (n == 2)
		return 1;
	nx_f128_t n1 = 0, n2 = 0, n3 = 0;
	while (--n > 0) {
		n3 = n1 + n2;
		n1 = n2;
		n2 = n3;
	}
	return n2;
}

nx_f128_t nx_summation(nx_f128_t n1, nx_f128_t n2)
{
	if (n1 < n2)
		return n1;
	nx_f128_t i = n1;
	while (n1 > i)
		n1 += n1--;
	return n1;
}

nx_f128_t nx_absolute(nx_f128_t n)
{
	if (n < 0)
		return n * -1;
	return n;
}

nx_f128_t nx_euclidean(nx_f128_t n1, nx_f128_t n2)
{
	if (n1 < 1 || n2 < 1)
		return NX_NAN;
	nx_f128_t n;
	while (n1) {
		n = n1;
		n1 = nx_fmod(n2, n1);
		n2 = n;
	}
	return n;
}

nx_f128_t nx_lcd(nx_f128_t n1, nx_f128_t n2)
{
	nx_f128_t n;
	return ((n = nx_euclidean(n1, n2)) == NX_NAN) ? n : n1 * n2 / n;
}


nx_f128_t nx_mrange(nx_f128_t n1, nx_f128_t n2, nx_f128_t n3, nx_f128_t n4)
{
	n2 = n2 - n3;
	return nx_fmod(nx_fmod(n1 - n3 + n4, n2) + n2, n2) + n3;
}

nx_f128_t nx_mexp(nx_f128_t n1, nx_f128_t n2)
{
	if (n1 == 0)
		return 0;
	if (n2 == 0)
		return 1;
	int b = 0;
	if (n2 < 0) {
		n2 = nx_absolute(n2);
		b = 1;
	}
	nx_f128_t r = 1, m = 100000007;
	n1 = nx_fmod(n1, m) + m;
	while (n2 > 0) {
		if (nx_fmod(n2, 2) == 1)
			r = nx_fmod(r * n1, m);
		n1 = nx_fmod(n1 * n1, m);
		n2 = nx_floor(n2 / 2);
	}
	if (b)
		return 1.0 / r;
	return r;
}

nx_f128_t nx_remainder(nx_f128_t n1, nx_f128_t n2)
{
	return (n2 == 0) ? NX_NAN : nx_fmod(n2 - nx_fmod(n2, n1), n2);
}

/*
nx_f128_t nx_mod(nx_f128_t n1, nx_f128_t n2)
{
	if (n2 == 0)
		return -1;
	nx_f128_t q = n1 / n2;
	return x - (q > 0) ? (nx_u64_t)(q) : (nx_u64_t)(q - 1) * y
}






*/

