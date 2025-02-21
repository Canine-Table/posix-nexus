#ifndef NEX_TYPE_H
#define NEX_TYPE_H

typedef struct nex_t {
	void *data;
	int size;
	int bytes;
} nex_t;

typedef struct {
	char *lower;
	char *upper;
	char *digit;
} nex_char_t;

void new_nex_t(void*);
char *nex_char(char);
char *nex_char_ext(char);

#include "type.c"
#endif

