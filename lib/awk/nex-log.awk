function __nx_color_map(D1, D2,		c)
{
	if (D2 == "<")
		c = 10
	else
		c = 0
	if ((D2 = tolower(D1)) == "c")
		return c + 39
	if (D2 == "r")
		return c + 38
	if (D1 != D2)
		c += 60
	if (D2 == "b")
		return c + 30
	if (D2 == "e")
		return c + 31
	if (D2 == "s")
		return c + 32
	if (D2 == "w")
		return c + 33
	if (D2 == "i")
		return c + 34
	if (D2 == "d")
		return c + 35
	if (D2 == "a")
		return c + 36
	if (D2 == "l")
		return c + 37
	return 0
}

function __nx_style_map(D,	c)
{
	if (D == "o") # overline
		return 53
	if (D == "O") # not overline
		return 55
	if (D != (c = tolower(D))) {
		D = c
		c = 20
	} else {
		c = 0
	}
	if (D == "n") # normal
		return "0"
	if (D == "b") # bold
		return c + 1
	if (D == "d") # dim
		return c + 2
	if (D == "i") # italic
		return c + 3
	if (D == "u") # underline
		return c + 4
	if (D == "f") # flash
		return c + 5
	if (D == "r") # reverse video
		return c + 7
	if (D == "h") # hide
		return c + 8
	if (D == "s") # strike
		return c + 9
}

