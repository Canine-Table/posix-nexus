#ifndef NX_IO_H
#define NX_IO_H
#include <stdio.h>

typedef struct {
	FILE *fh;
	nx_char_t *mode;
} nx_fe_s;

nx_fe_s* nx_fopen(nx_char_pT, nx_char_pT);
nx_char_t nx_fpeekc(nx_fe_s*);
nx_void_t nx_fpushc(nx_fe_s*, nx_char_t);
nx_char_t nx_fgetc(nx_fe_s*);
nx_void_t nx_fdel(nx_char_pT);
nx_void_t nx_fcp(nx_fe_s*, nx_fe_s*);

#endif

