#ifndef NX_MATH_H
#define NX_MATH_H

#define NX_NAN 0x7FF8000000000000

// Mathematical Constants
#define NX_GOLDEN_RATIO 1.618033988749895 // Golden Ratio (phi)
#define NX_PI 3.141592653589793        // Value of Pi
#define NX_TAU 6.283185307179586       // Tau (2 * Pi)
#define NX_E 2.718281828459045         // Euler's number
#define NX_SQRT2 1.414213562373095     // Square root of 2
#define NX_LN2 0.6931471805599453      // Natural logarithm of 2
#define NX_LN10 2.302585092994046      // Natural logarithm of 10

// Physical Constants
#define NX_LIGHT_SPEED 299792458          // Speed of light in vacuum (m/s)
#define NX_GRAVITY 9.80665                // Standard gravity (m/s^2)
#define NX_PLANCK 6.62607015e-34          // Planck's constant (Js)
#define NX_BOLTZMANN 1.380649e-23         // Boltzmann constant (J/K)
#define NX_AVOGADRO 6.02214076e23         // Avogadro's number (1/mol)
#define NX_GAS_CONSTANT 8.314462618       // Ideal gas constant (J/(mol·K))
#define NX_ELECTRON_MASS 9.10938356e-31   // Electron mass (kg)
#define NX_PROTON_MASS 1.67262192369e-27  // Proton mass (kg)
#define NX_ELEM_CHARGE 1.602176634e-19    // Elementary charge (C)
#define NX_PERMITTIVITY 8.854187817e-12   // Vacuum permittivity (F/m)
#define NX_PERMEABILITY 1.2566370614e-6   // Vacuum permeability (H/m)

// Engineering and Computer Science Constants
#define NX_KILOBYTE 1024                // Bytes in a kilobyte
#define NX_MEGABYTE (1024 * NX_KILOBYTE) // Bytes in a megabyte
#define NX_GIGABYTE (1024 * NX_MEGABYTE) // Bytes in a gigabyte
#define NX_FLOAT_EPSILON 1.19209290e-7   // Smallest float difference (32-bit)
#define NX_DOUBLE_EPSILON 2.22044605e-16 // Smallest double difference (64-bit)
#define NX_MAX_INT 2147483647            // Maximum value of a 32-bit int
#define NX_MIN_INT -2147483648           // Minimum value of a 32-bit int

// Astronomy Constants
#define NX_AU 149597870700              // Astronomical Unit (meters)
#define NX_PARSEC 3.085677581e16        // Parsec (meters)
#define NX_SOLAR_MASS 1.989e30          // Mass of the Sun (kg)
#define NX_EARTH_MASS 5.972e24          // Mass of the Earth (kg)
#define NX_LUNAR_MASS 7.342e22          // Mass of the Moon (kg)
#define NX_EARTH_RADIUS 6371000         // Earth's mean radius (meters)
#define NX_EARTH_ORBITAL_PERIOD 365.25  // Earth's orbital period (days)
#define NX_MOON_DISTANCE 384400000      // Average Earth-Moon distance (meters)

// Chemistry Constants
#define NX_WATER_FREEZING 273.15       // Freezing point of water (Kelvin)
#define NX_WATER_BOILING 373.15        // Boiling point of water (Kelvin)
#define NX_STP_PRESSURE 101325         // Standard pressure (Pa)
#define NX_STP_TEMPERATURE 273.15      // Standard temperature (K)
#define NX_MOLAR_VOLUME 22.414         // Molar volume of ideal gas at STP (L/mol)

// Human-Friendly Units
#define NX_FEET_TO_METERS 0.3048         // 1 foot in meters
#define NX_MILES_TO_KM 1.60934           // 1 mile in kilometers
#define NX_POUNDS_TO_KG 0.453592         // 1 pound in kilograms
#define NX_INCH_TO_CM 2.54               // 1 inch in centimeters

// Basic Operations
#define NX_SQUARE_N(N) ((N) * (N))                // Calculates the square of a number
#define NX_CUBE_N(N) (NX_SQUARE_N(N) * (N))       // Calculates the cube of a number
#define NX_MIN(A, B) ((A) < (B) ? (A) : (B))      // Returns the minimum of two numbers
#define NX_MAX(A, B) ((A) > (B) ? (A) : (B))      // Returns the maximum of two numbers
#define NX_AVG(A, B) (((A) + (B)) / 2)            // Calculates the average of two numbers
#define NX_ODD_N(N)(N % 2 == 1)
#define NX_EVEN_N(N) ((N) % 2 == 0)                // Checks if a number is even
#define NX_ABS(N) ((N) < 0 ? -(N) : (N))           // Returns the absolute value of a number
#define NX_IS_POWER_OF_TWO(N) ((N) && !((N) & ((N) - 1)))  // Checks if N is a power of 2

// Range and Clamping
#define NX_CLAMP(N, MIN, MAX) ((N) < (MIN) ? (MIN) : ((N) > (MAX) ? (MAX) : (N))) // Clamps N within MIN and MAX
#define NX_IN_RANGE(N, MIN, MAX) ((N) >= (MIN) && (N) <= (MAX))                  // Checks if N is within range [MIN, MAX]

// Bitwise Operations
#define NX_SET_BIT(N, B) ((N) | (1 << (B)))       // Sets the B-th bit of N
#define NX_CLEAR_BIT(N, B) ((N) & ~(1 << (B)))    // Clears the B-th bit of N
#define NX_TOGGLE_BIT(N, B) ((N) ^ (1 << (B)))    // Toggles the B-th bit of N

/* Geometry */
#define NX_AREA_CIRCLE(R) (3.141592653589793 * (R) * (R)) // Calculates the area of a circle
#define NX_PERIMETER_CIRCLE(R) (2 * 3.141592653589793 * (R)) // Calculates the perimeter of a circle
#define NX_AREA_RECTANGLE(L, W) ((L) * (W))               // Calculates the area of a rectangle

/* Temperature Conversion */
#define NX_F2C(F) (((F) - 32) * 5 / 9)            // Converts Fahrenheit to Celsius
#define NX_C2F(C) (((C) * 9 / 5) + 32)            // Converts Celsius to Fahrenheit

// Floating-point types
typedef float nx_f32_t;         // 32-bit floating-point
typedef double nx_f64_t;        // 64-bit floating-point
typedef long double nx_f128_t;  // 128-bit (or extended precision) floating-point

// Signed integer types
typedef signed char nx_s8_t;    // 8-bit signed integer
typedef short nx_s16_t;         // 16-bit signed integer
typedef int nx_s32_t;           // 32-bit signed integer
typedef long long nx_s64_t;     // 64-bit signed integer

// Unsigned integer types
typedef unsigned char nx_u8_t;  // 8-bit unsigned integer
typedef unsigned short nx_u16_t; // 16-bit unsigned integer
typedef unsigned int nx_u32_t;  // 32-bit unsigned integer
typedef unsigned long long nx_u64_t; // 64-bit unsigned integer

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
