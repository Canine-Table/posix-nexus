function valid_address(D)
{
        # Check if the address has exactly 5 colons, dots, or hyphens
        if ((gsub(/:/, ":", D) == 5) || (gsub(/[.]/, ".", D) == 5) || (gsub(/-/, "-", D) == 5)) {
                # Validate address format with regex
                if (D ~ /^([0-9a-zA-Z]{2}((:|[.]|-)[0-9a-zA-Z]{2}){5})$/)
                        return D  # Return the address if valid
        }
}

function valid_prefix(D, S, B,          l, i, d, v)
{
        # Check if the separator is not valid, default to ":"
        if (S !~ /^(:|[.]|-)$/)
                S = ":"
        # Remove all occurrences of colons, dots, or hyphens from the address
        gsub(/:|[.]|-/, "", D)
        # Add random string to make the length of D equal to 12 characters if shorter
        if (l = 12 - length(D))
                D = D random_str(l, "xdigit")
        # Join characters into pairs separated by S
        for (i = 2; i <= split(D, v, ""); i += 2)
                d = __join_str(d, v[i - 1] v[i], S)
        delete v
        # Convert to uppercase if B is provided and truthy, otherwise convert to lowercase
        if (B)
                d = toupper(d)
        else if (length(B))
                d = tolower(d)
        # Validate and return the modified address
        return valid_address(d)
}

function l2_type(D,	d, m, x)
{
	if (valid_address(D)) {
		# RFC 7042
		d = convert_base(substr(D, 2, 1), 16, 2)
		d = append_str(4 - length(D), "0") d
		m = substr(d, 2, 1)
		x = substr(d, 4, 1)
		if (m == "1")
			d = "univers"
		else
			d = "loc"
		d = d "ally administered "
		if (x == "1")
			d = d "multi"
		else
			d = d "uni"
		return D " is a " d "cast address"
	}
}

