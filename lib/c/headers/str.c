#include <stdio.h>

char *nex_srvs(char *arr, unsigned int r)
{
	int l = 0;
	if (r == 0)
		r = nex_iscan();
	for (r = nex_slen(arr, r); r > l; r--, l++) {
		char t = arr[l];
		arr[l] = arr[r];
		arr[r] = t;
	}
	return arr;
}

int nex_iscan()
{
	int l = 0;
	printf("length: ");
	scanf("%d", &l);
	nex_fflush();
	if (l)
		return l;
	perror("nex_iscan: Not an integer!");
	return nex_iscan();
}

int nex_slen(char *arr, unsigned int len)
{
	printf("line: ");
	fgets(arr, len + 2, stdin);
	int i = 0;
	while (arr[++i] != '\0');
	if (--i == 0) {
		perror("nex_slen: Input Required!");
		return nex_slen(arr, len);
	}
	return i;
}

void nex_fflush()
{
	while (getchar() != '\n');
}

