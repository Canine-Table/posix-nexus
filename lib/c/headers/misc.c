#include <float.h>
#include <limits.h>
#include <stddef.h>
#include <stdint.h>
#include <time.h>

void nx_range_constants()
{
	nx_float_range();
	nx_int_range();
	nx_short_range();
	nx_char_range();
	nx_epsilon_values();
	nx_limits_constants();
	nx_print('L', 'i', "\n");
}

void nx_float_range()
{
	nx_print('L', 'i', "\nFloating-point ranges");
	printf("Long double range: %Le to %Le\n", LDBL_MIN, LDBL_MAX);
	printf("Double range: %e to %e\n", DBL_MIN, DBL_MAX);
	printf("Float range: %e to %e\n", FLT_MIN, FLT_MAX);
	nx_print('L', 'i', "\nFloating-point precision");
	printf("Precision of long double: %d decimal digits\n", LDBL_DIG);
	printf("Precision of double: %d decimal digits\n", DBL_DIG);
	printf("Precision of float: %d decimal digits\n", FLT_DIG);
}

void nx_int_range()
{
	nx_print('L', 'i', "\nInteger ranges");
	printf("Long long range: %lld to %lld\n", LLONG_MIN, LLONG_MAX);
	printf("Unsigned long long range: 0 to %llu\n", ULLONG_MAX);
	printf("Integer range: %d to %d\n", INT_MIN, INT_MAX);
	printf("Unsigned integer range: 0 to %u\n", UINT_MAX);
}

void nx_short_range()
{
	nx_print('L', 'i', "\nShort ranges");
	printf("Short range: %d to %d\n", SHRT_MIN, SHRT_MAX);
	printf("Unsigned short range: 0 to %u\n", USHRT_MAX);
}

void nx_char_range()
{
	nx_print('L', 'i', "\nChar ranges");
	printf("Char range: %d to %d\n", CHAR_MIN, CHAR_MAX);
	printf("Unsigned char range: 0 to %u\n", UCHAR_MAX);
}

void nx_epsilon_values()
{
	nx_print('L', 'i', "\nFloating-point Epsilon Values");
	printf("Float Epsilon: %e (Smallest value where 1.0 + EPSILON != 1.0)\n", FLT_EPSILON);
	printf("Double Epsilon: %e (Smallest value where 1.0 + EPSILON != 1.0)\n", DBL_EPSILON);
	printf("Long Double Epsilon: %Le (Smallest value where 1.0 + EPSILON != 1.0)\n", LDBL_EPSILON);
}

void nx_limits_constants()
{
	nx_print('L', 'i', "\nSystem Limits");
	printf("Bits in a Char: %d\n", CHAR_BIT);
	printf("Max Size_t Value: %zu\n", SIZE_MAX);
	printf("Clock Ticks Per Second: %ld\n", CLOCKS_PER_SEC);
}

