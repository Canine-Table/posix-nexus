#!/bin/sh

###:( get ):##################################################################################

get_test_diff() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/trig.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
		)
	"'
		BEGIN {
		print modular_exponentiation(tmpa, tmpb)
			#print factoral(tmpa, 1)
			#print cos(tmpa)
			#print cosine(tmpa)
			#print pi(tmpa)
			#print tau(tmpa)
			#print divisible(tmpa, tmpb)
			#print fermats_little_theorm(tmpa)
			#print reverse_str("hello world")
			#print modulus_range(tmpa, tmpb, tmpc)
			split("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f", hex, ",")
			#remove_indexed_item(hex, "back", 1, 0, 7, 5, 1)
			#remove_indexed_item(hex, "front", 2, 0, 7, 5, 1)
			#remove_indexed_item(hex, "front", 1, 0, 7, 5, 1)
			#for (i in hex)
			#	print hex[i]
			#stack(stk, "push", "A,B")
			#stack(stk, "push", "A,B")
			#stack(stk, "push", "A,B")
			#print stack(stk, "pop")
			#reverse_indexed_hashmap(hex)
			#insert_indexed_item(hex, "A,B,C,D", ",", tmpa, tmpb, tmpc)
			#resize_indexed_hashmap(hex, tmpa, tmpb)
			#for (i = 1; i < stk[0]; i++)
			#	print stk[i]
		}
	'
}


get_test_sort() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/dataset.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
		)
	"'
		BEGIN {
			#qsort("seo,ctr,fwe,eyj,awe,ewd,ahr", arr, ",", 1) 
			split("sen9i3o,ct4rtr,fwewe,nenytj,aweas,ewtd,ahr", arr, ",") 
			#split("6,1,8,4,2,7,9,3,2,0", arr, ",")
			quick_sort(arr, 1, 10, 1, "length")
			for (i = 1; i <= 10; i++)
				print arr[i]
			#__hoares_partition(arr)
			#for (i in arr)
			#	print arr[i]
			#print entropy(tmpa)
		}
	'
}

get_test_bool() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/bool.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/structs.awk" \
			"$G_NEX_MOD_LIB/awk/algor.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
		)
	"'
		BEGIN {
			printf("expr is %s vs %s\n", tmpa, tmpb)
			print "ge:", GE__(tmpa, tmpb, tmpc)
			print "le:", LE__(tmpa, tmpb, tmpc)
			print "gt:", GT__(tmpa, tmpb, tmpc)
			print "lt:", LT__(tmpa, tmpb, tmpc)
			print "eq:", EQ__(tmpa, tmpb, tmpc)
			print "neq:", NEQ__(tmpa, tmpb, tmpc)
			print "ieq:", IEQ__(tmpa, tmpb, tmpc)
			print "ineq:", INEQ__(tmpa, tmpb, tmpc)
			print "match:", MATCH__(tmpa, tmpb, tmpc)
			print "oppose:", OPPOSE__(tmpa, tmpb, tmpc)
			print "xor:", XOR__(tmpa, tmpb, tmpc)
			print "xnor:", XNOR__(tmpa, tmpb, tmpc)
		}
	'
}



get_test_data_val() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/dataset.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk" \
			"$G_NEX_MOD_LIB/awk/numbers.awk"
		)
	"'
		BEGIN {
			print __pivot(5, 39)
			#print entropy(tmpa)
		}
	'
}

get_test_data_conv2() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk"
		)
	"'
		BEGIN {
			print convert_base(tmpa, tmpb, tmpc)
		}
	'
}

get_test_data_length() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/bases.awk"
			#"$G_NEX_MOD_LIB/awk/dataset.awk"
		)
	"'
		BEGIN {
			print convert_base("1234567890.0123456789", 10, 2)

			#print __base_regex(44)
			#getline line < "/dev/urandom"
			#print __pivot(4, 8)
			#random_str(6, "digit")
			#cnt = split((getline line < "/dev/urandom"), arr, "")
			#print cnt
			#print __sort_pivot(333333333333333)
			#a = "abc, def, ghi, jkl, mno, pqr, stu, vwx, a"
			#print match_length(a, tmpa)
		}
	'
}

get_test_data_half() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/dataset.awk" \
		)
	"'
		BEGIN {
			a = "abc, def, ghi, jkl, mno, pqr, stu, vwx, a"
			print __get_half(a, ",", tmpa, tmpb)
		}
	'
}



get_test_data_bound() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/dataset.awk" \
		)
	"'
		BEGIN {
			a = "abc, def, ghi, jkl, mno, pqr, stu, vwx, a"
			print match_boundary(tmpa, a)
			print match_boundary(tmpa, a, 1)
		}
	'
}

get_test_data_array() {
	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/str.awk" \
			"$G_NEX_MOD_LIB/awk/dataset.awk" \
		)
	"'
		BEGIN {
			array("abc, def, ghi, jkl, mno, pqr, stu, vwx", arr)
			for (i in arr)
				print i
		}
	'
}

get_test_int_types() {
	$(get_cmd_awk) \
		-v tmpa="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/types.awk"
		)
	"'
		BEGIN {
			if (is_integral(tmpa))
				print "Integral:	" tmpa
			if (is_signed_integral(tmpa))
				print "Signed Integral:	" tmpa
			if (is_float(tmpa))
				print "Float:	" tmpa
			if (is_signed_float(tmpa))
				print "Signed Float:	" tmpa
			if (is_digit(tmpa))
				print "Digit:	" tmpa
			if (is_signed_digit(tmpa))
				print "Signed Digit:	" tmpa
		}
	'
}


