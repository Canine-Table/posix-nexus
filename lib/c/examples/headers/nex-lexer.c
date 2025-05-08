#include <stdio.h>
#include <string.h>
#include "nex-define.h"
#include "nex-bit.h"
#include "nex-lexer.h"

static nx_Char_t *nx_keywords[] = {"if", "for", "while", "do", "else"};

nx_sint_t nx_is_keyword(nx_Char_t *s)
{
	for (nx_uint_t i = 0; i < sizeof(nx_keywords) / sizeof(nx_keywords[0]); i++) {
		if (strcmp(s, nx_keywords[i]) == 0)
			return(1);
	}
	return(0);
}

nx_sint_t nx_is_space(nx_char_t s)
{
	return s == ' ' || s == '\t' || s == '\v' || s == '\n' || s == '\f' || s == '\r';
}

nx_sint_t nx_is_digit(nx_char_t s)
{
	return ! (s < '0' || s > '9');
}

nx_sint_t nx_is_lower(nx_char_t s)
{
	return ! (s < 'a' || s > 'z');
}

nx_sint_t nx_is_upper(nx_char_t s)
{
	return ! (s < 'A' || s > 'Z');
}

nx_sint_t nx_is_alpha(nx_char_t s)
{
	return nx_is_upper(s) || nx_is_lower(s);
}

nx_sint_t nx_is_alnum(nx_char_t s)
{
	return nx_is_alpha(s) || nx_is_digit(s);
}

nx_sint_t nx_is_quote(nx_char_t s)
{
	return s == '"' || s == '\'' || s == '`';
}

void nx_tok(nx_Char_t *s)
{
	nx_Char_t *p = s;
	while (*p) {
		if (nx_is_space(*p)) {
			p++;
			continue;
		}
		nx_tok_s t;
		if (nx_is_alpha(*p) || *p == '_') {
			nx_uint_t l = 0;
			while (nx_is_alpha(*p) || *p == '_') {
				t.value[l++] = *p++;
			}
			t.value[l] = '\0';
			t.type = nx_is_keyword(t.value) ? NX_KEYWORD : NX_IDENTIFIER;
		} else if (nx_is_digit(*p)) {
			nx_uint_t l = 0;
			while (nx_is_digit(*p)) {
				t.value[l++] = *p++;
			}
			t.value[l] = '\0';
			t.type = NX_NUMBER;
		} else if (nx_is_quote(*p)) {
			nx_uint_t l = 0;
			nx_uint_t e = 0;
			nx_Char_t q = *p++;
			nx_uint_t m = 0;
			while (*p) {
				if (*p == 92) {
					t.value[l++] = *p++;
					if (nx_mod_pot(e, 2) == 0)
						e = 0;
					else
						p--;
				} else {
					if ((e == 0 || nx_mod_pot(e, 2) == 0) && *p == q) {
						printf("%d", *p);
						p++;
						t.value[l] = '\0';
						t.type = NX_STRING;
						m = 1;
						break;
					} else {
						t.value[l++] = *p++;
						e = 0;
					}
				}
			}
			if (! m) {
				t.value[l] = '\0';
				t.type = NX_MALFORMED_STRING;
			}
		} else {
			t.type = NX_OPERATOR;
			t.value[0] = *p++;
			t.value[1] = '\0';
		}
		printf("Token: Type=%d, Value=%s\n", t.type, t.value);
	}
}

