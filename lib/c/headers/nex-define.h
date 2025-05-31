#ifndef NX_DEFINE_H
#define NX_DEFINE_H

 #if defined(_WIN32)
	#define NX_OS_NAME "windows"
#elif defined(__linux__)
	#define NX_OS_NAME "linux"
#elif defined(__APPLE__)
	#define NX_OS_NAME "macos"
#else
	#define NX_OS_NAME "unix"
#endif

#if defined(__STDC_VERSION__)
	#if __STDC_VERSION__ >= 199901L  /* C99 or newer */
		#define NX_SUPPORTS_LONG_LONG 1  /* Long long is available */
	#else
		#define NX_SUPPORTS_LONG_LONG 0  /* No long long in C89 */
	#endif
#else
	#define NX_SUPPORTS_LONG_LONG 0  /* Default to C89 */
#endif

/* Endian Macros */
#if (defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__ || __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__)) \
	||defined(__BIG_ENDIAN__) || defined(_BIG_ENDIAN) || defined(__ARMEB__) \
	|| defined(__MIPSEB__) || defined(__POWERPC__) || defined(__sparc__) \
	|| defined(__s390__) || defined(__HPPA__) || defined(__M68K__)
	#define NX_ENDIAN 1
#else
	#define NX_ENDIAN 0
#endif

/* Architecture Detection */
#if defined(__x86_64__) || defined(_M_X64) || defined(__aarch64__) \
	|| defined(__PPC64__) || defined(__mips64__)
	#define NX_IS_BIT 64
#elif defined(__i386__) || (defined(__arm__) && !(defined(__thumb__) || defined(__ARM_ARCH_8__))) \
	|| defined(__PPC__) || defined(__mips__) || defined(__sparc__) || defined(_M_IX86)
	#define NX_IS_BIT 32
#elif defined(__x86__) || defined(__ARM_ARCH_4T__) || defined(__ARM_ARCH_5T__) \
	|| defined(__ARM_ARCH_5TE__) || defined(__m68k__) || defined(__TMS320__) \
	|| defined(__HCS12__) || defined(__HC12__) || defined(__68HC12__) \
	|| defined(__HCS12X__) || defined(__XMEGA__) || defined(__AVR_HAVE_16BIT__) \
	|| defined(__DSP56K__) || defined(__Blackfin__) || defined(__thumb__)
	#define NX_IS_BIT 16
#elif defined(__Z80__) || defined(__8080__) || defined(__AVR__) \
	|| defined(__PIC__) || defined(__HC08__) || defined(__6502__)
	#define NX_IS_BIT 8
#else
	#define NX_IS_BIT 0  /* Undefined architecture */
#endif

#define NX_SWAP64(D) ((((D) >> 56) & 0x00000000000000FF) | \
	(((D) >> 40) & 0x000000000000FF00) | \
	(((D) >> 24) & 0x0000000000FF0000) | \
	(((D) >> 8) & 0x000000000FF00000) | \
	(((D) << 8) & 0x0000000FF0000000) | \
	(((D) << 24) & 0x0000FF0000000000) | \
	(((D) << 40) & 0x00FF000000000000) | \
	(((D) << 56) & 0xFF00000000000000))
#define NX_SWAP32(D) ((((D) >> 24) & 0x000000FF) | \
	(((D) >> 8)  & 0x0000FF00) | \
	(((D) << 8)  & 0x00FF0000) | \
	(((D) << 24) & 0xFF000000))
#define NX_SWAP16(D) (((D) >> 8) | ((D) << 8))
#define NX_SWAP8(D) (D)

#if NX_IS_BIT == 64
	#define NX_SWAP(D) (NX_SWAP64(D))
#elif NX_IS_BIT == 32
	#define NX_SWAP(D) (NX_SWAP32(D))
#elif NX_IS_BIT == 16
	#define NX_SWAP(D) (NX_SWAP16(D))
#else
	#define NX_SWAP(D) (NX_SWAP8(D))
#endif

#if defined(__SIZEOF_LONG_DOUBLE__) && __SIZEOF_LONG_DOUBLE__ == 16
	#define NX_HAS_REAL_128BIT_FLOAT 1
