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

#define NX_ADD(D1, D2) ((D1) + (D2))
#define NX_SUB(D1, D2) ((D1) - (D2))
#define NX_MUL(D1, D2) ((D1) * (D2))
#define NX_DIV(D1, D2) ((D1) / (D2))

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

#define NX_ORS(D1, D2) ((D1) | (D1) >> (D2))
#define NX_XRS(D1, D2) ((D1) ^ (D1) >> (D2))

#define NX_EVEN_PARITY(D) (((NX_XRS(1, NX_XRS(2, NX_XRS(4, NX_XRS(8, NX_XRS(D, 16)))))) & 1) == 0)
#define NX_NXT_POT(D) NX_ADD(NX_ORS(NX_ORS(NX_ORS(NX_ORS(NX_ORS(NX_SUB(D, 1), 1), 2), 4), 8), 16), 1)

#define NX_EXP_POT_ST(D) (1 << (D))
#define NX_EXP_POT_UT(D) (1U << (D))
#define NX_EXP_POT_FT(D) (1.0f * NX_EXP_POT_ST(D))

#define NX_EVEN(D) (NX_MOD_POT(D, 2) == 0)
#define NX_ODD(D) (NX_EVEN(D) == 0)

#define NX_MUL_POT(D) (D << 1)
#define NX_DIV_POT(D) ((D > 0) ? (D >> 1) : 0)
#define NX_MOD_POT(D1, D2) (D1 & NX_SUB(NX_NXT_POT(D2), 1))

#define NX_IS_POT(D) ((D > 0) && ((D & NX_SUB(D, 1)) == 0))

#define NX_MIN_ST(D) NX_EXP_POT_ST(NX_SUB(sizeof(D) * 8, 1))
#define NX_MAX_ST(D) NX_SUB(-NX_MIN_ST(D), 1)
#define NX_MIN_UT(D) 0
#define NX_MAX_UT(D) NX_SUB(NX_MAX_ST(D), NX_MIN_ST(D))

#define NX_DB_MAX_CUT NX_MAX_UT(nx_dd_cut)
#define NX_DB_MIN_CUT NX_MIN_UT(nx_dd_cut)

#define NX_DB_MAX_CST NX_MAX_ST(nx_dd_cst)
#define NX_DB_MIN_CST NX_MIN_ST(nx_dd_cst)

#define NX_DW_MAX_SUT NX_MAX_UT(nx_dw_sut)
#define NX_DW_MIN_SUT NX_MIN_UT(nx_dw_sut)

#define NX_DW_MAX_SST NX_MAX_ST(nx_dw_sst)
#define NX_DW_MIN_SST NX_MIN_ST(nx_dw_sst)

#define NX_DD_MAX_IUT NX_MAX_UT(nx_dd_iut)
#define NX_DD_MIN_IUT NX_MIN_UT(nx_dd_iut)

#define NX_DD_MAX_IST NX_MAX_ST(nx_dd_ist)
#define NX_DD_MIN_IST NX_MIN_ST(nx_dd_ist)

#define NX_BIN_DEF(D1, D2, D3) nx_##D1##_##D2##t nx_##D1##_##D3##_##D2##F(nx_##D1##_##D2##t n1, nx_##D1##_##D2##t n2)
#define NX_BADD_IMP(D1, D2) NX_BIN_DEF(D1, D2, badd) \
{ \
	printf("%d\t", nx_dd_bkbc_isF((nx_d_pt)&n1, sizeof(nx_##D1##_##D2##t))); \
	nx_##D1##_bprint_F(n1); \
	printf("%d\t", nx_dd_bkbc_isF((nx_d_pt)&n2, sizeof(nx_##D1##_##D2##t))); \
	nx_##D1##_bprint_F(n2); \
	while (n2) { \
		nx_##D1##_##D2##t c = (n1 & n2) << 1; \
		n1 ^= n2; \
		n2 = c; \
	} \
	printf("%d\t", nx_dd_bkbc_isF((nx_d_pt)&n1, sizeof(nx_##D1##_##D2##t))); \
	nx_##D1##_bprint_F(n1); \
	return n1; \
}

#define NX_BSUB_IMP(D1, D2) NX_BIN_DEF(D1, D2, bsub) \
{ \
	return nx_##D1##_badd_##D2##F(n1, nx_##D1##_badd_##D2##F(~n2, 1)); \
}


NX_BIN_DEF(dd, is, badd);
NX_BIN_DEF(dw, ss, badd);
NX_BIN_DEF(dd, is, bsub);
NX_BIN_DEF(dw, ss, bsub);

nx_dd_ist nx_dd_bkbc_isF(nx_d_pt, nx_dd_ist);

#endif

