#ifndef NX_LEXER_H
#define NX_LEXER_H

/*
	Current State	Character Condition	Next State
	NX_DEFAULT	" " (Whitespace)	Ignore, stay in NX_DEFAULT
	NX_DEFAULT	"\"" (Quote start)	NX_IN_STRING
	NX_IN_STRING	"\"" (End quote)	NX_DEFAULT
	NX_IN_STRING	"\\" (Escape char)	NX_ESCAPE_SEQUENCE
	NX_ESCAPE_SEQUENCE	(Any valid escape char)	NX_IN_STRING
	NX_DEFAULT	isalpha() (Letter)	NX_IN_KEYWORD
	NX_IN_KEYWORD	isalnum() (Alphanumeric)	Stay in NX_IN_KEYWORD
	NX_IN_KEYWORD	Whitespace or operator	Token finalized, switch to NX_DEFAULT
	NX_DEFAULT	isdigit() (Number)	NX_IN_NUMBER
	NX_IN_NUMBER	"." (Dot)	NX_IN_FLOAT
	NX_IN_NUMBER	Non-digit character	Token finalized, switch to NX_DEFAULT
*/

typedef enum {
	NX_IDENTIFIER,
	NX_KEYWORD,
	NX_NUMBER,
	NX_FLOAT,
	NX_COMPLEX,
	NX_STRING,
	NX_OPERATOR,
	NX_DEFAULT,
	NX_UNKNOWN
} nx_tok_e;

typedef struct {
	nx_uint_t x;
	nx_uint_t y;
	nx_uint_t size;
	nx_tok_e state;
	nx_char_t quote;
	nx_uint_t escape;
	nx_char_t value[NX_TOK_LENGTH];
} nx_tok_s;

nx_sint_t nx_is_space(nx_char_t);
nx_sint_t nx_is_digit(nx_char_t);
nx_sint_t nx_is_lower(nx_char_t);
nx_sint_t nx_is_upper(nx_char_t);
nx_sint_t nx_is_alpha(nx_char_t);
nx_sint_t nx_is_alnum(nx_char_t);
nx_sint_t nx_is_quote(nx_char_t);
nx_sint_t nx_is_keyword(nx_Char_t*);
void nx_lex_tok_debug(nx_tok_s*);
void nx_lex_tok_string(nx_tok_s*, nx_char_t);
void nx_lex_tok_word(nx_tok_s*, nx_fe_s*, nx_char_t);
void nx_lex_tok_number(nx_tok_s*, nx_fe_s*, nx_char_t);
void nx_lex_tok_default(nx_tok_s*, nx_fe_s*, nx_char_t);
void nx_lex_tok(nx_Char_t*);

/*
nx_sint_t nx_is_keyword(nx_Char_t*);
void nx_handle_operator(nx_Char_t, FILE*, nx_tok_s*, nx_tok_st_e*, nx_uint_t*);
void nx_handle_number(nx_Char_t, nx_tok_s*, nx_tok_st_e*, nx_uint_t*);
void nx_handle_keyword(nx_Char_t, nx_tok_s*, nx_tok_st_e*, nx_uint_t*);
void nx_handle_string(nx_Char_t, nx_tok_s*, nx_tok_st_e*, nx_uint_t*, nx_char_t*, nx_uint_t*);
void nx_tok(nx_Char_t*);
*/

#endif

