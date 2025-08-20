#!/bin/sh

test -z "$NEXUS_LIB" && return 1
L_NEX_APP_ROOT='drivers' L_NEX_APP='run.py' nx_py_venv $@

