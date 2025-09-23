

__nx_pg_exec()
(
	eval "$(nx_str_optarg ':U:h:d:f:p:c:p:W' "$@")"
	test -n "$c" || {
		f=true
	} || f=false
	pgadmin ${h:-h localhost} \
		${U:--U postgres} \
		${d:--d postgres} \
		${p:-5432} \
		${W:+-W}
)

nx_pg_show_tables()
{
	SELECT table_schema, table_name
	FROM information_schema.tables
	WHERE table_type = 'BASE TABLE'
	  AND table_schema NOT IN ('pg_catalog', 'information_schema')
	ORDER BY table_schema, table_name;
}
