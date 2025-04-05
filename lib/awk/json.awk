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

function json_object_parser(D, V, jp, l)
{
	sep = ","
	__load_json_objects(jp)
	#print D
	#gsub(/\\/, "\\\\", D)
	if (l = first_index(D, ":", 1)) {
		#if (l > 1 && substr(D, 1, l - 1) ~ /[ \n\t\v]*/)
		print substr(D, 1, l - 1)
	}
}

#function __json_object(D, V,	l, n, s, jp, itm, sep)
#{
#	n = ","
#	__load_json_pairs(jp)
#	while (l = match_start(D, "{[}]:,", 1)) {
#		sep = substr(D, l, 1)
#		itm = substr(D, 1, l - 1)
#
#		# TODO
#		if (sep == "}") {
#			if (stack(V, "pop") != "{")
#				return sprintf("unexpected bracket, expected '}' before ']': %s\n", substr(D, 1, l))
#			return json_parser(substr(D, l + 1), V)
#		} else if (sep == "}") {
#			return sprintf("unexpected closing object }")
#		}
#		if (sep ~ /\[\{/) {
#			json_parser(D, V)
#		}
#	}
#}

#function __json_array(D, V,	itm, sep, l)
#{
#	while (l = match_start(D, "{[}],", 1)) {
#		sep = substr(D, l, 1)
#		itm = substr(D, 1, l - 1)
#
#		# TODO
#		if (sep == "]") {
#			if (stack(V, "pop") != "[")
#				return sprintf("unexpected bracket, expected ']' before '}': %s\n", substr(D, 1, l))
#			return json_parser(D, V)
#		}
#		if (sep ~ /\[\{/) {
#			json_parser(D, V)
#		} else if (sep == "}") {
#			return sprintf("unexpected closing object }")
#		} else if (sep == ",")
#			print substr(D, 1, l - 1)
#			D = substr(D, l + 1)
#		}
#	}
#}

