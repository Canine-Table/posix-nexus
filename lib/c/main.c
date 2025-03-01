#include "headers/type.h"
#include "headers/math.h"
#include "headers/file.h"
#include "headers/data.h"
#include<stdio.h>

int main()
{
	nex_fwrite(nex_fopen("/tmp/hello.txt", "a"), "hello world\n");
	nex_fread(nex_fopen("/tmp/hello.txt", "r"));
	nex_fwrite(nex_fopen("/tmp/hello.txt", "a"), "hello world\n");
	nex_fwrite(nex_fopen("/tmp/hello.txt", "a"), "hello world\n");
	nex_fwrite(nex_fopen("/tmp/hello.txt", "a"), "hello world\n");
	nex_fread(nex_fopen("/tmp/hello.txt", "r"));
	nex_fdel("/tmp/hello.txt");
	//printf("%s\n", nex_char('a'));
	return(0);
}

/*
FILE* fopen(FILE *f, const char *c)
{
	FILE *fp;
	switch (*c) {
		''
	}
}
*/
