#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nex-define.h"
#include "nex-misc.h"
#include "nex-io.h"

nx_fe_s *nx_fopen(nx_Char_t *f, nx_Char_t *c)
{
	nx_fe_s *fe = (nx_fe_s*)malloc(sizeof(nx_fe_s));
	if (nx_mem_chk(fe) == -1)
		return(NULL);
	fe->fh = NULL;
	fe->mode = NULL;
	char *m;
	switch (*c) {
		case 'B':
			m = "ab+";
			break;
		case 'S':
			m = "rb+";
			break;
		case 'X':
			m = "wb+";
			break;
		case 'A':
			m = "a+";
			break;
		case 'R':
			m = "r+";
			break;
		case 'W':
			m = "w+";
			break;
		case 'b':
			m = "ab";
			break;
		case 's':
			m = "rb";
			break;
		case 'x':
			m = "wb";
			break;
		case 'a':
			m = "a";
			break;
		case 'r':
			m = "r";
			break;
		case 'w':
			m = "w";
			break;
		default:
			fprintf(stderr, "Invalid file mode");
			free(fe);
			return NULL;
	}
	fe->mode = malloc(strlen(m) + 1);
	if (nx_mem_chk(fe->mode) >= 0) {
		strcpy(fe->mode, m);
		if ((fe->fh = fopen(f, fe->mode)) != NULL)
			return(fe);
	}
	free(fe);
	return(NULL);
}

void nx_fread(nx_fe_s *f)
{
	nx_char_t s;
	while (1) {
		if ((s = fgetc(f->fh)) == EOF)
			break;
		printf("%c", s);
	}
	fclose(f->fh);
	free(f);
}

void nx_fwrite(nx_fe_s *f, nx_Char_t *s)
{
	fprintf(f->fh, s);
	fclose(f->fh);
	free(f);
}

void nx_fdel(nx_Char_t *f)
{
	if (remove(f))
		fprintf(stderr, "Error deleting file");
}

void nx_fcp(nx_fe_s *s, nx_fe_s *d)
{
	if (s->fh == NULL) {
		fprintf(stderr, "Error opening source file");
	} else if (d->fh == NULL) {
		fprintf(stderr, "Error opening destination file");
	} else {
		nx_char_t bf[NX_BUF_SIZE];
		nx_size_t b;
		while ((b = fread(bf, 1, sizeof(bf), s->fh)) > 0)
			fwrite(bf, 1, b, d->fh);
	}
	fclose(s->fh);
	free(s);
	fclose(d->fh);
	free(d);
}

