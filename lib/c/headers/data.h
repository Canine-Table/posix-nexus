#ifndef NX_DATA_H
#define NX_DATA_H
#include "def.h"
#include <stdlib.h>
#include <immintrin.h> /* AVX, AVX2 */
#include <emmintrin.h> /* SSE2 */

typedef struct {
	volatile nx_u32_t head;
	volatile nx_u32_t tail;
	nx_u32_t size;
	void **buffer;
} nx_lockfree_queue_t;

/* Initialize Lock-Free Queue */
#define NX_LOCKFREE_QUEUE_INIT(Q, BUFFER, SIZE)  \
	do {										 \
		(Q).head = 0;							\
		(Q).tail = 0;							\
		(Q).size = (SIZE);					   \
		(Q).buffer = (BUFFER);				   \
	} while (0)

/* Enqueue (Non-blocking) */
#define NX_LOCKFREE_ENQUEUE(Q, ITEM)						   \
	do {													   \
		nx_u32_t next = ((Q).head + 1) % (Q).size;			 \
		if (next != (Q).tail) {								\
			(Q).buffer[(Q).head] = (ITEM);					 \
			(Q).head = next;								   \
		}													  \
	} while (0)

/* Dequeue (Non-blocking) */
#define NX_LOCKFREE_DEQUEUE(Q, ITEM)						   \
	do {													   \
		if ((Q).tail != (Q).head) {							\
			(ITEM) = (Q).buffer[(Q).tail];					 \
			(Q).tail = ((Q).tail + 1) % (Q).size;			  \
		}													  \
	} while (0)

typedef struct nx_stack_node {
	void *data;
	struct nx_stack_node *next;
} nx_stack_node_t;

typedef struct {
	atomic_ptr_t top;
} nx_lockfree_stack_t;

typedef struct nx_hash_entry {
	atomic_uint key;
	atomic_ptr_t value;
	struct nx_hash_entry *next;  /* Chaining for collisions */
} nx_hash_entry_t;

typedef struct {
	nx_hash_entry_t *buckets[NX_HASH_TABLE_SIZE];
} nx_lockfree_hash_t;

typedef struct nx_mempool_node {
	struct nx_mempool_node *next;
} nx_mempool_node_t;

typedef struct {
	atomic_ptr_t free_list;
	nx_u32_t block_size;
	nx_u32_t total_blocks;
	void *memory;
} nx_lockfree_mempool_t;

typedef struct {
	atomic_uint head;
	atomic_uint tail;
	nx_u32_t size;
	void **buffer;
} nx_lockfree_ringbuffer_t;

typedef struct nx_priority_node {
	nx_u32_t priority;
	void *data;
	struct nx_priority_node *next;
} nx_priority_node_t;

typedef struct {
	atomic_ptr_t head;
} nx_lockfree_priority_queue_t;

typedef struct nx_graph_node {
	nx_u32_t id;
	atomic_ptr_t next;  /* Atomic pointer to the next node */
} nx_graph_node_t;

typedef struct nx_graph_edge {
	nx_graph_node_t *src;
	nx_graph_node_t *dst;
	atomic_ptr_t next;  /* Atomic pointer to the next edge */
} nx_graph_edge_t;

typedef struct {
	atomic_ptr_t nodes; /* Head pointer to nodes */
	atomic_ptr_t edges; /* Head pointer to edges */
} nx_lockfree_graph_t;

typedef struct {
	atomic_uint chosen_value; /* The agreed-upon consensus value */
} nx_lockfree_consensus_t;

typedef struct {
	atomic_uint proposal_id;
	atomic_uint accepted_value;
} nx_lockfree_paxos_t;

typedef struct {
	atomic_uint proposal_id;
	atomic_uint vote_count;
	atomic_uint final_decision;
} nx_lockfree_byzantine_t;

