#include "nex-define.h"
#include "nex-misc.h"
#include "nex-math.h"
#include "nex-string.h"
#include <stdio.h>
#if (NX_HAS_SSE == 1) /* SSE Instructions Available */
	#include <emmintrin.h> /* SSE2 */
#endif
#if (NX_HAS_AVX == 1) /* AVX Instructions Available */
	#include <immintrin.h> /* AVX, AVX2 */
#endif

