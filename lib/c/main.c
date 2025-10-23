#include "headers/nex-define.h"
#include "headers/nex-math.h"
#include "headers/nex-string.h"
//#include "headers/nex-misc.h"
//#include "headers/nex-atomic.h"
//#include "headers/nex-data.h"
//#include "headers/nex-string.h"
//#include "headers/nex-type.h"
//#include "headers/nex-string.h"
#include "headers/nex-io.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, const char *argv[])
{
	nx_d_PcT arr[64] = {
		"^e>E%^a>A%^w>W%^i>A%^i>I%^0",
		"string 1\n",
		"string 2\n",
		"string 3\n",
		"string 4\n",
		"string 5\n",
		"\0"
	};
	nx_ansi_F(arr);
	//nx_d_isT abc = nx_add_isF(1, 2);
	//printf("%d\n", nx_bkbc_isF(&abc,  4));
	//printf("%d\n", nx_dm_parity_M(4));
	return(0);
}