static inline __m128 nx_vec_add_f32(__m128, __m128);
static inline __m256 nx_vec_mul_f32(__m256, __m256);
static inline __m128 nx_vec_sub_f32(__m128, __m128);
static inline __m256 nx_vec_sqrt_f32(__m256);
static inline __m256i nx_vec_add_i32(__m256i, __m256i);
static inline __m256i nx_vec_mul_i32(__m256i, __m256i);
static inline __m256i nx_vec_and_i32(__m256i, __m256i);
static inline __m256i nx_vec_xor_i32(__m256i, __m256i);
static inline nx_s32_t nx_lockfree_enqueue(nx_lockfree_queue_t*, void*);
static inline nx_s32_t nx_lockfree_dequeue(nx_lockfree_queue_t*, void**);
static inline void nx_lockfree_queue_init(nx_lockfree_queue_t*, void**, nx_u32_t);
static inline void nx_lockfree_stack_init(nx_lockfree_stack_t*);
static inline void nx_lockfree_stack_push(nx_lockfree_stack_t*, nx_stack_node_t*);
static inline nx_stack_node_t *nx_lockfree_stack_pop(nx_lockfree_stack_t*);
static inline void nx_lockfree_hash_init(nx_lockfree_hash_t*);
static inline void nx_lockfree_hash_insert(nx_lockfree_hash_t*, nx_u32_t, void*);
static inline void *nx_lockfree_hash_lookup(nx_lockfree_hash_t *table, nx_u32_t);
static inline void nx_lockfree_mempool_free(nx_lockfree_mempool_t*, void*);
static inline void nx_lockfree_mempool_init(nx_lockfree_mempool_t*, nx_u32_t, nx_u32_t);
static inline void *nx_lockfree_mempool_alloc(nx_lockfree_mempool_t*);
static inline void nx_lockfree_mempool_free(nx_lockfree_mempool_t*, void*);
static inline void nx_lockfree_ringbuffer_init(nx_lockfree_ringbuffer_t*, void**, nx_u32_t);
static inline nx_s32_t nx_lockfree_ringbuffer_enqueue(nx_lockfree_ringbuffer_t*, void*);
static inline nx_s32_t nx_lockfree_ringbuffer_dequeue(nx_lockfree_ringbuffer_t*, void**);
static inline void nx_lockfree_priority_queue_init(nx_lockfree_priority_queue_t*);
static inline void nx_lockfree_priority_enqueue(nx_lockfree_priority_queue_t*, nx_u32_t, void*);
static inline void *nx_lockfree_priority_dequeue(nx_lockfree_priority_queue_t*);
static inline void nx_lockfree_graph_init(nx_lockfree_graph_t*);
static inline void nx_lockfree_graph_add_node(nx_lockfree_graph_t*, nx_u32_t);
static inline void nx_lockfree_graph_add_edge(nx_lockfree_graph_t*, nx_graph_node_t*, nx_graph_node_t*);
static inline void nx_lockfree_graph_bfs(nx_lockfree_graph_t*, nx_graph_node_t*);
static inline nx_u32_t nx_dhash(nx_u32_t);
static inline void nx_lockfree_dhash_init(nx_lockfree_hash_t*);
static inline void nx_lockfree_dhash_insert(nx_lockfree_hash_t*, nx_u32_t, void*);
static inline void *nx_lockfree_dhash_lookup(nx_lockfree_hash_t*, nx_u32_t);
static inline void nx_lockfree_consensus_init(nx_lockfree_consensus_t*);
static inline int nx_lockfree_consensus_vote(nx_lockfree_consensus_t*, nx_u32_t);
static inline int nx_lockfree_consensus_vote(nx_lockfree_consensus_t*, nx_u32_t);
static inline int nx_lockfree_paxos_propose(nx_lockfree_paxos_t*, nx_u32_t, nx_u32_t);
static inline int nx_lockfree_byzantine_propose(nx_lockfree_byzantine_t*, nx_u32_t, nx_u32_t);
static inline void nx_lockfree_byzantine_init(nx_lockfree_byzantine_t*);
static inline int nx_lockfree_byzantine_vote(nx_lockfree_byzantine_t*, nx_u32_t, nx_u32_t);

#include "data.c"
#endif
/*
lock-free distributed leader election
SIMD-accelerated sorting
SIMD-powered data compression
SIMD-optimized matrix operations
SIMD-optimized cryptography
*/

