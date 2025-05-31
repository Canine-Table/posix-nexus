#include <stdlib.h>
#include <immintrin.h> /* AVX, AVX2 */
#include <emmintrin.h> /* SSE2 */
/*
/* SIMD Addition (SSE2) */
static inline __m128 nx_vec_add_f32(__m128 a, __m128 b)
{
	return _mm_add_ps(a, b);
}

/* SIMD Multiplication (AVX) */
static inline __m256 nx_vec_mul_f32(__m256 a, __m256 b)
{
	return _mm256_mul_ps(a, b);
}

/* SIMD Subtraction (SSE2) */
static inline __m128 nx_vec_sub_f32(__m128 a, __m128 b)
{
	return _mm_sub_ps(a, b);
}

/* SIMD Square Root (AVX) */
static inline __m256 nx_vec_sqrt_f32(__m256 a)
{
	return _mm256_sqrt_ps(a);
}

/* SIMD Integer Addition */
static inline __m256i nx_vec_add_i32(__m256i a, __m256i b)
{
	return _mm256_add_epi32(a, b);
}

/* SIMD Integer Multiplication */
static inline __m256i nx_vec_mul_i32(__m256i a, __m256i b)
{
	return _mm256_mullo_epi32(a, b);
}

/* SIMD Bitwise AND */
static inline __m256i nx_vec_and_i32(__m256i a, __m256i b)
{
	return _mm256_and_si256(a, b);
}

/* SIMD Bitwise XOR */
static inline __m256i nx_vec_xor_i32(__m256i a, __m256i b)
{
	return _mm256_xor_si256(a, b);
}

/* Initialize Lock-Free Queue */
static inline void nx_lockfree_queue_init(nx_lockfree_queue_t *q, void **buffer, nx_u32_t size)
{
	atomic_store(&q->head, 0);
	atomic_store(&q->tail, 0);
	q->size = size;
	q->buffer = buffer;
}

/* Enqueue (Non-blocking) */
static inline nx_s32_t nx_lockfree_enqueue(nx_lockfree_queue_t *q, void *item)
{
	nx_u32_t head = atomic_load(&q->head);
	nx_u32_t next = (head + 1) % q->size;
	
	if (next == atomic_load(&q->tail)) {
		return 0; /* Queue Full */
	}

	q->buffer[head] = item;
	atomic_store(&q->head, next);
	return 1; /* Success */
}

/* Dequeue (Non-blocking) */
static inline nx_s32_t nx_lockfree_dequeue(nx_lockfree_queue_t *q, void **item)
{
	nx_u32_t tail = atomic_load(&q->tail);

	if (tail == atomic_load(&q->head)) {
		return 0; /* Queue Empty */
	}

	*item = q->buffer[tail];
	atomic_store(&q->tail, (tail + 1) % q->size);
	return 1; /* Success */
}


/* Initialize Lock-Free Stack */
static inline void nx_lockfree_stack_init(nx_lockfree_stack_t *stack)
{
	atomic_store(&stack->top, NX_NULL);
}

/* Push (Lock-Free) */
static inline void nx_lockfree_stack_push(nx_lockfree_stack_t *stack, nx_stack_node_t *node)
{
	nx_stack_node_t *old_top;
	do {
		old_top = atomic_load(&stack->top);
		node->next = old_top;
	} while (!atomic_compare_exchange_weak(&stack->top, &old_top, node));
}

/* Pop (Lock-Free) */
static inline nx_stack_node_t *nx_lockfree_stack_pop(nx_lockfree_stack_t *stack)
{
	nx_stack_node_t *old_top;
	do {
		old_top = atomic_load(&stack->top);
		if (!old_top) return NX_NULL;  /* Stack Empty */
	} while (!atomic_compare_exchange_weak(&stack->top, &old_top, old_top->next));
	return old_top;
}

/* Initialize Hash Table */
static inline void nx_lockfree_hash_init(nx_lockfree_hash_t *table)
{
	for (nx_u32_t i = 0; i < NX_HASH_TABLE_SIZE; i++) {
		table->buckets[i] = NX_NULL;
	}
}

/* Lock-Free Insert */
static inline void nx_lockfree_hash_insert(nx_lockfree_hash_t *table, nx_u32_t key, void *value)
{
	nx_u32_t index = nx_hash(key);
	nx_hash_entry_t *new_entry = malloc(sizeof(nx_hash_entry_t));
	new_entry->key = key;
	atomic_store(&new_entry->value, value);

	nx_hash_entry_t *old_head;
	do {
		old_head = atomic_load(&table->buckets[index]);
		new_entry->next = old_head;
	} while (!atomic_compare_exchange_weak(&table->buckets[index], &old_head, new_entry));
}

