#ifndef NX_DATA_H
#define NX_DATA_H
typedef struct {
	nx_char_t **data;	// Stack data (array of string pointers)
	nx_size_t top;		// Index of the top element
	nx_size_t capacity;	// Maximum capacity
} nx_char_stack_s;

nx_char_stack_s *nx_char_cstack(nx_size_t);
nx_char_t *nx_char_pop(nx_char_stack_s*);
nx_char_t *nx_char_peek(nx_char_stack_s*);
void nx_char_push(nx_char_stack_s*, nx_char_t*);
void nx_char_fstack(nx_char_stack_s*);

#endif
