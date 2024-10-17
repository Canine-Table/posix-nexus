#!/bin/sh

awkIterpreter() {

    (
        # Attempt to find and set an awk variant, prioritizing common and lightweight versions
        AWK="$(
            command -v mawk ||          # Mawk is a fast and lightweight version of awk
            command -v nawk ||          # Nawk is the new awk, often used as the default on many systems
            command -v awk ||           # Awk is the original version, often a symlink to another variant
            command -v gawk ||          # Gawk is the GNU version of awk, feature-rich and widely used
            command -v busybox awk ||   # BusyBox awk is used in embedded systems
            false;                      # Ensure the chain returns a non-zero status if no awk variant is found
        )" || {
            # If no variant of awk is found, return 1 (failure)
            try -O 'C=awk';
            exit 1;

        } && {
            # Return 0 (success)
            echo -n "${AWK}";

        }
    )
}


try() {

    _kwargs() {

        (

            # Export the function name and flags for environment use
            export NAME="${1}"; # NAME
            export FLAGS="$(
                case "$(${AWK} 'BEGIN{ printf("%s", substr(ENVIRON["NAME"], length(ENVIRON["NAME"])))}')" in
                    P) ;;                       # Property flags _exceptionP
                    I) echo -n 'RshLtxwrfdep';; # Item flags for _exceptionI
                    T) ;;                       # Placeholder for T flag
                    C) echo -n 'R';;            # Placeholder for T flag
                    V) echo -n 'zn';;           # Value flags for _exceptionV
                    W) echo -n 'HAE';;          # Warning flags for _exceptionW
                    S) ;;                       # Placeholder for S flag
                    A) ;;                       # Placeholder for A flag
                    O) echo -n 'TMCDLRF';;      # Operating System flags for _exceptionO
                    R) echo -n 'N';;            # Regular Expressions flags for _exceptionR
                esac
            )"
            
            # Initialize the index
            INDEX=0;  

            # Iterate through the provided arguments, delimited by commas
            for VALUE in $(echo -n "${2}," | ${AWK} '{

                while((position = index(substr($0, last_position), character))) {

                    if (character == "=") {
                        character = ",";
                    } else {
                        character = "=";
                    }

                    print substr($0, last_position, position - 1);
                    last_position = last_position + position;

                }

                print substr($0, last_position, position - 1);

            }'); do

                INDEX=$((INDEX + 1));

                # For odd indexed elements, validate the key
                if [ $((INDEX % 2)) -eq 1 ]; then
                    ERROR_OCCURED=false;
                    export KEY="$(echo -n "${VALUE}" | ${AWK} '{

                        split(ENVIRON["FLAGS"], list, "");

                        for (flag in list) {
                            if (list[flag] == $0) {
                                printf("%s", $0);
                                delete list;
                                exit 0;
                            }

                            string = string "|" list[flag];
                            delete list[flag];

                        }

                        printf("[-] The option \x27%s\x27 is not one supported by the \x27%s\x27. The supported options are as follows: [%s]\x0a", $0, ENVIRON["NAME"], substr(string, 2));
                        delete list;
                        exit 1;

                    }')" || {
                        echo "${KEY}";
                        INDEX=$((INDEX + 1));
                        ERROR_OCCURED=true;
                        unset KEY;
                    }

                else
                    # For even indexed elements, evaluate the function with key and value
                    "${NAME}" "${KEY}" "${VALUE}" || {
                        case $? in
                            254) export ROOT_DIRECTORY="${_}/";;  # Special case handling
                            *) [ -n "${Q_SET}" ] && exit 1;;      # Handle errors
                        esac
                    }

                    ${ANSI_COLOR:-false} && echo -en "${ANSI_COLOR_VALUE:-$(_exceptionc E)}";

                fi

            done

        ) || ERROR_OCCURED=true;

        return 0;

    }

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
            export ANSI_COLOR_VALUE="$(echo -en "\x1b[0m\x1b[1;${ANSI_COLOR_VALUE}m")";
            echo -n "${ANSI_COLOR_VALUE}";
        }

        return 0;
    }

    _exceptionR() {
        # RegexError

        case "${1}" in
            N)
                echo -n "${2}" | ${AWK} '{ if ($0 ~ /^((_)?[[:alpha:]]{1}(_)?[[:alnum:]_]*)$/) { exit 0; } else { exit 1; } }' || {
                    echo "Invalid naming convention '${2}': Names must start with an optional underscore, followed by an alphabetic character, and can include alphanumeric characters and underscores.";
                    return 1;
                };;
        esac

    }

    _exceptionT() {
        # TypeError
        return 0;

    }

    _exceptionV() {
        # ValueErrors

        _variable() {
            [ -${KEY} "$(eval "echo -n \$${VALUE}")" ] || {
                return 1;
            }
        }

        case "${KEY}" in
            z) _variable || {
                    echo "The '${VALUE}' variable has already been assigned the value '$(eval "echo -n \$${VALUE}")'";
                    return 1;
                };;
            n)
                _variable || {
                    echo "The '${VALUE}' variable has not been defined or is empty";
                    return 1;
                };;
        esac

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

        _error() {
            echo "The task to ${1} '${VALUE}' failed. Manual intervention is required";
            return 1;
        }

        _success() {
            _exceptionc S;
            echo "The ${1} '${VALUE}' was successfully ${2}";
        }

        case "${KEY}" in
            C)
                command -v "${VALUE}" 1> /dev/null || {
                    echo "Your '$(uname -o)' system on '$(uname -n)' does not have the '${VALUE}' command installed";
                    return 1;
                };;
            D)
                {

                    [ -e "${VALUE}" ] || {

                        mkdir -p "${VALUE}" && {
                            _success "directory" "created";
                        }

                    } || _error "create the directory";

                };;
            M)
                {
                    [ -e "${VALUE}" ] || {
                        
                        mv "${VALUE}" "$(dirname "${VALUE}")/.$(basename "${VALUE}")-$(date +"%s").bak" && {
                            _success "item" "moved";
                        }

                    } || _error "move";

                };;
            T)
                {

                    [ -e "${VALUE}" ] || {

                        touch "${VALUE}" && {
                            _success "file" "created";
                        } || _error "create";

                    } 

                };;

            L)
                {
                    {
                        _exceptionc E;
                        eval "$(echo -n "${VALUE}" | awk '{
                            i = index($0, ":");
                            print "ln -sf " substr($0, 1, i - 1) " " substr($0, i + 1);
                        }')"  && _success "symbolic link" "created"

                    } || _error "link";

                };;

            R)
                {
                    [ -e "${VALUE}" ] && {

                        rm -rf "${VALUE}" && {
                            _success "item" "removed";
                        }

                    } || _error "remove";

                };;
            
            F) 

                {
                    {
                        mkfifo "${VALUE}" &&  _success "fifo file" "created";
                    } || _error "create the fifo file";
                };;


        esac

        return 0;

    }

    _exceptionI() {

        _item() {
            # Check if the key path exists in the root directory
            [ -${KEY} "${ROOT_DIRECTORY}${VALUE}" ] || {
                return 1;
            }

        }

        _output() {
            # Echo formatted error message
            echo "[${KEY}] The path to '${VALUE}' ${ROOT_DIRECTORY:+"within '${ROOT_DIRECTORY}' "}is not ${1}";
            return 1;
        }

        case "${1}" in

            R) 
                {
                    # Check if the working directory is a directory and executable
                    (
                        _kwargs "_exceptionI" "e=${2},r=${2},d=${2}";
                    ) && {
                        export ROOT_DIRECTORY="$(cd "${2}" && pwd)";
                        return 254;
                    } || {
                        return 1;
                    }

                };;

            e)
                _item || {
                    # Check if the path is a exists
                    echo "[${KEY}] Error: Path to $(basename "${VALUE}") does not exist ${ROOT_DIRECTORY:+"within '${ROOT_DIRECTORY}' directory"}";
                    return 1;
                };;

            d)
                _item || {
                    # Check if the path is a directory
                    _output "is not a directory.";
                    return 1;
                };;
            f)
                _item || {
                    # Check if the path is a file
                    _output "a file";
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
                _item "${ROOT_DIRECTORY}${2}" || {
                    # Check if the path is an executable
                    _output "an executable.";
                };;

            s) 
                _item || {
                    # Check if the path is a socket
                    _output "a socket";
                };;

            h|L) 
                _item || {
                    # Check if the path is a symbolic link
                    _output "a symbolic link";
                };;
            p)
                _item || {
                    # Check if the path is a fifo file (named pipe)
                    _output "a named pipe";
                };;

            t)
                _item || {
                    # Check if the path is attached to a terminal
                    _output "file that is not attached to a terminal";
                };;

        esac

    }

    _exceptionC() {

        _exceptionc W;

        case "${KEY}" in
            R) echo "Please execute the '${VALUE}' script to initialize the POSIX Nexus environment or ensure the correct file path is specified.";;
        esac

        return 0;
    }

    _exceptionW() {

        _exceptionc W;

        case "${KEY}" in
            H) echo "Undefined case, cannot handle argument: '${VALUE}'";;
            A) echo "An empty value was passed to _exceptionTemplate. The _exceptionTemplate requires an argument";;
            E) echo "Please fix the errors above before continuing";;
        esac

    }

    _exceptionTemplate() {

        [ "${1}" = 'q' ] && {
            Q_SET=true;
            return 0;
        }

        [ "${1}" = 'Q' ] && {
            Q_SET=false;
            return 0;
        }

        [ "${1}" = 'E' ] && {
            Q_SET="on";
            return 0;
        }

        [ -z "${2}" ] && {
            _kwargs "_exceptionW" "A=${1}";
            return 0;
        }

        (
            INDEX=0;
            _exceptionc E;

            while [ ${#@} -gt ${INDEX} ]; do
                ERROR_OCCURED=false;
                INDEX=$((INDEX + 2));

                case "${1}" in
                    c) _exception${1} "${2}";;
                    C|P|I|T|V|S|A|O|R|W) _kwargs "_exception${1}" "${2}" & PROCESS_IDS="${PROCESS_IDS} $!";;
                    ?) _kwargs "_exceptionW" "H=${2}";;
                    *) echo "The option '_exception${1}' is nor an existing function. The value '${2}' which was assigned to '_exception${1}' will be discarded.";;
                esac

                [ ${ERROR_OCCURED} = true ] && {
                    echo "[-] An unexpected error occurred within the '_exception${1}' while passing '${2}'.";
                    exit 0;
                }

                shift 2;

                [ -n "${Q_SET}" ] && {
                    wait ${PROCESS_IDS};
                    [ ${ERROR_OCCURED:-false} = true ] || exit 0;
                    unset PROCESS_IDS;

                }

            done

            wait ${PROCESS_IDS};
            exit ${INDEX};

        ) && case "${Q_SET}" in 
            on) export ERROR_ON_EXIT='on';;
            *) exit 1;;
        esac

        [ "${ERROR_ON_EXIT}" = 'on' ] && {
            _exceptionW E;
            exit 1;
        }

        return 0;
    }

    _exception() {

        export AWK="$(awkIterpreter)" || exit 1;

        # Dispatch to the appropriate error handling function based on the first argument
        while getopts :I:T:V:P:S:A:O:R:C:S:cEQq OPT; do
            case ${OPT} in
                E|q|Q) _exceptionTemplate ${OPT};;
                *) _exceptionTemplate "${OPT}" "${OPTARG}" || exit 2;;
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


startPosixNexus() {

    (

        export AWK="$(awkIterpreter)" || exit 1;
        # Check various paths and files using the _taskErrors function
        # Ensures all necessary directories and files exist and are accessible
        try -I "R=${1},\
            d=main,d=main,x=main,\
            e=main/awk,d=main/awk,x=main/awk,\
            e=main/awk/lib,d=main/awk/lib,x=main/awk/lib,r=main/awk/lib,\
            e=main/awk/lib/awk-interpreter.awk,f=main/awk/lib/awk-interpreter.awk,r=main/awk/lib/awk-interpreter.awk,\
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

        )"

    ) || exit;

}

if [ -e "$(cd "$(dirname "${0}")" && pwd)/main/sh/lib/posix-nexus.sh" ]; then
    startPosixNexus "$(cd "$(dirname "${0}")" && pwd)" "${@}";
else
    try -C 'R=run.sh';
    exit 1;
fi
