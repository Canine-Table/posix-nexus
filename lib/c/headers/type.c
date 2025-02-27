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

void new_nex_t(void *ptr)
{
	char *arr = (char *)ptr;
	for (int i = 0; i < strlen(arr); i++) {
		printf("%c\n", *(arr + i));
	}
}

