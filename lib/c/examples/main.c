#include "headers/nex-define.h"
#include <stdio.h>

int main(int argc, const char *argv[])
{
	nx_dd_St my_var;
	printf("%d\n", nx_dd_int_sf(&my_var, 21));
	printf("%f\n", nx_dd_float_f(&my_var, 45.423));
	return(0);
}

