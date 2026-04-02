
mount | grep -q "$NEXUS_LIB/py/flask/nexus/webgl/static/glsl/" || {
	sudo mount --bind $NEXUS_LIB/glsl $NEXUS_LIB/py/flask/nexus/webgl/static/glsl
}

mount | grep -q "$NEXUS_LIB/py/flask/nexus/static/img/" || {
	sudo mount --bind $NEXUS_LIB/../img $NEXUS_LIB/py/flask/nexus/static/img
}



nx_py_venv \
        -A flask \
        $@

