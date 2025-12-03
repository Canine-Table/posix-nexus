#include "headers/nex-define.h"
#include "headers/nex-data.h"
#include <stdio.h>

//#include "headers/nex-math.h"
//#include "headers/nex-string.h"
//#include "headers/nex-misc.h"
//#include "headers/nex-atomic.h"
//#include "headers/nex-string.h"
//#include "headers/nex-type.h"
//#include "headers/nex-string.h"
//#include "headers/nex-io.h"
//#include <string.h>
//#include <stdlib.h>

int main(int argc, const char *argv[])
{
	nX256_d_cS arr;
	nX256_a_stk_cF(&arr.cur, 'a');
	nX256_a_stk_cF(&arr.cur, 'b');
	nX256_a_stk_cF(&arr.cur, 'c');
	nX256_a_stk_cF(&arr.cur, 'd');
	
	nX256_f_stk_cF(&arr.cur, 'f');
	/*
	arr.cur[1].c = '4';
	arr.cur[2].c = 'b';
	arr.cur[3].c = 'a';
	arr.cur[4].c = '\0';
	arr.prev = arr.cur[0]
	nX256_a_stk_cF(&arr, 'b');
	nX256_a_stk_cF(&arr, 'c');
	nX256_f_stk_cF(&arr, 'y');
	nX256_f_stk_cF(&arr, 'f');
	nX256_f_stk_cF(&arr, 'Y');
	*/
	return(1);
}

