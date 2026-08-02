#ifndef NEX_string_H
#define NEX_string_H

#include <stddef.h>

void NX_normalizeText_gB1b1_uF(
	const char *in,
	char *out,
	size_t outsz
);

void nX_deriveSlug_gB1b1_uF(
	const char*,
	char*,
	size_t
);

void nX_deriveNormalized_gB1b1_uF(
	const char*,
	char*,
	size_t
);

#endif
