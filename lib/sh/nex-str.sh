nx_str_od()
(
	nx_asm_export
	h_nx_cmd od || {
		nx_tty_print -e 'o no od was not found'
		exit 127
	}

	nx_data_longopt -- ',
		d<%format>
		<default x>
		<regex ^[ox]$>
		<description Byte format: x for hex (\xHH), o for octal (\0NNN); default x>

		s<%separator>
		<description String inserted between bytes; defaults to a space, <nx:blank/> for none>

		help<h>
		<description Show help for nx_str_od>
	' "$@"

	test "$NEX_Gk_s" = '<nx:blank/>' && NEX_Gk_s='' || NEX_Gk_s="${NEX_Gk_s:- }"
	test "$G_NEX_ASM_ENDIAN" -eq 1 && G_NEX_ASM_ENDIAN="big" || G_NEX_ASM_ENDIAN="little"

	${AWK:-$(nx_cmd_awk)} \
		-v dlm="$NEX_Gk_s" \
		-v args="$(printf '%s' "$NEX_ARGV_R" | od --endian="$G_NEX_ASM_ENDIAN" --address-radix=none --format="${NEX_Gk_d}1")" \
		-v cnv="$NEX_Gk_d" \
	'
		BEGIN {
			if (cnv == "x")
				gsub(/ /, "\\x", args)
			else
				gsub(/ /, "\\0", args)
			gsub(/\n/, "", args)
			if (cnv == "x")
				gsub(/\\x3c\\x6e\\x78\\x3a\\x6e\\x75\\x6c\\x6c\\x2f\\x3e/, dlm, args)
			else
				gsub(/\\0074\\0156\\0170\\0072\\0156\\0165\\0154\\0154\\0057\\0076/, dlm, args)
			printf("%s", args)
		}
	'
)

nx_str_timestamp()
(
	nx_data_longopt -- ',
		a<all>
		<description Full timestamp with timezone and weekday: YYYY-MM-DD HH:MM:SS TZ (Weekday)>
		<build date +"%Y-%m-%d %H:%M:%S %Z (%A)";>

		n<nanoseconds>
		<description Timestamp with nanoseconds: YYYY-MM-DD HH:MM:SS.NNNNNNNNN>
		<build date +"%Y-%m-%d %H:%M:%S.%N";>

		u<utc>
		<description ISO-8601 UTC timestamp: YYYY-MM-DDTHH:MM:SSZ>
		<build date +"%Y-%m-%dT%H:%M:%SZ";>

		l<local-iso>
		<description ISO-8601 local timestamp with numeric offset: YYYY-MM-DDTHH:MM:SS+ZZZZ>
		<build date +"%Y-%m-%dT%H:%M:%S%z";>

		s<syslog>
		<description Syslog-style timestamp: Mon DD HH:MM:SS>
		<build date +"%b %d %H:%M:%S";>

		e<epoch>
		<description Unix epoch seconds>
		<build date +"%s";>

		f<filename>
		<description Filename-safe timestamp: YYYYMMDD_HHMMSS>
		<build date +"%Y%m%d_%H%M%S";>

		w<weekday>
		<description Weekday-prefixed filename timestamp: DDD_YYYYMMDD_HHMM>
		<build date +"%a_%Y%m%d_%H%M";>

		z<zoned>
		<description Timestamp with timezone abbreviation: YYYY-MM-DD HH:MM:SS TZ>
		<build date +"%Y-%m-%d %H:%M:%S %Z";>

		help<h>
		<description Show help for nx_str_timestamp>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
)

nx_str_rand()
(
	nx_data_longopt --concat ',' ',
		n<%num number>
		<type int>
		<default 8>
		<min 1>
		<description Number of random characters to generate>

		alnum<@upper lower xupper xlower digit alpha xdigit print punct>
		<regex ^(x?upper|x?lower|x?digit|alpha|alnum|print|punct)$>
		<default alnum>
		<description Comma-separated character classes: upper, lower, xupper, xlower, digit, alpha, xdigit, alnum, print, punct>

		help<h>
		<description Show help for nx_str_rand>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"

	${AWK:-$(nx_cmd_awk)} \
		-v num="$NEX_Gk_n" \
		-v chars="$NEX_GF_alnum" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		BEGIN {
			if (val = nx_random_str(num, chars))
				print val
			else
				exit 226
		}
	'
)

nx_str_append()
(
	nx_data_longopt -- ',
		n<%number count>
		<type int>
		<min 1>
		<default 1>
		<description Number of times to repeat the character>

		c<%char>
		<type char>
		<description Character to repeat>

		help<h>
		<description Show help for nx_str_append>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"

	${AWK:-$(nx_cmd_awk)} \
		-v cnt="$NEX_Gk_n" \
		-v cr="$NEX_Gk_c" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str.awk")
	"'
		BEGIN {
			print nx_append_str(cr, cnt)
		}
	'
)

nx_str_case()
(
	nx_data_longopt -- '
		l<@ut, title lower upper>
		<type str>
		<regex ^([tul]|title|lower|upper)$>
		<default l>
		<description Case transform: t = title, u = upper, l = lower (default)>

		v<%value>
		<description String to transform (defaults to the first positional)>

		help<h>
		<description Show help for nx_str_case>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"

	${AWK:-$(nx_cmd_awk)} \
		-v cse="$NEX_GF_l" \
		-v str="${NEX_Gk_v:-$NEX_ARGV_S}" \
	"
		$(nx_data_include -i "${NEXUS_LIB}/awk/nex-str-extras.awk")
	"'
		BEGIN {
			if (cse ~ "t")
				printf("%s", nx_str_totitle(str))
			else if (cse ~ "u")
				printf("%s", toupper(str))
			else
				printf("%s", tolower(str))
		}
	'
)

nx_str_join()
(
	nx_data_longopt -- ',
		s<%separator>
		<description Separator inserted between lines>

		help<h>
		<description Show help for nx_str_join>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	${AWK:-$(nx_cmd_awk)} -v dlm="$NEX_Gk_s" -v str="$NEX_ARGV_R" 'BEGIN {gsub("<nx:null/>", dlm, str); printf("%s", str)}'
)


nx_str_cnt()
(
	nx_data_longopt -- ',
		d<%delimiter>
		<type str>
		<default ,>
		<description Delimiter to count occurrences of (default comma)>

		help<h>
		<description Show help for nx_str_cnt>
		<build exit;>
	' "$@"

	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"

	${AWK:-$(nx_cmd_awk)} \
		-v dlm="$NEX_Gk_d" \
		-v str="$NEX_ARGV_S" \
		'BEGIN {print gsub(dlm, "\\&", str)}'
)

nx_str_chain()
{
	: ${G_NEX_DELIMETER:='<nx:null/>'}
	test "$#" -gt 0 && {
		printf '%s' "$1"
		shift
		while test "$#" -gt 0; do
			printf '%s' "$G_NEX_DELIMETER$1"
			shift
		done
	}
}