function __nx_emoji_map(V)
{
	V["Fsmiling_sunglasses"] = "\xF0\x9F\x98\x8E"
	V["Fsleeping"] = "\xF0\x9F\x98\xB4"
	V["Ftired"] = "\xF0\x9F\x98\xB0"
	V["Fconfused"] = "\xF0\x9F\x98\xA7"
	V["Fpouting"] = "\xF0\x9F\x98\xA1"
	V["Sexclamation"] = "\xE2\x9D\x97"
	V["Swarn"] = "\xE2\x9A\xA0\xEF\xB8\x8F"
	V["Fgrin"] = "\xF0\x9F\x98\x80"
	V["Fgrinning"] = "\xF0\x9F\x98\x83"
	V["Fgrin_smile"] = "\xF0\x9F\x98\x84"
	V["Fgrin_beam"] = "\xF0\x9F\x98\x81"
	V["Fgrin_sweat"] = "\xF0\x9F\x98\x85"
	V["Fgrin_squint"] = "\xF0\x9F\x98\x86"
	V["Ftear_joy"] = "\xF0\x9F\x98\x82"
	V["Froll_laugh"] = ""
	V["Fslight_smile"] = "\xF0\x9F\x99\x82"
	V["Fdown"] = "\xF0\x9F\x99\x83"
	V["Fwink"] = "\xF0\x9F\x98\x89"
	V["Fsmile_smile"] = "\xF0\x9F\x98\x8A"
	V["Fhalo"] = "\xF0\x9F\x98\x87"
	V["Fkiss"] = "\xF0\x9F\x98\x98"
	V["Fsmile"] = "\xE2\x98\xBA\x00"
	V["Fkissing"] = "\xF0\x9F\x98\x97"
	V["Fclose_kiss"] = "\xF0\x9F\x98\x9A"
	V["Fsmile_kiss"] = "\xF0\x9F\x98\x99"
	V["Fsavor"] = "\xF0\x9F\x98\x8B"
	V["Ftongue"] = "\xF0\x9F\x98\x9B"
	V["Fwink_tongue"] = "\xF0\x9F\x98\x9C"
	V["Fsquint_tongue"] = "\xF0\x9F\x98\x9D"
	V["Fneutral"] = "\xF0\x9F\x98\x90"
	V["Fno_express"] = "\xF0\x9F\x98\x91"
	V["Funamused"] = "\xF0\x9F\x98\x92"
	V["Fsmirking"] = "\xF0\x9F\x98\x8F"
	V["Fno_mouth"] = "\xF0\x9F\x98\xB6"
	V["Shorizontal"] = "\xE2\x86\x94\xEF\xB8\x8F"
	V["Svertical"] = "\xE2\x86\x95\xEF\xB8\x8F"
	V["Frelieved"] = "\xF0\x9F\x98\x8C"
	V["Fpensive"] = "\xF0\x9F\x98\x94"
	V["Fsleepy"] = "\xF0\x9F\x98\xAA"
	V["Fmedical_mask"] = "\xF0\x9F\x98\xB7"
	V["Fdead"] = "\xF0\x9F\x98\xB5"
	V["Fconfused"] = "\xF0\x9F\x98\x95"
	V["Fworried"] = "\xF0\x9F\x98\x9F"
	V["Ffrown"] = "\xF0\x9F\x99\x81"
	V["Ffrowning"] = "\xE2\x98\xB9\x00"
	V["Fopen"] = "\xF0\x9F\x98\xAE"
	V["Fhush"] = "\xF0\x9F\x98\xAF"
	V["Fastonish"] = "\xF0\x9F\x98\xB2"
	V["Fflush"] = "\xF0\x9F\x98\xB3"
	V["Fopen_frown"] = "\xF0\x9F\x98\xA6"
	V["Fanguish"] = "\xF0\x9F\x98\xA7"
	V["Ffear"] = "\xF0\x9F\x98\xA8"
	V["Fanxious_sweat"] = "\xF0\x9F\x98\xB0"
	V["Fsad_releved"] = "\xF0\x9F\x98\xA5"
	V["Fcry"] = "\xF0\x9F\x98\xA2"
	V["Floud_cry"] = "\xF0\x9F\x98\xAD"
	V["Fconfound"] = "\xF0\x9F\x98\x96"
	V["Fscream_fear"] = "\xF0\x9F\x98\xB1"
	V["Fpersever"] = "\xF0\x9F\x98\xA3"
	V["Fdisappoint"] = "\xF0\x9F\x98\x9E"
	V["Fdowncast_sweat"] = "\xF0\x9F\x98\xA9"
	V["Fweary"] = "\xF0\x9F\x98\x93"
	V["Ftired"] = "\xF0\x9F\x98\xAB"
	V["Sok"] = "\xF0\x9F\x86\x97"
	V["Squestion"] = "\xE2\x9D\x93"
	V["Ssos"] = "\xF0\x9F\x86\x98"
	V["Sfist"] = "\xE2\x9C\x8A"
	V["Swriting_hand"] = "\xE2\x9C\x8D"
	V["Spalm"] = "\xE2\x9C\x8B"
	V["Shand_spread"] = "\xF0\x9F\x96\x90"
	V["Ssun"] = "\xE2\x98\x80"
	V["Searth_globe_americas"] = "\xF0\x9F\x8C\x8E"
	V["Searth_globe_europe"] = "\xF0\x9F\x8C\x8D"
	V["Searth_globe_asia"] = "\xF0\x9F\x8C\x8F"
	V["Slightning"] = "\xE2\x9A\xA1"
	V["Srain_cloud"] = "\xF0\x9F\x8C\xA7"
	V["Ssnow_cloud"] = "\xF0\x9F\x8C\xA8"
	V["Sumbrella_rain"] = "\xE2\x98\x94"
	V["Ssnowflake"] = "\xE2\x9D\x84"
	V["Ssnowman"] = "\xE2\x98\x83"
	V["Ssnowman_nosnow"] = "\xE2\x9B\x84"
	V["Stornado"] = "\xF0\x9F\x8C\xAA"
	V["Smusical_notes"] = "\xF0\x9F\x8E\xB6"
	V["Smusical_note"] = "\xF0\x9F\x8E\xB5"
	V["Sheadphones"] = "\xF0\x9F\x8E\xA7"
	V["Slaptop"] = "\xF0\x9F\x92\xBB"
	V["Sdesktop"] = "\xF0\x9F\x96\xA5"
	V["Sprinter"] = "\xF0\x9F\x96\xA8"
	V["Skeyboard"] = "\xE2\x8C\xA8"
	V["Sgame_console"] = "\xF0\x9F\x8E\xAE"
	V["Sjoystick"] = "\xF0\x9F\x95\xB9"
	V["Strophy"] = "\xF0\x9F\x8F\x86"
	V["Sred_heart"] = "\xE2\x9D\xA4"
	V["Sblack_heart"] = "\xF0\x9F\x96\xA4"
	V["Swhite_heart"] = "\xF0\x9F\xA4\x8D"
	V["Slight_exclamation"] = "\xE2\x9D\x95"
	V["Slight_question"] = "\xE2\x9D\x94"
	V["Swhite_circle"] = "\xE2\x9A\xAA"
	V["Sblack_circle"] = "\xE2\x9A\xAB"
	V["Sblack_square"] = "\xE2\xAC\x9B"
	V["Swhite_square"] = "\xE2\xAC\x9C\x00"
	V["Swhite_dot_square"] = "\xE2\xAC\x9A"
	V["Sinfo"] = "\xE2\x84\xB9"
	V["Splus"] = "\xE2\x9E\x95"
	V["Sminus"] = "\xE2\x9E\x96"
	V["Sright_arrow"] = "\xE2\x9E\xA1"
	V["Sleft_arrow"] = "\xE2\xAC\x85"
	V["Sup_arrow"] = "\xE2\xAC\x86"
	V["Sdown_arrow"] = "\xE2\xAC\x87"
	V["Sleft_triangle"] = "\xE2\x97\x80"
	V["Sright_triangle"] = "\xE2\x96\xB6"
	V["Sfast_forward"] = "\xE2\x8F\xA9"
	V["Srewind"] = "\xE2\x8F\xAA"
	V["Sup_button"] = "\xE2\x8F\xAB"
	V["Sdown_button"] = "\xE2\x8F\xAC"
	V["Splay_pause"] = "\xE2\x8F\xAF"
	V["Sbeach_umbrella"] = "\xF0\x9F\x8F\x96"
	V["Sunknown_symbol"] = "\xF0\x9F\x96\xA1"
	V["Smouse"] = "\xF0\x9F\x96\xB1"
	V["Smedal"] = "\xF0\x9F\x8E\x96"
	V["Fpoop"] = "\xF0\x9F\x92\xA9"
	V["Fskull_crossbones"] = "\xE2\x98\xA0"
	V["Fdevil"] = "\xF0\x9F\x98\x88"
	V["Falien"] = "\xF0\x9F\x91\xBD"
	V["Frobot"] = "\xF0\x9F\xA4\x96"
	V["Fcat_smile"] = "\xF0\x9F\x98\xBA"
	V["Fcat_grin"] = "\xF0\x9F\x98\xB8"
	V["Fcat_tear_joy"] = "\xF0\x9F\x98\xB9"
	V["Fcat_heart_eyes"] = "\xF0\x9F\x98\xBB"
	V["Fcat_smirk"] = "\xF0\x9F\x98\xBC"
	V["Fcat_kiss"] = "\xF0\x9F\x98\xBD"
	V["Fcat_fear"] = "\xF0\x9F\x98\xBE"
	V["Fcat_cry"] = "\xF0\x9F\x98\xBF"
	V["Fcat_pout"] = "\xF0\x9F\x99\x80"
	V["Sheart"] = "\xE2\x9D\xA4"
	V["Fbandage_heart"] = "\xF0\x9F\xA9\xB9"
	V["Fhole"] = "\xF0\x9F\x95\xB3"
	V["Feye"] = "\xF0\x9F\x91\x81"
	V["Fspeech_bubble"] = "\xF0\x9F\x97\xA8"
	V["Fthought_bubble"] = "\xF0\x9F\x97\xAF"
	V["Fpoint_left"] = "\xF0\x9F\x91\x88"
	V["Fpoint_right"] = "\xF0\x9F\x91\x89"
	V["Fpoint_down"] = "\xF0\x9F\x91\x87"
	V["Fpoint_up_light"] = "\xE2\x98\x9D"
	V["Fear"] = "\xF0\x9F\x91\x82"
	V["Fheart_anatomical"] = "\xF0\x9F\xAB\x80"
	V["Flung"] = "\xF0\x9F\xAB\x81"
	V["Fsnowflake"] = "\xE2\x9D\x84"
	V["Fkeyboard"] = "\xE2\x8C\xA8"
	V["Fmouse"] = "\xF0\x9F\x96\xA1"
	V["Fgame_console"] = "\xF0\x9F\x8E\xAE"
	V["Ftrophy"] = "\xF0\x9F\x8F\x86"
	V["Flightning"] = "\xE2\x9A\xA1"
	V["Fumbrella_rain"] = "\xE2\x98\x94"
	V["Fsnowman_nosnow"] = "\xE2\x9B\x84"
	V["Ftornado"] = "\xF0\x9F\x8C\xAA"
	V["Ffast_forward"] = "\xE2\x8F\xA9"
	V["Freverse"] = "\xE2\x8F\xAA"
	V["Frewind"] = "\xE2\x8F\xAB"
	V["Fpause"] = "\xE2\x8F\xAF"
	V["Fspy"] = "\xF0\x9F\x95\xB5"
	V["Fbusiness_suit_levitate"] = "\xF0\x9F\x95\xB4"
	V["Fskier"] = "\xE2\x9B\xB7"
	V["Fsnowboarder"] = "\xF0\x9F\x8F\x82"
	V["Fgolfing_man"] = "\xF0\x9F\x8F\x8C"
	V["Fsurfing_man"] = "\xF0\x9F\x8F\x84"
	V["Fswimming_man"] = "\xF0\x9F\x8F\x8A"
	V["Fbouncing_ball_person"] = "\xE2\x9B\xB9"
	V["Fbouncing_ball_man"] = "\xE2\x9B\xB9\xE2\x99\x82"
	V["Fbouncing_ball_woman"] = "\xE2\x9B\xB9\xE2\x99\x80"
	V["Fweight_lifting"] = "\xF0\x9F\x8F\x8B"
	V["Fspeaking_head"] = "\xF0\x9F\x97\xA3"
	V["Fpeople_hugging"] = "\xF0\x9F\xAB\x82"
	V["Ffamily"] = "\xF0\x9F\x91\xAA"
	V["Fmonkey_face"] = "\xF0\x9F\x90\xB5"
	V["Fdog"] = "\xF0\x9F\x90\x95"
	V["Fcat"] = "\xF0\x9F\x90\xB1"
	V["Fcow"] = "\xF0\x9F\x90\xAE"
	V["Fmouse"] = "\xF0\x9F\x90\xAD"
	V["Fsquirrel"] = "\xF0\x9F\x90\xBF"
	V["Fbird"] = "\xF0\x9F\x90\xA6"
	V["Ffeather"] = "\xF0\x9F\xAA\xB6"
	V["Fblack_bird"] = "\xF0\x9F\xA6\x85"
	V["Ffish"] = "\xF0\x9F\x90\x9F"
	V["Fbeetle"] = "\xF0\x9F\xAA\xB2"
	V["Fcockroach"] = "\xF0\x9F\xAA\xB3"
	V["Fspider"] = "\xF0\x9F\x95\xB9"
	V["Ffly"] = "\xF0\x9F\xAA\xB0"
	V["Fworm"] = "\xF0\x9F\xAA\xB1"
	V["Frosette"] = "\xF0\x9F\x8F\xB5"
	V["Fpotted_plant"] = "\xF0\x9F\xAA\xB4"
	V["Fshamrock"] = "\xE2\x98\x98"
	V["Fblueberries"] = "\xF0\x9F\xAB\x90"
	V["Folives"] = "\xF0\x9F\xAB\x92"
	V["Fhot_pepper"] = "\xF0\x9F\x8D\x86"
	V["Fbell_pepper"] = "\xF0\x9F\xAB\x91"
	V["Fcoffee"] = "\xE2\x98\x95"
	V["Ftea"] = "\xF0\x9F\xAB\x96"
	V["Fcocktail_glass"] = "\xF0\x9F\x8D\xB8"
	V["Fplate_fork_knife"] = "\xF0\x9F\x8D\xBD"
	V["Fworld_map"] = "\xF0\x9F\x97\xBA"
	V["Fcamping"] = "\xF0\x9F\x8F\x95"
	V["Fdesert"] = "\xF0\x9F\x8F\x9C"
	V["Fbeach"] = "\xF0\x9F\x8F\x9D"
	V["Fpark"] = "\xF0\x9F\x8F\x9E"
	V["Fstadium"] = "\xF0\x9F\x8F\x9F"
	V["Fcityscape"] = "\xF0\x9F\x8F\x99"
	V["Fhot_springs"] = "\xE2\x99\xA8"
	V["Ftrain"] = "\xF0\x9F\x9A\x87"
	V["Fbus"] = "\xF0\x9F\x9A\x8D"
	V["Fambulance"] = "\xF0\x9F\x9A\x91"
	V["Fpolice_car"] = "\xF0\x9F\x9A\x94"
	V["Fcar"] = "\xF0\x9F\x9A\x98"
	V["Ftruck"] = "\xF0\x9F\x9B\xBB"
	V["Fbicycle"] = "\xF0\x9F\x9A\xB2"
	V["Ftrolley"] = "\xF0\x9F\x9A\xBA"
	V["Froller_skate"] = "\xF0\x9F\xAA\xB6"
	V["Fskateboard"] = "\xF0\x9F\xAA\xB9"
	V["Fhighway"] = "\xF0\x9F\x9B\xA3"
	V["Fbridge"] = "\xF0\x9F\x9B\xA4"
}

