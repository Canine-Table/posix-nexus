# Check if the number N is signed (has a + or - prefix)
function __is_signed(N)
{
        return N ~ /^([-]|[+])/
}

# Get the sign of the number N (if it is signed)
function __get_sign(N)
{
        if (__is_signed(N)) {
                return substr(N, 1, 1)
        }
}

# Check if N is an integral number (integer without a decimal point)
function is_integral(N, B,      e)
{
        if ((B && N ~ /^([-]|[+])?[0-9]+$/) || (! B && N ~ /^[0-9]+$/))
                e = 1
        return e
}

# Check if N is a signed integral number (integer with a + or - prefix)
function is_signed_integral(N,          e)
{
        if (__is_signed(N) && is_integral(N, 1))
                e = 1
        return e
}

# Check if N is a floating-point number (decimal number)
function is_float(N, B,         e)
{
        if ((B && N ~ /^([-]|[+])?[0-9]+[.][0-9]+/) || (! B && N ~ /^[0-9]+[.][0-9]+/))
                e = 1
        return e
}

# Check if N is a signed floating-point number (decimal number with a + or - prefix)
function is_signed_float(N,             e)
{
        if (__is_signed(N) && is_float(N, 1))
                e = 1
        return e
}

# Check if N is a digit (integral or floating-point number)
function is_digit(N, B,         e)
{
        if (is_integral(N, B) || is_float(N, B))
                e = 1
        return e
}

# Check if N is a signed digit (integral or floating-point number with a + or - prefix)
function is_signed_digit(N,     e)
{
        if (__is_signed(N) && is_digit(N, 1))
                e = 1
        return e
}

