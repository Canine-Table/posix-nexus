#ifndef NX_TYPE_H
#define NX_TYPE_H

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

#define NX_SWAP64(v) ((((v) >> 56) & 0x00000000000000FF) | \
	(((v) >> 40) & 0x000000000000FF00) | \
	(((v) >> 24) & 0x0000000000FF0000) | \
	(((v) >> 8) & 0x000000000FF00000) | \
	(((v) << 8) & 0x0000000FF0000000) | \
	(((v) << 24) & 0x0000FF0000000000) | \
	(((v) << 40) & 0x00FF000000000000) | \
	(((v) << 56) & 0xFF00000000000000))
#define NX_SWAP32(v) ((((v) >> 24) & 0x000000FF) | \
	(((v) >> 8)  & 0x0000FF00) | \
	(((v) << 8)  & 0x00FF0000) | \
	(((v) << 24) & 0xFF000000))
#define NX_SWAP16(v) (((v) >> 8) | ((v) << 8))

#if NX_IS_BIT == 64
	#define NX_SWAP(v) (NX_SWAP64(v))
#elif NX_IS_BIT == 32
	#define NX_SWAP(v) (NX_SWAP32(v))
#elif NX_IS_BIT == 16
	#define NX_SWAP(v) (NX_SWAP16(v))
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
	typedef unsigned long long nx_uint64_t;
	typedef signed long long nx_sint64_t;
	typedef unsigned long long nx_size_t;
	typedef signed long long nx_ptrdiff_t;
	typedef signed long int nx_sint_t;
	typedef unsigned long int nx_uint_t;
#else /* 32-bit system */
	typedef unsigned long nx_size_t;
	typedef signed long nx_ptrdiff_t;
	typedef signed int nx_sint_t;
	typedef unsigned int nx_uint_t;
	typedef struct {
		nx_size_t low;
		nx_size_t high;
	} nx_uint64_t;
	typedef struct {
		nx_ptrdiff_t low;
		nx_ptrdiff_t high;
	} nx_sint64_t;
#endif

/* Pointer types */
typedef void* nx_ptr_t;			/* Generic pointer */
typedef void* const nx_Ptr_t;		/* Constant generic pointer */

typedef const void* nx_cptr_t;		/* Constant pointer to a constant object */
typedef const void* const nx_CPtr_t;	/* Fully constant pointer */

/* Floating-point types */
typedef float nx_flt_t;			/* 32-bit floating-point */
typedef const float nx_Flt_t;		/* Constant 32-bit floating-point */

typedef double nx_dbl_t;		/* 64-bit floating-point */
typedef const double nx_Dbl_t;		/* Constant 64-bit floating-point */

typedef long double nx_ldbl_t;		/* 128-bit (or extended precision) floating-point */
typedef const long double nx_Ldbl_t;	/* Constant 128-bit floating-point */

/* integer types */
typedef const nx_sint_t nx_Sint_t;
typedef const nx_uint_t nx_Uint_t;

typedef unsigned short nx_ushrt_t;		/* 16-bit unsigned integer (most of the time) */
typedef unsigned const short nx_Ushrt_t;	/* 16-bit unsigned constant integer (most of the time) */
typedef signed short nx_sshrt_t;		/* 16-bit signed integer */
typedef signed const short nx_Sshrt_t;		/* Constant 16-bit signed integer */

typedef char nx_char_t;				/* 8-bit integer */
typedef const char nx_Char_t;			/* 8-bit constant integer */
typedef unsigned char nx_uchar_t;		/* 8-bit unsigned integer */
typedef unsigned const char nx_Uchar_t;		/* 8-bit unsigned constant integer */
typedef signed char nx_schar_t;			/* 8-bit signed integer */
typedef signed const char nx_Schar_t;		/* Constant 8-bit signed integer */

typedef unsigned char nx_uint8_t;
typedef signed char nx_sint8_t;
typedef unsigned short nx_uint16_t;
typedef signed short nx_sint16_t;
typedef unsigned int nx_uint32_t;
typedef signed int nx_sint32_t;

#endif