#else
	#define NX_HAS_REAL_128BIT_FLOAT 0
#endif

#if defined(__FLT_HAS_INFINITY__)
	#define NX_SUPPORTS_INFINITY 1
#else
	#define NX_SUPPORTS_INFINITY 0
#endif

#if defined(__FLT_HAS_NAN__)
	#define NX_SUPPORTS_NAN 1
#else
	#define NX_SUPPORTS_NAN 0
#endif

#if NX_IS_64BIT && (NX_SUPPORTS_LONG_LONG || (__SIZEOF_LONG__ == 8))
	#define NX_LONG_LONG = 1
#else /* 32-bit system */
	#define NX_LONG_LONG = 0
#endif

/* Memory Alignment Macros */
#define NX_ALIGN_4 __attribute__((aligned(4)))   /* Align to 4 bytes */
#define NX_ALIGN_8 __attribute__((aligned(8)))   /* Align to 8 bytes */
#define NX_ALIGN_16 __attribute__((aligned(16))) /* Align to 16 bytes */
#define NX_ALIGN_32 __attribute__((aligned(32))) /* Align to 32 bytes */
#define NX_CACHE_ALIGN_64 __attribute__((aligned(64))) /* Align to 64-byte cache line */
#define NX_CACHE_ALIGN_128 __attribute__((aligned(128))) /* Align to 128-byte cache line */
#define NX_CACHE_ALIGN_256 __attribute__((aligned(256))) /* Align to 256-byte cache line */

/* CPU Instruction Set Detection */
#if defined(__SSE__) || defined(__x86_64__) || defined(_M_X64)
	#define NX_HAS_SSE 1  /* SSE Instructions Available */
#else
	#define NX_HAS_SSE 0
#endif

#if defined(__AVX__) || defined(__AVX2__) || defined(__x86_64__) || defined(_M_X64)
	#define NX_HAS_AVX 1  /* AVX Instructions Available */
#else
	#define NX_HAS_AVX 0
#endif

#if defined(__ARM_NEON) || defined(__ARM_FEATURE_NEON)
	#define NX_HAS_NEON 1 /* NEON Instructions Available (ARM) */
#else
	#define NX_HAS_NEON 0
#endif

#if defined(__CACHE_LINE_SIZE)
	#define NX_CACHE_LINE_SIZE __CACHE_LINE_SIZE /* Cache line size */
#elif defined(__GNUC__) && defined(__x86_64__)
	#include <unistd.h>
	#define NX_CACHE_LINE_SIZE sysconf(_SC_LEVEL1_DCACHE_LINESIZE) /* Retrieve cache line size */
#else
	#define NX_CACHE_LINE_SIZE 64 /* Default to 64 bytes (common architecture) */
#endif

/* Branch Prediction Macros */
/* Instruction Prefetching */
#if defined(__GNUC__) || defined(__clang__)
	#define NX_PREFETCH(D) __builtin_prefetch(D)
	#define NX_LIKELY(D) __builtin_expect(!!(D), 1) /* Likely branch */
	#define NX_UNLIKELY(D) __builtin_expect(!!(D), 0) /* Unlikely branch */
#else
	#define NX_PREFETCH(D) /* No prefetch available */
	#define NX_LIKELY(D) (D) /* No prediction available */
	#define NX_UNLIKELY(D) (D)
#endif

#define NX_TOK_LENGTH 64
#define NX_BUF_SIZE 4096
#define NX_XSTR(D) NX_STR(D)
#define NX_STR(D) #D
#define NX_TYPE_DEF(D1, D2, D3) nx_##D2##D3##t nx_##D1##_##D2##D3##f(nx_##D1##_St*, nx_##D2##D3##t)
#define NX_TYPE_CAST(D1) nx_void_t nx_##D1##_f(nx_##D1##_St*, nx_##D1##_Et, nx_void_pt)
#define NX_TYPE(D1, D2, D3, D4) nx_##D2##D3##t nx_##D1##_##D2##D3##f(nx_##D1##_St *s, nx_##D2##D3##t d) \
{ \
	nx_##D2##D3##t t = d; \
	nx_##D1##_f(s, D4, (nx_void_pt)&t); \
	return t; \
}

