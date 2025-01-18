function load_borders(t, s, l,	bdrs) {
	if (! t)
		t = "*"
	if (! s)
		s = ","
	if (t == "single")
		bdrs = "┌" s "┐" s "└" s "┘" s "├" s " ┬" s "┤" s "┴" s "│" s "─" s "┼"
	else if (t == "double")
		bdrs = "╔" s "╗" s "╚" s "╝" s "╠" s "╦" s "╣" s "╩" s "║" s "═" s "╬"
	else
		bdrs = get_custom_borders(t, s)
	split(bdrs, borders, " *" s " *")
	if (int(l) > 2 && int(l) == l) {
		bdrs = append(l - 2, borders[10])
		borders["start"] = borders[9]
		borders["end"] = borders[9]
		borders["div"] = borders["start"] " " append(l - 4, borders[10]) " " borders["end"]
		borders["top"] = borders[1] bdrs borders[2]
		borders["center"] = borders[5] bdrs borders[7]
		borders["bottom"] = borders[3] bdrs borders[4]
	}
}

function get_custom_borders(i, s,	arr, str) {
	if (! s)
		s = ","
	cnt = split(i, arr, " *" s " *")
	for (i = 0; i < 11; i++) {
		if (i)
			str = str s
		str = str arr[((i % cnt) + 1)]
	}
	delete arr
	return str
}

function fold(f, c, n,	fld, cmn) {
	if ((cmn = int(c - n)) > 0) {
		do {
			if (length(f) > cmn) {
				fld = substr(f, 1, cmn)
				f = substr(f, cmn + 1)
				print outline(fld)
			} else {
				fld = f
				f = ""
			}
		} while (f)
		return fld
	}
}

function outline(s) {
	return borders["start"] s borders["end"]
}

function divider(r, f, c, 	st) {
	if (int(c) > 2 && int(c) == c && match(f, /<\{div\}>/)) {
		st = borders["start"]
		gsub(/[0-9]+/, " ", borders["start"])
		do {
			r = r substr(f, 1, RSTART - 1)
			if (r)
				print outline(r append(c - length(r), " "))
			f = substr(f, RSTART + RLENGTH)
			r = ""
			print borders["div"]
		} while (match(f, /<\{div\}>/))
		borders["start"] = st
	}
	return r f
}

function wrap(r, c, n,		ed, rcd, fld, i) {
	if ("div" in borders)
		c = c - 2
	if ((c = floor(c)) < 2)
		return
	if (! (n = round(n)) || n >= c - 1)
		n = 0
	gsub(/\x1b\[[0-9]+((;[0-9]*)+)?m/, "", r)
	gsub(/\t/, "        ", r)
	rcd = ""
	while ((i = index(r, " ")) || r) {
		if (! (fld = substr(r, 1, i))) {
			fld = r
			i = length(r)
		}
		r = substr(r, i + 1)
		if ((length(rcd fld) < c - n)) {
			if (fld ~ /<\{div\}>/ && "div" in borders) {
				rcd = divider(rcd, fld, c - n)
			} else {
				rcd = rcd fld
			}
		} else {
			print outline(rcd append(c - n - length(rcd), " "))
			if (fld < c - n) {
				rcd = fld
			} else {
				rcd = fold(fld, c, n, s)
			}
		}
	}
	if (rcd)
		print outline(rcd append(c - n - length(rcd), " "))
}

