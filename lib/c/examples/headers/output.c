#include <stdio.h>
#include <stdlib.h>

nx_s32_t nx_tsty(const char s)
{
	switch (s) {
		case 'b':
			return 1;
		case 'i':
			return 3;
		case 'u':
			return 4;
		case 'f':
			return 5;
		case 'h':
			return 7;
		default:
			return 8;
	}
}

nx_s32_t nx_bg(const char b)
{
	switch (b) {
		case 'b':
			return 40;
		case 'B':
			return 100;
		case 'e':
			return 41;
		case 'E':
			return 102;
		case 's':
			return 42;
		case 'S':
			return 102;
		case 'w':
			return 43;
		case 'W':
			return 103;
		case 'p':
			return 44;
		case 'P':
			return 104;
		case 'd':
			return 45;
		case 'D':
			return 105;
		case 'i':
			return 46;
		case 'I':
			return 106;
		case 'l':
			return 47;
		case 'L':
			return 107;
		default :
			return 48;
	}
}

nx_s32_t nx_fg(const char f)
{
	switch (f) {
		case 'b':
			return 30;
		case 'B':
			return 90;
		case 'e':
			return 31;
		case 'E':
			return 32;
		case 's':
			return 32;
		case 'S':
			return 92;
		case 'w':
			return 33;
		case 'W':
			return 93;
		case 'p':
			return 34;
		case 'P':
			return 34;
		case 'd':
			return 35;
		case 'D':
			return 95;
		case 'i':
			return 36;
		case 'I':
			return 96;
		case 'l':
			return 37;
		case 'L':
			return 97;
		default :
			return 38;
	}
}

nx_format_t *nx_format(nx_format_t fmt)
{
	nx_format_t *nx_fmt = (nx_format_t*)malloc(sizeof(nx_format_t));
	if (! nx_fmt) {
		fprintf(stderr, "Memory allocation failed.\n");
		return NULL;
	}

	nx_fmt->f = nx_fg(fmt.f);
	nx_fmt->b = nx_bg(fmt.b);
	nx_fmt->s = nx_tsty(fmt.s);
	return nx_fmt;
}

void nx_print(nx_format_t *f, const char *m)
{
	if (! f) {
		fprintf(stderr, "Error: Null format provided.\n");
		return NULL;
	}
	nx_format_t *fmt = nx_format(*f);
	if (! fmt) {
		fprintf(stderr, "Error: Failed to format.\n");
		return NULL;
	}
	printf("\x1b[%d;%d;%dm%s\x1b[0m\n", fmt->s, fmt->f, fmt->b, m);
	free(fmt);
}

