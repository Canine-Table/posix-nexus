#include<stdio.h>
#include<string.h>
#include<stdlib.h>

char *nex_char(char c)
{
	char s = ' ';
	char e = '~';
	switch (c) {
		case 'u':
			s = 'A';
			e = 'Z';
			break;
		case 'l':
			s = 'a';
			e = 'z';
			break;
		case 'd':
			s = '0';
			e = '9';
			break;
		case 'o':
			s = '0';
			e = '7';
			break;
		case 'b':
			s = '0';
			e = '1';
			break;
	}
	char *arr = (char*)malloc(e - s + 2);
	if (arr == NULL)
		return NULL;
	int i = 0;
	for (; s <= e; s++)
		arr[i++] = s;
	arr[i] = '\0';
	return arr;
}

char *nex_char_ext(char c, nex_char_t arr) {
	switch (c) {
		case 'a':
			thisstruct.l = nex_char('l');
			thisstruct.u = nex_char('u');
			thisstruct.d = nex_char('d');
		default:
			return nex_char(c);
	}
/*
	char* nex_char_ext(char c, CharSets* sets) {
    switch (c) {
        case 'a':
            sets->lower_case_set = nex_char('l');
            sets->upper_case_set = nex_char('u');
            sets->digit_set = nex_char(
			    */
	return NULL;
}

void new_nex_t(void *ptr)
{
	char *arr = (char *)ptr;
	for (int i = 0; i < strlen(arr); i++) {
		printf("%c\n", *(arr + i));
	}
}

