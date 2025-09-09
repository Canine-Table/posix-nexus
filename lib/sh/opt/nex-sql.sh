
__nx_sql_exec()
{
	if test -n "$G_NEX_SQL" && h_nx_cmd "$(nx_info_path -b "$G_NEX_SQL")"; then
		"$G_NEX_SQL" -u "${U:-$(whoami)}" ${P:+-p} "$*"
	else
		nx_io_printf -A "ALERT: Environment not loaded. Have you even sourced nex-init? The script is confused, betrayed, and considering early retirement."
	fi
}

nx_sql_ed25519()
(
	eval "$(nx_str_optarg ':U:u:p:h:P' "$@")"
	test -z "$u" && {
		nx_io_printf -i 'Speak thy name, brave user: '
		read -p '$ ' u
		skip=true
	}
	test -z "$h" && {
		nx_io_printf -i 'Name the host that shall bear your digital legacy: '
		read -p '$ ' h
		skip=true
	}
	test -z "$p" && {
		nx_io_printf -i 'Whisper your secret into the void (it shall not echo): '
		read -p '$ ' -s p
		skip=true
	}
	test "$skip" = true && printf '\n\n'
	if __nx_sql_exec -e "CREATE USER '$u'@'$h' IDENTIFIED VIA ed25519 USING PASSWORD('$p');"; then
		__nx_sql_grant "$@"
		nx_io_printf -S "SUCCESS: $u@$h has been forged in the fires of SQL glory. The database sings your name."
	else
		nx_io_printf -E "Creation of $u@$h failed. The database recoiled in horror and refused your offering."
		exit 1
	fi
)

nx_sql_grant()
(
	eval "$(nx_str_optarg ':U:t:d:h:a:Pg' "$@")"
	__nx_sql_exec -e "GRANT ${a:-'ALL PRIVILEGES'} ON ${d:-'*'}.${t:-'*'} TO '$h'@'$u'${g:+' WITH GRANT OPTION'};" || {
		nx_io_printf -E "GRANT failed. '$h'@'$u' remains powerless. Much like your understanding of SQL."
	}
)

nx_sql_create_db()
(
	eval "$(nx_str_optarg ':U:d:P' "$@")"
	test -z "$d" && {
		nx_io_printf -E "No database name provided. The void stares back. Try again before the system loses all hope."
		exit 2
	}
	__nx_sql_exec -e "CREATE DATABASE $d CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
)

