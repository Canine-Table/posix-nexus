#ifndef NX_DEF_H
#define NX_DEF_H

#define NX_HASH_TABLE_SIZE 1024
#define NX_NAN 0x7FF8000000000000
#define NX_NULL ((nx_ptr_t)0)

/* Mathematical Constants */
#define NX_GOLDEN_RATIO 1.618033988749895	/* Golden Ratio (phi) */
#define NX_PI 3.141592653589793			/* Value of Pi */
#define NX_TAU 6.283185307179586		/* Tau (2 * Pi) */
#define NX_E 2.718281828459045			/* Euler's number */
#define NX_SQRT2 1.414213562373095		/* Square root of 2 */
#define NX_LN2 0.6931471805599453		/* Natural logarithm of 2 */
#define NX_LN10 2.302585092994046		/* Natural logarithm of 10 */

/* Physical Constants */
#define NX_LIGHT_SPEED 299792458		/* Speed of light in vacuum (m/s) */
#define NX_GRAVITY 9.80665			/* Standard gravity (m/s^2) */
#define NX_PLANCK 6.62607015e-34		/* Planck's constant (Js) */
#define NX_BOLTZMANN 1.380649e-23		/* Boltzmann constant (J/K) */
#define NX_AVOGADRO 6.02214076e23		/* Avogadro's number (1/mol) */
#define NX_GAS_CONSTANT 8.314462618		/* Ideal gas constant (J/(mol·K)) */
#define NX_ELECTRON_MASS 9.10938356e-31		/* Electron mass (kg) */
#define NX_PROTON_MASS 1.67262192369e-27	/* Proton mass (kg) */
#define NX_ELEM_CHARGE 1.602176634e-19		/* Elementary charge (C) */
#define NX_PERMITTIVITY 8.854187817e-12		/* Vacuum permittivity (F/m) */
#define NX_PERMEABILITY 1.2566370614e-6		/* Vacuum permeability (H/m) */

/* Engineering and Computer Science Constants */
#define NX_KILOBYTE 1024			/* Bytes in a kilobyte */
#define NX_MEGABYTE (1024 * NX_KILOBYTE)	/* Bytes in a megabyte */
#define NX_GIGABYTE (1024 * NX_MEGABYTE)	/* Bytes in a gigabyte */
#define NX_FLOAT_EPSILON 1.19209290e-7		/* Smallest float difference (32-bit) */
#define NX_DOUBLE_EPSILON 2.22044605e-16	/* Smallest double difference (64-bit) */
#define NX_MAX_INT 2147483647			/* Maximum value of a 32-bit int */
#define NX_MIN_INT -2147483648			/* Minimum value of a 32-bit int */

/* Astronomy Constants */
#define NX_AU 149597870700		/* Astronomical Unit (meters) */
#define NX_PARSEC 3.085677581e16	/* Parsec (meters) */
#define NX_SOLAR_MASS 1.989e30		/* Mass of the Sun (kg) */
#define NX_EARTH_MASS 5.972e24		/* Mass of the Earth (kg) */
#define NX_LUNAR_MASS 7.342e22		/* Mass of the Moon (kg) */
#define NX_EARTH_RADIUS 6371000		/* Earth's mean radius (meters) */
#define NX_EARTH_ORBITAL_PERIOD 365.25	/* Earth's orbital period (days) */
#define NX_MOON_DISTANCE 384400000	/* Average Earth-Moon distance (meters) */

/* Chemistry Constants */
#define NX_WATER_FREEZING 273.15	/* Freezing point of water (Kelvin) */
#define NX_WATER_BOILING 373.15		/* Boiling point of water (Kelvin) */
#define NX_STP_PRESSURE 101325		/* Standard pressure (Pa) */
#define NX_STP_TEMPERATURE 273.15	/* Standard temperature (K) */
#define NX_MOLAR_VOLUME 22.414		/* Molar volume of ideal gas at STP (L/mol) */

/* Human-Friendly Units */
#define NX_FEET_TO_METERS 0.3048	/* 1 foot in meters */
#define NX_MILES_TO_KM 1.60934		/* 1 mile in kilometers */
#define NX_POUNDS_TO_KG 0.453592	/* 1 pound in kilograms */
#define NX_INCH_TO_CM 2.54		/* 1 inch in centimeters */

