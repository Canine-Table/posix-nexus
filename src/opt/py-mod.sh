#!/bin/sh

nx_py_venv()
{
	[ ${#@} -gt 0 ] && {
		[ "$1" = '-a' ] && {
			. "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/venv/bin/activate"
		}
		[ "$1" = '-d' ] && {
			deactivate 2>/dev/null
		}
		[ "$1" = '-c' ] && {
			python -m venv "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/venv"
		}
		[ "$VIRTUAL_ENV" = "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/venv" ] && {
			[ "$1" = '-s' ] && {
				python "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/${L_NEX_APP:-run.py}"
			}
			[ $1 = '-r' -a -f "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/requirements.txt" -a -r "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/requirements.txt" ] && {
				pip install -r "$G_NEX_MOD_LIB/py/$L_NEX_APP_ROOT/requirements.txt"
				pip install --upgrade pip
			}
		}
		shift
		nx_py_venv $@
	}
}

