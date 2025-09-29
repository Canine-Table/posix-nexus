#ifndef nx_Dm_define_H
#define nx_Dm_define_H

/* Endian Macros */
#if (defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__ || __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__)) \
	||defined(__BIG_ENDIAN__) || defined(_BIG_ENDIAN) || defined(__ARMEB__) \
	|| defined(__MIPSEB__) || defined(__POWERPC__) || defined(__sparc__) \
	|| defined(__s390__) || defined(__HPPA__) || defined(__M68K__)
	#define nx_dm_endian_isD 1
	#define nx_dm_fshft_M(D1, D2) ((D1) << (D2))
	#define nx_dm_bshft_M(D1, D2) ((D1) >> (D2))
#else
	#define nx_dm_endian_isD 0
	#define nx_dm_fshft_M(D1, D2) ((D1) >> (D2))
	#define nx_dm_bshft_M(D1, D2) ((D1) << (D2))
#endif

/* Architecture Detection */
#if defined(__x86_64__) || defined(_M_X64) || defined(__aarch64__) \
	|| defined(__PPC64__) || defined(__mips64__)
	#define nx_dm_bit_isD 64
#elif defined(__i386__) || (defined(__arm__) && !(defined(__thumb__) || defined(__ARM_ARCH_8__))) \
	|| defined(__PPC__) || defined(__mips__) || defined(__sparc__) || defined(_M_IX86)
	#define nx_dm_bit_isD 32
#elif defined(__x86__) || defined(__ARM_ARCH_4T__) || defined(__ARM_ARCH_5T__) \
	|| defined(__ARM_ARCH_5TE__) || defined(__m68k__) || defined(__TMS320__) \
	|| defined(__HCS12__) || defined(__HC12__) || defined(__68HC12__) \
	|| defined(__HCS12X__) || defined(__XMEGA__) || defined(__AVR_HAVE_16BIT__) \
	|| defined(__DSP56K__) || defined(__Blackfin__) || defined(__thumb__)
	#define nx_dm_bit_isD 16
#elif defined(__Z80__) || defined(__8080__) || defined(__AVR__) \
	|| defined(__PIC__) || defined(__HC08__) || defined(__6502__)
	#define nx_dm_bit_isD 8
#else
	#define nx_dm_bit_isD -1  /* Undefined architecture */
#endif

#define nX_dm_swap_8M(D) ((((D) >> 56) & 0x00000000000000FF) | \
	(((D) >> 40) & 0x000000000000FF00) | \
	(((D) >> 24) & 0x0000000000FF0000) | \
	(((D) >> 8) & 0x000000000FF00000) | \
	(((D) << 8) & 0x0000000FF0000000) | \
	(((D) << 24) & 0x0000FF0000000000) | \
	(((D) << 40) & 0x00FF000000000000) | \
	(((D) << 56) & 0xFF00000000000000))
#define nX_dm_swap_4M(D) ((((D) >> 24) & 0x000000FF) | \
	(((D) >> 8)  & 0x0000FF00) | \
	(((D) << 8)  & 0x00FF0000) | \
	(((D) << 24) & 0xFF000000))
#define nX_dm_swap_2M(D) (((D) >> 8) | ((D) << 8))
#define nX_dm_swap_1M(D) (D)

#if nx_dm_bit_isD == 64
	#define nx_dm_swap_M(D) (nX_dm_swap_8M(D))
#elif nx_dm_bit_isD == 32
	#define nx_dm_swap_M(D) (nX_dm_swap_4M(D))
#elif nx_dm_bit_isD == 16
	#define nx_dm_swap_M(D) (nX_dm_swap_2M(D))
#else
	#define nx_dm_swap_M(D) (nX_dm_swap_1M(D))
#endif

/* indirection single depth */
#define nx_Dm_ptr_PM(D1, D2) \
	typedef const D1 *nx_d_P##D2##T; \
	typedef D1 *const nx_D_p##D2##T; \
	typedef const D1 *const nx_D_P##D2##T;

#define nx_dm_ptr_pM(D1, D2) \
	typedef D1 *nx_d_p##D2##T;

/* indirection double depth */
#define nx_Dm_ptr_PPM(D1, D2) \
	typedef const D1 **nx_d_Pp##D2##T; \
	typedef D1 *const *nx_d_pP##D2##T; \
	typedef D1 **const nx_D_pp##D2##T; \
	typedef const D1 *const *nx_d_PP##D2##T; \
	typedef const D1 **const nx_D_Pp##D2##T; \
	typedef const D1 *const *const nx_D_PP##D2##T;

#define nx_dm_ptr_ppM(D1, D2) \
	typedef D1 **nx_d_pp##D2##T;