/* Basic Operations */
#define NX_SQUARE_N(N) ((N) * (N))				/* Calculates the square of a number */
#define NX_CUBE_N(N) (NX_SQUARE_N(N) * (N))			/* Calculates the cube of a number */
#define NX_MIN(A, B) ((A) < (B) ? (A) : (B))			/* Returns the minimum of two numbers */
#define NX_MAX(A, B) ((A) > (B) ? (A) : (B))			/* Returns the maximum of two numbers */
#define NX_AVG(A, B) (((A) + (B)) / 2)				/* Calculates the average of two numbers */
#define NX_ODD_N(N)(N % 2 == 1)					/* Checks if a number is odd */
#define NX_EVEN_N(N) ((N) % 2 == 0)				/* Checks if a number is even */
#define NX_ABS(N) ((N) < 0 ? -(N) : (N))			/* Returns the absolute value of a number */
#define NX_IS_POWER_OF_TWO(N) ((N) && !((N) & ((N) - 1)))	/* Checks if N is a power of 2 */

/* Range and Clamping */
#define NX_CLAMP(N, MIN, MAX) ((N) < (MIN) ? (MIN) : ((N) > (MAX) ? (MAX) : (N)))	/* Clamps N within MIN and MAX */
#define NX_IN_RANGE(N, MIN, MAX) ((N) >= (MIN) && (N) <= (MAX))				/* Checks if N is within range [MIN, MAX] */

/* Bitwise Operations */
#define NX_SET_BIT(N, B) ((N) | (1 << (B)))	/* Sets the B-th bit of N */
#define NX_CLEAR_BIT(N, B) ((N) & ~(1 << (B)))	/* Clears the B-th bit of N */
#define NX_TOGGLE_BIT(N, B) ((N) ^ (1 << (B)))	/* Toggles the B-th bit of N */

/* Geometry */
#define NX_AREA_CIRCLE(R) (3.141592653589793 * (R) * (R))	/* Calculates the area of a circle */
#define NX_PERIMETER_CIRCLE(R) (2 * 3.141592653589793 * (R))	/* Calculates the perimeter of a circle */
#define NX_AREA_RECTANGLE(L, W) ((L) * (W))			/* Calculates the area of a rectangle */

/* Temperature Conversion */
#define NX_F2C(F) (((F) - 32) * 5 / 9)		/* Converts Fahrenheit to Celsius */
#define NX_C2F(C) (((C) * 9 / 5) + 32)		/* Converts Celsius to Fahrenheit */

/* Endian Macros */
#if defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
	#define NX_BIG_ENDIAN 1
	#define NX_LITTLE_ENDIAN 0
#elif defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__)
	#define NX_BIG_ENDIAN 0
	#define NX_LITTLE_ENDIAN 1
#elif defined(__BIG_ENDIAN__) || defined(_BIG_ENDIAN) || defined(__ARMEB__) || defined(__MIPSEB__) || defined(__POWERPC__) || defined(__sparc__)
	#define NX_BIG_ENDIAN 1
	#define NX_LITTLE_ENDIAN 0
#else
	#define NX_BIG_ENDIAN 0
	#define NX_LITTLE_ENDIAN 1
#endif

/* Conditional Endian Swap Based on Architecture */
#if NX_BIG_ENDIAN
	#define NX_TO_LITTLE16(X) nx_swap16(X)
	#define NX_TO_LITTLE32(X) nx_swap32(X)
	#define NX_TO_LITTLE64(X) nx_swap64(X)
	#define NX_TO_BIG16(X) (X)  /* Already big-endian */
	#define NX_TO_BIG32(X) (X)
	#define NX_TO_BIG64(X) (X)
#else
	#define NX_TO_LITTLE16(X) (X)  /* Already little-endian */
	#define NX_TO_LITTLE32(X) (X)
	#define NX_TO_LITTLE64(X) (X)
	#define NX_TO_BIG16(X) nx_swap16(X)
	#define NX_TO_BIG32(X) nx_swap32(X)
	#define NX_TO_BIG64(X) nx_swap64(X)
