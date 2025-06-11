#ifndef NX_STRING_H
#define NX_STRING_H

nx_int_st nx_is_space(nx_char_t);
nx_int_st nx_is_digit(nx_char_t);
nx_int_st nx_is_lower(nx_char_t);
nx_int_st nx_is_upper(nx_char_t);
nx_int_st nx_is_alpha(nx_char_t);
nx_int_st nx_is_alnum(nx_char_t);
nx_int_st nx_is_quote(nx_char_t);
nx_int_st nx_tok_num(nx_char_pT);
nx_int_pst nx_atol(nx_int_st, nx_char_ppT);
nx_float_pt nx_atof(nx_int_st, nx_char_ppT);

#endif
