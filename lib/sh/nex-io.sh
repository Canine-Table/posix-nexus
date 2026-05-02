nx_io_prompt()
{
	nx_tty_print -F '_b>L%_ui>A%>L_nb%>S%' '┌──[' "${*:-Nexus Shell}" ']\n│\n└' '$ '
}

nx_io_yn()
(
	nx_io_prompt "$*${*:+ }(y/n)"
	nx_tty_hault
	test "$tmpa" = 'y' -o "$tmpa" = 1
)

__nx_io_pid()
{
	test -n "$c" && exec 3<&-
	while test "$#" -gt 0; do
		read < "$1"
		kill -9 "$REPLY"
		rm -f "$1"
		shift
	done 2> /dev/null
}

nx_io_evlp()
{
	NEXUS_PID="$(nx_fs_noclobber -v "$NEXUS_ENV/run/$$.$(nx_str_timestamp -f)-$(nx_str_rand 16).pid")"
	(

		b='' m='' e='' c='' f='' c='' p='' s='' r=''
		while test "$#" -gt 1; do
			case "$1" in
				-r|--resize) {
					b="$2"
				};;

				-b|--begin) {
					b="$2"
				};;

				-m|--middle) {
					m="$2"
				};;

				-e|--end) {
					e="$2"
				};;

				-f|--file) {
					f="$2"
				};;

				-c|--command) {
					c="$2"
				};;

				-p|--prefix) {
					p="$2"
				};;

				-s|--separator) {
					s="$2"
				};;

				--) {
					shift
					break
				};;

				*) {
					break
				};;
			esac
			shift 2
		done

		ttou="$(nx_fs_fifo -t "$p" "ttou")"
		ttin="$(nx_fs_fifo -t "$p" "ttin")"
		ev="$(nx_fs_noclobber -v "$NEXUS_ENV/run/$$.$(nx_str_timestamp -f)-$(nx_str_rand 16).pid")"
		trap "nx_fs_fifo -r $ttin; nx_fs_fifo -r $ttou; __nx_io_pid $ev; rm -f $NEXUS_PID" EXIT HUP INT TERM
		printf 'G_NEX_TTIN="%s"\nG_NEX_TTOU="%s"' "$ttin" "$ttou"
		${AWK:-$(nx_cmd_awk)} \
			-v ttin="$ttin" \
			-v ttou="$ttou" \
			-v sep="${s:-<nx:null/>}" \
			-v shpid="$NEXUS_PID" \
			-v awkpid="$ev" \
		"${f:+$(nx_data_include -i "${NEXUS_LIB}/awk/$f")}"'
			BEGIN {
				'"$b"'
				flh = 1
				cnt = 0
				while (1) {
					if ((getline line < ttin) <= 0)
						continue
					cnt = cnt + 1
					if (line != "EXIT") {
						split(line, args, sep)
						op = args[1]
						if (op == "FLUSH") {
							flh = int(args[2])
							line = "FLUSH"
						} else if (op == "PING") {
							line = "PONG"
						} else if (op == "ENVIRON") {
							line = ENVIRON[args[2]]
							if (line == "")
								line = "BOUNCE"
						} else if (op == "COUNTER") {
							line = cnt
						} else if (op == "AWK") {
							line = awkpid
						} else if (op == "SHELL") {
							line = shpid
						} else if (op == "TTIN") {
							line = ttin
						} else if (op == "TTOU") {
							line = ttou
						} '"${m:+else $(printf '%s' "$m"  | sed --posix 's/\(^[[:space:]]*\|[[:space:]]*$\)//g;/^$/d')}"'
					}
					print line > ttou
					if (flh != 0)
						fflush(ttou)
					close(ttin)
				}
				'"$e"'
				delete args
			}
		' & printf '%d' "$!" > "$ev"

		if test -n "$c"; then
			test -n "$r" && {
				trap "nx_tty_all" WINCH
				nx_tty_all
			}
			exec 3< "$ttou"
			while read -u 3; do
				case "$REPLY" in
					*EXIT) {
						$c "BYE"
						break
					};;
					*) {
						$c "$REPLY"
					};;
				esac
			done
		else
			#read < "$ev"
			wait # "$REPLY"
		fi
	) & printf '%d' "$!" > "$NEXUS_PID"
}

nx_io_json()
{
	nx_io_evlp \
		--file 'nex-json.awk' \
		--begin 'dbg=2;ind=4;rt="";' \
		--middle '
			if (op == "DEBUG-LEVEL") {
				dbg = __nx_else(args[2], dbg, 1)
				line = dbg
			} else if (op == "ROOT") {
				rt = __nx_else(args[2], rt, 1)
				line = rt
			} else if (op == "INDENT") {
				ind = __nx_else(args[2], ind, 1)
				line = ind
			} else {
				if (op == "SET") {
					split("", js, "")
					op = "MERGE"
				}
				if (op == "MERGE") {
					if (err = nx_json(args[2], js, __nx_else(args[3], dbg)))
						line = err
					else
						line = "MERGE"
				} else if (op == "DELETE") {
					nx_json_delete(__nx_else(args[2], rt, 1), js)
					line = "DELETE"
				} else if (op == "TYPE") {
					line = nx_json_type(__nx_else(args[2], rt, 1), js)
				} else if (op == "OUTPUT") {
					line = nx_json_flatten(__nx_else(args[2], rt, 1), js, __nx_else(args[3], ind, 1))
				} else if (op == "DUMP") {
					line = "something! "
					sp = __nx_else(args[2], " = ")
					ed = __nx_else(args[3], "\n")
					for (et in js)
						line = line et sp js[et] ed
				} else {
					line = "BOUNCE"
				}
			}
		' \
		--end 'delete cfg;delete js;' \
		--command 'echo'
}

nx_io_basic()
{
	nx_io_evlp --command 'echo' "$@"
}

