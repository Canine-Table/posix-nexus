function valid_address(D)
{
	# Check if the address has exactly 5 colons, dots, or hyphens
	if ((gsub(/:/, ":", D) == 5) || (gsub(/[.]/, ".", D) == 5) || (gsub(/-/, "-", D) == 5)) {
		# Validate address format with regex
		if (D ~ /^([0-9a-zA-Z]{2}((:|[.]|-)[0-9a-zA-Z]{2}){5})$/)
			return D  # Return the address if valid
	}
}

function valid_prefix(D, S, B,		l, i, d, v)
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

function __valid_cidr(D1, D2, B)
{
	c = __get_half(D1, "/")
	if (c ~ /^[0-9]+$/ && D2 ~ /^[46]$/) {
		c = int(c)
		if ((D2 == 4 && c <= 32) || (D2 == 6 && c <= 128)) {
			if (B)
				return "/" c
			return c
	}
}

function expand_ipv6(D,		e, i, cidr, hex, str)
{
	cidr = __valid_cidr(D, 6, 1)
	D = __get_half(D, "/", 1)
	# Ensure there are 8 segments in the address
	for (i = split(D, hex, ":"); i <= 8; i++)
		e = e ":0000"
	# Replace "::" with the appropriate number of ":0000" segments
	sub(/::/, e ":", D)
	# Loop through each segment
	for (i = 1; i <= split(D, hex, ":"); i++) {
		# Construct the result string
		if (i > 1)
			str = str ":"
		# Prepend leading zeros to make each segment 4 characters long
		str = str append(4 - length(hex[i]), "0") hex[i]
	}
	# Clean up
	delete hex
	return str cidr
}

function truncate_ipv6(D,	i, cidr, hex, str)
{
	cidr = __valid_cidr(D, 6, 1)
	D = __get_half(D, "/", 1)
	# Check if the address does not contain "::"
	if (D !~ /::/) {
		# Replace the longest segment of zero(s) with "::"
		sub(/:0+(:0+)+/, "::", D)
	} else {
		gsub(/(:0+)+::(0+:)+/, "::", D)
		gsub(/::0+((:0+)?)+/, "::", D)
		gsub(/(:0+)+::/, "::", D)
	}
	# Ensure no ":::" is present
	sub(/:::/, "::", D)
	for (i = 1; i <= split(a, hex, ":"); i++) {
		# Remove leading zeros in each segment
		if (hex[i] ~ /^0+[^0]+/)
			sub(/^0+/, "", hex[i])
		# Replace a segment of only zeros with a single "0"
		else if (hex[i] ~ /^0+$/)
			sub(/^0+$/, "0", hex[i])
		# Construct the result string
		if (i > 1)
			str = str ":"
		str = str hex[i]
	}
	# Ensure trailing zeros after "::" are correct
	sub(/::0+$/, "::", str)
	sub(/^0+::$/, "::", str)
	return str cidr
}

function valid_ipv6(D, B,	hex, cidr, cnt, i)
{
	if (! (cidr = __valid_cidr(a, 6, 1)) && B)
		return
	D = __get_half(D1, "/", 1)
	# Set initial return value to the input address
	if ((cnt = gsub(/[:]/, ":", D)) > 1 && cnt < 8 && D) {
		# Split the address into segments
		for (i = 1; i <= split(D, hex, ":"); i++) {
			# Validate each segment
			if (hex[i]) {
				# check range
				if (hex[i] !~ /^[0-9a-fA-F]{0,4}$/) {
					delete hex
					return
				}
			}
		}
		# Check for invalid patterns in the address
		if ((D ~ /:::|::.+::/) || (cnt != 7 && D !~ /::/) || (D ~ /:$/ && D !~ /::$/) || (D ~ /^:/ && D !~ /^::/))
			return
		return expand_ipv6(D) cidr
	}
}

function valid_ipv4(D, B,	oct, cidr, i)
{
	if (! (cidr = __valid_cidr(a, 4, 1)) && B)
		return
	D = __get_half(D1, "/", 1)
	# Set initial return value to the input address
	if (gsub(/[.]/, ".", D) == 3 && D) {
		# Split the address into octets
		for (i = 1; i <= split(D, oct, "."); i++) {
			# Validate each octet
			if (oct[i] < 0 || oct[i] > 255 || oct[i] ~ /^0[0-9]+$/ || oct[i] !~ /^[0-9]+$/) {
				delete oct
				return
			}
		}
		# Clean up the oct array
		delete oct
		return D cidr
	}
}

function load_inet_map(D, V)
{
	if (D == 4) {
		V["char"] = "."
		V["tet"] = 8
		V["seg"] = 4
		V["base"] = 10
	} else if (D == 6) {
		V["char"] = ":"
		V["tet"] = 16
		V["seg"] = 8
		V["base"] = 16
	}

}

function inet(D,	fam, cidr, tet, cnt, i, bin, cur, str, arr, inet_map)
{
	# Validate IPv4 or IPv6 address
	if (addr = valid_ipv4(D))
		fam = 4
	else if (addr = valid_ipv6(D))
		fam = 6
	# Validate CIDR notation
	if (cidr = __valid_cidr(D, fam)) {
		# Load appropriate address map
		load_inet_map(fam, inet_map)
		# Split address into segments
		cnt = split(addr, arr, inet_map["char"])
		# Determine the tetra (number of segments covered by CIDR)
		tet = int(cidr / inet_map["tet"]) + 1
		if (tet > inet_map["seg"])
			tet = inet_map["seg"]
		# Adjust segments if necessary
		if (tet < inet_map["seg"]) {
			for (i = inet_map["seg"]; i > tet; i--)
				arr[i] = 0
		}
		# Convert the relevant segment to binary
		cur = arr["tet"]
		bin = convert_base(arr[tet], inet_map["base"], 2)
		bin = append_str(inet_map["tet"] - length(bin), "0") bin
		# Adjust binary length
		if ((bits = cidr % inet_map["tet"]) > 0) {
			bin = substr(bin, 1, bits) append_str(inet_map["tet"] - bits, "0")
		}
		# Convert back to original base
		arr[tet] = convert_base(bin, 2, inet_map["base"])
		# Construct result address
		str = ""
		for (i = 1; i <= inet_map["seg"]; i++) {
			if (i > 1)
				str = str inet_map["char"]
			str = str arr[i]
		}
		# Clean up
		delete arr
		delete inet_map
		# Truncate IPv6 if necessary
		if (fam == 6)
			str = truncate_ipv6(str)
		# Return result address with CIDR
		return str "/" cidr
	}
}