function __nx_symbol_map(D,	c)
{
	if (D == "b") # emphasis
		return "#"
	if (D == "B") # pipeline
		return "|"
	if (D == "e") # minor error
		return "x"
	if (D == "E") # critical error needs attention like yesterday
		return "X"
	if (D == "s") # success
		return "v"
	if (D == "S") # great success
		return "V"
	if (D == "w") # warning
		return "!"
	if (D == "W") # warning but not sure
		return "?"
	if (D == "d") # debug
		return "*"
	if (D == "D") # trace
		return ">"
	if (D == "i") # info
		return "i"
	if (D == "I") # verbose
		return "."
	if (D == "l") # log
		return "%"
	if (D == "L") # detailed log
		return "$"
	if (D == "a") # alert
		return "@"
	if (D == "A") # more info alert
		return "&"
}

function nx_printf(D1, D2,	fv, i, l, stkv)
{
	if (D1 != "" && D2 != "") {
		l = split(D1, fv, "")
		stkv["s"] = ">"
		stkv["i"] = ""
		stkv["fmt"] = ""
		stkv["plhdr"] = ""
		for (i = 1; i <= l; i++) {
			if (fv[i] ~ /[<>_\\^]/) {
				stkv["s"] = fv[i]
			} else if (fv[i] == "%") {
				stkv["fmt"] = stkv["fmt"] __nx_if(stkv["plhdr"], "\x1b[" stkv["plhdr"] "m<nx:placeholder/>", "<nx:placeholder/>")
				stkv["plhdr"] = ""
			} else if (stkv["s"] ~ /[<>]/) {
				stkv["plhdr"] = nx_join_str(stkv["plhdr"], __nx_color_map(fv[i], stkv["s"]), ";")
			} else if (stkv["s"] == "^" && (stkv["i"] = __nx_symbol_map(fv[i]))) {
				stkv["i"] = "\x0a[" stkv["i"] "]: "
				stkv["fmt"] = stkv["fmt"] __nx_if(stkv["plhdr"], "\x1b[" stkv["plhdr"] "m" stkv["i"], stkv["i"])
				stkv["plhdr"] = ""
			} else if (stkv["s"] == "_") {
				stkv["plhdr"] = nx_join_str(stkv["plhdr"], __nx_style_map(fv[i]), ";")
			}
		}
		stkv["fmt"] = stkv["fmt"] __nx_if(stkv["plhdr"], "\x1b[" stkv["plhdr"] "m", "")
		l = nx_log_db(stkv["fmt"], D2) "\x1b[0m"
		delete stkv
		return l
	}
}

