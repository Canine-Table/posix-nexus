#!/bin/sh

nx_fs_mount \
	-r \
	-c 'sudo' \
	-p "$NEXUS_LIB/py/flask/nexus/" \
	-l 'webgl/static/glsl/' -M \
	-l 'static/img/' -M

nx_py_venv \
	-A flask -d


