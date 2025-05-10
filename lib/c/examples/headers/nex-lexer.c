#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "nex-define.h"
#include "nex-bit.h"
#include "nex-io.h"
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

nx_char_t nx_peek_next(FILE *f)
{
	nx_char_t n = fgetc(f);
	ungetc(n, f);  /* Put the character back into the input stream for normal processing x_x */
	return n;
}

void nx_handle_keyword(nx_Char_t p, nx_tok_s *t, nx_tok_st_e *s, nx_uint_t *l)
{
	if (nx_is_alnum(p)) {
		t->value[(*l)++] = p;
	} else {
		t->value[*l] = '\0';
		printf("Keyword: %s\n", t->value);
		*s = NX_DEFAULT;
		*l = 0;
	}
}

void nx_handle_number(nx_Char_t p, nx_tok_s *t, nx_tok_st_e *s, nx_uint_t *l)
{
	if (nx_is_digit(p)) {
		t->value[(*l)++] = p;
	} else if (p == '.') {
		*s = NX_IN_FLOAT;
		t->value[(*l)++] = p;
	} else {
		t->value[*l] = '\0';
		printf("Number: %s\n", t->value);
		*s = NX_DEFAULT;
		*l = 0;
	}
}

void nx_handle_string(nx_Char_t p, nx_tok_s *t, nx_tok_st_e *s, nx_uint_t *l, nx_char_t *q, nx_uint_t *e)
{
	if (p == '\\') {
		*e = 1;
		*s = NX_ESCAPE_SEQUENCE;
	} else if (p == *q) {
		*s = NX_DEFAULT;
		t->value[*l] = '\0';
		printf("String: %s\n", t->value);
		*l = 0;
	} else {
		t->value[(*l)++] = p;
	}
}

void nx_handle_operator(nx_char_t p, FILE *f, nx_tok_s *t, nx_tok_st_e *s, nx_uint_t *l)
{
	t->value[(*l)++] = p;
	nx_char_t n = nx_peek_next(f);
	if (n == '=' || n == p)// Handle assignment or double operators
		t->value[(*l)++] = fgetc(f);
	t->value[*l] = '\0';
	printf("Operator: %s\n", t->value);
	*s = NX_DEFAULT;
	*l = 0;
}

void nx_tok(nx_Char_t *nm)
{
	nx_fe_s *f = nx_fopen(nm, "R");
	if (f == NULL)
		return;
	nx_tok_st_e s = NX_DEFAULT; /* Start in default state */
	nx_tok_s t; /* Current token being constructed */
	nx_uint_t l = 0, e = 0;
	nx_char_t p, q = '\0';
	while((p = fgetc(f->fh)) != EOF) {
		switch (s) {
			case NX_DEFAULT:
				if (nx_is_space(p))
					continue;
				if (nx_is_alpha(p)) {
					s = NX_IN_KEYWORD;
					t.value[l++] = p;
				} else if (nx_is_digit(p)) {
					s = NX_IN_NUMBER;
					t.value[l++] = p;
				} else if (nx_is_quote(p)) {
					q = p;
					s = NX_IN_STRING;
				} else if (p == '(' || p == ')') {
					t.type = NX_DELIMITER;
					t.value[0] = p;
					t.value[1] = '\0';
					printf("Delimiter: %s\n", t.value);
				} else if (p == '{' || p == '}') {
					t.type = NX_SCOPE;
					t.value[0] = p;
					t.value[1] = '\0';
					printf("Scope: %s\n", t.value);
				} else {
					s = NX_IN_OPERATOR;
					t.value[l++] = p;
				}
				break;
			case NX_IN_OPERATOR:
				nx_handle_operator(p, f->fh, &t, &s, &l);
				break;
			case NX_IN_KEYWORD:
				nx_handle_keyword(p, &t, &s, &l);
				break;
			case NX_IN_NUMBER:
				nx_handle_number(p, &t, &s, &l);
				break;
			case NX_IN_STRING:
				nx_handle_string(p, &t, &s, &l, &q, &e);
				break;
			case NX_ESCAPE_SEQUENCE:
				if (p != '\\' || nx_mod_pot(++e, 2) == 0) {
					e = 0;
					t.value[l++] = p; // Store the escaped character
					s = NX_IN_STRING; // Return to normal string processing
				}
				break;
			case NX_IN_FLOAT:
				if (nx_is_digit(p)) {
					t.value[l++] = p;
				} else {
					t.value[l] = '\0';
					printf("Float: %s\n", t.value);
					s = NX_DEFAULT;
					l = 0;
				}
				break;
		}
	}
	fclose(f->fh);
	free(f);
}

