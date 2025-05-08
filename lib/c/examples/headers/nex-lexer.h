#ifndef NX_LEXER_H
#define NX_LEXER_H

#define NX_TOK_LENGTH 64

typedef enum {
	NX_IDENTIFIER,
	NX_KEYWORD,
	NX_NUMBER,
	NX_STRING,
	NX_MALFORMED_STRING,
	NX_OPERATOR,
	NX_UNKNOWN
} nx_tok_e;

typedef struct {
	nx_tok_e type;
	nx_char_t value[NX_TOK_LENGTH];
} nx_tok_s;

nx_sint_t nx_is_keyword(nx_Char_t*);
nx_sint_t nx_is_space(nx_char_t);
nx_sint_t nx_is_digit(nx_char_t);
nx_sint_t nx_is_lower(nx_char_t);
nx_sint_t nx_is_upper(nx_char_t);
nx_sint_t nx_is_alpha(nx_char_t);
nx_sint_t nx_is_alnum(nx_char_t);
nx_sint_t nx_is_quote(nx_char_t);
void nx_tok(nx_Char_t*);

#endif

