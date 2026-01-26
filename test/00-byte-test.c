#include "headers/nex-bw.h"
//#include "headers/nex-vm.h"
#include "headers/nex-byte.h"
#include <stdio.h>
#include <limits.h>

int main(int argc, const char *argv[])
{
	NX_wbbS resA;
	NX_wbbS resB;
	NX_wbbS resC;
	NX_wbbS resD;
	unsigned char a = 123;
	unsigned char b = 234;
	NX_set_b1wBBF(&resA, a, b);

	printf("%hu\n", NX_get_v1WF(&resA));

	NX_set_b1wVF(&resB, 2048);
	printf("%hu\n", NX_get_v1WF(&resB));

	// test swap
	NX_swap_b1w1wF(&resA, &resB);
	printf("%hu\n", NX_get_v1WF(&resA));
	printf("%hu\n", NX_get_v1WF(&resB));

	switch (NX_cmp_b1W1WF(&resA, &resB)) {
		case 0:
			printf("%hu is eq %hu\n", NX_get_v1WF(&resA), NX_get_v1WF(&resB));
			break;
		case 1:
			printf("%hu is gt %hu\n", NX_get_v1WF(&resA), NX_get_v1WF(&resB));
			break;
		case UCHAR_MAX:
			printf("%hu is lt %hu\n", NX_get_v1WF(&resA), NX_get_v1WF(&resB));
			break;
	}

	switch (NX_cmp_b1W1WF(&resB, &resB)) {
		case 0:
			printf("%hu is eq %hu\n", NX_get_v1WF(&resB), NX_get_v1WF(&resB));
			break;
		case 1:
			printf("%hu is gt %hu\n", NX_get_v1WF(&resB), NX_get_v1WF(&resB));
			break;
		case UCHAR_MAX:
			printf("%hu is lt %hu\n", NX_get_v1WF(&resB), NX_get_v1WF(&resB));
			break;
	}

	switch (NX_cmp_b1W1WF(&resB, &resA)) {
		case 0:
			printf("%hu is eq %hu\n", NX_get_v1WF(&resB), NX_get_v1WF(&resA));
			break;
		case 1:
			printf("%hu is gt %hu\n", NX_get_v1WF(&resB), NX_get_v1WF(&resA));
			break;
		case UCHAR_MAX:
			printf("%hu is lt %hu\n", NX_get_v1WF(&resB), NX_get_v1WF(&resA));
			break;
	}

	// test add
	NX_add_b1w1W1WF(&resC, &resB, &resA);
	printf("add: %hu\n", NX_get_v1WF(&resC));

	// test sub
	NX_sub_b1w1W1WF(&resC, &resB, &resA);
	printf("sub: %hu\n", NX_get_v1WF(&resC));
	
	// test sub
	NX_div_b1w1W1WF(&resC, &resB, &resA);
	printf("div: %hu\n", NX_get_v1WF(&resC));

	// test mul
	NX_set_b1wVF(&resA, 64);
	NX_set_b1wVF(&resB, NX_get_v1WF(&resA));
	NX_mul_b1w1W1WF(&resC, &resB, &resA);
	printf("mul: %hu\n", NX_get_v1WF(&resC));

	NX_set_b1wVF(&resB, 2);
	//test min
	NX_min_b1w1W1WF(&resC, &resB, &resA);
	printf("min: %hu\n", NX_get_v1WF(&resC));

	// test clamp
	NX_set_b1wVF(&resA, 50);   // x
	NX_set_b1wVF(&resB, 10);   // lo
	NX_set_b1wVF(&resC, 100);  // hi
	NX_clamp_b1w1W1W1WF(&resD, &resA, &resB, &resC);
	printf("clamp(50,10,100): %hu\n", NX_get_v1WF(&resD));

	// x < lo
	NX_set_b1wVF(&resA, 0);
	NX_clamp_b1w1W1W1WF(&resD, &resA, &resB, &resC);
	printf("clamp(0,10,100): %hu\n", NX_get_v1WF(&resD));

	// x > hi
	NX_set_b1wVF(&resA, 200);
	NX_clamp_b1w1W1W1WF(&resD, &resA, &resB, &resC);
	printf("clamp(200,10,100): %hu\n", NX_get_v1WF(&resD));

	// degenerate lo == hi
	NX_set_b1wVF(&resB, 42);
	NX_set_b1wVF(&resC, 42);
	NX_set_b1wVF(&resA, 999);
	NX_clamp_b1w1W1W1WF(&resD, &resA, &resB, &resC);
	printf("clamp(999,42,42): %hu\n", NX_get_v1WF(&resD));

	return(1);
}

