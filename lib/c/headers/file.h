#ifndef NEX_FILE_H
#define NX_FILE_H
#define NX_BUF_SIZE 4096

typedef struct {
	FILE *fh;
	char *mde;
} nx_fe_s;

nx_fe_s* nx_fopen(const char*, const char*);
void nx_fwrite(nx_fe_s*, const char*);
void nx_fdel(const char*);
void nx_fread(nx_fe_s*);
void nx_fcp(nx_fe_s*, nx_fe_s*);
void nx_chrs(void);
long nx_cchrs(void);
long nx_wchrs(void);

#include "file.c"
#endif

