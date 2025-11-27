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
				. "$tmpa/$tmpb/.env/bin/activate"
			};;
			-d) {
				. "$tmpa/$tmpb/.env/bin/deactivate"
			};;
			-c) {
				python -m venv "$tmpa/$tmpb/.env/"
			};;
			*) {
				if test "$VIRTUAL_ENV" = "$tmpa/$tmpb/.env"; then
					case "$1" in
						-s) {
							python "$tmpa/$tmpb/$tmpc"
						};;
						-r) {
							test -f "$tmpa/$tmpb/requirements.txt" -a -r "$tmpa/$tmpb/requirements.txt" && {
								pip install -r "$tmpa/$tmpb/requirements.txt"
								pip install --upgrade pip
							}
						};;
					esac
				else
					printf '%s\n' "($1) unknown argument" 1>&2
				fi
			};;
		esac
		shift
	done
}
