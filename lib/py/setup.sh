#!/bin/sh

[ -z "$G_NEX_MOD_LIB" ] && return 1
setup_posix_nexus_web_server()
{
	[ ${#@} -gt 0 ] && {
		[ "$1" = '-a' ] && {
			. "$G_NEX_MOD_LIB/py/venv/bin/activate"
		}
		[ "$1" = '-d' ] && {
			deactivate 2>/dev/null
		}
		[ "$1" = '-c' ] && {
			python -m venv "$G_NEX_MOD_LIB/py/venv"
		}
		[ "$VIRTUAL_ENV" = "$G_NEX_MOD_LIB/py/venv" ] && {
			[ "$1" = '-s' ] && {
				python "$G_NEX_MOD_LIB/py/run.py"
			}
			[ $1 = '-r' -a -f "$G_NEX_MOD_LIB/py/requirements.txt" -a -r "$G_NEX_MOD_LIB/py/requirements.txt" ] && {
				pip install -r "$G_NEX_MOD_LIB/py/requirements.txt"
			}
		}
		shift
		setup_posix_nexus_web_server $@
	}
}

setup_posix_nexus_web_server $@

