#!/bin/sh

[ -z "$G_NEX_MOD_LIB" ] && return 1
L_NEX_APP='nex-init.py'
L_NEX_APP_ROOT='gimp' nx_py_venv $@
ln -f "$(nx_content_path "$L_NEX_APP")" "$G_NEX_GIMP_PLUG/$L_NEX_APP"

