
function nx_parser(D, S1, S2,	i, lo, l, p, s, t, toks, opts, v1, v2)
{
	if (l = split(D, toks, S1)) {
		__nx_bracket_map(v1)
		S2 = __nx_else(S2, ":")
		l = length(toks[1])
		for (i = 1; i <= l; i++) {
			lo = 0
			if ((s = substr(toks[1], i, 1)) in v1) {
				p = nx_next_pair(toks[1], v1, v2)
				s = v2[p] + v2[p "_" v2[p]]
				e = v2[++p] + v2[p "_" v2[p]]
				i = i + e + s
				s = substr(toks[1], s, v2[p])
				print s
				if (length(s) > 1)
					lo = 1
			}
			if (substr(toks[1], i + 1, 1) != S2) {
				if (s != S2) {
					if (lo)
						larr[s] = ""
					else
						arr[s] = ""
				}
			} else {
				if (lo)
					lkw[s] = ""
				else
					kw[s] = ""
			}
		}
	}
	delete toks
}

#for (i = 1; i <= l; i++) {
#		if (opts[i + 1] != ":") {
#			if (opts[i] != ":")
#				arr[opts[i]] = ""
#		} else {
#			kw[opts[i++]] = ""
#		}
#	}

