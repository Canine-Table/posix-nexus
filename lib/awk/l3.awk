function __valid_cidr(c, f, s,	i) {
	if (i = index(c, "/"))
		c = substr(c, i + 1)
	if (c ~ /^[0-9]+$/ && f ~ /^[46]$/) {
		c = int(c)
		if ((f == 4 && c <= 32) || (f == 6 && c <= 128)) {
			if (s)
				c = "/" c
			return c
		}
	}
}

function __network(a,	i) {
	if (i = index(a, "/"))
		a = substr(a, 1, i - 1)
	return a
}

function valid_ipv4(a, r,		oct, cidr, rtn, i) {
	if (! (cidr = __valid_cidr(a, 4, 1)) && r)
		return
	a = __network(a)
	# Set initial return value to the input address
	if (gsub(/[.]/, ".", a) == 3 && (rtn = a)) {
		# Split the address into octets
		for (i = 1; i <= split(a, oct, "."); i++) {
			# Validate each octet
			if (oct[i] < 0 || oct[i] > 255 || oct[i] ~ /^0[0-9]+$/ || oct[i] !~ /^[0-9]+$/) {
				rtn = 0
				break
	    		}
		}
		# Clean up the oct array
		delete oct
		if (rtn) {
			rtn = rtn cidr
			# Return the validation result
		}
	}
	return rtn
}

function valid_ipv6(a, r,		hex, cidr, cnt, rtn, i) {
	if (! (cidr = __valid_cidr(a, 6, 1)) && r)
		return
	a = __network(a)
	# Set initial return value to the input address
	if ((cnt = gsub(/[:]/, ":", a)) > 1 && cnt < 8 && (rtn = a)) {
		# Split the address into segments
		for (i = 1; i <= split(a, hex, ":"); i++) {
	    		# Validate each segment
			if (hex[i]) {
				# check range
				if (hex[i] !~ /^[0-9a-fA-F]{0,4}$/) {
					rtn = 0
					break
				}
			}
		}
		# Clean up the hex array
		delete hex
		# Check for invalid patterns in the address
		if ((a ~ /:::|::.+::/) || 
		     (cnt != 7 && a !~ /::/) || 
		     (a ~ /:$/ && a !~ /::$/) || 
		     (a ~ /^:/ && a !~ /^::/))
			rtn = 0
		else if (rtn) {
			rtn = expand_ipv6(rtn)
			if (cidr)
				rtn = rtn cidr
		}
	}
	# Return the validation result
	return rtn
}

function load_inet_map(f) {
	if (f == 4) {
		inet_map["char"] = "."
		inet_map["tet"] = 8
		inet_map["seg"] = 4
		inet_map["base"] = 10
	} else if (f == 6) {
		inet_map["char"] = ":"
		inet_map["tet"] = 16
		inet_map["seg"] = 8
		inet_map["base"] = 16
	}
}

function inet(a,	fam, cidr, tet, cnt, i, bin, cur, str, arr) {
	# Validate IPv4 or IPv6 address
	if (addr = valid_ipv4(a))
		fam = 4
	else if (addr = valid_ipv6(a))
		fam = 6
	# Validate CIDR notation
	if (cidr = __valid_cidr(a, fam)) {
		# Load appropriate address map
		load_inet_map(fam)
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
		bin = convert(arr[tet], inet_map["base"], 2)
		bin = append(inet_map["tet"] - length(bin), "0") bin
		# Adjust binary length
		if ((bits = cidr % inet_map["tet"]) > 0) {
			bin = substr(bin, 1, bits) append(inet_map["tet"] - bits, "0")
		}
		# Convert back to original base
		arr[tet] = convert(bin, 2, inet_map["base"])
		# Apply subnet rules
		if (! (subnet_rules(cur, arr[tet], cidr, fam)))
			return
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

function subnet_rules(t, s, c, f,	rtn) {
	# TODO
	rtn = 1
	if (t == s)
		rtn = 0
	return rtn
}

function expand_ipv6(a,		e, i, cidr, hex, str) {
	cidr = __valid_cidr(a, 6, 1)
	a = __network(a)
	# Ensure there are 8 segments in the address
	for (i = split(a, hex, ":"); i <= 8; i++)
		e = e ":0000"
	# Replace "::" with the appropriate number of ":0000" segments
	sub(/::/, e ":", a)
	# Loop through each segment
	for (i = 1; i <= split(a, hex, ":"); i++) {
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

function truncate_ipv6(a,	i, cidr, hex, str) {
	cidr = __valid_cidr(a, 6, 1)
	a = __network(a)
	# Check if the address does not contain "::"
	if (a !~ /::/) {
		# Replace the longest segment of zero(s) with "::"
		sub(/:0+(:0+)+/, "::", a)
	} else {
		gsub(/(:0+)+::(0+:)+/, "::", a)
		gsub(/::0+((:0+)?)+/, "::", a)
		gsub(/(:0+)+::/, "::", a)
	}
	# Ensure no ":::" is present
	sub(/:::/, "::", a)
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

