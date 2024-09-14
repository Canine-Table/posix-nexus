#!/bin/sh

function _posix() {
    echo "${@}" | awk \
        -f '/usr/local/include/posix/posix.d/awk/awk-utilities.awk' \
        -f '/usr/local/include/posix/posix.d/awk/awk-stage.awk' \
        -f '/usr/local/include/posix/posix.d/awk/testing-utilities.awk';
    return 0;
}

_posix "${@}" /dev/null;
