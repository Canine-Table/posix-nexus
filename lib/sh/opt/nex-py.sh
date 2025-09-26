
nx_py_venv()
{
	while test "$#" -gt 0; do
		test "$1" = '-a' && {
			. "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/venv/bin/activate"
		}
		test "$1" = '-d' && {
			deactivate 2>/dev/null
		}
		test "$1" = '-c' && {
			python -m venv "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/venv"
		}
		test "$VIRTUAL_ENV" = "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/venv" && {
			test "$1" = '-s' && {
				python "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/${L_NEX_APP:-run.py}"
			}
			test "$1" = '-r' -a -f "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/requirements.txt" -a -r "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/requirements.txt" && {
				pip install -r "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/requirements.txt"
				pip install --upgrade pip
			}
		}
		shift
	done
}

