#include <stdio.h>

char *nx_srvs(char *arr, unsigned int r)
{
	int l = 0;
	if (r == 0)
		r = nx_iscan();
	for (r = nx_slen(arr, r); r > l; r--, l++) {
		char t = arr[l];
		arr[l] = arr[r];
		arr[r] = t;
	}
	return arr;
}

int nx_iscan()
{
	int l = 0;
	printf("length: ");
	scanf("%d", &l);
	nx_fflush();
	if (l)
		return l;
	perror("nx_iscan: Not an integer!");
	return nx_iscan();
}

int nx_slen(char *arr, unsigned int len)
{
	printf("line: ");
	fgets(arr, len + 2, stdin);
	int i = 0;
	while (arr[++i] != '\0');
	if (--i == 0) {
		perror("nex_slen: Input Required!");
		return nx_slen(arr, len);
	}
	return i;
}

void nx_fflush()
{
	while (getchar() != '\n');
}

