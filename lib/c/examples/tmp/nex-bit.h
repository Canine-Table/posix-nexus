#ifndef NX_BIT_H
#define NX_BIT_H

#define NX_SET_BIT(N, B) ((N) | (1 << (B)))     /* Sets the B-th bit of N */
#define NX_CLEAR_BIT(N, B) ((N) & ~(1 << (B)))  /* Clears the B-th bit of N */
#define NX_TOGGLE_BIT(N, B) ((N) ^ (1 << (B)))  /* Toggles the B-th bit of N */
#define NX_ALIGN(S, A) (((S) + (A - 1)) & ~(A - 1))
#define NX_MASK_4_BITS  0b1111  // 15 (2^4 - 1)
#define NX_MASK_8_BITS  0b11111111  // 255 (2^8 - 1)

void nx_printb(nx_ptrdiff_t);
nx_uint_t nx_even(nx_ptr_t);
void nx_swap(nx_ptr_t, nx_ptr_t, nx_size_t);
nx_size_t nx_nxt_pot(nx_size_t);
nx_size_t nx_mod_pot(nx_size_t, nx_size_t);
nx_size_t nx_exp_pot(nx_size_t);
nx_size_t nx_div_pot(nx_size_t);
nx_size_t nx_mul_pot(nx_size_t);
nx_size_t nx_bk_cnt(nx_ptr_t, nx_size_t);

#endif


