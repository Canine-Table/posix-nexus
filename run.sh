#!/bin/sh

_taskErrors() {

    _commonErrors() {

        _itemErrors() {

            # If the first argument is 'item', shift past it
            [ "${1}" = 'item' ] && shift;

            # If WORKING_DIRECTORY is not set, initialize it
            [ "${1}" = 'dir' ] && {
                WORKING_DIRECTORY="$(cd "${2}" && pwd)/";
                shift;

                # Check if WORKING_DIRECTORY is a directory and executable
                [ -d "${WORKING_DIRECTORY}" -a -x "${WORKING_DIRECTORY}" ] && {
                    shift;

                } || unset WORKING_DIRECTORY;

            }

            (
                INDEX=0;

                # Loop through all arguments
                while [ ${#@} -gt ${INDEX} ]; do
                    ERROR_OCCURED=false;

                    PATH_LOCATION="${WORKING_DIRECTORY}${2}";
                    INDEX=$((INDEX + 2));

                    case "${1}" in
                        e)
                            # Check if the path exists
                            [ -e "${PATH_LOCATION}" ] || {
                                printf "No match found for the relative path '%s' in the '%s' working directory" "${2}" "${WORKING_DIRECTORY}";
                                ERROR_OCCURED=true;

                            };;

                        d)
                            # Check if the path is a directory
                            [ -d "${PATH_LOCATION}" ] || {
                                printf "[${1}] The relative path to '%s' is already in use within the '%s' working directory" "${2}" "${WORKING_DIRECTORY}";
                                ERROR_OCCURED=true;

                            };;

                        f)
                            # Check if the path is a regular file
                            [ -f "${PATH_LOCATION}" ] || {
                                printf "[${1}] The the relative path to '%s' exists within '%s' but '%s' is a not regular file" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
                                ERROR_OCCURED=true;

                            };;

                        r)
                            # Check if the path is readable
                            [ -r "${PATH_LOCATION}" ] || {
                                printf "[${1}] The path to '%s' exists within '%s' but '%s' is not readable" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
                                ERROR_OCCURED=true;

                            };;
                        w)
                            # Check if the path is writable
                            [ -w "${PATH_LOCATION}" ] || {
                                printf "[${1}] The path to '%s' exists within '%s' but '%s' is not writable" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
                                ERROR_OCCURED=true;

                            };;

                        x)
                            # Check if the path is executable
                            [ -x "${PATH_LOCATION}" ] || {
                                printf "[${1}] The path to '%s' exists within the '%s' root directory but '%s' is not executable" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
                                ERROR_OCCURED=true;

                            };;

                        item|static)
                            # Handle common errors
                            _commonErrors "${@}" &
                            exit 0;;
                    esac

                    shift 2;

                    "${ERROR_OCCURED}" && {
                        printf ".\x0a";
                        "${QUIT_ON_ERROR:-false}" && exit 0;
                    }

                done

                exit ${INDEX};

            ) && exit 2;

            shift $?;

            [ ${#@} -gt 1 ] && _itemErrors "${@}";

        }

        _staticErrors() {

            [ "${1}" = 'static' ] && shift;

            (
                INDEX=0;

                while [ ${#@} -gt ${INDEX} ]; do
                    ERROR_OCCURED=false;
                    INDEX=$((INDEX + 1));

                    case "${1}" in
                        S)
                            # If source error, provide a message and set ERROR_OCCURED
                            {
                                echo "[-] Please execute the 'run.sh' script to initialize the POSIX Nexus environment or ensure the correct file path is specified";
                                ERROR_OCCURED=true;

                            };;
                        item|static)
                            # Handle common errors
                            _commonErrors "${@}" &
                            exit 0;;

                    esac

                    shift;

                    ${ERROR_OCCURED} && {
                        "${QUIT_ON_ERROR:-false}" && exit 0;
                    }

                done

                exit ${INDEX};

            ) && exit 3;

            shift $?;

            [ ${#@} -gt 0 ] && _staticErrors "${@}";

        }

        # Dispatch to the appropriate error handling function based on the first argument
        case "${1}" in
            item) _itemErrors "${@}";;
            static) _staticErrors "${@}";;
            # Default case for unknown argument, print help message
            *) printf "[-] Undefined case, cannot handle argument: %s\x0a" "${1}";;
        esac

    }

    (

        trap 'echo -en "${ANSI_COLOR:+\\033[0m}"; exec 1>&-' EXIT;

        case "${TERM}" in
            screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*) ANSI_COLOR='\033[1;31m';;
        esac

        exec 1>&2;

        echo -en "${ANSI_COLOR}";

        # If the number of arguments exceeds 256, return an error
        [ ${#@} -gt 255 ] && {
            echo "[-] Too many arguments provided, maximum is 255.";
            exit 1;

        }

        # If the first argument is 'Q', enable QUIT_ON_ERROR and shift past it
        [ "${1}" = 'Q' ] && {
            QUIT_ON_ERROR='true';
            shift;

        }

        _commonErrors "${@}";

    )

}

_startPosixNexus() {

    (

        # Check various paths and files using the _taskErrors function
        # Ensures all necessary directories and files exist and are accessible
        _taskErrors 'item' 'dir' "${1}" \
            e 'main' d 'main' x 'main' \
            e 'main/awk' d 'main/awk' x 'main/awk' \
            e 'main/awk/lib' d 'main/awk/lib' x 'main/awk/lib' r 'main/awk/lib' \
            e 'main/sh' d 'main/sh' x 'main/sh' \
            e 'main/sh/lib' d 'main/sh/lib' x 'main/sh/lib' r 'main/sh/lib' \
            e 'main/sh/lib/posix-nexus.sh' f 'main/sh/lib/posix-nexus.sh' r 'main/sh/lib/posix-nexus.sh' || exit;

        # Set the root directory for POSIX Nexus
        export POSIX_NEXUS_ROOT="${1}";
        shift;

        # Read and evaluate the content of posix-nexus.sh, appending each argument wrapped in single quotes and spaces.
        eval "$(cat "${POSIX_NEXUS_ROOT}/main/sh/lib/posix-nexus.sh")$(
            while [ ${#@} -gt 0 ]; do
                echo -en "\x20\x27${1}\x27";
                shift;

            done

        )";

    ) || exit;

}

if [ -e "$(cd "$(dirname "${0}")" && pwd)/main/sh/lib/posix-nexus.sh" ]; then
    _startPosixNexus "$(cd "$(dirname "${0}")" && pwd)" "${@}";
else
    _taskErrors static S;
    exit 1;
fi
