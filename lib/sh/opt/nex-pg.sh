

__nx_pg_exec()
(
	h_nx_cmd psql || {
        	nx_io_printf -E "psql not found! The gates to PostgreSQL are sealed." 1>&2
		exit 1
	}
	eval "$(nx_str_optarg ':U:h:d:f:p:c:W' "$@")"
	test -z "$c" || {
		test -f "$f" -a -r "$f" || {
			c="$(nx_io_fifo_mgr)" || exit
			prinf '%s' "$f" > "$c" &
		}
		f='-f'
	} || f='-c'
		psql -h ${h:-localhost} \
		-U ${U:-postgres} \
		-d ${d:-postgres} \
		${h:+-p ${p:-5432}} \
		${W:+-W} \
		$f $c && p=0 || {
            		nx_io_printf -E "pgadmin invocation failed! The portal to the database realm collapsed." 1>&2
			p=3
		}
	test "$f" = true && nx_io_fifo_mgr -r "$c"
	exit $p
)

nx_pg_show_tables()
{
	tmpa='SELECT table_schema, table_name FROM information_schema.tables WHERE table_type = '"'"'BASE TABLE'"'"' AND table_schema NOT IN ('"'"'pg_catalog'"'"', '"'"'information_schema'"'"') ORDER BY table_schema, table_name;'
	__nx_pg_exec "$@" -c "$tmpa"
}
