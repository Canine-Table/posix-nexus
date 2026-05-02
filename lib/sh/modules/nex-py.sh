nx_py_venv()
{
	tmpa="$NEXUS_LIB/py"
	tmpb=""
	tmpc="run.py"
	while test "$#" -gt 0; do
		case "$1" in
			-N) {
				test -f "$tmpa/$tmpb/$2" && tmpc="$2"
				shift
			};;
			-R) {
				test -d "$2" && tmpa="$2"
				shift
			};;
			-A) {
				test -d "$tmpa/$2" && tmpb="$2"
				shift
			};;
			-a) {
				tmpd="$tmpa/$tmpb/.env/bin/activate"
				echo $tmpd
				test -f "$tmpd" -a -r "$tmpd" -a -z "$VIRTUAL_ENV" && {
					. "$tmpd"
					unset VIRTUAL_ENV_PROMPT
					nx_cfg_ps1
				}
			};;

			-c) {
				h_nx_cmd $G_NEX_PY && $G_NEX_PY -m venv "$tmpa/$tmpb/.env/"
			};;

			*) {
				if test "$VIRTUAL_ENV" = "$tmpa/$tmpb/.env"; then
					case "$1" in
						-d) {
							tmpd="$tmpa/$tmpb/.env/bin/deactivate"
							test -f "$tmpd" -a -r "$tmpd" && . "$tmpd"
							unset VIRTUAL_ENV
							nx_cfg_ps1
						};;
						-s) {
							h_nx_cmd $G_NEX_PY && $G_NEX_PY "$tmpa/$tmpb/$tmpc"
						};;
						-r) {
							tmpd="$tmpa/$tmpb/requirements.txt"
							test -f "$tmpd" -a -r "$tmpd" && h_nx_cmd $G_NEX_PIP && {
								$G_NEX_PIP install -r "$tmpd"
								$G_NEX_PIP install --upgrade pip
							}
						};;
					esac
				else
					nx_tty_print -E "($1) unknown argument"
				fi
			};;
		esac
		shift
	done
}

