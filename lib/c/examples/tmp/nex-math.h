#ifndef NX_MATH_H
#define NX_MATH_H

typedef union {
	nx_uint_t u;
	nx_flt_t f;
} nx_ieee754_t;

typedef union {
    nx_size_t u;
    nx_dbl_t d;
} nx_ieee754_double_t;

#define NX_NAN       (0.0 / 0.0)
#define NX_INFINITY  (1.0 / 0.0)
#define NX_NEG_INFINITY ((nx_ieee754_t){ .u = 0xFF800000 }).f  /* Negative infinity */
#define NX_HUGE_VAL ((nx_ieee754_double_t){ .u = 0x7FEFFFFFFFFFFFFF }).d  /* Max finite double */

nx_dbl_t nx_floor(nx_dbl_t);
nx_dbl_t nx_ceiling(nx_dbl_t);
nx_dbl_t nx_round(nx_dbl_t);
nx_dbl_t nx_trunc(nx_dbl_t);
nx_dbl_t nx_fmod(nx_dbl_t, nx_dbl_t);
nx_dbl_t nx_lcd(nx_dbl_t, nx_dbl_t);
nx_dbl_t nx_euclidean(nx_dbl_t, nx_dbl_t);
nx_dbl_t nx_absolute(nx_dbl_t);
nx_dbl_t nx_fmod(nx_dbl_t, nx_dbl_t);
nx_dbl_t nx_mrange(nx_dbl_t, nx_dbl_t, nx_dbl_t, nx_dbl_t);
nx_dbl_t nx_remainder(nx_dbl_t, nx_dbl_t);
nx_size_t nx_factoral(nx_size_t);
nx_size_t nx_fibonacci(nx_size_t);

#endif

