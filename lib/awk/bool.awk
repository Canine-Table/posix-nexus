# NOT__: Return the logical NOT of D
function NOT__(D)
{
	return ! D
}

# NULL__: Return the logical NOT of D (same as NOT__)
function NULL__(D)
{
	return NOT__(D)
}

# FULL__: Compare D with an empty string to check if it is full (non-empty)
function FULL__(D)
{
	return CMP__(D, "", "", 1)
}

# TRUE__: Return 1 if D is full (non-empty) or if D is not null and B is false
function TRUE__(D, B)
{
	if (B)
		return FULL__(D)
	else if (NOT__(NULL__(D)))
		return 1
	return 0
}

function IN__(V, D, B)
{
	return D in V && TRUE__(V[D], B)
}

# FALSE__: Return the logical NOT of TRUE__(D, B)
function FALSE__(D, B)
{
	return NOT__(TRUE__(D, B))
}

# OR__: Return true if either B1 or B2 is true based on the condition B3
function OR__(B1, B2, B3)
{
	return TRUE__(B1, B3) || TRUE__(B2, B3)
}

# NOR__: Return the logical NOT of OR__(B1, B2, B3)
function NOR__(B1, B2, B3)
{
	return NOT__(OR__(B1, B2, B3))
}

# ORFT__: Return true if B1 is false or B2 is true based on the condition B3
function ORFT__(B1, B2, B3)
{
	# Return the result of OR__ with the negation of B1 and the truth value of B2
	return OR__(FALSE__(B1, B3), TRUE__(B2, B3))
}

# AND__: Return true if both B1 and B2 are true based on the condition B3
function AND__(B1, B2, B3)
{
	return TRUE__(B1, B3) && TRUE__(B2, B3)
}

# NAND__: Return the logical NOT of AND__(B1, B2, B3)
function NAND__(B1, B2, B3)
{
	return NOT__(AND__(B1, B2, B3))
}

# XOR__: Return true if exactly one of B1 or B2 is true based on the condition B3
function XOR__(B1, B2, B3)
{
	# Return the result of OR__ with the combination of AND__ and AND__
	return OR__(AND__(TRUE__(B1, B3), FALSE__(B2, B3)), 
			AND__(FALSE__(B1, B3), TRUE__(B2, B3)))
}

# XNOR__: Return the logical NOT of XOR__(B1, B2, B3)
function XNOR__(B1, B2, B3)
{
	return NOT__(XOR__(B1, B2, B3))
}

# CMP__: Compare two values (B1 and B2) based on the conditions specified by B3 and B4
function CMP__(B1, B2, B3, B4)
{
	# If B3 is true
	if (B3) {
		# If B4 is true, compare B1 and B2 to see if B1 is greater than B2
		if (B4)
			return B1 > B2
		# If B4 has a length, check if B1 matches the pattern B2
		if (length(B4))
			return B1 ~ B2
		# Otherwise, check if B1 is equal to B2
		return B1 == B2
	# If B3 is not true
	} else if (length(B3)) {
		# If B4 is true, compare the lengths of B1 and B2 to see if the length of B1 is greater than the length of B2
		if (B4)
			return length(B1) > length(B2)
		# If B4 has a length, check if the length of B1 matches the length of B2
		if (length(B4))
			return length(B1) ~ length(B2)
		# Otherwise, check if the lengths are equal
		return length(B1) == length(B2)
	# If B1 and B2 are both integral numbers
	} else if (is_digit(B1, 1) && is_digit(B2, 1)) {
		# If B4 is true, compare the integer values of B1 and B2 to see if B1 is greater than B2
		if (B4)
			return +B1 > +B2
		# If B4 has a length, check if the integer values of B1 match the pattern B2
		if (length(B4))
			return +B1 ~ +B2
		# Otherwise, check if the integer values are equal
		return +B1 == +B2
	# If B1 and B2 are not integral numbers
	} else {
		# If B4 is true, compare the string representations of B1 and B2 to see if B1 is greater than B2
		if (B4)
			return "a" B1 > "a" B2
		# If B4 has a length, check if the string representation of B1 matches the pattern B2
		if (length(B4))
			return "a" B1 ~ "a" B2
		# Otherwise, check if the string representations are equal
		return "a" B1 == "a" B2
	}
}

# NCMP__: Return the logical NOT of CMP__(B1, B2, B3, B4)
function NCMP__(B1, B2, B3, B4)
{
	return NOT__(CMP__(B1, B2, B3, B4))
}

function LOR__(B1, B2, B3, M,	     t)
{
	if (M ~ /^(l(e(n(g(t(h)?)?)?)?)?)$/) 
		t = 0
	else if (M ~ /^(d(e(f(a(u(l(t)?)?)?)?)?)?)$/) 
		t = 1
	if (FULL__(t)) {
		if (B3)
			return GT__(B1, B2, t)
		else
			return LT__(B1, B2, t)
	} else {
		if (! (is_digit(B1, 1) && is_digit(B2, 1)) || M ~ /^(s(t(r(i(n(g)?)?)?)?)?)$/) 
			t = "a"
		if (B3)
			return GT__(t B1, t B2)
		else
			return LT__(t B1, t B2)
	}
}

# EQ__: Return the result of CMP__ (equality comparison) between B1 and B2 based on the condition B3
function EQ__(B1, B2, B3)
{
	return CMP__(B1, B2, B3)
}

# NEQ__: Return the result of NCMP__ (inequality comparison) between B1 and B2 based on the condition B3
function NEQ__(B1, B2, B3)
{
	return NCMP__(B1, B2, B3)
}

# IEQ__: Compare B1 and B2 case-insensitively based on the condition B3
function IEQ__(B1, B2, B3)
{
	return CMP__(tolower(B1), tolower(B2), B3)
}

# INEQ__: Return the logical NOT of IEQ__(B1, B2, B3)
function INEQ__(B1, B2, B3)
{
	return NOT__(IEQ__(B1, B2, B3))
}

# MATCH__: Compare B1 and B2 based on the condition B3, without considering the type of comparison (equality or inequality)
function MATCH__(B1, B2, B3)
{
	return CMP__(B1, B2, B3, 0)
}

# OPPOSE__: Return the logical NOT of CMP__ (equality comparison) between B1 and B2 based on the condition B3
function OPPOSE__(B1, B2)
{
	return NCMP__(B1, B2, B3, 0)
}

# GT__: Return true if B1 is greater than B2 based on the condition B3
function GT__(B1, B2, B3)
{
	return CMP__(B1, B2, B3, 1)
}

# LT__: Return true if B1 is less than B2 based on the condition B3
function LT__(B1, B2, B3)
{
	return NOR__(GT__(B1, B2, B3, 1), EQ__(B1, B2, B3))
}

# LE__: Return true if B1 is less than or equal to B2 based on the condition B3
function LE__(B1, B2, B3)
{
	return NOT__(GT__(B1, B2, B3, 1))
}

# GE__: Return true if B1 is greater than or equal to B2 based on the condition B3
function GE__(B1, B2, B3)
{
	return NOT__(LT__(B1, B2, B3))
}

# EQTT__: Compare the truth values of B1 and B2 based on the condition B3
function EQTT__(B1, B2, B3)
{
	return EQ__(TRUE__(B1, B3), TRUE__(B2, B3))
}

# EQTL__: Compare the truth value of B1 with the full value of B2 based on the condition B3
function EQTL__(B1, B2, B3)
{
	return EQ__(TRUE__(B1, B3), TRUE__(B2, FULL__(B3)))
}

