#include<stdio.h>
#include<string.h>

NexFE* nex_fopen(const char *f, const char *c)
{
	NexFE *fe = (NexFE*)malloc(sizeof(NexFE));
	if (fe == NULL) {
		perror("Memory allocation failed");
		return NULL;
	} else {
		fe->fh = NULL;
		fe->mde = NULL;
	}
	char *mde;
	switch (*c) {
		case 'B':
			mde = "ab+";
			break;
		case 'S':
			mde = "rn+";
			break;
		case 'X':
			mde = "wb+";
			break;
		case 'A':
			mde = "a+";
			break;
		case 'R':
			mde = "r+";
			break;
		case 'W':
			mde = "w+";
			break;
		case 'b':
			mde = "ab";
			break;
		case 's':
			mde = "rb";
			break;
		case 'x':
			mde = "wb";
			break;
		case 'a':
			mde = "a";
			break;
		case 'r':
			mde = "r";
			break;
		case 'w':
			mde = "w";
			break;
		default:
			perror("Invalid file mode");
			free(fe);
			return NULL;
	}

	fe->mde = malloc(strlen(mde) + 1);
	if (fe->mde == NULL) {
		perror("Memory allocation failed");
	} else {
		strcpy(fe->mde, mde);
		if ((fe->fh = fopen(f, fe->mde)) != NULL)
			return(fe);
		perror("file could not be opended");
	}
	free(fe);
	abort();
}

void nex_fread(NexFE *f)
{
	char str;
	while (1) {
		if ((str = fgetc(f->fh)) == EOF)
			break;
		printf("%c", str);
	}
	fclose(f->fh);
	free(f);
}

void nex_fwrite(NexFE *f, const char *str)
{
	fprintf(f->fh, str);
	fclose(f->fh);
	free(f);
}

void nex_fdel(const char *f)
{
	if (remove(f))
		perror("Error deleting file");
}


void nex_fcp(NexFE *s, NexFE *d)
{
	if (s->fh == NULL) {
		perror("Error opening source file");
	} else if (d->fh == NULL) {
		perror("Error opening destination file");
	} else {
		char buf[NEX_BUF_SIZE];
		size_t b;
		while ((b = fread(buf, 1, sizeof(buf), s->fh)) > 0)
			fwrite(buf, 1, b, d->fh);
	}
	fclose(s->fh);
	free(s);
	fclose(d->fh);
	free(d);
}

void nex_chrs()
{
	int c;
	while ((c = getchar()) != EOF)
		putchar(c);
}

long nex_cchrs()
{
	int c;
	long l;
	while ((c = getchar()) != EOF)
		++l;
	return l;
}

long nex_lchrs()
{
	int c;
	long l;
	while ((c = getchar()) != EOF)
		if (c == '\n')
			++l;
	return l;
}

long nex_wchrs()
{
	int c;
	long l;
	while ((c = getchar()) != EOF)
		if (c == '\n' || c == '\t' || c == ' ')
			++l;
	return l;
}
