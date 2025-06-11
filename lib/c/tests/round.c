#include "../headers/nex-define.h"
#include "../headers/nex-math.h"
#include <stdio.h>

int main(int argc, const char *argv[])
{
	nx_dd_St my_var;
	printf("%f\n", nx_dd_float_f(&my_var, 3.9));
	printf("Trunc (signed) %d\n", nx_dd_trunc_sf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, -3.9));
	printf("Trunc (signed) %d\n", nx_dd_trunc_sf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, 3.5));
	printf("Floor (signed) %d\n", nx_dd_floor_sf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, -3.5));
	printf("Floor (signed) %d\n", nx_dd_floor_sf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, 3.5));
	printf("Ceil (signed): %d\n", nx_dd_ceil_sf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, -3.5));
	printf("Round (signed): %d\n", nx_dd_round_sf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, 3.5));
	printf("Floor (unsigned) %d\n", nx_dd_floor_uf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, -3.5));
	printf("Ceil (unsigned): %d\n", nx_dd_ceil_uf(&my_var));
	printf("%f\n", nx_dd_float_f(&my_var, 3.5));
	printf("Round (unsigned): %d\n", nx_dd_round_uf(&my_var));
	return(0);
}

