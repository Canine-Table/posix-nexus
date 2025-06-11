#ifndef NX_MATH_H
#define NX_MATH_H

#define NX_NAN 0x7FF8000000000000

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

/* Geometry */
#define NX_AREA_CIRCLE(R) (3.141592653589793 * (R) * (R))	/* Calculates the area of a circle */
#define NX_PERIMETER_CIRCLE(R) (2 * 3.141592653589793 * (R))	/* Calculates the perimeter of a circle */
#define NX_AREA_RECTANGLE(L, W) ((L) * (W))			/* Calculates the area of a rectangle */

/* Temperature Conversion */
#define NX_F2C(F) (((F) - 32) * 5 / 9)		/* Converts Fahrenheit to Celsius */
#define NX_C2F(C) (((C) * 9 / 5) + 32)		/* Converts Celsius to Fahrenheit */

#define NX_ADD(D1, D2) (D1 + D2)
#define NX_SUB(D1, D2) (D1 - D2)
#define NX_MUL(D1, D2) (D1 * D2)
#define NX_DIV(D1, D2) (D1 / D2)
#define NX_SQUARE(D) NX_MUL(D, D)
#define NX_CUBE(D) NX_MUL(NX_SQUARE(D), D)
#define NX_AVG(D1, D2) NX_DIV(NX_ADD(D1, D2), 2)
#define NX_ABS(D) (D < 0) ? NX_MUL(D, -1) : (D)
#define NX_MIN(D1, D2) ((D1) < (D2) ? (D1) : (D2))
#define NX_MAX(D1, D2) ((D1) > (D2) ? (D1) : (D2))
#define NX_CLAMP(D1, D2, D3) ((D1) < (D2) ? (D2) : ((D1) > (D3) ? (D3) : (D1)))
#define NX_IN_RANGE(D1, D2, D3) ((D1) >= (D2) && (D1) <= (D3))
#define NX_CDIV(D1, D2) NX_DIV(NX_SUB(NX_ADD(D1, D2), 1), D2)
#define NX_SET_BIT(D1, D2)  ((D1) |= (1 << (D2)))
#define NX_CLEAR_BIT(D1, D2) ((D1) &= ~(1 << (D2)))
#define NX_TOGGLE_BIT(D1, D2) ((D1) ^= (1 << (D2)))
#define NX_CHECK_BIT(D1, D2) ((D1) & (1 << (D2)))
#define NX_ORS(D1, D2) (D1 | D1 >> D2)
#define NX_NXT_POT(D) NX_ADD(NX_ORS(NX_ORS(NX_ORS(NX_ORS(NX_ORS(NX_SUB(D, 1), 1), 2), 4), 8), 16), 1)
#define NX_EVEN(D) (NX_MOD_POT(D, 2) == 0)
#define NX_ODD(D) (NX_EVEN(D) == 0)
#define NX_MUL_POT(D) (D << 1)
#define NX_DIV_POT(D) ((D > 0) ? (D >> 1) : 0)
#define NX_MOD_POT(D1, D2) (D1 & NX_SUB(NX_NXT_POT(D2), 1))
#define NX_IS_POT(D) ((D > 0) && ((D & NX_SUB(D, 1)) == 0))
#define NX_ROUND_DEF(D1, D2) nx_int_##D1##t nx_dd_##D2##_##D1##f(nx_dd_St *s)
#define NX_ROUND(D1, D2, D3, D4, D5, D6) NX_ROUND_DEF(D1, D2) \
{ \
	nx_float_t t; \
	if (s->type == _FLOAT) \
		t = s->data._FLOAT + D6; \
	else \
		return nx_dd_int_##D1##f(s, s->data.D3); \
	return (t D4 nx_dd_int_##D1##f(s, t)) ? (nx_dd_int_##D1##f(s, s->data.D3 + D5)) : (s->data.D3); \
}

NX_ROUND_DEF(s, floor);
NX_ROUND_DEF(s, ceil);
NX_ROUND_DEF(s, round);
NX_ROUND_DEF(s, trunc);
NX_ROUND_DEF(u, floor);
NX_ROUND_DEF(u, ceil);
NX_ROUND_DEF(u, round);

#endif

