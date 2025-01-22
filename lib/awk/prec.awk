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

function subtract(N1, N2, B,	f1, f2, t, tl, sn)
{
	if (is_digit(N1, 1) && is_digit(N2, 1)) {
		if (sn1 = __get_sign(N1))
			N1 = substr(N1, 2)
		if (sn2 = __get_sign(N2))
			N2 = substr(N2, 2)
		if (XNOR__(sn1 == "-", __return_value(sn2, "+") != "-"))
			return sn1 add_base(N1, N2)

		# TODO
		if (__return_value(sn1, "+") == __return_value(sn2, "+")) {
			if (sn1 == "-")
				sn = "-"
			else 
				sn = substr(sn1 sn2, 1, 1)
			N1 = convert_base(N1, 10, 2)
			N2 = convert_base(N2, 10, 2)
			if ((tl = length(N1) - length(N2)) > 0) {
				N2 = append_str(tl, "0") N2
			} else if (tl) {
				t = append_str(absolute(tl), "0") N1
				N1 = N2
				N2 = t
				if (sn != "-")
					sn = "-"
				else
					sn = substr(sn1 sn2, 1, 1)
			}
			t = append_str(length(N1) % 4, "0")
			N2 = twos_compliment(t N2)
		}
	}
}