typedef void nx_void_t;
typedef nx_void_t *nx_void_pt;
typedef nx_void_t **nx_void_ppt;
typedef nx_void_t ***nx_void_pppt;
typedef nx_void_t ****nx_void_ppppt;
#define NX_NULL ((nx_void_pt)0)

/* Byte */
typedef char nx_char_t;
typedef const nx_char_t nx_char_T;
typedef nx_char_t *nx_char_pt;
typedef nx_char_T *nx_char_pT;
typedef nx_char_pt const nx_char_Pt;
typedef nx_char_pT const nx_char_PT;
typedef nx_char_t **nx_char_ppt;
typedef nx_char_T **nx_char_ppT;
typedef nx_char_ppt const nx_char_pPt;
typedef nx_char_ppT const nx_char_pPT;

typedef unsigned char nx_char_ut;
typedef const nx_char_ut nx_char_uT;
typedef nx_char_ut *nx_char_put;
typedef nx_char_uT *nx_char_puT;
typedef nx_char_put const nx_char_Put;
typedef nx_char_puT const nx_char_PuT;

typedef signed char nx_char_st;
typedef const nx_char_st nx_char_sT;
typedef nx_char_st *nx_char_pst;
typedef nx_char_sT *nx_char_psT;
typedef nx_char_pst const nx_char_Pst;
typedef nx_char_psT const nx_char_PsT;

typedef union {
	nx_char_t _char;
	nx_char_ut u_char;
	nx_char_st s_char;
} nx_db_Ut;

typedef enum {
	_CHAR, U_CHAR, S_CHAR
} nx_db_Et;

typedef struct {
	nx_db_Et type;
	nx_db_Ut data;
} nx_db_St;

NX_TYPE_DEF(db, char, _u);
NX_TYPE_DEF(db, char, _s);
NX_TYPE_DEF(db, char, _);
NX_TYPE_CAST(db);

/* Word */
typedef short nx_short_st;
typedef const nx_short_st nx_short_sT;
typedef nx_short_sT *nx_short_psT;
typedef nx_short_psT const nx_short_PsT;

typedef unsigned short nx_short_ut;
typedef const nx_short_ut nx_short_uT;
typedef nx_short_ut *nx_short_put;
typedef nx_short_uT *nx_short_puT;
typedef nx_short_put const nx_short_Put;
typedef nx_short_puT const nx_short_PuT;

typedef union {
	nx_short_st s_short;
	nx_short_ut u_short;
} nx_dw_Ut;

typedef enum {
	U_SHORT, S_SHORT
} nx_dw_Et;

typedef struct {
	nx_dw_Et type;
	nx_dw_Ut data;
} nx_dw_St;

NX_TYPE_DEF(dw, short, _u);
NX_TYPE_DEF(dw, short, _s);
NX_TYPE_CAST(dw);

/* Double Word */
typedef float nx_float_t;
typedef const nx_float_t nx_float_T;
typedef nx_float_t *nx_float_pt;
typedef nx_float_T *nx_float_pT;
typedef nx_float_pt const nx_float_Pt;
typedef nx_float_pT const nx_float_PT;

typedef int nx_int_st;
typedef const nx_int_st nx_int_sT;
typedef nx_int_st *nx_int_pst;
typedef nx_int_sT *nx_int_psT;
typedef nx_int_pst const nx_int_Pst;
typedef nx_int_psT const nx_int_PsT;

typedef unsigned int nx_int_ut;
typedef const nx_int_ut nx_int_uT;
typedef nx_int_ut *nx_int_put;
typedef nx_int_uT *nx_int_puT;
typedef nx_int_put const nx_int_Put;
typedef nx_int_puT const nx_int_PuT;

typedef union {
	nx_int_st s_int;
	nx_int_ut u_int;
	nx_float_t _float;
} nx_dd_Ut;

typedef enum {
	U_INT, S_INT, _FLOAT
} nx_dd_Et;

typedef struct {
	nx_dd_Et type;
	nx_dd_Ut data;
} nx_dd_St;

NX_TYPE_DEF(dd, int, _s);
NX_TYPE_DEF(dd, int, _u);
NX_TYPE_DEF(dd, float, _);
NX_TYPE_CAST(dd);

#endif

