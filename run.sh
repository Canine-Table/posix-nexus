#!/bin/sh

try() {

    _exceptionc() {

        ${ANSI_COLOR:-false} && ANSI_COLOR_VALUE="$(

            case "${1}" in
                E) printf "%d" 31;; # Success
                S) printf "%d" 32;; # Error
                W) printf "%d" 33;; # Warning
                D) printf "%d" 35;; # Debug
                *) exit 1;;
            esac

            exit 0;

        )" && {
            echo -en "\x1b[0m\x1b[1;${ANSI_COLOR_VALUE}m";
        }

        unset ANSI_COLOR_VALUE;
        return 0;
    }

    _exceptionR() {
        # RegexError
        echo "${1}";
   
        return 1;

    }

    _exceptionT() {
        # TypeError
        return 0;

    }

    _exceptionV() {
        # ValueError
        return 0;

    }

    _exceptionS() {
        # SyntaxError
        return 0;

    }

    _exceptionA() {
        # ArithmeticError
        return 0;
        
    }

    _exceptionP() {
        # PropertyError
        return 0;

    }

    _exceptionO() {
        # OSError
        return 0;

    }

    _exceptionI() {

        (

            _item() {
                # Check if the key path exists in the root directory
                [ -${KEY} "${ROOT_DIRECTORY}/${J}" ] || {
                    ERROR_OCCURED=true;
                    return 1;
                }

            }

            _output() {
                # Echo formatted error message
                echo "[${KEY}] The path to '${J}' ${ROOT_DIRECTORY:+"within '${ROOT_DIRECTORY}' "}is not ${1}";
            }

            INDEX=0;

            for I in $(iterator ',' "${@}"); do
                ERROR_OCCURED=false;

                for J in $(iterator '=' "${I}"); do
                    INDEX=$((INDEX + 1));

                    if [ $((INDEX % 2)) -eq 1 ]; then
                        case "${J}" in
                            R|s|h|L|t|x|w|r|f|d|e|p) KEY="${J}";;
                            *) echo "[-] The option '${J}' is not supported by _exceptionI: [R|s|h|L|t|x|w|r|f|d|e|p]";;
                        esac
                    else

                        case "${KEY}" in

                            R) 
                                {
                                    # Check if the working directory is a directory and executable
                                    _exceptionI "e=${J},d=${J},x=${J}" && ROOT_DIRECTORY="$(cd "${J}" && pwd)";
                                };;

                            e)
                                _item || {
                                    # Check if the path is a exists
                                    echo "[${KEY}] Error: Path to $(basename "${J}") does not exist ${ROOT_DIRECTORY:+"within in '${ROOT_DIRECTORY}' directory"}";
                                };;

                            d)
                                _item || {
                                    # Check if the path is a directory
                                    _output "is not directory.";
                                };;
                            f)
                                _item || {
                                    # Check if the path is a file
                                    _output "file";
                                };;

                            r)
                                _item || {
                                    # Check if the path is an readable
                                    _output "readable.";
                                };;

                            w)
                                _item || {
                                    # Check if the path is an writable
                                    _output "writable.";
                                };;

                            x)
                                _item "${ROOT_DIRECTORY}${J}" || {
                                    # Check if the path is an executable
                                    _output "an executable.";
                                };;

                            s) 
                                _item || {
                                    # Check if the path is a socket
                                    _output "socket";
                                };;

                            h|L) 
                                _item || {
                                    # Check if the path is a symbolic link
                                    _output "symbolic link";
                                };;
                            p)
                                _item || {
                                    # Check if the path is a fifo file (named pipe)
                                    _output "named pipe";
                                };;

                            t)
                                _item || {
                                     # Check if the path is attached to a terminal
                                    _output "file that is not attached to a terminal";
                                    ERROR_OCCURED=true;

                                };;

                        esac

                    fi

                done

                (${q_SET:-false} && ${ERROR_OCCURED:-false}) && exit 1;

            done

        ) || ERROR_OCCURED=true;

       return 0;
    }

    _exceptionC() {

        case $(echo -n "${1}" | cut -c 1) in
            H) _exceptionc W; echo "Undefined case, cannot handle argument: '-$(echo "${1}" | cut -c 3-)'.";;
            R) echo "Please execute the 'run.sh' script to initialize the POSIX Nexus environment or ensure the correct file path is specified.";;
            A) _exceptionc W; echo "The '-$(echo "${1}" | cut -c 3-)' exception requires an argument.";;
            U) _exceptionc W; echo -e "Unknown option '-$(echo "${2}" | cut -d ',' -f 1)'. The parameter '$(echo "${2}" | cut -d ',' -f 2)' assigned to '$(echo "${2}" | cut -d ',' -f 1)' will be discarded.";;
            *) _exceptionc W;  echo "[-] The option '$(echo -n "${1}" | cut -c 1)' is not supported and will be skipped: [H|R|A|U]";;
        esac

        _exceptionc E;
        return 0;
    }

    _exceptionTemplate() {

        [ "${1}" = 'q' ] && {
            q_SET=true;
            return 0;
        }

        [ "${1}" = 'Q' ] && {
            q_SET=false;
            return 0;
        }

        [ -z "${2}" ] && {
            _exceptionC A;
            return 1;
        }

        (
            INDEX=0;
            _exceptionc E;

            while [ ${#@} -gt ${INDEX} ]; do
                ERROR_OCCURED=false;
                INDEX=$((INDEX + 2));

                case "${1}" in
                    c) _exception${1} "${2}";;
                    P|I|C|T|V|S|A|O|R) _exception${1} "${2}" & PROCESS_IDS="${PROCESS_IDS} $!";;
                    *) _exceptionC U "${1},${2}";;
                esac

                [ ${ERROR_OCCURED} = true ] && echo "[-] An unexpected error occurred within the '_exception${1}' while passing '${2}'." && exit 1;

                shift 2;

                ${q_SET:-false} && {
                    wait ${PROCESS_IDS};
                    [ $? -gt 0 ] && exit 0;
                    unset PROCESS_IDS;

                }

            done

            wait ${PROCESS_IDS};
            exit ${INDEX};

        ) && exit 1;

        return 0;
    }

    _exception() {

        # Dispatch to the appropriate error handling function based on the first argument
        while getopts :I:T:V:P:S:A:O:R:C:S:cQq OPT; do
            case ${OPT} in
                q|Q) _exceptionTemplate ${OPT};;
                c|I|P|C|T|V|S|A|O|R) _exceptionTemplate "${OPT}" "${OPTARG}";;
                ?) _exceptionTemplate C "H ${OPTARG}";;
            esac
        done

        shift $((OPTIND - 1));

        return 0;

    }
    
    (

        trap 'echo -en "${ANSI_COLOR:+\\x1b[0m}"; exec 1>&-' EXIT;

        exec 1>&2;

        case "${TERM}" in
            screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*) ANSI_COLOR=true;;
        esac

        _exception "${@}";
    )
}

