#include "headers/type.h"
#include "headers/math.h"
#include "headers/file.h"
#include "headers/data.h"
#include "headers/str.h"
#include<stdio.h>

int main()
{
	int max = nex_iscan();
	char arr[max + 2];
	nex_srvs(arr, max);
	printf("reversed string: %s", arr);
	return(0);
}

