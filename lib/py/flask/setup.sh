#!/bin/sh

[ -z "$G_NEX_MOD_LIB" ] && return 1
L_NEX_APP_ROOT='flask' L_NEX_APP='run.py' nx_py_venv $@

