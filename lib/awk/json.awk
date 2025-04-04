function match_start(D, S, B,	i, l, v, m)
{
	l = split(S, v, "")
	for (i = 1; i <= l; i++) {
		if (match(D, ".*([^\\" v[i] "]*)*\\" v[i])) {
			if (RLENGTH < m || ! m)
				m = RLENGTH
		}
	}
	delete v
	if (! m && B)
		return length(D)
	return m
}

function __load_json_objects(V)
{
	V["\x5b"] = "\x5d"
	V["\x5d"] = "\x5b"
	V["\x7b"] = "\x7d"
	V["\x7d"] = "\x7b"
}

function __load_json_pairs(V)
{
	V["\x3a"] = "\x5d"
	V["\x2c"] = "\x2c"
}

function json_parser(D, V,	l, jp, sep, itm)
{
	__load_json_pairs(jp)
	if (l = match_start(D, "[{", 1)) {
		if (l > 1 && substr(D, 1, l - 1) ~ /[ \n\t\v]*/)
			return "unexpected brace: " substr(D, 1, l)
		stack(V, "push", substr(D, l, 1))
		D = substr(D, l + 1)
		if (stack(V, "peek") == "[")
		    return json_array(D, V)
		return json_object(D, V)
	}
}

function __json_object(D, V,	l, n, s, jp, itm, sep)
{
	n = ","
	__load_json_pairs(jp)
	while (l = match_start(D, "{[}]:,", 1)) {
		sep = substr(D, l, 1)
		itm = substr(D, 1, l - 1)

		# TODO
		if (sep == "}") {
			if (stack(V, "pop") != "{")
				return sprintf("unexpected bracket, expected '}' before ']': %s\n", substr(D, 1, l))
			return json_parser(substr(D, l + 1), V)
		} else if (sep == "}") {
			return sprintf("unexpected closing object }")
		if (sep ~ /\[\{/) {
			json_parser(D, V)
		}
	}
}

function __json_array(D, V,	itm, sep, l)
{
	while (l = match_start(D, "{[}],", 1)) {
		sep = substr(D, l, 1)
		itm = substr(D, 1, l - 1)

		# TODO
		if (sep == "]") {
			if (stack(V, "pop") != "[")
				return sprintf("unexpected bracket, expected ']' before '}': %s\n", substr(D, 1, l))
			return json_parser(, V)
		}
		if (sep ~ /\[\{/) {
			json_parser(D, V)
		} else if (sep == "}") {
			return sprintf("unexpected closing object }")
		} else if (sep == ",")
			print substr(D, 1, l - 1)
			D = substr(D, l + 1)
		}
	}
}