/* Lock-Free Lookup */
static inline void *nx_lockfree_hash_lookup(nx_lockfree_hash_t *table, nx_u32_t key)
{
	nx_u32_t index = nx_hash(key);
	nx_hash_entry_t *entry = atomic_load(&table->buckets[index]);

	while (entry) {
		if (atomic_load(&entry->key) == key) {
			return atomic_load(&entry->value);
		}
		entry = entry->next;
	}
	return NX_NULL;
}

/* Initialize Lock-Free Memory Pool */
static inline void nx_lockfree_mempool_init(nx_lockfree_mempool_t *pool, nx_u32_t block_size, nx_u32_t total_blocks)
{
	pool->block_size = block_size;
	pool->total_blocks = total_blocks;
	pool->memory = malloc(block_size * total_blocks);
	pool->free_list = NX_NULL;

	for (nx_u32_t i = 0; i < total_blocks; i++) {
		nx_mempool_node_t *node = (nx_mempool_node_t *)((char *)pool->memory + i * block_size);
		node->next = atomic_load(&pool->free_list);
		atomic_store(&pool->free_list, node);
	}
}

/* Allocate (Lock-Free) */
static inline void *nx_lockfree_mempool_alloc(nx_lockfree_mempool_t *pool)
{
	nx_mempool_node_t *node;
	do {
		node = atomic_load(&pool->free_list);
		if (!node) return NX_NULL; /* Memory pool exhausted */
	} while (!atomic_compare_exchange_weak(&pool->free_list, &node, node->next));

	return (void *)node;
}

/* Deallocate (Lock-Free) */
static inline void nx_lockfree_mempool_free(nx_lockfree_mempool_t *pool, void *ptr)
{
	nx_mempool_node_t *node = (nx_mempool_node_t *)ptr;
	nx_mempool_node_t *old_head;
	do {
		old_head = atomic_load(&pool->free_list);
		node->next = old_head;
	} while (!atomic_compare_exchange_weak(&pool->free_list, &old_head, node));
}


/* Initialize Lock-Free Memory Pool */
static inline void nx_lockfree_mempool_init(nx_lockfree_mempool_t *pool, nx_u32_t block_size, nx_u32_t total_blocks)
{
	pool->block_size = block_size;
	pool->total_blocks = total_blocks;
	pool->memory = malloc(block_size * total_blocks);
	pool->free_list = NX_NULL;

	for (nx_u32_t i = 0; i < total_blocks; i++) {
		nx_mempool_node_t *node = (nx_mempool_node_t *)((char *)pool->memory + i * block_size);
		node->next = atomic_load(&pool->free_list);
		atomic_store(&pool->free_list, node);
	}
}

/* Allocate (Lock-Free) */
static inline void *nx_lockfree_mempool_alloc(nx_lockfree_mempool_t *pool)
{
	nx_mempool_node_t *node;
	do {
		node = atomic_load(&pool->free_list);
		if (!node) return NX_NULL; /* Memory pool exhausted */
	} while (!atomic_compare_exchange_weak(&pool->free_list, &node, node->next));

	return (void *)node;
}

/* Deallocate (Lock-Free) */
static inline void nx_lockfree_mempool_free(nx_lockfree_mempool_t *pool, void *ptr)
{
	nx_mempool_node_t *node = (nx_mempool_node_t *)ptr;
	nx_mempool_node_t *old_head;
	do {
		old_head = atomic_load(&pool->free_list);
		node->next = old_head;
	} while (!atomic_compare_exchange_weak(&pool->free_list, &old_head, node));
}

/* Initialize Lock-Free Ring Buffer */
static inline void nx_lockfree_ringbuffer_init(nx_lockfree_ringbuffer_t *rb, void **buffer, nx_u32_t size)
{
	atomic_store(&rb->head, 0);
	atomic_store(&rb->tail, 0);
	rb->size = size;
	rb->buffer = buffer;
}

