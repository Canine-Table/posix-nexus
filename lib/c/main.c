#include "headers/nex-define.h"
#include "headers/nex-math.h"
#include "headers/nex-misc.h"
#include "headers/nex-atomic.h"
#include <stdio.h>

int main(int argc, const char *argv[])
{
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
	return(0);
}

