nx_fs_mount \
	-r \
	-c 'sudo' \
	-p "$NEXUS_LIB/py/flask/nexus" \
	-P "$NEXUS_LIB" \
	-l 'webgl/static/glsl' -L 'glsl' -m \
	-l 'static/img' -L '../img' -m

nx_py_venv \
        -A flask \
        -a $@ -s

