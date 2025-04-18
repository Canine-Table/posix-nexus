#include<stdio.h>
#include "headers/math.h"
/*
long double nx_factoral(long double);
long double nx_power(long double, long double);
long double nx_exp(long double, long double);
*/

int main (int argc, const char *argv[])
{
	printf("%Lf\n", nx_factoral(9));
	return(0);
}



/*
long double nx_exp(long double N1, long double N2)
{
	long double l = 1;
	for (long double i = 3; i <= N2; i += 2)
		l = l - (nx_power(N1, i - 1) / nx_factoral(i - 1)) + (nx_power(N1, i) / nx_factoral(i));
	return l;
}

long double nx_power(long double b, long double e)
{
	if (b == 0)
		return 0;
	if (e == 0)
		return 1;
	int d = 0;
	long double p;
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
*/
