//#include "headers/nex-define.h"
//#include "headers/nex-math.h"
//#include "headers/nex-misc.h"
//#include "headers/nex-atomic.h"
//#include "headers/nex-data.h"
//#include "headers/nex-string.h"
#include "headers/nex-type.h"
#include "headers/nex-string.h"
#include "headers/nex-math.h"
#include <stdlib.h>
#include <stdio.h>



/*

typedef struct {
	char arr[4];
}

int add(int a, int b) {
	nx_dd_bprint_F(a);
	nx_dd_bprint_F(b);
	while (b) {
		int carry = (a & b) << 1; // Compute the carry
		a = a ^ b; // Sum without carry
		b = carry; // Carry moves to the next bit
	}
	nx_dd_bprint_F(a);
    return a;
}


*/

int main(int argc, const char *argv[])
{

	//nx_dd_badd_isF(5, 5);
	nx_dd_bsub_isF(5, 2);

	//nx_d_S var_val;
	//nx_d_F(&var_val, NX_DD_FT, 3.14196);
	//printf("%f\n", var_val.data.NX_DD_E.data.NX_DD_FT);
	//nx_dd_S var_n;

	//nx_dd_atolf_EF(&var_n, "3.14");
	//printf("%f\n", var_n.data.NX_DD_FT);
	//printf("%d\n", );
	//printf("%s:\t%d\n", argv[1], nx_dd_isnum_isF(argv[1]));

	//printf("%d", NX_DD_MAX_IST);
	//printf("%d\n", NX_DD_MAX_FT);

	/*
	printf("%d\n", NX_DD_MIN_IST);
	printf("%d\n", NX_DD_MAX_IST);
	printf("%u\n", NX_DD_MAX_IUT);
	printf("%u\n", NX_DD_MIN_IUT);
	*/
	//printf("%u\n", NX_DD_MAX_IUT - NX_DD_MIN_IST);
	//		argv[1], nx_isnum_isF(argv[1]));


//2147483647

	//return hello("hello world");
	//nx_dd_S val;
	//printf("%d\n", nx_dd_isF(&val, 32));
	//printf("%f\n", nx_dd_fF(&val, 3.14));
	/*
	printf("%d\n", nx_isint_isF('1'));
	printf("%d\n", nx_ishex_isF('F'));
	printf("%d\n", nx_islhex_isF('F'));
	printf("%d\n", nx_ishex_isF('a'));
	printf("%d\n", nx_isuhex_isF('a'));
	*/
	//nx_int_st my_stk[10];
	//printf("%s\n", NX_STAGE_TWO); // / sizeof(my_stk[0]));
	//nx_dd_int_stk_sSt the_stk  = { .data = my_stk };
	//nx_dd_int_stk_init_sf(&the_stk, sizeof(my_stk));
	//nx_stk_init_f(&the_stk);
	//
	//nx_stk_push_f(&the_stk
	//return(0);
}


/*
nx_void_t nx_dd_int_stk_push_sf(nx_dd_int_stk_sSt *s, nx_int_st d)
{
	s->data[s->top++] = d;
}

nx_void_t nx_dd_int_stk_init_sf(nx_dd_int_stk_sSt *s)
{
	if (!
	NX_TOK_LENGTH
	s->top = 0;
}
	nx_float_pt p_flt = nx_atof(argc, argv);
	nx_int_st s = sizeof(*p_flt) / sizeof(p_flt[0]);
	for (nx_int_st i = 0; i < s; i++)
		printf("%f\n", p_flt[i]);
	free(p_flt);
	nx_lockfree_queue_St myQueue;
	nx_void_pt buf[8];
	NX_LOCKFREE_QUEUE_INIT(myQueue, buf, 8);
	NX_LOCKFREE_ENQUEUE(myQueue, (nx_void_ppt *) "Item 1");
	NX_LOCKFREE_ENQUEUE(myQueue, (nx_void_ppt *) "Item 2");
	nx_void_pt item = NX_NULL;
	NX_LOCKFREE_DEQUEUE(myQueue, item);
	printf("Dequeued: %s\n", (char *) item);
	NX_LOCKFREE_DEQUEUE(myQueue, item);
	printf("Dequeued: %s\n", (char *) item);
	*/
	
