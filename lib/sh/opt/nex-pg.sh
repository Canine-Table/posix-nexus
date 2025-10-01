__nx_pg_exec()
(
	h_nx_cmd psql || {
        	nx_io_printf -E "psql not found! The gates to PostgreSQL are sealed." 1>&2
		exit 1
	}
	eval "$(nx_str_optarg ':U:h:d:f:p:c:W' "$@")"

	test -z "$c" && {
		test -f "$f" -a -r "$f" && f='-f' || {
			test -n "$f" && {
				c="$(nx_io_fifo_mgr -c)" || exit
				f="$(printf "$f")"
				printf "$f" > "$c" &
				f='-f'
			}
		}
	} || {
		c="$(printf "$c")"
		test -n "$c" && f='-c'
	}
	psql -h ${h:-localhost} \
	-U ${U:-postgres} \
	-d ${d:-postgres} \
	${h:+-p ${p:-5432}} \
	${W:+-W} \
	$f ${c:+"$c"} && p=0 || {
		nx_io_printf -E "psql invocation failed! The portal to the database realm collapsed." 1>&2
		p=3
	}
	test "$f" = true && nx_io_fifo_mgr -r "$c"
	exit $p
)

nx_pg()
{
	__nx_pg_exec "$@"
}

s_nx_pg_l()
{
	__nx_pg_exec "$@" -c 'SELECT datname FROM pg_database WHERE datistemplate = false;'
}

nx_pg_dt()
{
	__nx_pg_exec "$@" -c "$(nx_str_od -x "SELECT table_schema, table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema') ORDER BY table_schema, table_name;")"
}

s_nx_pg_d()
(
	eval "$(nx_str_optarg ':t:' "$@")"
	test -z "$t" && {
        	nx_io_printf -E "No table specified. The schema spirits stir, but you’ve named no glyph. Invoke again with a proper table name." 2>&1
		exit 1
	}
	__nx_pg_exec "$@" -c "$(nx_str_od -x "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '$t';")"
)

s_nx_pg_dn()
{
	__nx_pg_exec "$@" -c 'SELECT nspname FROM pg_namespace;'
}

s_nx_pg_df()
{
	__nx_pg_exec "$@" -c "$(nx_str_od -x "SELECT proname FROM pg_proc WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');")"
}

s_nx_pg_dv()
{
	__nx_pg_exec "$@" -c "$(nx_str_od -x "SELECT table_name FROM information_schema.views WHERE table_schema = 'public';")"
}

s_nx_pg_di()
{
	__nx_pg_exec "$@" -c "$(nx_str_od -x "SELECT indexname, tablename FROM pg_indexes WHERE schemaname = 'public';")"
}

s_nx_pg_du()
{
	__nx_pg_exec "$@" -c 'SELECT rolname FROM pg_roles;'
}

s_nx_pg_dg()
{
	__nx_pg_exec "$@" -c 'SELECT rolname FROM pg_roles WHERE rolcanlogin = false;'
}

s_nx_pg_dp()
{
	__nx_pg_exec "$@" -c 'SELECT grantee, privilege_type, table_name FROM information_schema.role_table_grants;'
}

s_nx_pg_set()
{
	__nx_pg_exec "$@" -c 'SHOW ALL;'
}

s_nx_pg_enc()
{
	__nx_pg_exec "$@" -c 'SHOW client_encoding;'
}

s_nx_pg_con()
{
	__nx_pg_exec "$@" -c 'SELECT current_database(), current_user, inet_client_addr();'
}

nx_pg_ct()
(
	eval "$(nx_str_optarg ':t:p:' "$@")"
	test -z "$t" && {
		nx_io_printf -E "No table (-t) specified. What glyph are you trying to extract? The database altar awaits a name." 2>&1
		exit 1
	}
	test -z "$p" && {
		p="$(nx_io_noclobber -p "$HOME/Documents/$t" -s '.csv')"
		nx_io_printf -W "No path (-p) specified. Defaulting to '$p'—your scroll will be etched there unless overwritten by fate." 2>&1
	}
	__nx_pg_exec "$@" -c "$(nx_str_od -x "COPY $t TO '$p' WITH (FORMAT csv, HEADER);")"
)

nx_pg_cf()
(
	eval "$(nx_str_optarg ':t:p:' "$@")"
	test -z "$t" && {
		nx_io_printf -E "No table (-t) specified. Where shall the scroll be unrolled? The schema spirits demand a destination." 2>&1
		exit 1
	}
	test -z "$p" -o ! -f "$p" && {
        	nx_io_printf -E "Path (-p) is missing or invalid. No scroll to read, no parchment to parse. Provide a real file or abandon the ritual." 2>&1
		exit 2
	}
	__nx_pg_exec "$@" -c "$(nx_str_od -x "COPY my_table FROM '/path/to/file.csv' WITH (FORMAT csv, HEADER);")"
)

s_nx_pg_fn()
{
	__nx_pg_exec "$@" -c "$(nx_str_od -x "
		SELECT
		  n.nspname AS schema,
		  p.proname AS function_name,
		  pg_catalog.pg_get_function_result(p.oid) AS return_type,
		  pg_catalog.pg_get_function_arguments(p.oid) AS arguments,
		  p.prokind AS kind, -- 'f' = function, 'p' = procedure, 'a' = aggregate
		  p.prosrc AS source_code
		FROM pg_catalog.pg_proc p
		JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
		WHERE pg_catalog.pg_function_is_visible(p.oid);
	")"
}

