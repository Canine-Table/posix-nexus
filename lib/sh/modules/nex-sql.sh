nx_sql_exec()
(
	nx_data_longopt -v 4 -- ',
		b<%bin>
		<type str>
		<regex ^sqlite3|mariadb|psql$>
		<default sqlite3>
		<build h_nx_cmd <nx@b/\> && NEX_Gk_b=<nx@b/\>;>
		<description the binary to run the sql>

		t<%target>
		<type str>
		<lazy>
		<build test -e <nx@t/\> -a ! -d <nx@t/\> && NEX_Gk_t=<nx@t/\>;>
		<description the entry sql file>

		o<%output>
		<type str>
		<default /dev/stdout>
		<description output file>

		help<h>
		<build exit;>
		<description show help and exit>
	' "$@"
	test -n "$NEX_ARGV_E" && eval "$NEX_ARGV_E"
	h_nx_cmd "$NEX_Gk_b" || {
		nx_tty_print -E 'sql binary required'
		exit 226
	}
	test -e "$NEX_Gk_t" -a ! -d "$NEX_Gk_t" || {
		nx_tty_print -E 'sql file required'
		exit 227
	}
	nx_data_include \
		--verbose 1 \
		--method 2 \
		--directive 'nx_include' \
		--comment-start '/*' \
		--comment-end '*/' \
		--lib-root "$NEXUS_LIB" \
		--sigil '--' \
		--list-separator '<nx:null/>' \
		--file-separator '/' \
		--separator ',' \
		--input "$NEX_Gk_t" \
	>> "$NEX_Gk_o"
)