function nx_log_db(N, D, B, V,		msg)
{
	if (length(V))
		N = V[N "_" nx_modulus_range(__nx_entropy(V[N "_0"]), V[N "_0"]) + 1]
	else
		B = 0
	if (N != "") {
		if (B)
			delete V
		B = split(D, msg, "<nx:null/>")
		for (D = 1; D <= B; D++) {
			if (! gsub("<nx:placeholder +index=" D " */>", msg[D], N))
				sub("<nx:placeholder/>", msg[D], N)
		}
		gsub("<nx:placeholder.*/>", "", N)
		delete msg
		return N
	}
}

function nx_log_black(D, B)
{
	if (B)
		return nx_printf("B_bi^b_Iu%", D)
	return nx_printf("l<B_bi^b_Iu%", D)
}

function nx_log_light(D, B)
{
	if (B)
		return nx_printf("L_bi^l_Iu%", D)
	return nx_printf("b<L_bi^l_Iu%", D)
}

function nx_log_success(D, B)
{
	if (B)
		return nx_printf("S_bi^s_Iu%", D)
	return nx_printf("b<S_bi^s_Iu%", D)
}

function nx_log_warn(D, B)
{
	if (B)
		return nx_printf("W_bi^w_Iu%", D)
	return nx_printf("b<W_bi^w_Iu%", D)
}

function nx_log_error(D, B)
{
	if (B)
		return nx_printf("E_bi^e_Iu%", D)
	return nx_printf("b<E_bi^e_Iu%", D)
}

function nx_log_debug(D, B)
{
	if (B)
		return nx_printf("D_bi^d_Iu%", D)
	return nx_printf("b<D_bi^d_Iu%", D)
}

function nx_log_info(D, B)
{
	if (B)
		return nx_printf("I_bi^i_Iu%", D)
	return nx_printf("b<I_bi^i_Iu%", D)
}

function nx_log_alert(D, B)
{
	if (B)
		return nx_printf("A_bi^a_Iu%", D)
	return nx_printf("b<A_bi^a_Iu%", D)
}