iterator() {

    # Process the input string using Awk with the specified field separator (FS)
    echo -n "${*}" | awk -v FS="${1}" '{
        for (i = 1; i <= NF; ++i) {
            # Remove leading and trailing whitespace from each field
            gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", $i);
            if ($i) {
                # Print each non-empty field
                print $i;
            }
        }
    }'

    return 0;
}


startPosixNexus() {

    (

        # Check various paths and files using the _taskErrors function
        # Ensures all necessary directories and files exist and are accessible
        try -I "R=${1},\
        d=main,d=main,x=main,\
        e=main/awk,d=main/awk,x=main/awk,\
        e=main/awk/lib,d=main/awk/lib,x=main/awk/lib,r=main/awk/lib,\
        e=main/sh,d=main/sh,x=main/sh \
        e=main/sh/lib,d=main/sh/lib,x=main/sh/lib,r=main/sh/lib,\
        e=main/sh/lib/posix-nexus.sh,f=main/sh/lib/posix-nexus.sh,r=main/sh/lib/posix-nexus.sh" || exit;

        # Set the root directory for POSIX Nexus
        export POSIX_NEXUS_ROOT="${1}";
        shift;

        # Read and evaluate the content of posix-nexus.sh, appending each argument wrapped in single quotes and spaces.
        eval "$(cat "${POSIX_NEXUS_ROOT}/main/sh/lib/posix-nexus.sh")$(
            echo -en "\x0aposixNexusDaemon";

            while [ ${#@} -gt 0 ]; do
                echo -en "\x20\x27${1}\x27";
                shift;

            done

        )";

    ) || exit;

}


if [ -e "$(cd "$(dirname "${0}")" && pwd)/main/sh/lib/posix-nexus.sh" ]; then
    startPosixNexus "$(cd "$(dirname "${0}")" && pwd)" "${@}";
else
    try -C R;
    exit 1;
fi
