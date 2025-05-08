#include <stdio.h>
#include "nex-define.h"
#include "nex-math.h"

nx_dbl_t nx_floor(nx_dbl_t n)
{
	nx_sint_t i = (nx_sint_t)n;
	return (n > i) ? (i - 1) : i;
}

nx_dbl_t nx_ceiling(nx_dbl_t n)
{
	nx_sint_t i = (nx_sint_t)n;
	return (n > i) ? (i + 1) : i;
}

nx_dbl_t nx_round(nx_dbl_t n)
{
	return (nx_dbl_t)nx_floor(0.5 + n);
}

nx_dbl_t nx_trunc(nx_dbl_t n)
{
	return (n > 0) ? nx_floor(n) : nx_ceiling(n);
}

nx_dbl_t nx_fmod(nx_dbl_t n1, nx_dbl_t n2)
{
	return (n2 == 0) ? NX_NAN : n1 - nx_trunc(n1 / n2) * n2;
}

nx_dbl_t nx_absolute(nx_dbl_t n)
{
	if (n < 0)
		return n * -1;
	return n;
}

nx_dbl_t nx_euclidean(nx_dbl_t n1, nx_dbl_t n2)
{
	if (n1 < 1 || n2 < 1)
		return NX_NAN;
	nx_dbl_t n;
	while (n1) {
		n = n1;
		n1 = nx_fmod(n2, n1);
		n2 = n;
	}
	return n;
}

nx_dbl_t nx_lcd(nx_dbl_t n1, nx_dbl_t n2)
{
	nx_dbl_t n;
	return ((n = nx_euclidean(n1, n2)) == NX_NAN) ? n : n1 * n2 / n;
}

nx_dbl_t nx_mrange(nx_dbl_t n1, nx_dbl_t n2, nx_dbl_t n3, nx_dbl_t n4)
{
	n2 = n2 - n3;
	return nx_fmod(nx_fmod(n1 - n3 + n4, n2) + n2, n2) + n3;
}

nx_dbl_t nx_remainder(nx_dbl_t n1, nx_dbl_t n2)
{
	return (n2 == 0) ? NX_NAN : nx_fmod(n2 - nx_fmod(n2, n1), n2);
}

nx_size_t nx_factoral(nx_size_t n)
{
	if (n <= 0)
		return 0;
	if (n < 2)
		return 1;
	nx_size_t f = 1;
	do
		f = f * n;
	while (--n > 0);
	return f;
}

nx_size_t nx_fibonacci(nx_size_t n)
{
	if (n <= 0)
		return -1;
	if (n == 1)
		return 0;
	if (n == 2)
		return 1;
	nx_size_t n1 = 0, n2 = 0, n3 = 0;
	while (--n > 0) {
		n3 = n1 + n2;
		n1 = n2;
		n2 = n3;
	}
	return n2;
}

