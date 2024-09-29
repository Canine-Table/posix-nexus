#!/bin/sh

function _posix() {

    if [ "${1}" = '-B' -o "${1}" = "--benchmark" ]; then
        "/usr/local/include/posix/posix.d/testing/benchmarks.sh" "${@}"
    elif  [ "${1}" = '-C' -o "${1}" = "--core" ]; then
        "/usr/local/include/posix/posix.d/sh/lib/core-utilities.sh" "${@}";
    fi

    return $?;
}

_posix "${@}";
echo -e "\nReturned: ${?}";
