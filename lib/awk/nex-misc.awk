#nx_include "nex-struct.awk"
#nx_include "nex-str.awk"
#nx_include "nex-math.awk"

function nx_to_environ(D,	m)
{
	D = toupper(nx_trim_str(D))
	gsub(/[ \t]/, "_", D)
	if (! (m = sub(/^[.]/, "L_", D)))
	if (! (m = sub(/^[*]/, "G_", D)))
	if (! (m = sub(/^[@]/, "NEXUS_", D)))
	if (! (m = sub(/^[%]/, "P_", D)))
		sub(/^[0-9]/, "_\\&", D)
	gsub(/[^0-9A-Z_]/, "", D)
	return D
}

function nx_is_file(D)
{
	if ((getline < D) > 0)
		close(D)
	else
		return 0
	return 1
}

function nx_is_space(D)
{
	return D ~ /[ \t\n\f\r\v\b]/
}

function nx_is_upper(D)
{
	return D ~ /[A-Z]/
}

function nx_is_lower(D)
{
	return D ~ /[a-z]/
}

function nx_is_alpha(D)
{
	return nx_is_lower(D) || nx_is_upper(D)
}

function nx_is_digit(D)
{
	return D ~ /[0-9]/
}

function __nx_num_map(V,  i)
{
	for (i = 0; i < 10; i++)
		V[i] = i
}

function __nx_lower_map(V,	i)
{
	__nx_num_map(V)
	for (i = 10; i < 36; i++)
		nx_bijective(V, i, sprintf("%c", i + 87))
}

function __nx_upper_map(V,	i)
{
	__nx_lower_map(V)
	for (i = 36; i < 62; i++)
		nx_bijective(V, i, sprintf("%c", i + 29))
}

function __nx_quote_map(V, B1, B2, B3)
{
	if (B1) {
		if (B1 > 1)
			V["\x22\x22"] = "NX_DOUBLE_STRING"
		V["\x22"] = "\x22"
	}
	if (B2) {
		if (B2 > 1)
			V["\x27\x27"] = "NX_SINGLE_STRING"
		V["\x27"] = "\x27"
	}
	if (B3) {
		if (B3 > 1)
			V["\x60\x60"] = "NX_TICK_STRING"
		V["\x60"] = "\x60"
	}
}

function __nx_bracket_map(V, B1, B2, B3, B4)
{
	if (B1) {
		if (B1 > 1) {
			V["\x5b\x5d"] = "NX_RBRACKET"
			V["\x5d\x5b"] = "NX_LBRACKET"
		}
		nx_bijective(V, "\x5b", "\x5d")
	}
	if (B2) {
		if (B2 > 1) {
			V["\x7b\x7d"] = "NX_RBRACE"
			V["\x7d\x7b"] = "NX_LBRACE"
		}
		nx_bijective(V, "\x7b", "\x7d")
	}
	if (B3) {
		if (B3 > 1) {
			V["\x29\x28"] = "NX_LPARENTHESES"
			V["\x28\x29"] = "NX_RPARENTHESES"
		}
		nx_bijective(V, "\x28", "\x29")
	}
	if (B4) {
		if (B4 > 1) {
			V["\x3e\x3c"] = "NX_XML_LTAG"
			V["\x2f\x3e"] = "NX_XML_STAG"
			V["\x3c\x3e"] = "NX_XML_RTAG"
		}
		nx_bijective(V, "\x3c", "\x3e")
	}
}

function __nx_str_map(V)
{
	nx_bijective(V, ++V[0], "upper", "A-Z")
	nx_bijective(V, ++V[0], "lower", "a-z")
	nx_bijective(V, ++V[0], "xupper", "A-F")
	nx_bijective(V, ++V[0], "xlower", "a-f")
	nx_bijective(V, ++V[0], "digit", "0-9")
	nx_bijective(V, ++V[0], "alpha", V["upper"] V["lower"])
	nx_bijective(V, ++V[0], "xdigit", V["digit"] V["xupper"] V["xlower"])
	nx_bijective(V, ++V[0], "alnum", V["digit"] V["alpha"])
	nx_bijective(V, ++V[0], "print", "\x20-\x7e")
	nx_bijective(V, ++V[0], "punct", "\x21-\x2f\x3a-\x40\x5b-\x60\x7b-\x7e")
}

function __nx_escape_map(V)
{
	V["\x20"] = ""
	V["\x09"] = ""
	V["\x0a"] = ""
	V["\x0b"] = ""
	V["\x0c"] = ""
}

function nx_boolean(V, D)
{
	if (V[D] == "<nx:true/>")
		V[D] = "<nx:false/>"
	else if (V[D] == "" || V[D] == "<nx:false/>")
		V[D] = "<nx:true/>"
}

function __nx_defined(D, B)
{
	return (D || (length(D) && B))
}

function __nx_else(D1, D2, B)
{
	if (D1 || __nx_defined(D1, B))
		return D1
	return D2
}

function __nx_if(B1, D1, D2, B2)
{
	if (B1 || __nx_defined(B1, B2))
		return D1
	return D2
}

