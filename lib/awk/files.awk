# TODO work in progress
function nextline(r, f) {
	if (fprop["l"] == fprop["o"]) {
		printf("\x1b[1;34m%5s\x1b[0m %s ", "~", borders[9])
	} else {
		fprop["o"] = fprop["l"]
	}
	fprop["c"] = 0
	print r
	if (f)
		return f
}

function foldline(r, f, c,	ln) {
	gsub(/\t/, "        ", f)
	if (r) {
		nextline(r substr(f, 1, (ln = c - 8 - length(r))))
		r = substr(f, ln + 1)
	} else {
		r = f
	}
	if (r > c - 8) {
		do {
			nextline(substr(r, 1, c - 8 - rl))
			r = substr(r, c - 7)
		} while (length(r) > c - 8)
	}
	if (r)
		return r
	else
		return "\n"
}

function tabs(s) {
	return gsub(/\t/, "&", s) * 8
}


function outfile(f, l, c) {
	if (! (f in fls)) {
		cntr++
		if (! fls) {
			borders["suf"] = append(c - 7, borders[10])
			borders["pre"] = append(6, borders[10])
			borders["div"] = append(6, " ") borders[9]
			printf("%s%s%s\n",
			       borders["pre"],
			       borders[11],
			       borders["suf"])
		} else {
			printf("\n%s%s%s",
			       borders["pre"],
			       borders[11],
			       borders["suf"])
		}
		fls[f] = 1
		printf("%s \x1b[1;35m%s \x1b[36m%s\x1b[0m\n%s%s%s\n", 
			  borders["div"],
			  f, append(c - length(f cntr) - 10, " ") cntr,
			  borders["pre"], 
			  borders[11],
			  borders["suf"])
		fprop["l"] = 0
	}
	fprop["l"]++
	if (length(l) + tabs(l) < c - 8) {
		printf("\x1b[1;33m%5s\x1b[0m %s %s\n", fprop["l"], borders[9], l)
	} else {
		printf("\x1b[1;32m%5s\x1b[0m %s ", fprop["l"], borders[9])
		while ((i = index(l, " ")) || (i = index(l, "\t")) || l) {
			if (! (fld = substr(l, 1, i))) {
                        	fld = l
                        	i = length(l)
			}
			l = substr(l, i + 1)
			if (length(fld) + fprop["c"] + (rl = length(fld) + tabs(fld)) < c - 8) {
				rcd = rcd fld
			} else {
				if (rl > c - 8) {
					rcd = foldline(rcd, fld, c)
					fld = ""
				} else {
					rcd = nextline(rcd, fld)
				}
				fprop["c"] = 0
			}
			fprop["c"] += length(fld) + rl
                }
		if (rcd)
			nextline(rcd)
		rcd =  ""
	}
}

