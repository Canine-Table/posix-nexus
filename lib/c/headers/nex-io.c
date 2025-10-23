#include <stdio.h>
#include <ctype.h>
#include "nex-define.h"
#include "nex-io.h"

nx_d_T nx_ansi_F(nx_d_PcT args[])
{
	if (*args[0] == '\0')
		perror("printing the void is not supported");
	if (*args[1] == '\0')
		perror("you supplied the formating, where are the fields? *args[] needs at least 2 indexes");
	nx_d_iuT i = 1, j = 0;
	nx_d_cT stk[127] = { 3, '>', '\0', '0' };
	do {
		switch (args[0][j]) {
			case '<': case '>': case '_': case '\0':
				stk[1] = args[0][j];
				break;
			case '^':
				stk[2] = nx_lmap_iuF(args[0][++j]);
				break;
			case '%':
				if (stk[3] == '1')
					printf("m");
				if (stk[2] != '\0' && stk[1] != '\0')
					printf("[%c]: ", stk[2]);
				printf("%s", args[i++]);
				stk[3] = '0';
				stk[0] = 0;
				break;
			default:
				switch (stk[1]) {
					case '<': case '>': case '_':
						stk[(nx_d_iuT)(++stk[0])] = stk[1] == '_'
							? nx_smap_iuF(args[0][j])
							: nx_cmap_iuF(stk[1], args[0][j]);
						printf("%s%u", stk[3] == '0' ? "\x1b[" : ";", stk[(nx_d_iuT)stk[0]]);
						stk[3] = '1';
						break;
					default:
						printf("%s%c", stk[3] == '0' ? "" : "m", args[0][j]);
						stk[3] = '1';
				}
		}
	} while(args[0][++j] != '\0' && *args[i] != '\0');
	printf("\x1b[0m");
}

static nx_d_iuT nx_smap_iuF(nx_d_cT sym)
{
	nx_d_iuT ref = tolower(sym);
	if (sym == 'o') // overline
		return 53;
	if (sym == 'O') // not overline
		return 55;
	if (sym != ref) {
		sym = ref;
		ref = 20;
	} else {
		ref = 0;
	}
	switch (sym) {
		case 'b': // bold
			return ref + 1;
		case 'd': // dim
			return ref + 2;
		case 'i': // italic
			return ref + 3;
		case 'u': // underline
			return	ref + 4;
		case 'f': // flash
			return ref + 5;
		case 'r': // reverse video
			return ref + 7;
		case 'h': // hide
			return ref + 8;
		case 's': // strike
			return ref + 9;
		default:
			return 0; // normal
	}
}

static nx_d_iuT nx_cmap_iuF(nx_d_cT drc, nx_d_cT sym)
{
	nx_d_iuT c = drc == '<' ? 10 : 0;
	drc = tolower(sym);
	if (drc == 'c')
		return c + 39;
	if (drc == 'r')
		return c + 38;
	if (drc != sym)
		c += 60;
	switch (drc) {
		case 'b':
			return c + 30;
		case 'e':
			return c + 31;
		case 's':
			return c + 32;
		case 'w':
			return c + 33;
		case 'i':
			return c + 34;
		case 'd':
			return c + 35;
		case 'a':
			return c + 36;
		case 'l':
			return c + 37;
		default:
			return 0;
	}
}

static nx_d_cT nx_lmap_iuF(nx_d_cT sym)
{
	switch (sym) {
		case 'b':
			return '#';
		case 'B':
			return '|';
		case 'e':
			return 'x';
		case 'E':
			return 'X';
		case 's':
			return 'v';
		case 'S':
			return 'V';
		case 'w':
			return '!';
		case 'W':
			return '?';
		case 'd':
			return '*';
		case 'D':
			return '>';
		case 'i':
			return 'i';
		case 'I':
			return '.';
		case 'l':
			return '%';
		case 'L':
			return '$';
		case 'a':
			return '@';
		case 'A':
			return '&';
		default:
			return '\0';
	}
}

