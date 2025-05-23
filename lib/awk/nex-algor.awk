#nx_include "nex-misc.awk"
#nx_include "nex-math.awk"

function __nx_hoares_partition(V, N1, N2, D,	md)
{
	md = nx_modulus_range(__nx_entropy(N2), N1, N2)
	N1 = N1 - 1
	N2 = N2 + 1
	while (1) {
		do {
			N1++
		} while (__nx_equality(V[N1], D, V[md]))
		do {
			N2--
		} while (__nx_equality(V[md], D, V[N2]))
		if (N1 >= N2)
			return N2
		__nx_swap(V, N1, N2)
	}
}

function nx_quick_sort(V, N1, N2, D,	md)
{
	if (__nx_equality(N1 = __nx_else(nx_natural(N1), 1), "<0", N2 = __nx_else(nx_natural(N2), V[0]))) {
		md = __nx_hoares_partition(V, N1, N2, D)
		nx_quick_sort(V, N1, md, D)
		nx_quick_sort(V, md + 1, N2, D)
	}
}