/* Enqueue (Non-blocking) */
static inline nx_s32_t nx_lockfree_ringbuffer_enqueue(nx_lockfree_ringbuffer_t *rb, void *item)
{
	nx_u32_t head = atomic_load(&rb->head);
	nx_u32_t next = (head + 1) % rb->size;

	if (next == atomic_load(&rb->tail)) {
		return 0; /* Buffer Full */
	}

	rb->buffer[head] = item;
	atomic_store(&rb->head, next);
	return 1; /* Success */
/* Initialize Priority Queue */
static inline void nx_lockfree_priority_queue_init(nx_lockfree_priority_queue_t *pq) {
	atomic_store(&pq->head, NX_NULL);
}

/* Lock-Free Insert (Ordered by Priority) */
static inline void nx_lockfree_priority_enqueue(nx_lockfree_priority_queue_t *pq, nx_u32_t priority, void *data) {
	nx_priority_node_t *new_node = malloc(sizeof(nx_priority_node_t));
	new_node->priority = priority;
	new_node->data = data;
	
	nx_priority_node_t *old_head;
	do {
		old_head = atomic_load(&pq->head);

		/* Find correct insertion point */
		if (!old_head || priority < old_head->priority) {
			new_node->next = old_head;
		} else {
			nx_priority_node_t *current = old_head;
			while (current->next && current->next->priority <= priority) {
				current = current->next;
			}
			new_node->next = current->next;
			current->next = new_node;
			return;
		}
	} while (!atomic_compare_exchange_weak(&pq->head, &old_head, new_node));
}

/* Lock-Free Extract (Pop Highest Priority) */
static inline void *nx_lockfree_priority_dequeue(nx_lockfree_priority_queue_t *pq) {
	nx_priority_node_t *old_head;
	do {
		old_head = atomic_load(&pq->head);
		if (!old_head) return NX_NULL; /* Queue Empty */
	} while (!atomic_compare_exchange_weak(&pq->head, &old_head, old_head->next));

	void *data = old_head->data;
	free(old_head);
	return data;
}

/* Dequeue (Non-blocking) */
static inline nx_s32_t nx_lockfree_ringbuffer_dequeue(nx_lockfree_ringbuffer_t *rb, void **item)
{
	nx_u32_t tail = atomic_load(&rb->tail);

	if (tail == atomic_load(&rb->head)) {
		return 0; /* Buffer Empty */
	}

	*item = rb->buffer[tail];
	atomic_store(&rb->tail, (tail + 1) % rb->size);
	return 1; /* Success */
}

/* Initialize Priority Queue */
static inline void nx_lockfree_priority_queue_init(nx_lockfree_priority_queue_t *pq)
{
	atomic_store(&pq->head, NX_NULL);
}

/* Lock-Free Insert (Ordered by Priority) */
static inline void nx_lockfree_priority_enqueue(nx_lockfree_priority_queue_t *pq, nx_u32_t priority, void *data)
{
	nx_priority_node_t *new_node = malloc(sizeof(nx_priority_node_t));
	new_node->priority = priority;
	new_node->data = data;
	
	nx_priority_node_t *old_head;
	do {
		old_head = atomic_load(&pq->head);

		/* Find correct insertion point */
		if (!old_head || priority < old_head->priority) {
			new_node->next = old_head;
		} else {
			nx_priority_node_t *current = old_head;
			while (current->next && current->next->priority <= priority) {
				current = current->next;
			}
			new_node->next = current->next;
			current->next = new_node;
			return;
		}
	} while (!atomic_compare_exchange_weak(&pq->head, &old_head, new_node));
}

/* Lock-Free Extract (Pop Highest Priority) */
static inline void *nx_lockfree_priority_dequeue(nx_lockfree_priority_queue_t *pq)
{
	nx_priority_node_t *old_head;
	do {
		old_head = atomic_load(&pq->head);
		if (!old_head) return NX_NULL; /* Queue Empty */
	} while (!atomic_compare_exchange_weak(&pq->head, &old_head, old_head->next));

	void *data = old_head->data;
	free(old_head);
	return data;
}

/* Initialize Graph */
static inline void nx_lockfree_graph_init(nx_lockfree_graph_t *graph)
{
	atomic_store(&graph->nodes, NX_NULL);
	atomic_store(&graph->edges, NX_NULL);
}

/* Lock-Free Node Addition */
static inline void nx_lockfree_graph_add_node(nx_lockfree_graph_t *graph, nx_u32_t id)
{
	nx_graph_node_t *new_node = malloc(sizeof(nx_graph_node_t));
	new_node->id = id;
	
	nx_graph_node_t *old_head;
	do {
		old_head = atomic_load(&graph->nodes);
		new_node->next = old_head;
	} while (!atomic_compare_exchange_weak(&graph->nodes, &old_head, new_node));
}

/* Lock-Free Edge Addition */
static inline void nx_lockfree_graph_add_edge(nx_lockfree_graph_t *graph, nx_graph_node_t *src, nx_graph_node_t *dst)
{
	nx_graph_edge_t *new_edge = malloc(sizeof(nx_graph_edge_t));
	new_edge->src = src;
	new_edge->dst = dst;

	nx_graph_edge_t *old_head;
	do {
		old_head = atomic_load(&graph->edges);
		new_edge->next = old_head;
	} while (!atomic_compare_exchange_weak(&graph->edges, &old_head, new_edge));
}


/* Lock-Free BFS Traversal */
static inline void nx_lockfree_graph_bfs(nx_lockfree_graph_t *graph, nx_graph_node_t *start)
{
	if (!start) return;

	atomic_ptr_t queue_head = start;
	atomic_ptr_t queue_tail = start;

	while (queue_head) {
		nx_graph_node_t *node = atomic_load(&queue_head);
		printf("Visited Node: %u\n", node->id);

		queue_head = atomic_load(&node->next);
	}
}

/* Hash Function (Modulo-based) */
static inline nx_u32_t nx_dhash(nx_u32_t key)
{
	return key % NX_DHASH_TABLE_SIZE;
}

/* Initialize Distributed Hash Map */
static inline void nx_lockfree_dhash_init(nx_lockfree_hash_t *table)
{
	for (nx_u32_t i = 0; i < NX_DHASH_TABLE_SIZE; i++) {
		table->buckets[i] = NX_NULL;
	}
}

/* Lock-Free Insert */
static inline void nx_lockfree_dhash_insert(nx_lockfree_hash_t *table, nx_u32_t key, void *value)
{
	nx_u32_t index = nx_dhash(key);
	nx_hash_entry_t *new_entry = malloc(sizeof(nx_hash_entry_t));
	new_entry->key = key;
	atomic_store(&new_entry->value, value);

	nx_hash_entry_t *old_head;
	do {
		old_head = atomic_load(&table->buckets[index]);
		new_entry->next = old_head;
	} while (!atomic_compare_exchange_weak(&table->buckets[index], &old_head, new_entry));
}

/* Lock-Free Lookup */
static inline void *nx_lockfree_dhash_lookup(nx_lockfree_hash_t *table, nx_u32_t key)
{
	nx_u32_t index = nx_dhash(key);
	nx_hash_entry_t *entry = atomic_load(&table->buckets[index]);

	while (entry) {
		if (atomic_load(&entry->key) == key) {
			return atomic_load(&entry->value);
		}
		entry = entry->next;
	}
	return NX_NULL;
}

static inline void nx_lockfree_consensus_init(nx_lockfree_consensus_t *consensus)
{
	atomic_store(&consensus->chosen_value, 0); /* Default value */
}

/* Lock-Free Voting for Consensus */
static inline int nx_lockfree_consensus_vote(nx_lockfree_consensus_t *consensus, nx_u32_t proposed_value)
{
	nx_u32_t expected_value;
	do {
		expected_value = atomic_load(&consensus->chosen_value);

		/* If no value has been agreed upon, propose a new one */
		if (expected_value == 0) {
			if (atomic_compare_exchange_weak(&consensus->chosen_value, &expected_value, proposed_value)) {
				return 1; /* Consensus Achieved */
			}
		} else {
			return expected_value == proposed_value; /* Check if proposal matches existing decision */
		}
	} while (1);
}

/* Initialize Paxos */
static inline void nx_lockfree_paxos_init(nx_lockfree_paxos_t *paxos)
{
	atomic_store(&paxos->proposal_id, 0);
	atomic_store(&paxos->accepted_value, 0);
}

/* Lock-Free Proposal */
static inline int nx_lockfree_paxos_propose(nx_lockfree_paxos_t *paxos, nx_u32_t proposal_id, nx_u32_t value)
{
	nx_u32_t old_id = atomic_load(&paxos->proposal_id);

	/* If this proposal is newer, accept it */
	if (proposal_id > old_id) {
		atomic_store(&paxos->proposal_id, proposal_id);
		atomic_store(&paxos->accepted_value, value);
		return 1; /* Proposal accepted */
	}

	return 0; /* Proposal rejected */
}

/* Initialize Byzantine Consensus */
static inline void nx_lockfree_byzantine_init(nx_lockfree_byzantine_t *bft)
{
	atomic_store(&bft->proposal_id, 0);
	atomic_store(&bft->vote_count, 0);
	atomic_store(&bft->final_decision, 0);
}

/* Lock-Free Proposal */
static inline int nx_lockfree_byzantine_propose(nx_lockfree_byzantine_t *bft, nx_u32_t proposal_id, nx_u32_t value)
{
	nx_u32_t old_id = atomic_load(&bft->proposal_id);

	/* Accept only newer proposals */
	if (proposal_id > old_id) {
		atomic_store(&bft->proposal_id, proposal_id);
		atomic_store(&bft->final_decision, value);
		atomic_store(&bft->vote_count, 1);
		return 1; /* Proposal accepted */
	}

	return 0; /* Proposal rejected */
}

/* Lock-Free Voting */
static inline int nx_lockfree_byzantine_vote(nx_lockfree_byzantine_t *bft, nx_u32_t proposal_id, nx_u32_t vote_value)
{
	nx_u32_t expected_proposal = atomic_load(&bft->proposal_id);

	/* Only vote on valid proposals */
	if (proposal_id == expected_proposal) {
		atomic_fetch_add(&bft->vote_count, 1);
		return atomic_load(&bft->final_decision) == vote_value;
	}

	return 0; /* Invalid vote */
}
