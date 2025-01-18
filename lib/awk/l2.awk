function valid_address(a) {
	if ((gsub(/:/, ":", a) == 5) || (gsub(/[.]/, ".", a) == 5) || (gsub(/-/, "-", a) == 5))
		if (a ~ /^([0-9a-zA-Z]{2}((:|[.]|-)[0-9a-zA-Z]{2}){5})$/)
			return a
}

function valid_prefix(a, s, m, x,	l, str) {
	if (s !~ /^(:|[.]|-)$/)
		s = ":"
	gsub(/:|[.]|-/, "", a)
	if (l = 12 - length(a))
		a = a generate_string(l, "xdigit")
	for (i = 1; i <= 12; i += 2) {
		if (str)
			str = str s
		str = str substr(a, i, 2)
	}
	return l2_assign(str, m, x)
}

function eui64(a,	flp, i) {
	if (valid_address(a)) {
		a = l2_assign(a, "flip")
		gsub(/[^a-zA-Z0-9]/, "", a)
		a = substr(a, 1, 6) "fffe" substr(a, 7)
		flp = ""
		for (i = 1; i <= 16; i += 4) {
			if (flp)
				flp = flp ":"
			flp = flp substr(a, i, 4)
		}
		return flp
	}
}

function l2_type(a,	b, m, x, str) {
	if (valid_address(a)) {
		# RFC 7042
		b = convert(substr(a, 2, 1), 16, 2)
		b = append(4 - length(b), "0") b
		m = substr(b, 2, 1)
		x = substr(b, 4, 1)
		if (m == "1")
			str = "univers"
		else
			str = "loc"
		str = str "ally administered "
		if (x == "1")
			str = str "multi"
		else
			str = str "uni"
		return a " is a " str "cast address"
	}
}

function l2_assign(a, m, x,	b, l2_map) {
	if (valid_address(a)) {
		# RFC 7042
		m = complete_opt(m, "universal, local, flip") # U/L 
		x = complete_opt(x, "unicast, multicast, flip") # I/G
		b = convert(substr(a, 2, 1), 16, 2)
		b = append(4 - length(b), "0") b
		if (m) {
			l2_map["universal"] = "0"
			l2_map["local"] = "1"
			if (! (m = l2_map[m]))
				m = ones_compliment(substr(b, 2, 1))
			m = substr(b, 1, 1) m
			delete l2_map
		} else {
			m = substr(b, 1, 2)
		}
		if (x) {
			l2_map["unicast"] = "0"
			l2_map["multicast"] = "1"
			if (! (x = l2_map[x]))
				x = ones_compliment(substr(b, 4, 1))
			x = substr(b, 3, 1) x
			delete l2_map
		} else {
			x = substr(b, 3, 2)
		}
		return substr(a, 1, 1) convert(m "" x, 2, 16) substr(a, 3, 16)
	}
}

function load_flag_map() {
	chain("BROADCAST > broadcast > 0, MULTICAST > multicast > 0, ALLMULTI > allmulticast > 0, UP > state > 0, LOWER_UP > operational > 0, NOARP > arp > 1, NO-CARRIER > carrier > 1, LOOPBACK > loopback > 0, PROMISC > promisc > 0, MASTER > master > 0, SLAVE > slave > 0, RUNNING > running > 0,AUTOMEDIA > automedia > 0, DORMANT > dormant > 0, DYNAMIC > dynamic > 0", flag_map)
}

function flag_states(f, q, s,	i, c, opt, flgs, qry) {
	if (! s)
		s = ","
	for (i = 1; i <= split(q, opt, " *" s " *"); i++) {
		if (c = complete_opt(opt[i], "broadcast, multicast, allmulticast, state, operational, arp, carrier, loopback, promisc, master, slave, running, automedia, dormant, dynamic")) {
			if (qry)
				qry = qry s
			qry = qry c
		}
	}
	delete opt
	if (qry) {
		load_flag_map()
		for (i = 1; i <= split(f, flgs, "\n"); i++) {
			flag_map[flag_map[flgs[i]]] = ones_compliment(flag_map[flag_map[flgs[i]]])
		}
		for (i = 1; i <= split(qry, flgs, s); i++) {
			if (flag_map[flgs[i]] == "1")
				bl = "true"
			else
				bl = "false"
			print "L_IFACE_" toupper(flgs[i]) "=" bl
		}
		delete flgs
		delete flag_map
	}
}