get_test_sb() {

	$(get_cmd_awk) \
		-v tmpa="$1" \
		-v tmpb="$2" \
		-v tmpc="$3" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/binary.awk" \
			"$G_NEX_MOD_LIB/awk/misc.awk" \
			"$G_NEX_MOD_LIB/awk/conv.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/types.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk" \
			"$G_NEX_MOD_LIB/awk/l2.awk"
		)
	"'
		BEGIN {
			__load_s
			print s
			#print match_str(tmpa, tmpb, 1)
			#side_difference(tmpa, tmpb, tmpc)
			#print comp_opt("ab", "abcd, abcde")
		}
	'
}

get_test_chain() {
	$(get_cmd_awk) "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk"
		)
	"'
		BEGIN {
			chain("a > b > c, A > B > C", cn)
			v = cn["a"]
			print v
			v = cn[v]
			print v
			v = cn["A"]
			print v
			delete cn
			chain("a > A > b > B > c > C", cn, 1)
			v = "a"
			for (i = 1; i <= 27; i++) {
				print v
				v = cn[v]
			}
		}
	'
}

get_test_queue() {
	$(get_cmd_awk) "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk" \
		)
	"'
		BEGIN {
			queue(qu, "enqueue", "apple, orange, banana")
			print queue(qu, "dequeue")
			queue(qu, "enq", "grape, peach")
			print queue(qu, "deq")
			print queue(qu, "deq")
			queue(qu, "enqueue", "apple, orange, banana")
			while (! queue(qu, "isempty")) {
				print queue(qu, "deq")
			}
			print queue(qu, "is")
		}
	'
}

get_test_stack() {
	$(get_cmd_awk) "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk" \
		)
	"'
		BEGIN {
			stack(stk, "push", "apple, orange, banana")
			stack(stk, "push", "grape, peach")
			print stack(stk, "ise")
			while (stack(stk, "peek")) {
				print stack(stk, "pop")
			}
			print stack(stk, "ise")
		}
	'
}

get_test_escape() {
	$(get_cmd_awk) \
		-v str="$*" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk" \
			"$G_NEX_MOD_LIB/awk/conv.awk" \
			"$G_NEX_MOD_LIB/awk/l2.awk"
		)
	"'
		BEGIN {
			print escape(str)
		}
	'
}

get_test_l2() {
	$(get_cmd_awk) \
		-v ln="$1" \
		-v chars="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/struct.awk" \
			"$G_NEX_MOD_LIB/awk/conv.awk" \
			"$G_NEX_MOD_LIB/awk/l2.awk"
		)
	"'
		BEGIN {
			print valid_prefix(net)
			#print generate_string(ln, chars)
			#generate_hex(net)
		}
	'
}

get_test_inet() {
	$(get_cmd_awk) \
		-v net="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/binary.awk" \
			"$G_NEX_MOD_LIB/awk/conv.awk" \
			"$G_NEX_MOD_LIB/awk/l3.awk"
		)
	"'
		BEGIN {
			print inet(net)
		}
	'
}

get_test_expand6() {
	$(get_cmd_awk) \
		-v net="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/l3.awk"
		)
	"'
		BEGIN {
			var = expand_ipv6(net)
			print var
			var = truncate_ipv6(var)
			print var
		}
	'
}

get_test_pi() {
	$(get_cmd_awk) \
		-v prec="$1" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/pi.awk"
		)
	"'
		BEGIN {
			print pi(prec)
		}
	'
}

get_test_bdrs() {
	$(get_cmd_awk) \
		-v inpt="$(set_struct_opt -i "$1" 'single, double' || echo "$1")" \
		-v sep="$2" "
		$(cat \
			"$G_NEX_MOD_LIB/awk/strings.awk" \
			"$G_NEX_MOD_LIB/awk/math.awk" \
			"$G_NEX_MOD_LIB/awk/tui.awk"
		)
	"'
		BEGIN {
			load_borders(inpt, sep)
			for (i in borders) {
				print i ":\t" borders[i]
			}
		}
	'
}

get_test_esc() {
	(
		csup="$(get_out_color_support && echo "true")"
		$(get_cmd_awk) \
			-v inpt="$*" \
			-v csup="$csup" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/tui.awk"
			)
		"'
			BEGIN {
				print ansi_codes(inpt, csup)
			}
		'
	)
}

get_test_fold() {
	(
	        col="$(get_tty_prop -k "columns")"
                get_out_color_support && {
                        csp='true'
                        trap 'echo -e "\x1b[0m"' SIGHUP SIGINT EXIT
                }
		$(get_cmd_awk) \
			-v col="$col" \
			-v csup="$csup" \
			-v oset="$2" \
			-v inpt="$1" "
			$(cat \
				"$G_NEX_MOD_LIB/awk/strings.awk" \
				"$G_NEX_MOD_LIB/awk/math.awk" \
				"$G_NEX_MOD_LIB/awk/pi.awk" \
				"$G_NEX_MOD_LIB/awk/tui.awk"
			)
		"'
			BEGIN {
                                nor = nor + 1
                                if (FILENAME) {
                                        if (! (FILENAME in fn)) {
                                                fn[FILENAME] = nor
                                                ln = 0
                                        }
                                        ln = ln + 1
                                }

				print fold(inpt, col, oset, csup, nor)

			}
		'
	)
}


###:( set ):##################################################################################
###:( cls ):##################################################################################
###:( new ):##################################################################################
###:( add ):##################################################################################
###:( del ):##################################################################################
###:( is ):###################################################################################
##############################################################################################

