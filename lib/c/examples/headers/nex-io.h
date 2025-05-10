#include <stdio.h>
#ifndef NX_IO_H
#define NX_IO_H

typedef struct {
	FILE *fh;
	char *mode;
} nx_fe_s;

nx_fe_s* nx_fopen(nx_Char_t*, nx_Char_t*);
void nx_fread(nx_fe_s*);
void nx_fwrite(nx_fe_s*, nx_Char_t*);
void nx_fdel(nx_Char_t*);
void nx_fcp(nx_fe_s*, nx_fe_s*);

#endif
