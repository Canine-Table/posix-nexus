#!/bin/sh

try() {

    _error() {

        # Set color to error (red) and display the error symbol
        _color E true;
        
        # Output the error message
        echo "${*}";

        #10: Quit immediately on the first error.
        #11: Quit on the first chunk of errors (one chunk refers to one optarg iteration).
        #12: Exit if any error occurs.
        case "${STATUS}" in
            Q) exit 10;;
            E) _status 11;;
            *) _status 12;;
        esac

        return 0;
    }

    _success() {
        # Set color to success (green) and display the success symbol
        _color S true;
        # Output the success message
        echo "${*}";
    }

    _warning() {
        # Set color to warning (yellow) and display the warning symbol
        _color W true;
        # Output the warning message
        echo "${*}";
    }

    _debug() {
        # Set color to debug (magenta) and display the debug symbol
        _color D true;
        # Output the debug message
        echo "${*}";
    }

    _info() {
        # Set color to info (blue) and display the info symbol
        _color I true;
        # Output the info message
        echo "${*}";
    }

    _awk() {

        # Attempt to find and set an awk variant, prioritizing common and lightweight versions
        export AWK="$(
            command -v mawk ||          # Mawk is a fast and lightweight version of awk
            command -v nawk ||          # Nawk is the new awk, often used as the default on many systems
            command -v awk ||           # Awk is the original version, often a symlink to another variant
            command -v gawk ||          # Gawk is the GNU version of awk, feature-rich and widely used
            command -v busybox awk ||   # BusyBox awk is used in embedded systems
            false;                      # Ensure the chain returns a non-zero status if no awk variant is found
        )" || {
            # If no variant of awk is found, exit 2 (failure)
            _exceptionC A;
            exit 2;
        }
    }

    _shell() {

        # Attempt to find and set a POSIX-compliant shell, prioritizing speed
        export SHELL="$(
            command -v dash ||          # Dash is very fast and lightweight
            command -v ash ||           # Ash is also lightweight and fast
            command -v sh ||            # Bourne shell is generally fast
            command -v mksh ||          # MirBSD Korn Shell is lightweight
            command -v posh ||          # Policy-compliant Ordinary Shell is minimal
            command -v yash ||          # Yet Another Shell is focused on correctness
            command -v ksh ||           # KornShell is balanced in performance and features
            command -v loksh ||         # Loksh is a lightweight version of ksh
            command -v pdksh ||         # Public Domain Korn Shell is another ksh variant
            command -v bash ||          # Bash is feature-rich but slightly heavier
            command -v zsh ||           # Zsh is powerful but can be heavier
            command -v fish ||          # Fish is user-friendly but not as lightweight
            command -v busybox sh ||    # BusyBox shell is used in embedded systems
            false;                      # Ensure the chain returns a non-zero status if no shell is found
        )" || {
            # If no shell is found, exit 1 (failure)
            _exceptionC S;
            exit 1;
        }

    }

    _color() {

        # Check if color setting is enabled
        ${C_SET:-false} && SET_C="$(

            case "${1:-E}" in
                E) printf "%d" 31;; # Error (Red)
                S) printf "%d" 32;; # Success (Green)
                W) printf "%d" 33;; # Warning (Yellow)
                I) printf "%d" 34;; # Info (Blue)
                D) printf "%d" 35;; # Debug (Magenta)
            esac

            exit 0;

        )" && {
            # Set the color and prefix symbol if second parameter is true
            echo -en "\x1b[0m\x1b[1;${SET_C}m";
        }

        # Set the prefix symbol if the second parameter is true
        echo -n "$(
            [ "${2}" = true ] && case "${1}" in
                E) echo -n "[X] ";;  # Error symbol
                S) echo -n "[V] ";;  # Success symbol
                W) echo -n "[!] ";;  # Warning symbol
                I) echo -n "[i] ";;  # Info symbol
                D) echo -n "[B] ";;  # Debug symbol
            esac
        )";
    }

    _status() {

        case "${1}" in

            # If the status file exists, retrieve the status and remove the file
            R)
                [ -f "/tmp/try-status-$$" ] && {
                    STATUS="$(_status G)";
                    rm -f "/tmp/try-status-$$";
                    return ${STATUS:-0};
                };;

            # If the status file exists, output its content
            G)
                [ -f "/tmp/try-status-$$" ] && {
                    cat "/tmp/try-status-$$";
                };;

            # Write the given status code to the status file
            *) printf "%d" "${1}" > "/tmp/try-status-$$";
        esac

    }

    _exceptionC() {
        _color E true;

        _missing() {
            # Output a message indicating that a required POSIX compatible tool needs to be installed
            echo "The posix-nexus requires a posix compatible ${1} to be installed.";
            # Provide possible options for the missing tool
            _possible "${2}";
        }

        _invalid() {
            # Output a message indicating that the provided option is not supported by the function
            echo "The option '${1}' is not one of the flags the '${2}' function supports.";
            # List the supported options for the function
            _options "${3}";
        }

        _possible() {
            _color I true;
            # Output possible options for the required tool
            echo "Possible options: ${1}";
        }

        _options() {
           _color I true;
            # Format and output the supported options for a function
            echo "${1}" | awk '{
                gsub(//, "|", $0);
                print "Supported options are: [" substr($0, 2, length($0) - 2) "]";
            }';

        }

        # Handle different exception cases
        case "${1}" in
            R) echo "Please execute the '${2}' script to initialize the POSIX Nexus environment or ensure the correct file path is specified.";;
            E) echo "The '${2}' subroutine does not support the '-${3}' flag.";;
            I) echo "The '-${1}' flag of the '${2}' subroutine requires an argument.";;
            S) _missing "'shell'" "[dash|ash|sh|mksh|posh|yash|ksh|loksh|pdksh|bash|zsh|fish|busybox]";;
            A) _missing "'awk' interpreter" "[mawk|nawk|awk|gawk|busybox]";;
            F) _invalid "${1}" "${2}" "${3}";;
            *) _invalid "${1}" "_exceptionC" "REISAF";;
        esac

        return 0;
    }

    _exceptionI() {

        _item() {
            # Check if the key path exists in the root directory
            [ -${KEY} "${WORKING_DIRECTORY}${VALUE}" ] || {
                return 1;
            }

        }

        _output() {
            # Echo formatted error message
            _error "The path to '${VALUE}' ${WORKING_DIRECTORY:+"within '${WORKING_DIRECTORY}' "}is not ${1}.";
        }

        case "${KEY}" in

            R)
                {
                    # Check if the working directory is a directory and executable
                    (
                        _exceptionTemplate "_exceptionI" "e=${VALUE},r=${VALUE},d=${VALUE}";
                    ) && {
                        export WORKING_DIRECTORY="$(cd "${VALUE}" && pwd)/";
                    } || {
                        _warning "The root directory '${VALUE}' will be skipped as it does not meet the requirements.";
                    }

                    return 0;
                };;

            e)
                _item || {
                    # Check if the path exists
                    _error "Path to $(basename "${VALUE}") does not exist ${WORKING_DIRECTORY:+"within '${WORKING_DIRECTORY}' directory"}";
                };;

            d)
                _item || {
                    # Check if the path is a directory
                    _output "is not a directory.";
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
                _item "${WORKING_DIRECTORY}${2}" || {
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

        esac

    }

    _exceptionR() {
        # RegexError

        case "${KEY}" in
            N)
                # Check naming convention using AWK. Names must start with an optional underscore, 
                # followed by an alphabetic character, and can include alphanumeric characters and underscores.
                echo -n "${VALUE}" | ${AWK} '{ if ($0 ~ /^((_)?[[:alpha:]]{1}(_)?[[:alnum:]_]*)$/) { exit 0; } else { exit 1; } }' || {
                    # Display error message if naming convention is invalid
                    _error "Invalid naming convention '${VALUE}': Names must start with an optional underscore, followed by an alphabetic character, and can include alphanumeric characters and underscores.";
                };;
        esac
    }

    _exceptionTemplate() {

        (
            # Export the function name and its supported flags for environment use
            export NAME="${1}";
            export FLAGS="$(
                case "$(${AWK} 'BEGIN{ printf("%s", substr(ENVIRON["NAME"], length(ENVIRON["NAME"])))}')" in
                    I) echo -n 'RshLtxwrfdep';; # Item flags for _exceptionI
                    C) echo -n 'REISAF';;       # Custom flags for _exceptionC
                    V) echo -n 'zn';;           # Value flags for _exceptionV
                    W) echo -n 'HAE';;          # Warning flags for _exceptionW
                    O) echo -n 'TMCDLRF';;      # Operating System flags for _exceptionO
                    R) echo -n 'N';;            # Regular Expressions flags for _exceptionR
                esac
            )"

            # Initialize the index
            INDEX=0;

            # Iterate through the provided arguments, delimited by , and =
            for VALUE in $(echo -n "${2}," | ${AWK} '{

                # Loop to process the input string, alternating the character between '=' and ','
                while((position = index(substr($0, last_position), character))) {

                    if (character == "=") {
                        character = ",";
                    } else {
                        character = "=";
                    }

                    # Print the substring from last_position up to the current position
                    print substr($0, last_position, position - 1);
                    last_position = last_position + position;

                }

                # Print the last substring after the final delimiter
                print substr($0, last_position, position - 1);

            }'); do

                INDEX=$((INDEX + 1));

                # For odd indexed elements, validate the key
                if [ $((INDEX % 2)) -eq 1 ]; then
                    export KEY="$(echo -n "${VALUE}" | ${AWK} '{

                        split(ENVIRON["FLAGS"], list, "");

                        for (flag in list) {
                            if (list[flag] == $0) {
                                printf("%s", $0);
                                delete list;
                                exit 0;
                            }

                        }

                        delete list;
                        exit 1;

                    }')" || {
                        _exceptionC "${VALUE}" "${NAME}" "${FLAGS}";
                        INDEX=$((INDEX + 1));
                        unset KEY;
                    }

                else
                    # For even indexed elements, evaluate the function with key and value
                    "${NAME}" "${KEY}" "${VALUE}" || exit 10;
                fi

            done

            case "$(_status G)" in
                *11)  exit 11;
            esac

            return 0;

        ) || exit;

    }

    _exception() {
        # Call the _exceptionTemplate function with the given exception and argument, or exit if it fails
        _exceptionTemplate "_exception${1:-OPT}" "${2:-OPTARG}" || exit;
    }

    (

        # Ensure the terminal is reset on exit and retrieve the status
        trap 'echo -en "${C_SET:+\\x1b[0m}"; _status R; exec 1>&-' EXIT;

        # Redirecting standard output to standard error, commonly done for logging
        exec 1>&2;

        # Check the terminal type and enable color if it matches one of the listed types
        case "${TERM}" in
            screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*) C_SET=true;;
        esac

        _shell;
        _awk;

        # Dispatch to the appropriate error handling function based on the first argument
        while getopts :I:C:V:W:O:R:EQ OPT; do

            # Process command-line options
            case ${OPT} in
                # Set status to quit (Q) or error (E)
                E|Q) STATUS="${OPT}";;
                # Handle missing arguments
                \:) _exceptionC I try "${OPTARG}";;
                # Handle unknown options
                \?) _exceptionC E try "${OPTARG}";;
                # Process other options
                *) _exception "${OPT}" "${OPTARG}";;
            esac
        done

        # Check the status and exit accordingly
        case "$(_status G)" in
            *12)  exit 12;;
            *) exit 0;;
        esac
    ) && {
        _shell;
        _awk;
    }
}

startPosixNexus() {

    (

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
