function NOT__(D)
{
	return ! D
}

function NULL__(D)
{
	return D == 0 || D == ""
}

function FULL__(D)
{
	return length(D) > 0
}

function TRUE__(D, B)
{
        if (B)
                return FULL__(D)
        else if (NOT__(NULL__(D)))
                return 1
        return 0
}

function FALSE__(D, B)
{
	return NOT__(TRUE__(D, B))
}

function OR__(B1, B2, B3)
{
	return TRUE__(B1, B3) || TRUE__(B2, B3)
}

function NOR__(B1, B2, B3)
{
	return NOT__(OR__(B1, B2, B3))
}

function ORFT__(B1, B2, B3)
{
	return OR__(FALSE__(B1, B3), TRUE__(B2, B3))
}

function AND__(B1, B2, B3)
{
	return TRUE__(B1, B3) && TRUE__(B2, B3)
}

function NAND__(B1, B2, B3)
{
	return NOT__(AND__(B1, B2, B3))
}

function XOR__(B1, B2, B3)
{
	return OR__(AND__(TRUE__(B1, B3),
				FALSE__(B2, B3)), 
			AND__(FALSE__(B1, B3), 
				TRUE__(B2, B3)))
}

function XNOR__(B1, B2, B3)
{
	return NOT__(XOR__(B1, B2, B3))
}

function CMP__(B1, B2, B3, B4)
{
	if (B3) {
		if (B4 == 1)
			return B1 > B2
		if (B4 == "0")
			return B1 ~ B2
		return B1 == B2
	} else if (AND__(is_integral(B1), is_integral(B2))) {
		if (B4 == 1)
			return +B1 > +B2
		if (B4 == "0")
			return +B1 ~ +B2
		return +B1 == +B2
	} else {
		if (B4 == 1)
			return "a" B1 > "a" B2
		if (B4 == "0")
			return "a" B1 ~ "a" B2
		return "a" B1 == "a" B2
	}
}

function EQ__(B1, B2, B3)
{
	return CMP__(B1, B2, B3)
}

function NEQ__(B1, B2, B3)
{
	return NOT__(CMP__(B1, B2, B3))
}

function IEQ__(B1, B2, B3)
{
	return CMP__(tolower(B1), tolower(B2), B3)
}

function INEQ__(B1, B2, B3)
{
	return NOT__(IEQ__(B1, B2, B3))
}

function MATCH__(B1, B2, B3)
{
	return CMP__(B1, B2, B3, 0)
}

function OPPOSE__(B1, B2)
{
	return NOT__(CMP__(B1, B2, B3, 0))
}

function GT__(B1, B2, B3)
{
	return CMP__(B1, B2, B3, 1)
}

function LT__(B1, B2, B3)
{
	return NOR__(GT__(B1, B2, B3, 1),
	       EQ__(B1, B2, B3))
}

function LE__(B1, B2, B3)
{
	return NOT__(GT__(B1, B2, B3, 1))
}

function GE__(B1, B2, B3)
{
	return NOT__(LT__(B1, B2, B3))
}

function EQTT__(B1, B2, B3)
{
	return EQ__(TRUE__(B1, B3), TRUE__(B2, B3))
}


function EQTL__(B1, B2, B3)
{
	return EQ__(TRUE__(B1, B3), TRUE__(B2, FULL__(B3)))
}

