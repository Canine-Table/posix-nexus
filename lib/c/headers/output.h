#ifndef NX_OUTPUT_H
#define NX_OUTPUT_H
#include "math.h"

typedef struct {
	nx_u8_t f, b, s;
} nx_format_t;

nx_s32_t nx_tsty(const char);
nx_s32_t nx_fg(const char);
nx_s32_t nx_bg(const char);
nx_format_t *nx_format(nx_format_t);
void nx_print(const char, const char, const char*);
#include "output.c"
#endif

