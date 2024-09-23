function _trapper() {

    # Check if the first argument is provided and assign it to TRAPPER_APPEND
    while getopts :T:M:L: OPT; do
        case ${OPT} in
            H|S) UNIQUE_PROPERTIES["${OPT}"]='true';;
        esac
    done

    [ -n "${1}" ] && {
        TRAPPER_APPEND="${1}";
        shift;
    } || return 255;

    # Check if the second argument is provided and determine the trap signal
    [ -n "${1}" ] && {
        for TRAPPER_TRAP in $(trap -l | awk '{for (i = 2; i <= 64; i+=2) {print $i}}' | awk '{if ($0 !~ /^$/) {printf $1 " "}}') 'RETURN' 'EXIT' 'DEBUG'; do
            [ "${1^^}" = "${TRAPPER_TRAP}" ] && {
                TRAPPER_TRAP="${1^^}";
                break;
            }

            TRAPPER_TRAP="";
        done

        shift;

    }

    # Default to 'EXIT' if no valid trap signal is found
    [ -z "${TRAPPER_TRAP}" ] && return 228;

    # Check if a trap is already set for the specified signal
    trap -p "${TRAPPER_TRAP}" | awk '{if ($3 ~ /^-$/) {exit 0} else {exit 1}}' && {
        # Set a new trap if no trap is set
        trap "${TRAPPER_APPEND}" "${TRAPPER_TRAP}";
    } || {
        # Append to the existing trap command if a trap is already set
        trap "$(trap -p "${TRAPPER_TRAP}" | awk '{
            if (match($0, "\x27.*\x27")) {
                print substr($0, RSTART + 1, RLENGTH - 2);
            }
        }'); ${TRAPPER_APPEND}" "${TRAPPER_TRAP}";
    }

    # Cleanup temporary variables
    trap 'unset TRAPPER_TRAP TRAPPER_APPEND' RETURN EXIT SIGINT;
    return 0;
}


function _classify() {

    _trapper 'unset CLASSIFY_LOCATION CLASSIFY_CLASSIFICATION CLASSIFY_DIRNAME CLASSIFY_BASENAME' EXIT;

    CLASSIFY_LOCATION="$(_exist "${1}")" && shift || return 228;
    CLASSIFY_BASENAME="$(basename "${CLASSIFY_LOCATION}")";
    CLASSIFY_DIRNAME="$(realpath "$(dirname "${CLASSIFY_LOCATION}")")";

    [ -d "${CLASSIFY_LOCATION}" ] && {
        CLASSIFY_DIRNAME="$(realpath "${CLASSIFY_LOCATION}/..")";
    }

    CLASSIFY_CLASSIFICATION="$(ls --color=never -al "${CLASSIFY_DIRNAME}" | grep "${CLASSIFY_BASENAME}" | cut -c1)" && case "${CLASSIFY_CLASSIFICATION}" in
        -|l|b|p|c|d)
            [ -z "${1}" ] && {
                echo -n "${CLASSIFY_CLASSIFICATION}";
                return 0;
            } || [ "${CLASSIFY_CLASSIFICATION}" = "${1}" ] && {
                return 0;
            }
        ;; *) return 228;;
    esac

    return 1;
}


function _awkFactory() {

    command -v awk 1> /dev/null || return 1;

    echo -n "${0}" | grep -q '[[:alnum:]]*-utilities.sh' && {
        _trapper 'unset POSIX_AWK' EXIT;
        POSIX_AWK="$(realpath "$(dirname "${0}")/../awk")";

        [ -z "${POSIX_AWK_LIBRARY}" ] && {
            [ -d "${POSIX_AWK}/lib" -a -r "${POSIX_AWK}/lib" ] && {
                export POSIX_AWK_LIBRARY="${POSIX_AWK}/lib";
            } || {
                unset POSIX_AWK;
                return 2;
            }
        }

        [ -z "${POSIX_AWK_BIN}" ] && {
            [ -d "${POSIX_AWK}/bin" -a -r "${POSIX_AWK}/bin" ] && {
                export POSIX_AWK_BIN="${POSIX_AWK}/bin";
            } || {
                unset POSIX_AWK;
                return 3;
            }
        }
    }

    [ -z "${POSIX_AWK_FILES}" ] && {
        for POSIX_AWK in ${POSIX_AWK_LIBRARY}/*-utilities.awk; do
            [ -f "${POSIX_AWK}" -a -r "${POSIX_AWK}" ] && {
                POSIX_AWK_FILES="${POSIX_AWK_FILES} -f \"${POSIX_AWK}\"";
            }
        done
    }

    [ -n "${1}" ] && {
        POSIX_AWK="${POSIX_AWK_BIN}/${1}";
        [ -f "${POSIX_AWK}" -a -r "${POSIX_AWK}" ] && {
            echo "${*:2}" | awk "${POSIX_AWK_FILES} -f \"${POSIX_AWK}\"";
        }
    } || return 228;
}

# _awkFactory 'testing.awk' "hello worlld";
_awkFactory 'testing.awk' "${@}";