#endif

/* Architecture Detection */
#if defined(__x86_64__) || defined(_M_X64) || defined(__aarch64__) || defined(__PPC64__) || defined(__mips64)
	#define NX_IS_64BIT 1
	typedef unsigned long long nx_size_t;
	typedef long long nx_ptrdiff_t;
#else
	#define NX_IS_64BIT 0
	typedef unsigned long nx_size_t;
	typedef long nx_ptrdiff_t;
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
#if defined(__GNUC__) || defined(__clang__)
	#define NX_LIKELY(x) __builtin_expect(!!(x), 1) /* Likely branch */
	#define NX_UNLIKELY(x) __builtin_expect(!!(x), 0) /* Unlikely branch */
#else
	#define NX_LIKELY(x) (x) /* No prediction available */
	#define NX_UNLIKELY(x) (x)
#endif

/* Instruction Prefetching */
#if defined(__GNUC__) || defined(__clang__)
	#define NX_PREFETCH(addr) __builtin_prefetch(addr)
#elif defined(_MSC_VER)
	#include <mmintrin.h>
	#define NX_PREFETCH(addr) _mm_prefetch((const char *)(addr), _MM_HINT_T0)
#else
	#define NX_PREFETCH(addr) /* No prefetch available */
#endif

/* Pointer types */
typedef void* nx_ptr_t;			/* Generic pointer */
typedef void* const nx_Ptr_t;		/* Constant generic pointer */
typedef const void* nx_cptr_t;		/* Constant pointer to a constant object */
typedef const void* const nx_CPtr_t;	/* Fully constant pointer */

/* Floating-point types */
typedef float nx_f32_t;			/* 32-bit floating-point */
typedef const float nx_F32_t;		/* Constant 32-bit floating-point */
typedef double nx_f64_t;		/* 64-bit floating-point */
typedef const double nx_F64_t;		/* Constant 64-bit floating-point */
typedef long double nx_f128_t;		/* 128-bit (or extended precision) floating-point */
typedef const long double nx_F128_t;	/* Constant 128-bit floating-point */

/* integer types */
typedef signed char nx_s8_t;			/* 8-bit signed integer */
typedef signed const char nx_S8_t;		/* Constant 8-bit signed integer */
typedef signed	short nx_s16_t;			/* 16-bit signed integer */
typedef signed const short nx_S16_t;		/* Constant 16-bit signed integer */
typedef signed int nx_s32_t;			/* 32-bit signed integer */
typedef signed const int nx_S32_t;		/* Constant 32-bit signed integer */
typedef signed long long nx_s64_t;		/* 64-bit signed integer */
typedef signed const long long nx_S64_t;	/* Constant 64-bit signed integer */
typedef unsigned const char nx_U8_t;		/* 8-bit unsigned constant integer */
typedef unsigned char nx_u8_t;			/* 8-bit unsigned integer */
typedef unsigned const short nx_U16_t;		/* 16-bit unsigned constant integer */
typedef unsigned short nx_u16_t;		/* 16-bit unsigned integer */
typedef unsigned const int nx_U32_t;		/* 32-bit unsigned constant integer */
typedef unsigned int nx_u32_t;			/* 32-bit unsigned integer */
typedef unsigned const long long nx_U64_t;	/* 64-bit unsigned constant integer */
typedef unsigned long long nx_u64_t;		/* 64-bit unsigned integer */

#if defined(_SC_NPROCESSORS_ONLN)
	#include <unistd.h>
	#define NX_CPU_CORES sysconf(_SC_NPROCESSORS_ONLN) /* Get core count */
#elif defined(__APPLE__)
	#include <sys/sysctl.h>
	static inline nx_u32_t nx_cpu_cores(void);
#else
	#define NX_CPU_CORES 1 /* Default fallback */
#endif

static inline nx_u16_t nx_swap16(nx_u16_t);
static inline nx_u32_t nx_swap32(nx_u32_t);
static inline nx_u64_t nx_swap64(nx_u64_t);

#include "def.c"
#endif

