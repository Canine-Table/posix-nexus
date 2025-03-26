#ifndef NEX_FILE_H
#define NEX_FILE_H
#define NEX_BUF_SIZE 4096

typedef struct {
	FILE *fh;
	char *mde;
} NexFE;

NexFE* nex_fopen(const char*, const char*);
void nex_fwrite(NexFE*, const char*);
void nex_fdel(const char*);
void nex_fread(NexFE*);
void nex_fcp(NexFE*, NexFE*);
void nex_chrs(void);
long nex_cchrs(void);
long nex_wchrs(void);

#include "file.c"
#endif