function __nx_elif(B1, B2, B3, B4, B5, B6)
{
	if (B4) {
		B5 = __nx_else(B5, B4)
		B6 = __nx_else(B6, B5)
	}
	return (__nx_defined(B1, B4) == __nx_defined(B2, B5) && __nx_defined(B3, B6) != __nx_defined(B1, B4))
}

function __nx_or(B1, B2, B3, B4, B5, B6)
{
	if (B4) {
		B5 = __nx_else(B5, B4)
		B6 = __nx_else(B6, B5)
	}
	return ((__nx_defined(B1, B4) && __nx_defined(B2, B5)) || (__nx_defined(B3, B6) && ! __nx_defined(B1, B4)))
}

function __nx_xor(B1, B2, B3, B4)
{
	if (B3)
		B4 = __nx_else(B4, B3)
	return ((! __nx_defined(B2, B4) && __nx_defined(B1, B3)) || (__nx_defined(B2, B4) && ! __nx_defined(B1, B3)))
}

function __nx_compare(B1, B2, B3, B4)
{
	if (! B3) {
		if (length(B3)) {
			B1 = length(B1)
			B2 = length(B2)
		} else if (nx_digit(B1, 1) && nx_digit(B2, 1)) {
			B1 = +B1
			B2 = +B2
		} else {
			B1 = "a" B1
			B2 = "a" B2
		}
		B3 = 1
	}
	if (B4)
		return __nx_if(nx_digit(B4), B1 > B2, B1 < B2) || __nx_if(__nx_else(nx_digit(B4) == 1, tolower(B4) == "i"), B1 == B2, 0)
	if (length(B4))
		return B1 ~ B2
	return B1 == B2
}

function __nx_equality(B1, B2, B3,	b, e, g)
{
	b = substr(B2, 1, 1)
	if (b == ">") {
		e = 2
		g = 1
	} else if (b == "<") {
		e = "a"
		g = "i"
	} else if (b == "=") {
		e = ""
	} else if (b == "~") {
		e = 0
	} else {
		b = ""
	}
	if (b) {
		if (__nx_compare(substr(B2, 2, 1), "=", 1)) {
			b = g
		} else {
			b = e
		}
		e = substr(B2, length(B2), 1)
		if (__nx_compare(e, "a", 1))
			return __nx_compare(B1, B3, "", b)
		else if (__nx_compare(e, "_", 1))
			return __nx_compare(B1, B3, 0, b)
		else
			return __nx_compare(B1, B3, 1, b)
	}
	return __nx_compare(B1, B2)
}

function __nx_swap(V, D1, D2,	t)
{
	t = V[D1]
	V[D1] = V[D2]
	V[D2] = t
}


# D1:		the file path
# B:		the boolean toggle:
# 			empty or 0 as an int:	basename
# 			something:		dirname
# D2:		path sep, defaults to /
function nx_file_path(D1, B, D2,	i, j)
{
	D2 = __nx_else(D2, "/")
	if (! sub(/^-/, ENVIRON["OLDPWD"], D1))
	if (! sub(/^~/, ENVIRON["HOME"], D1))
	if (! sub(/^NX_L:/, ENVIRON["NEXUS_LIB"], D1))
	if (! sub(/^NX_C:/, ENVIRON["NEXUS_CNF"], D1))
	if (! sub(/^NX_D:/, ENVIRON["NEXUS_DOCS"], D1))
	if (! sub(/^NX_E:/, ENVIRON["NEXUS_ENV"], D1))
	if (! sub(/^NX_SB:/, ENVIRON["NEXUS_SBIN"], D1))
	if (! sub(/^NX_B:/, ENVIRON["NEXUS_BIN"], D1))
	if (! sub(/^NX_J:/, ENVIRON["NEXUS_LIB"] "java" D2 ENVIRON["G_NEX_JAVA_PROJECT"], D1))
		sub(/^NX_S:/, ENVIRON["NEXUS_SRC"], D1)
	gsub(D2 "+", D2, D1)
	gsub(D2 "+$", "", D1)
	i = D1
	if (! sub("[^" D2 "]+$", "", i))
		return D1
	i = length(i)
	j = length(D2)
	if (B == "")
		return substr(D1, i + j)
	if (B == 0)
		return D1
	return substr(D1, 1, i - j)
}

# D1:		the relative or absolute file path
# D2:		the absolute path of the directory the file path is in if its not an absolute path
# V:		the actual hashmap that holds the valid unique file names/paths
# D3:		path sep, defaults to /

# indexes
# [-0] = all the absolute unique directory paths
# [0] = all the absolute realpaths to the file
function nx_uniq_file(D1, D2, V, D3,	b, r, d, i)
{
	b = nx_file_path(D1)
	D3 = __nx_else(D3, "/")
	r = nx_file_path( D2 D3 D1, 0)
	if (nx_is_file(r)) {
		d = nx_file_path(r, 1)
	} else if (nx_is_file(D1)) {
		r = D1
		d = nx_file_path(D1, 1)
	} else {
		for (i = -1; i >= V["-0"]; --i) {
			r = nx_file_path(V[i] D3 b, 0)
			if (nx_is_file(r)) {
				d = nx_file_path(r, 1)
				break
			}
		}
	}
	if (d == "")
		return -1
	if (! (d in V))
		nx_bijective(V , "" --V["-0"], d)
	if (! (r in V))
		nx_bijective(V , "" ++V[0], r)
	return 1
}

