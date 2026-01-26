#ifndef NEX_bw_H
#define NEX_bw_H

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
	#define nx_dm_bw_isD 64
#elif defined(__i386__) || (defined(__arm__) && !(defined(__thumb__) || defined(__ARM_ARCH_8__))) \
	|| defined(__PPC__) || defined(__mips__) || defined(__sparc__) || defined(_M_IX86)
	#define nx_dm_bw_isD 32
#elif defined(__x86__) || defined(__ARM_ARCH_4T__) || defined(__ARM_ARCH_5T__) \
	|| defined(__ARM_ARCH_5TE__) || defined(__m68k__) || defined(__TMS320__) \
	|| defined(__HCS12__) || defined(__HC12__) || defined(__68HC12__) \
	|| defined(__HCS12X__) || defined(__XMEGA__) || defined(__AVR_HAVE_16BIT__) \
	|| defined(__DSP56K__) || defined(__Blackfin__) || defined(__thumb__)
	#define nx_dm_bw_isD 16
#elif defined(__Z80__) || defined(__8080__) || defined(__AVR__) \
	|| defined(__PIC__) || defined(__HC08__) || defined(__6502__)
	#define nx_dm_bw_isD 8
#else
	#error "Undefined architecture"
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

#if nx_dm_bw_isD == 64
	#define nx_dm_swap_M(D) (nX_dm_swap_8M(D))
#elif nx_dm_bw_isD == 32
	#define nx_dm_swap_M(D) (nX_dm_swap_4M(D))
#elif nx_dm_bw_isD == 16
	#define nx_dm_swap_M(D) (nX_dm_swap_2M(D))
#else
	#define nx_dm_swap_M(D) (nX_dm_swap_1M(D))
#endif

unsigned long NX_bwEven_lLF(
	const unsigned long
);

unsigned long NX_bwOdd_lLF(
	const unsigned long
);

unsigned long NX_bwTarget_lLF(
	const unsigned long
);

unsigned long NX_bwIs_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwOff_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwOn_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwFlip_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwDiverge_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwCascade_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwOnly_lLLLF(
	const unsigned long,
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwTwos_lLF(
	const unsigned long
);

unsigned long NX_bwMove_lLLLF(
	const unsigned long,
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwZeros_lLLLF(
	const unsigned long,
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwCount_lLF(
	const unsigned long
);

unsigned long NX_bwLeading_lLF(
	const unsigned long
);

unsigned long NX_bwTrailing_lLF(
	const unsigned long
);

unsigned long NX_bwNextBit_lLF(
	const unsigned long
);

unsigned long NX_bwModNextBit_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwParity_lLF(
	const unsigned long
);

unsigned long NX_bwRight_lLLF(
	const unsigned long,
	const unsigned long
);

unsigned long NX_bwLeft_lLLF(
	const unsigned long,
	const unsigned long
);

int nx_bw_mix(int, int, int);

#endif

