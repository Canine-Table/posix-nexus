#ifndef NX_MATH_H
#define NX_MATH_H
#include "def.h"

// Function Definitions
nx_f128_t nx_floor(nx_f128_t);
nx_f128_t nx_ceiling(nx_f128_t);
nx_f128_t nx_round(nx_f128_t);
nx_f128_t nx_trunc(nx_f128_t);
nx_f128_t nx_fmod(nx_f128_t, nx_f128_t);
nx_f128_t nx_trunc(nx_f128_t);

nx_f128_t nx_fibonacci(nx_f128_t);
nx_f128_t nx_power(nx_f128_t, nx_f128_t);
nx_f128_t nx_factoral(nx_f128_t);
nx_f128_t nx_summation(nx_f128_t, nx_f128_t);
nx_f128_t nx_absolute(nx_f128_t);
nx_f128_t nx_euclidean(nx_f128_t, nx_f128_t);
nx_f128_t nx_lcd(nx_f128_t, nx_f128_t);
nx_f128_t nx_remainder(nx_f128_t, nx_f128_t);

#include "math.c"
#endif
