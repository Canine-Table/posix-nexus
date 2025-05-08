#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "headers/nex-define.h"
#include "headers/nex-str.h"
#include "headers/nex-math.h"
#include "headers/nex-bit.h"
#include "headers/nex-data.h"

nx_sint_t main (nx_sint_t argc, nx_Char_t *argv[])
{
	nx_char_stack_s *stack = nx_char_cstack(10); // Create stack with initial capacity of 10
	nx_char_push(stack, "Hello");
	printf("Top of stack: %s\n", nx_char_peek(stack)); // Should print "World"
	nx_char_fstack(stack);
	/*
	nx_ptrdiff_t *st = nx_atol(argc, argv);
	for (nx_uint_t i = 1; i < argc; i++) {

		if (nx_even(&st[i]))
			printf("%ld is even\n", st[i]);
		else
			printf("%ld is odd\n", st[i]);
		nx_printb(st[i]);
		printf("%ld\n", nx_nxt_pot(st[i]));
		printf("%ld\n", nx_bk_cnt(&st[i], sizeof(st[i])));
		printf("\n");
	}
	free(st);  \ * Prevent memory leak * /
	*/
	return(0);
}

