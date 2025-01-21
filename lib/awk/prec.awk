function nines_compliment(N,	n, sn, v)
{
	if (is_digit(N, 1)) {
		if (sn = __get_sign(N))
			N = substr(N, 2)
		for (i = split(N, v, ""); i > 0; i--) {
			if (v[i] == ".")
				n = "." n
			else
				n = int(9 - v[i]) n
		}
		delete v
		return sn n
	}
}

function tens_compliment(N, n, sn, v)
{
	if (is_digit(N, 1)) {
		if (sn = __get_sign(N))
			N = substr(N, 2)
		for (i = split((N = nines_compliment(N)), v, ""); i > 0; i--) {
			if (v[i] == ".") {
				n = "." n
			} else if (int(v[i] + 1) % 10) {
				n = int(v[i] + 1) n
				break
			} else {
				n = "0" n
			}
		}
		delete v
		if (i)
			n = substr(N, 1, i - 1) n
		else
			n = "1" n
		return sn n
	}
}

function __load_sign_map(V)
{
	V["+"] = 0
	V[""] = V["+"]
	V["-"] = 1
}

function add(N1, N2, B,		f1, f2, v1, v2, sn, sn1, sn2, t, tl, tn, f, fl, n, nl, i, c)
{
	if (is_digit(N1) && is_digit(N2)) {
		if (sn1 = __get_sign(N1))
			N1 = substr(N1, 2)
		if (sn2 = __get_sign(N2))
			N2 = substr(N2, 2)
		if (__return_value(sn1, "+") == __return_value(sn2, "+")) {
			if((substr(sn1 sn2, 1, 1) == "+" || B) && ! (length(B) && B == 0))
				sn = "+"
			if (f1 = __get_half(N1, "."))
				N1 = __get_half(N1, ".", 1)
			if (f2 = __get_half(N2, "."))
				N2 = __get_half(N2, ".", 1)
			if (fl = absolute(length(f1) - length(f2))) {
				t = match_length(f1  "," f2, 1)
				tl = length(t)
			f = substr(t, 1, tl - fl)
				if (t == f1)
					f1 = f
				else
					f2 = f
				f = substr(t, tl - fl + 1)
			}
			split(f1, v1, "")
			for (i = split(f2, v2, ""); i > 0; i--) {
				if ((t = c + v1[i] + v2[i]) > 9) {
					f = int(t % 10) f
					c = 1
				} else {
					f = t f
					c = 0
				}
			}
			if (absolute(length(N1) - length(N2))) {
				tn = match_length(N1  "," N2, 1)
			}
			split(reverse_str(N1), v1, "")
			split(reverse_str(N2), v2, "")
			i = 1
			do {
				if ((t = c + v1[i] + v2[i]) > 9) {
					n = int(t % 10) n
					c = 1
				} else {
					n = t n
					c = 0
				}
				i++
			} while ((length(v1[i]) && length(v2[i])) || c)
			delete v1
			delete v2
			if (f)
				n = n "." f
			return sn tn n
		} else {
			# TODO
			# N1 + -N2
			# -N1 + N2
		}
	}
}

function subtract(N1, N2, B,	f1, f2, t)
{
	if (is_digit(N1, 1) && is_digit(N2, 1)) {
		if (sn1 = __get_sign(N1))
			N1 = substr(N1, 2)
		if (sn2 = __get_sign(N2))
			N2 = substr(N2, 2)
		if (__return_value(sn1, "+") == __return_value(sn2, "+")) {
			# TODO
		}
	}
}

