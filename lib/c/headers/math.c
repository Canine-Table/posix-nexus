#include <stdio.h>
#include "str.h"
#include "type.h"

void nex_fahcel(double *arr, unsigned int len)
{
	for (int i = 0; i < len; i++)
		arr[i] = 5.0 / 9.0 * (arr[i] - 32.0);
}

void nex_celfah(double *arr, unsigned int len)
{
	for (int i = 0; i < len; i++)
		arr[i] = 9.0 / 5.0 * arr[i] + 32.0;
}

static long __fibonacci(long, long, long);
static long __factoral(long, long);

long factoral(long n1)
{
	return __factoral(n1, 0);
}

static long __factoral(long n1, long n2)
{
	if (n1 < 2)
		return 1;
	if (! n2)
		n2 = n1 - 1;
	printf("%ld * %ld = %ld\n", n1, n2, n2 * n1);
	if (n2 > 1)
		return __factoral(n2 * n1, n2 - 1);
	return n1;
}

long fibonacci(long n1)
{
	return __fibonacci(n1, 0, 0);
}

long lcd(long n1, long n2)
{
	return (n1 * n2) / euclidean(n1, n2);
}

long euclidean(long n1, long n2)
{
	if (n2)
		return euclidean(n2, n1 % n2);
	return n1;
}

static long __fibonacci(long n1, long n2, long n3)
{
	printf("%ld + %ld = %ld\n", n3, n2, n2 + n3);
	if (! n3)
		return __fibonacci(--n1, 0, 1);
	if (--n1 > 1)
		return __fibonacci(n1, n3, n2 + n3);
	return n2 + n3;
}

