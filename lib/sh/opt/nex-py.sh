#!/bin/sh

nx_py_venv()
{
	while [ ${#@} -gt 0 ]; do
		[ "$1" = '-a' ] && {
			. "${NEXUS_LIB}/py/${{L_NEX_APP_ROOT}}/venv/bin/activate"
		}
		[ "$1" = '-d' ] && {
			deactivate 2>/dev/null
		}
		[ "$1" = '-c' ] && {
			python -m venv "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/venv"
		}
		[ "$VIRTUAL_ENV" = "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/venv" ] && {
			[ "$1" = '-s' ] && {
				python "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/${L_NEX_APP:-run.py}"
			}
			[ $1 = '-r' -a -f "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/requirements.txt" -a -r "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/requirements.txt" ] && {
				pip install -r "${NEXUS_LIB}/py/${L_NEX_APP_ROOT}/requirements.txt"
				pip install --upgrade pip
			}
		}
		shift
	done
}