/* indirection triple depth */
#define nx_Dm_ptr_PPPM(D1, D2) \
    typedef D1 ***nx_d_ppp##D2##T; \
    typedef const D1 ***nx_d_Ppp##D2##T; \
    typedef D1 *const **nx_d_pPp##D2##T; \
    typedef D1 **const *nx_d_ppP##D2##T; \
    typedef D1 ***const nx_D_ppp##D2##T; \
    typedef const D1 *const **nx_d_PPp##D2##T; \
    typedef const D1 **const *nx_d_PpP##D2##T; \
    typedef const D1 ***const nx_D_Ppp##D2##T; \
    typedef D1 **const **nx_D_pPp##D2##T; \
    typedef D1 *const *const *nx_D_pPP##D2##T; \
    typedef D1 **const *const nx_D_ppP##D2##T; \
    typedef const D1 *const *const *nx_D_PPP##D2##T;

#define nx_dm_ptr_pppM(D1, D2) \
	typedef D1 ***nx_d_ppp##D2##T;

/* indirections */
#define nx_DM_ptr_M(D1, D2) \
	nx_Dm_ptr_PM(D1, D2) \
	nx_Dm_ptr_PPM(D1, D2) \
	nx_Dm_ptr_PPPM(D1, D2)

#define nx_dM_ptr_M(D1, D2) \
	nx_dm_ptr_pM(D1, D2) \
	nx_dm_ptr_ppM(D1, D2) \
	nx_dm_ptr_pppM(D1, D2)

/* signage */
#define nx_dm_signage_M(D1, D2) \
	typedef D1 nx_d_##D2##T; \
	nx_dM_ptr_M(D1, D2)

#define nx_Dm_signage_M(D1, D2) \
	typedef const D1 nx_D_##D2##T; \
	nx_DM_ptr_M(D1, D2)

#define nx_DM_signage_M(D1, D2) \
	nx_Dm_signage_M(D1, D2) \
	nx_dm_signage_M(D1, D2)

/* sign */
#define nx_dm_sign_M(D1, D2) \
	nx_dm_signage_M(signed D1, D2##s) \
	nx_dm_signage_M(unsigned D1, D2##u)

#define nx_Dm_sign_M(D1, D2) \
	nx_Dm_signage_M(signed D1, D2##s) \
	nx_Dm_signage_M(unsigned D1, D2##u)

#define nx_DM_sign_M(D1, D2) \
	nx_Dm_sign_M(D1, D2) \
	nx_dm_sign_M(D1, D2)

/* autosign */
#define nx_dm_autosign_M(D1, D2) \
	nx_dm_signage_M(D1, D2) \
	nx_dm_sign_M(D1, D2)

#define nx_Dm_autosign_M(D1, D2) \
	nx_Dm_signage_M(D1, D2) \
	nx_Dm_sign_M(D1, D2)

#define nx_DM_autosign_M(D1, D2) \
	nx_DM_signage_M(D1, D2) \
	nx_DM_sign_M(D1, D2)

#define Nx2_dm_param_M(D1, D2) (D1 D2)
#define Nx4_dm_param_M(D1, D2, D3, D4) ((D1 D3), (D2 D4))
#define Nx6_dm_param_M(D1, D2, D3, D4, D5, D6) ((D1 D4), (D2 D5), (D3 D6))

#define nx_dm_expandafter_M(D1, D2) ((D1) D2)
#define nx_dm_expandbefore_M(D1, D2) (D1 (D2))

#define nx_dm_enum_M(D1, D2) \
	typedef enum { \
		D1 \
	} nx_##D2##_E;

#define nx_dm_union_M(D1, D2) \
	typedef union { \
		D2 \
	} nx_##D1##_U;

#define nx_dm_struct_M(D1, D2, D3) \
	typedef struct D3 { \
		D2 \
	} nx_##D1##_S;

/*
#define nx_dm_width_M(D1, D2, D3, D4, D5) \
	typedef union { \
		D2 \
	} nx_##D1##_U; \
	typedef nx_##D1##_U *nx_##D1##_pU; \
	typedef enum { \
		D3 \
	} nx_##D1##_E; \
	typedef struct D5 { \
		nx_##D1##_E type; \
		nx_##D1##_U pun; \
		D4 \
	} nx_##D1##_S; \
	typedef nx_##D1##_S *nx_##D1##_pS;
*/

nx_dm_signage_M(void, /**/)
nx_DM_autosign_M(char, c)
nx_DM_sign_M(short, s)
nx_DM_sign_M(int, i)
nx_DM_signage_M(float, f)
nx_DM_sign_M(long , l)
nx_DM_signage_M(double, d)

#endif
