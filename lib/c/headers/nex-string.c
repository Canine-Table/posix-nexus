#include <string.h>
#include "nex-string.h"

void NX_normalizeText_gB1b1_uF(
	const char *in,
	char *out,
	size_t outsz
) {
	size_t j = 0;
	int last_space = 0;

	for (size_t i = 0; in[i] && j + 1 < outsz; i++) {
		unsigned char c = in[i];

		// newline -> space
		if (c == '\n' || c == '\r' || c == '\t')
			c = ' ';

		if (c == ' ') {
			if (!last_space && j > 0) {
				out[j++] = ' ';
				last_space = 1;
			}
			continue;
		}

		out[j++] = c;
		last_space = 0;
	}

	if (j > 0 && out[j - 1] == ' ')
		j--;

	out[j] = '\0';
}

void nX_deriveSlug_gB1b1_uF(
	const char *in,
	char *out,
	size_t outsz
) {
	size_t j = 0;

	for (size_t i = 0; in[i] != '\0' && j + 1 < outsz; i++) {
		unsigned char c = in[i];

		if (c >= 'A' && c <= 'Z') {
			out[j++] = (char)(c + 32);
		} else if ((c >= 'a' && c <= 'z') ||
				(c >= '0' && c <= '9')) {
			out[j++] = (char)c;
		} else if (c == ' ' || c == '-' || c == '_') {
			if (j > 0 && out[j-1] != '-')
				out[j++] = '-';
		} else {
			// ignore punctuation
		}
	}

	// trim trailing hyphen
	if (j > 0 && out[j-1] == '-')
		j--;

	out[j] = '\0';
}

void nX_deriveNormalized_gB1b1_uF(
	const char *in,
	char *out,
	size_t outsz
) {
	size_t j = 0;
	int last_was_space = 0;

	for (size_t i = 0; in[i] != '\0' && j + 1 < outsz; i++) {
		unsigned char c = in[i];

		if (c >= 'A' && c <= 'Z') {
			out[j++] = (char)(c + 32);
			last_was_space = 0;
		} else if ((c >= 'a' && c <= 'z') ||
				(c >= '0' && c <= '9')) {
			out[j++] = (char)c;
			last_was_space = 0;
		// Convert separators to a single space
		} else if (c == ' ' || c == '-' || c == '_') {
			if (!last_was_space && j > 0) {
				out[j++] = ' ';
				last_was_space = 1;
			}
		// Ignore punctuation entirely
		} else {
			// skip
		}
	}

	// Trim trailing space
	if (j > 0 && out[j - 1] == ' ')
		j--;

	out[j] = '\0';
}