function nx_sub_counter(D1, D2)
{
	return gsub(D2, "", D1)
}

function nx_nesc_match(D1, D2, B, D3,	f, l, t, i)
{
	if (D1 == "")
		return -1
	f = 0
	D2 = __nx_else(D2, " ")
	if ((D3 = __nx_else(D3, "\\\\", 1)) == "\\\\")
		l = 1
	else
		l = length(D3)
	while (match(D1, D2)) {
		f = f + RSTART
		if (! (match(substr(D1, 1, RSTART - 1), D3 "+$") && D3) || int(RLENGTH % 2) == 0)
			break
		i = nx_sub_counter(substr(D1, 1, f - 1), D3)
		f = f + RLENGTH - i * l
		D1 = substr(D1, f + 1)
	}
	i = nx_sub_counter(substr(D1, 1, f - 1), D3)
	return __nx_if(B && D1 == "", -1, f - i * l)
}

function nx_find_next(D1, V, B1, B2, D2,	i, f, m)
{
	if (D1 == "")
		return -1
	B = __nx_if(B, ">0", "<0")
	for (i in V) {
		m = nx_nesc_match(D1, V[i], D2)
		if (! f || __nx_equality(m, B, f))
			f = m
	}

	if (f == length(D1))
		return __nx_if(B2, -1, f)
	return __nx_if(B1 == ">0", f + 1, f)
}

function __nx_file_merge_push(V, D)
{
	if (D ~ /^[ \t]*$/)
		return -1
	V[__nx_file_merge_rt(V, 1)] = D
	return __nx_file_merge_rt(V)
}

function __nx_file_merge_rt(V, N)
{
	if (N = int(N))
		V[V["rt"] "0"] = V[V["rt"] "0"] + N
	return V["rt"] V[V["rt"] "0"]
}

# D1:		the file name or input stream
# D2:		the sigil to identify the include directive
# D3:		files to omit if encountered
# D4:		the directive name itself
function nx_file_merge(D1, D2, D3, D4,	stk, fls, trk)
{
	if (nx_uniq_file(D1, "", fls) != 1)
		return -1

	D4 = __nx_else(D4, "include", 1)

	# the directive name
	trk["dir"] = "nx_" D4

	# the directive sigil
	trk["sig"] = __nx_else(D2, "#", 1)

	# are there files to omit if founds after the directive??
	if (D2 = nx_trim_split(D3, stk, "<nx:null/>")) {
		do {
			nx_uniq_file(que[D2], fls[fls["-0"]], fls)
		} while (--D2 > 0)
		split("", trk, "")
	}

	stk["rt"] = "."

	do {
		while ((getline D2 < D1) > 0) {
			# if the directive is at the start of the line
			# or it within a line and has white space at both ends
			if (D2 ~ "([ \t]+|^)" trk["sig"] trk["dir"] && match(D2, trk["sig"] trk["dir"] "[ \t]+")) {
				# from the start up to before the sigil
				trk["cr"] = substr(D2, 1, RSTART - 1)

				# after the directive
				D2 = substr(D2, RSTART + RLENGTH)

				# if the directive isnt NF
				if (match(D2, /^[^ \t]+/)) {
					# if its a new file
					if (nx_uniq_file(substr(D2, RSTART, RLENGTH), fls[fls["-0"]], fls) != -1) {
						__nx_file_merge_push(stk, trk["cr"])
						trk[++trk[0]] = fls[fls[0]]
						trk[fls[fls[0]]] = stk["rt"] "" ++stk[stk["rt"] "0"] "."
						if ((trk["cr"] = substr(D2, RSTART + RLENGTH)) !~ /^[ \t]*$/)
							trk["cr"] = trk["cr"] "\n"
						__nx_file_merge_push(stk,  trk["cr"])
					} else {
						# directive match, but either the arg was not a file or its already been passed
						# add the line without the directive
						__nx_file_merge_push(stk, trk["cr"] substr(D2, RSTART + RLENGTH) "\n")
					}
				} else if (trk["cr"] !~ /^[ \t]*$/) {
					# directive match, but no file provided, add the cr
					__nx_file_merge_push(stk, trk["cr"] "\n")
				}
			} else if (D2 !~ /^[ \t]*$/) {
				# no directive match, add the line
				__nx_file_merge_push(stk, D2 "\n")
			}
		}
		close(D1)

		# if its a file
		D1 = trk[trk[0]]
		# the root
		stk["rt"] = trk[trk[trk[0]]]
	} while (trk[0]-- > 0)
	delete trk
	delete fls
	nx_dfs(stk)
	for (D2 = 1; D2 <= stk[0]; D2++)
		printf(stk[stk[D2]])
	delete stk
}

