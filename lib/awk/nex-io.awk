#nx_include nex-misc-extras.awk
#nx_include nex-struct-extras.awk
#nx_include nex-int-extras.awk
#nx_include nex-str-extras.awk
#nx_include nex-log-extras.awk

function nx_is_file(D)
{
	if (D == "")
		return 0
	if ((getline < D) > 0)
		close(D)
	else
		return 0
	return 1
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

# [1] == realpath
# [2] == dirname
# [3] == basename
function nx_file_store(V, D1, D2, D3, B,	trk)
{
	if (D1 == "")
		return -1
	if (! (0 in V) || int(V[0]) < 3)
		nx_parr_stk(V, 3)
	D3 = __nx_else(D3, "/")
	trk["rlp"] = nx_file_path(D2 __nx_only(D2, D3) D1, 0)
	trk["orlp"] = nx_file_path(D1, 0)
	trk["bs"] = nx_file_path(D1)
	if (nx_is_file(trk["rlp"])) {
		trk["drp"] = nx_file_path(trk["rlp"], 1)
	} else if (nx_is_file(trk["orlp"])) {
		trk["drp"] = nx_file_path(trk["orlp"], 1)
		trk["rlp"] = trk["orlp"]
	} else {
		for (trk["i"] = 2; trk["i"] <= V[2]; trk["i"] = trk["i"] + 3) {
			trk["rlp"] = nx_file_path(V[trk["i"]] D3 D1, 0)
			if (nx_is_file(trk["rlp"]) && ! (trk["rlp"] in V)) {
				trk["drp"] = nx_file_path(trk["rlp"], 1)
				break
			}
		}
	}
	D1 = -1
	if (trk["drp"] != "") {
		if (! (trk["rlp"] in V)) {
			nx_bijective(V , trk["rlp"], nx_parr_stk(V, 1, trk["rlp"]))
			D1 = 1
		}
		if (! (trk["drp"] in V))
			nx_bijective(V , trk["drp"], nx_parr_stk(V, 2, trk["drp"]))
		if (! (trk["bs"] in V))
			nx_bijective(V , trk["bs"], nx_parr_stk(V, 3, trk["bs"]))
	}
	delete trk
	return D1
}

function __nx_file_merge_push(V, D)
{
	if (D ~ /^[ \t]*$/)
		return -1
	V[V[V["rt"] "0"] = V[V["rt"] "0"] + 1] = D
	V[V["rt"] V[V["rt"] "0"]] = D
	return V["rt"] V[V["rt"] "0"]

}

# D1:		the file name or input stream
# D2:		files to omit if encountered
# D3:		the sigil to identify the include directive
# D4:		the directive name itself
function nx_file_merge(D1, D2, B1, B2, D3, D4,		stk, fls, trk)
{
	if (nx_file_store(fls, D1) != 1)
		return -1
	if (D1 !~ /[.]py$/ && B2)
		trk["trm"] = B2
	else
		trk["trm"] = 0
	B1 = int(B1)

	# the directive name
	trk["dir"] = "nx_" __nx_else(D4, "include", 1)

	# the directive sigil
	trk["sig"] = __nx_else(D3, "#", 1)

	# are there files to omit if founds after the directive??
	if (D2 = nx_trim_split(D3, stk, "<nx:null/>")) {
		do {
			nx_file_store(fls, stk[D2], fls[fls[2]])
		} while (--D2 > 0)
		split("", stk, "")
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
					trk["nr"] = substr(D2, RSTART, RLENGTH)
					D2 = substr(D2, RSTART + RLENGTH)

					# if its a new file
					if (nx_file_store(fls, trk["nr"], fls[fls[2]]) != -1) {
						__nx_file_merge_push(stk, trk["cr"])
						trk[++trk[0]] = fls[fls[1]]
						trk[fls[fls[1]]] = stk["rt"] "" ++stk[stk["rt"] "0"] "."
						if (D2 !~ /^[ \t]*$/)
							__nx_file_merge_push(stk, D2 "\n")
					} else {
						# directive match, but either the arg was not a file or its already been passed
						# add the line without the directive
						__nx_file_merge_push(stk, trk["cr"] "\n")
					}
				} else {
					# directive match, but no file provided, add the cr
					__nx_file_merge_push(stk, trk["cr"] __nx_only(trk["cr"], "\n"))
				}
			} else {
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
	delete fls
	nx_dfs(stk) # flattens the dfs stack into indexes
	for (D2 = 1; D2 <= stk[0]; D2++) {
		# the sigil should really be the comment inn the language you're using
		if (stk[stk[D2]] !~ "^[ \t\n\v\f\r]*(" trk["sig"] "|$)") {
			if (trk["trm"] != 0) {
				sub("[ \t\n\v\f\r]+" trk["sig"] ".*$", stk[stk[D2]])
				printf("%s", nx_trim_str(stk[stk[D2]], trk["trm"]))
			} else {
				printf("%s", stk[stk[D2]])
			}
		}
	}
	delete trk
	delete stk
}

