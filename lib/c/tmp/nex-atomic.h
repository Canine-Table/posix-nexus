#ifndef NX_ATOMIC_H
#define NX_ATOMIC_H

typedef struct {
	volatile nx_int_ut head;
	volatile nx_int_ut tail;
	nx_int_ut size;
	nx_void_ppt buffer;
} nx_lockfree_queue_St;

/* Initialize Lock-Free Queue */
#define NX_LOCKFREE_QUEUE_INIT(Q, BUFFER, SIZE) \
	do { \
		(Q).head = 0; \
		(Q).tail = 0; \
		(Q).size = SIZE; \
		(Q).buffer = (BUFFER); \
	} while (0)

/* Enqueue (Non-blocking) */
#define NX_LOCKFREE_ENQUEUE(Q, ITEM) \
	do { \
		nx_int_ut next = NX_MOD_POT(((Q).head + 1), (Q).size); \
		if (next != (Q).tail) { \
			(Q).buffer[(Q).head] = (ITEM); \
			(Q).head = next; \
		} \
	} while (0)

/* Dequeue (Non-blocking) */
#define NX_LOCKFREE_DEQUEUE(Q, ITEM) \
	do { \
		if ((Q).tail != (Q).head) { \
			(ITEM) = (Q).buffer[(Q).tail]; \
			(Q).tail = NX_MOD_POT(((Q).tail + 1), (Q).size); \
		} \
	} while (0)

#endif

