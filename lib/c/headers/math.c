#include <stdio.h>

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

/*
nx_f128_t nx_euclidean(nx_f128_t n1, nx_f128_t n2)
{
	if (n1 < 1 || n2 < 1)
		return -1;
	nx_f128_t n;
	while (n1) {
		n = n1;
		n1 = n2 % n1;
		n2 = n;
	}
	return n;
}

nx_f128_t nx_lcd(nx_f128_t n1, nx_f128_t n2)
{
	nx_f128_t n;
	if ((n = nx_euclidean(n1, n2)) < 0)
		return n;
	return n1 * n2 / n;
}

nx_f128_t nx_remainder(nx_f128_t n1, nx_f128_t n2)
{
	if (n2 < 1)
		return -1;
	return (n2 - n1 % n2) % n2;
}

*/

