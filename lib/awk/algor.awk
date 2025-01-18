# L:	Left index
# R:	Right index
function __pivot(L, R)
{
	if (is_integral(L R)) {  # Check if both L and R are integers
		return int((entropy(6) % (R - L + 1)) + L)  # Generate a random pivot index within the range [L, R]
	}
}

# DA: The first value to compare.
# DB: The second value to compare.
# B:  A flag indicating the comparison direction (1 for greater than, 0 for less than).
# M:  A mode indicating the type of comparison (e.g., "length" for length comparison, "default" for default comparison).
function __compare(DA, DB, B, M)
{
	if (M ~ /^(l(e(n(g(t(h)?)?)?)?)?)$/) {  # Check if mode M is a variant of "length"
		if (B)
			return length(DA) > length(DB)  # Compare lengths if B is true
		else
			return length(DA) < length(DB)  # Compare lengths if B is false
	} else if (M ~ /^(d(e(f(a(u(l(t)?)?)?)?)?)?)$/) {  # Check if mode M is a variant of "default"
		if (B)
			  return DA > DB  # Compare values if B is true
		else
			return DA < DB  # Compare values if B is false
	} else if ((is_digit(DA) && is_digit(DB)) && M !~ /^(s(t(r(i(n(g)?)?)?)?)?)$/) {  # Check if both DA and DB are digits, and M is not "string"
		if (B)
			return +DA > +DB  # Compare numeric values if B is true
		else
			return +DA < +DB  # Compare numeric values if B is false
	} else {
		if (B)
			return "a" DA > "a" DB  # Compare strings if B is true
		else
			return "a" DA < "a" DB  # Compare strings if B is false
	}
}

# V:  The array in which the elements are to be swapped.
# DA: The index of the first element to swap.
# DB: The index of the second element to swap.
function __swap(V, DA, DB, ta)
{
	ta = V[DA]  # Temporarily store the value at DA
	V[DA] = V[DB]  # Assign the value at DB to DA
	V[DB] = ta  # Assign the temporary value to DB
}

# V:   The array to partition.
# L:   The starting index of the partition.
# R:   The ending index of the partition.
# B:   A flag indicating the comparison direction (1 for greater than, 0 for less than).
# M:   A mode indicating the type of comparison (e.g., "length" for length comparison).
function __hoares_partition(V, L, R, B, M, v, c, pv, md, lft, rgt)
{
	md = V[pv = __pivot(L, R)]  # Select the pivot element using the __pivot function
	lft = L - 1, rgt = R + 1  # Initialize left and right pointers
	while (1) {
		do {
			lft++  # Increment the left pointer
		} while (__compare(V[lft], md, B, M))  # Move left pointer until an element greater than or equal to pivot is found
		do {
			rgt--  # Decrement the right pointer
		} while(__compare(md, V[rgt], B, M))  # Move right pointer until an element less than or equal to pivot is found
		if (lft >= rgt)  # If pointers cross, partitioning is done
			return rgt  # Return the partition index
		__swap(V, lft, rgt)  # Swap the elements at the left and right pointers
	}
}

# P:	The desired length of the random alphanumeric string.
function entropy(P) 
{
	if (is_integral(P)) {  # Check if P is an integer
		P = int(P)  # Convert P to an integer
		return convert_base(random_str(P, "alnum"), 62, 10)  # Generate a random string, then convert it from base-62 to base-10
	}
}

# V: The array to be sorted.
# L: The starting index of the range to sort.
# R: The ending index of the range to sort.
# B: A flag indicating the comparison direction (1 for greater than, 0 for less than).
# M: A mode indicating the type of comparison (e.g., "length" for length comparison).
function quick_sort(V, L, R, B, M,		md)
{
	if (L < R) {
		md = __hoares_partition(V, L, R, B, M)
		quick_sort(V, L, md, B, M)
		quick_sort(V, md + 1, R, B, M)
	}
}

