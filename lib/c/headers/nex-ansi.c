#include <stdarg.h>
#include <stdio.h>
#include "nex-ansi.h"

#define NEX_ansiPrefix_M(color, symbol) \
	fprintf(stderr, color "[" "\x1b[4;3;7m" symbol "\x1b[24;23;27m" "]" "\x1b[37m: " color)

#define NEX_ansiSuffix_M() \
	fprintf(stderr, "\x1b\[0m\n")

void nx_ansi_success(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[92;1m", "V");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_error(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[91;1m", "X");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_warning(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[93;1m", "?");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_alert(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[96;1m", "&");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_debug(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[95;1m", ">");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_info(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[94;1m", ".");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_light(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[97;1m", "$");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

void nx_ansi_dark(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	NEX_ansiPrefix_M("\x1b[90;1m", "|");
	vfprintf(stderr, fmt, args);
	NEX_ansiSuffix_M();
	va_end(args);
}

