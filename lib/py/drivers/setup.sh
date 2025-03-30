#!/bin/sh

[ -z "$G_NEX_MOD_LIB" ] && return 1
L_NEX_APP_ROOT='drivers' L_NEX_APP='run.py' set_py_venv $@

