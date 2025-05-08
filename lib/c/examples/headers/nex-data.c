#include <stdio.h>
#include <stdlib.h>
#include "nex-define.h"
#include "nex-data.h"

nx_char_stack_s *nx_char_cstack(nx_size_t c)
{
	nx_char_stack_s *s = malloc(sizeof(nx_char_stack_s));
	s->data = malloc(sizeof(nx_char_t*) * c);
	s->capacity = c;
	return s;
}

/* Pop a string from the stack */
nx_char_t *nx_char_pop(nx_char_stack_s *s)
{
	return (s->top > 0) ? s->data[--s->top] : NULL;
}

/* Peek at the top string */
nx_char_t *nx_char_peek(nx_char_stack_s *s)
{
	return (s->top > 0) ? s->data[s->top - 1] : NULL;
}

/* Push a string onto the stack */
void nx_char_push(nx_char_stack_s *s, nx_char_t *d)
{
	if (s->top >= s->capacity) {
		s->capacity *= 2; /* Dynamic resizing */
		s->data = realloc(s->data, sizeof(nx_char_t*) * s->capacity);
	}
	s->data[s->top++] = d;
}

// Free the stack
void nx_char_fstack(nx_char_stack_s *s)
{
	free(s->data);
	free(s);
}

