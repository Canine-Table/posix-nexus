#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "nex-define.h"
#include "nex-bit.h"
#include "nex-io.h"
#include "nex-lexer.h"

static nx_Char_t *nx_keywords[] = {"if", "for", "while", "do", "else"};

void nx_lex_tok_debug(nx_tok_s *tok)
{
	tok->value[tok->size] = '\0';
	printf("( line %d,\tcharacter %d )\t", tok->y, tok->x);
	switch (tok->state) {
			case NX_DEFAULT:
				printf("Default");
				break;
			case NX_UNKNOWN:
				printf("Unknown");
				break;
			case NX_OPERATOR:
				printf("Operator");
				break;
			case NX_KEYWORD:
				printf("Keyword");
				break;
			case NX_IDENTIFIER:
				printf("Identifier");
				break;
			case NX_NUMBER:
				printf("Number");
				break;
			case NX_COMPLEX:
				printf("Complex");
				break;
			case NX_FLOAT:
				printf("Float");
				break;
			case NX_STRING:
				printf("String");
				break;
	}
	printf(": %s\n", tok->value);
	tok->state = NX_DEFAULT;
}

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
	return s == ' ' || s == '\t' || s == '\v' || s == '\f';
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

nx_sint_t nx_is_newline(nx_tok_s *tok, nx_fe_s *fe, nx_char_t cur)
{
	if (cur == '\r') {
		if (nx_fpeekc(fe) == '\n')
			nx_fgetc(fe);
		cur = '\n';
	}
	if (cur == '\n') {
		tok->y++;
		tok->x = 0;
		return 1;
	}
	return 0;
}

void nx_lex_tok_string(nx_tok_s *tok, nx_char_t cur)
{
	if (cur != tok->quote || nx_mod_pot(tok->escape, 2) == 1) {
		if (cur != '\\' || nx_mod_pot(++tok->escape, 2) == 0) {
			tok->escape = 0;
			tok->value[tok->size++] = cur;
		}
	} else {
		tok->quote = '\0';
		nx_lex_tok_debug(tok);
	}
}

void nx_lex_tok_word(nx_tok_s *tok, nx_fe_s *fe, nx_char_t cur)
{
	if (nx_is_alpha(cur) || cur == '_') {
		tok->value[tok->size++] = cur;
	} else {
		nx_fpushc(fe, cur);
		tok->state = nx_is_keyword(tok->value) ? NX_KEYWORD : NX_IDENTIFIER;
		nx_lex_tok_debug(tok);
	}
}

void nx_lex_tok_number(nx_tok_s *tok, nx_fe_s *fe, nx_char_t cur)
{
	if (nx_is_digit(cur)) {
		tok->value[tok->size++] = cur;
	} else if (cur == '.' && tok->state != NX_FLOAT) {
		tok->value[tok->size++] = cur;
		tok->state = NX_FLOAT;
	} else {
		nx_fpushc(fe, cur);
		nx_lex_tok_debug(tok);
	}
}

void nx_lex_tok_default(nx_tok_s *tok, nx_fe_s *fe, nx_char_t cur)
{
	nx_uint_t reset = 1, append = 1;
	if (nx_is_newline(tok, fe, cur) || nx_is_space(cur) || (cur == '\\' && nx_mod_pot(++tok->escape, 2) == 1)) {
		return;
	} else if (nx_is_alpha(cur)) {
		tok->state = NX_KEYWORD;
	} else if (nx_is_digit(cur)) {
		tok->state = NX_NUMBER;
	} else if (nx_is_quote(cur)) {
		tok->state = NX_STRING;
		tok->quote = cur;
		append = 0;
	} else {
		tok->state = NX_OPERATOR;
		printf("Operator: %c\n", cur);
	}
	if (reset) {
		tok->size = 0;
		tok->escape = 0;
	}
	if (append)
		tok->value[tok->size++] = cur;
}

void nx_lex_tok(nx_Char_t *nm)
{
	nx_fe_s *fe = nx_fopen(nm, "R");
	if (fe == NULL)
		return;
	nx_char_t cur;
	nx_tok_s tok = {
		.state = NX_DEFAULT,
		.x = 0,
		.y = 1,
		.escape = 0,
		.quote = '\0',
		.size = 0
	};
	while((cur = nx_fgetc(fe)) != EOF) {
		tok.x++;
		switch (tok.state) {
			case NX_DEFAULT:
			case NX_UNKNOWN:
			case NX_OPERATOR:
				nx_lex_tok_default(&tok, fe, cur);
				break;
			case NX_KEYWORD:
			case NX_IDENTIFIER:
				nx_lex_tok_word(&tok, fe, cur);
				break;
			case NX_NUMBER:
			case NX_COMPLEX:
			case NX_FLOAT:
				nx_lex_tok_number(&tok, fe, cur);
				break;
			case NX_STRING:
				nx_lex_tok_string(&tok, cur);
				break;
		}
	}
}

