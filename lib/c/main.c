#include "headers/nex-define.h"
#include "headers/nex-math.h"
#include "headers/nex-string.h"
//#include "headers/nex-misc.h"
//#include "headers/nex-atomic.h"
//#include "headers/nex-data.h"
//#include "headers/nex-string.h"
//#include "headers/nex-type.h"
//#include "headers/nex-string.h"
//#include "headers/nex-math.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

nx_d_T nx_d_prnt_F(nx_d_PcT[]);

int main(int argc, const char *argv[])
{
	nx_d_PcT arr[] = {
		"string 1",
		"string 2",
		"string 3",
		"string 4",
		"string 5",
		"<nx:null/>"
	};
	nx_d_prnt_F(arr);
	//nx_d_isT abc = nx_add_isF(1, 2);
	//printf("%d\n", nx_bkbc_isF(&abc,  4));
	//printf("%d\n", nx_dm_parity_M(4));
	return(0);
}

nx_d_T nx_d_prnt_F(nx_d_PcT arr[])
{
	nx_d_iuT len = 0;
	if (strcmp(arr[++len], "<nx:null/>") != 0);
	for (nx_d_iuT i = 0; i <= len; ++i)
		printf("%s\n", arr[i]);
}

