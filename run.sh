#!/bin/sh

cmd() {

    while [ ${#@} -gt 0 ]; do
        command -v "${1}" && return;
        shift;
    done

    return 1;
}

unQuote() {

    echo -n $* | ${AWK} '{
        # Remove leading and trailing whitespace
        gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", $0);

        # Get the first character of the input
        start_of_record = substr($0, 1, 1);
        
        # Get the last character of the input
        end_of_record = substr($0, length($0));

        # Check if the input starts and ends with the same quote character
        if ((start_of_record == "\x27" || start_of_record == "\x22") && start_of_record == end_of_record) {
            # Remove the quotes
            printf("%s", substr($0, 2, length($0) - 2));

        } else {
            # Print the input as-is
            printf("%s", $0);                

        }

    }';

}

join() {
    echo -n $* | ${AWK} '{
        printf("%s\x20", $0);
    }';
}

tolower() {
    echo -n $* | ${AWK} '{
        printf("%s", tolower($0));
    }';
}

toupper() {
    echo -n  $* | ${AWK} '{
        printf("%s", toupper($0));
    }';
}

format() {
    echo -en "${1}:" | ${AWK} -v msg="${2}" '
    function format() {

        if ((i = index(param["str"], "\x3a"))) {
            do {
                param["cur"] = substr(param["str"], 1, i - 1);
                gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", param["cur"]);
                param["str"] = substr(param["str"], i + 1);
                param["idx"] = param["idx"] + 1;
                
                if (! gsub("<" param["idx"] ">", param["cur"], param["msg"])) {
                    sub("<>", param["cur"], param["msg"]);
                }

            } while ((i = index(param["str"], "\x3a")));
        }
    }

    BEGIN {
        param["msg"] = msg;
    } {
        param["str"] = param["str"] "" $0;
        format();
        gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", param["msg"]);
        print param["msg"];
        delete param;
        exit 0;
    }';
}

kwargs() {
    echo $*, | ${AWK} '
    function kwargs() {
        # Set the initial character to equal sign if not set
        if (!(char in param)) {
            param["char"] = "\x3d";
        }

        # Find the index of the current character in the string
        if ((i = index(param["str"], param["char"]))) {
            do {
                tmp = substr(param["str"], 1, i - 1);

                # Trim whitespace
                gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", tmp); 

                # Print the processed value or NULL if empty
                if (tmp) {
                    gsub(/ /, "\\x20", tmp);
                    print tmp;
                } else {
                    print "NULL";
                }

                param["str"] = substr(param["str"], i + 1);
                # Toggle the character between comma and equal sign
                if (param["char"] == "\x2c") {
                    param["char"] = "\x3d";
                } else {
                    param["char"] = "\x2c";
                }

            } while ((i = index(param["str"], param["char"])));
        }
    }

    {
        param["str"] = param["str"] "" $0;
        kwargs();
        delete param;
        exit 0;
    }';

}

ref() {
    eval "eval echo -en '\$${1}'";
}

try() {

    _error() {

        # Set color to error (red) and display the error symbol
        _style E true;

        # Output the error message
        echo $*;

        #10: Quit immediately on the first error.
        #11: Quit on the first chunk of errors (one chunk refers to one optarg iteration).
        #12: Exit if any errors occur.

        case "${STATUS}" in
            Q) exit 10;;
            E) _status 11;;
            *) _status 12;;
        esac

        return 0;
    }

    _success() {
        # Set color to success (green) and display the success symbol
        _style S true;
        # Output the success message
        echo $*;
    }

    _warning() {
        # Set color to warning (yellow) and display the warning symbol
        _style W true;
        # Output the warning message
        echo $*;
    }

    _debug() {
        # Set color to debug (magenta) and display the debug symbol
        _style D true;
        # Output the debug message
        echo $*;
    }

    _info() {
        # Set color to info (blue) and display the info symbol
        _style I true;
        # Output the info message
        echo $*;
    }

    _style() {

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

        _missing() {
            # Output a message indicating that a required POSIX compatible tool needs to be installed
            _error "The posix-nexus requires a posix compatible $(format  $* "<1>") to be installed.";
            # Provide possible options for the missing tool
            _possible "$(format  $* "<2>")";
        }

        _invalid() {

            # exit
            # Output a message indicating that the provided option is not supported by the function
            _error "The option ${1} is not one of the flags the ${2} function supports.";
            # List the supported options for the function
            _options "${3}";
        }

        _possible() {
            # Output possible options for the required tool
            _info "Possible options: ${1}";
        }

        _options() {

            # Format and output the supported options for a function
            _info $(echo -n $* | ${AWK} '{
                gsub(//, "|", $0);
                print "Supported options are: [" substr($0, 2, length($0) - 2) "]";
            }');
        }


        echo $VALUE
        # Handle different exception cases
        case "${KEY-${1}}" in
            R) _error "Please execute the '${VALUE-${2}}' script to initialize the POSIX Nexus environment or ensure the correct file path is specified.";;
            E) _error $(format "${VALUE-${2}}" "The '<1>' subroutine does not support the '-<2>' flag.");;
            I) _error $(format "${KEY-${1}} : ${VALUE-${2}}" "The '-<1>' flag of the '<2>' subroutine requires an argument.");;
            F)  _invalid $(format "${KEY-${1}} : ${VALUE-${2}}" "'<1>' '<2>' <3>");;
            D) _debug "$(basename "${2}") tests completed!";;
            L) _info "Location: $(cd "$(dirname "${VALUE-${2}}")" && pwd)";;
            U) _success "The posix-nexus daemon '${VALUE-${2}}' has started.";;
            M) _missing "${VALUE-${2}}";;
            *) _invalid "${KEY-${1}} : _exceptionC : REIMFDUL";;
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
                    if [ -n "$(_exceptionTemplate "_exceptionI" "edx = ${VALUE}")" ]; then
                       _warning "The root directory '${VALUE}' will be skipped as it does not meet the requirements.";
                       unset WORKING_DIRECTORY;
                    else
                        export WORKING_DIRECTORY="$(cd "${VALUE}" && pwd)/";
                    fi
 
                    return 0;
                };;

            e)
                _item || {
                    # Check if the path exists
                    _error "Path to $(basename "${VALUE}") does not exist ${WORKING_DIRECTORY:+"within the '${WORKING_DIRECTORY}' directory."}";
                };;

            d)
                _item || {
                    # Check if the path is a directory
                    _output "is not a directory";
                };;
            f)
                _item || {
                    # Check if the path is a file
                    _output "a file";
                };;

            r)
                _item || {
                    # Check if the path is an readable
                    _output "readable";
                };;

            w)
                _item || {
                    # Check if the path is an writable
                    _output "writable";
                };;

            x)
                _item || {
                    # Check if the path is an executable
                    _output "an executable";
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

    _exceptionV() {
        # Value Errors

        _variable() {
            [ -${KEY} "$(ref VALUE)" ] || {
                return 1;
            }
        }

        case "${KEY}" in
            n)
                # Check if the value is non-empty
                _variable || {
                    _error "The variable '\${${VALUE}}' should not be empty.";
                };;
            z)
                # Check if the value is empty
                _variable || {
                    _error "The variable '\${${VALUE}}' has been assigned the value '$(ref VALUE)' when it should be empty.";
                };;
        esac
    }

    _exceptionR() {
        # RegexErrors

        case "${KEY}" in
            N)
                # Check naming convention using AWK. Names must start with an optional underscore, 
                # followed by an alphabetic character, and can include alphanumeric characters and underscores.
                echo -n "${VALUE}" | ${AWK} '{ if ($0 ~ /^((_)?[[:alpha:]]{1}(_)?[[:alnum:]_]*)$/) { exit 0; } else { exit 1; } }' || {
                    # Display error message if naming convention is invalid
                    _error "Invalid naming convention '${VALUE}'. Names must start with an optional underscore, followed by an alphabetic character, and can include alphanumeric characters and underscores.";
                };;
        esac
    }

    _exceptionO() {

        # Error descriptions:
        # C: Command not found
        # T: Touch operation failed
        # D: Directory creation failed
        # F: FIFO special file creation failed
        # M: Move operation failed
        # R: Remove operation failed
        # S: Symbolic link creation failed
        # H: Hard link creation failed
        # P: Change mode failed
        # G: Change group failed
        # W: Copy (cp) failed
        # U: Unlink (unlink) failed
        # A: Archive with tar failed
        # K: Kill process (kill) failed
        # G: Pattern search (grep) failed
        # O: Change owner (chown) failed

        case "${KEY}" in
            # Handle command checks
            C)
                # Check if the specified command is available
                cmd "${VALUE}" 1> /dev/null 2>&1 || {
                    # If the command is not found, log an error message
                    _error "Command '${VALUE}' not found. Please ensure it is installed and available in your PATH.";
                };;

            # Handle touch operation
            T)
                # Attempt to create an empty file or update the access/modification time of an existing file
                touch "${VALUE}" 2> /dev/null || {
                    # If the touch operation fails, log an error message
                    _error "Failed to touch the file '${VALUE}'. Please ensure the directory $(dirname "${VALUE}") exists and you have the necessary permissions.";
                };;

            # Handle make directory operation
            D)
                # Attempt to create the directory
                mkdir -p "${VALUE}" 2> /dev/null || {
                    _error "Failed to create the directory '${VALUE}'. Please ensure the directory '$(dirname "${VALUE}")' exists and you have the necessary permissions.";
                };;

            # Handle named pipe operation
            F)
                # Attempt to create a FIFO special file (named pipe)
                mkfifo "${VALUE}" 2> /dev/null || {
                    _error "Failed to create the FIFO '${VALUE}'. Please ensure the directory '$(dirname "${VALUE}")' exists and you have the necessary permissions.";
                };;

            # Handle move operation
            M)
                {
                    # Execute the formatted move command
                    eval $(format "${VALUE}" "mv '<>' '<>'") 2> /dev/null || {
                        _error "Failed to move $(format "${VALUE}" "'<>' to '<>'"). Please ensure the destination directory exists and you have the necessary permissions.";
                    }
                };;

            # Handle remove operation
            R)

                # Attempt to remove the file or directory
                rm -rf "${VALUE}" 2> /dev/null || {
                    _error "Failed to remove '${VALUE}'. Please ensure you have the necessary permissions.";
                };;

            # Handle symbolic link operation
            S)
                eval "$(format "${VALUE}" "ln -s '<>' '<>'")" 2> /dev/null || {
                    _error "Failed to create a link using command '$(format "${VALUE}" "from '<>' to '<>'"). Please ensure the source and target directories exist and you have the necessary permissions.";
                };;

            # Handle hard link creation
            H)
                # Execute the formatted hardlink link command (ln)
                eval $(format "${VALUE}" "ln '<>' '<>'") 2> /dev/null || {
                    _error "Failed to create a hard link using command $(format "${VALUE}" "ln '<>' '<>'"). Please ensure the source and target directories exist and you have the necessary permissions.";
                };;

            # Handle change mode operation
            P)

                # Execute the formatted chmod command
                eval $(format "${VALUE}" "chmod '<>' '<>'") 2> /dev/null || {
                    _error "Failed to change mode $(format "${VALUE}" "'<>' on '<>'"). Please ensure you have the necessary permissions.";
                };;

            # Handle change group operation
            G)
                # Execute the formatted chgrp command
                eval $(format "${VALUE}" "chgrp '<>' '<>'") 2> /dev/null || {
                    _error "Failed to change group to $(format "${VALUE}" "'<>' on '<>'"). Please ensure you have the necessary permissions.";
                };;

            # Handle copy operation
            W)
                # Execute the formatted copy command
                eval $(format "${VALUE}" "cp -R '<>' '<>'") 2> /dev/null || {
                    _error "Failed to copy $(format "${VALUE}" "from '<>' to '<>'"). Please ensure the source and destination directories exist and you have the necessary permissions."
                };;

            # Handle kill operation
            K)
                # Execute the formatted kill command
                kill "${VALUE}" 2> /dev/null  || {
                    _error "Failed to kill process '${VALUE}'. Please ensure the process ID is valid and you have the necessary permissions.";
                };;

            # Handle unlink operation
            U)

                unlink "${VALUE}" 2> /dev/null || {
                    _error "Failed to unlink '${VALUE}'. Please ensure you have the necessary permissions.";
                };;

            # Handle archive operation
            A)

                # Execute the formatted tar command
                eval $(format "${VALUE}" "tar -cf '<>' '<>'") 2> /dev/null || {
                    _error "Failed to archive $(format "${VALUE}" "'<>' to '<>'"). Please ensure the source directory exists and you have the necessary permissions.";
                };;

            # Handle change owner operation
            O)
                # Execute the formatted chown command
                eval $(format "${VALUE}" "chown '<>:<>' '<>'") 2> /dev/null || {
                    _error "Failed to change owner $(format "${VALUE}" "from '<>' to '<>' on '<>'"). Please ensure you have the necessary permissions.";
                };;
        esac
    }

    _exceptionTemplate() {

        (
            # Export the function name and its supported flags for environment use
            export NAME="${1}";
            export FLAGS="$(
                case "$(${AWK} 'BEGIN{ printf("%s", substr(ENVIRON["NAME"], length(ENVIRON["NAME"])))}')" in
                    I) echo -n 'RshLtxwrfdep';;         # Item flags for _exceptionI
                    C) echo -n 'LREIMFDU';;             # Custom flags for _exceptionC
                    V) echo -n 'zn';;                   # Value flags for _exceptionV
                    O) echo -n 'CTDFMRPGWSHUAKNGO';;    # Operating System flags for _exceptionO
                    R) echo -n 'N';;                    # Regular Expressions flags for _exceptionR
                esac
            )";

            # Initialize the index
            INDEX=0;
            # Iterate through the provided arguments, delimited by , and =

            for VALUE in $(kwargs "${2}"); do
                INDEX=$((INDEX + 1));

                # For odd indexed elements, validate the key
                if [ $((INDEX % 2)) -eq 1 ]; then

                    export KEYS="$(echo -en "${VALUE}" | ${AWK} '{
                        for (i = 1; i <= length(ENVIRON["FLAGS"]); i++) {

                            for (j = 1; j <= length($0); j++) {
                                if (substr(ENVIRON["FLAGS"], i, 1) == substr($0, j, 1)) {
                                    v = v "" substr($0, j, 1);
                                }
                            }
                        }

                        if (v) {
                            print v;
                        } else {
                            exit 1;
                        }

                    }')" || {
                        INDEX=$((INDEX + 1));
                        unset KEYS;
                    }

                else

                    for KEY in $(
                        ${AWK} 'BEGIN {
                        for (i = 1; i <= length(ENVIRON["KEYS"]); i++) {
                            print substr(ENVIRON["KEYS"], i, 1);
                        }

                    }'); do
                        # For even indexed elements, evaluate the function with key and value
                        "${NAME}" "${KEY}" "${VALUE}" || exit 10;
                    done
                fi

            done

            case "$(_status G)" in
                *11) exit 11;;
            esac

        ) || exit;

    }

    (

        # Ensure the terminal is reset on exit and retrieve the status
        trap '_status R; echo -en "${C_SET:+\\x1b[0m}"; exec 1>&-' EXIT;

        # Redirecting standard output to standard error, commonly done for logging
        exec 1>&2;

        # Check the terminal type and enable color if it matches one of the listed types
        case "${TERM}" in
            screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*) C_SET=true;;
        esac

        # Dispatch to the appropriate error handling function based on the first argument
        while getopts :I:C:V:O:R:EQ OPT; do

            # Process command-line options
            case "${OPT}" in
                # Set status to quit (Q) or error (E)
                E|Q) STATUS="${OPT}";;
                # Handle missing arguments
                \:) _exceptionC I "try : ${OPTARG}";;
                # Handle unknown options
                \?) _exceptionC E "try : ${OPTARG}";;
                # Process other options
                *) _exceptionTemplate "_exception${OPT}" "${OPTARG}";;
            esac
        done

        # Check the status and exit accordingly
        case "$(_status G)" in
            *12) exit 12;;
        esac

    )

}

# Any function defined beyond startPosixNexus will NOT be included in the daemons environment
startPosixNexus() {

    _import() {

        eval "$(
            echo -n $* | ${AWK} -F ',' '{
                for(i = 1; i < NF; ++i) {
                    while ((getline line < $i) > 0) {
                        print line;
                    }

                    close($i);
                }

            }'
        )";

    }
    
    _posixNexusLinker() {

        # Ensure POSIX_NEXUS_ROOT is set, or return an error
        # Validate the first argument to ensure it's a valid variable name
        try -V '
            n = POSIX_NEXUS_ROOT
        ' -R "
            N = ${1}
        " || exit 1;

        # Export linker variable
        export "POSIX_NEXUS_$(toupper "${1}")_LINKER"="$(
            LINKER_PROCESS_IDS="";
            # Iterate over files in the specified directory that match the pattern
            for POSIX_NEXUS_LOCATION in "${POSIX_NEXUS_ROOT}/main/${1}/lib/"*"-utilities.${1}"; do
                {
                    try -I "
                        efr = ${POSIX_NEXUS_LOCATION}
                    "  && echo -n "${POSIX_NEXUS_LOCATION},";
                } & LINKER_PROCESS_IDS="${LINKER_PROCESS_IDS} $!";
            done

            wait ${LINKER_PROCESS_IDS};
        )";

        ref "POSIX_NEXUS_$(toupper "${1}")_LINKER";

        return 0;
    }

    # Set file creation mask
    umask 027;

    # Check various paths and files using the try function
    # Ensures all necessary directories and files exist and are accessible
    try -Q -O "
        C = nohup
    " -E -I "
        R = ${1},
        edx = main
    " -I "
        R = ${1}/main,
        edx = awk,
        edx = sh
    " -I "
        R = ${1}/main/awk,
        edxr = lib,
        efr = lib/awk-interpreter.awk
    " -I "
        R = ${1}/main/sh,
        edxr = lib,
        efr = lib/posix-nexus.sh
    " -I "
        R = /var,
        edx = run,
        edx = tmp
    " -O "
        D = /var/run/posix-nexus,
        D = /var/tmp/posix-nexus,
        T = /var/run/posix-nexus/posix-nexus.pid
    " -I "
        w = /var/run/posix-nexus,
        w = /var/tmp/posix-nexus,
        wr = /var/run/posix-nexus/posix-nexus.pid
    " || exit;

    # Set the root directory for POSIX Nexus
    export POSIX_NEXUS_ROOT="${1}";
    shift;

    # Functions to export
    export -f _import;
    export -f _posixNexusLinker;

    # Set required run files
    export POSIX_NEXUS_PID="/var/run/posix-nexus/posix-nexus.pid";
    export POSIX_NEXUS_LINK="/var/run/posix-nexus/posix-nexus-directory";

    [ -h "${POSIX_NEXUS_LINK}" ] && {
        try -Q -O "
            C = unlink,
            U = ${POSIX_NEXUS_LINK}
        " || exit;
    }

    kill "$(cat "${POSIX_NEXUS_PID}")" 2> /dev/null;
    nohup "${POSIX_NEXUS_ROOT}/main/sh/lib/posix-nexus.sh" "$(basename "${0}")" \
        1> /dev/null 2>&1 & printf "%d" $! > "${POSIX_NEXUS_PID}";

}

_awk() {

    # Attempt to find and set an awk variant, prioritizing common and lightweight versions
    export AWK="$(cmd mawk nawk awk gawk || false;
        # Mawk is a fast and lightweight version of awk
        # Nawk is the new awk, often used as the default on many systems
        # Awk is the original version, often a symlink to another variant
        # Gawk is the GNU version of awk, feature-rich and widely used
        # BusyBox awk is used in embedded systems
        # Ensure the chain returns a non-zero status if no awk variant is found
    )" || {
        # If no variant of awk is found, exit 2 (failure)
        try -C "M = 'awk' interpreter : [mawk|nawk|awk|gawk|busybox]";
        exit 1;
    }
}

_shell() {

    # Attempt to find and set a POSIX-compliant shell, prioritizing speed
    export SHELL="$(cmd dash sh ash mksh posh yash ksh loksh pdksh bash zsh fish || false;
        # Dash is very fast and lightweight
        # Bourne shell is generally fast
        # Ash is also lightweight and fast
        # MirBSD Korn Shell is lightweight
        # Policy-compliant Ordinary Shell is minimal
        # Yet Another Shell is focused on correctness
        # KornShell is balanced in performance and features
        # Loksh is a lightweight version of ksh
        # Public Domain Korn Shell is another ksh variant
        # Bash is feature-rich but slightly heavier
        # Zsh is powerful but can be heavier
        # Fish is user-friendly but not as lightweight
        # BusyBox shell is used in embedded systems
        # Ensure the chain returns a non-zero status if no shell is found
    )" || {
        # If no shell is found, exit 1 (failure)
        try -C "M = 'shell' : [dash|ash|sh|mksh|posh|yash|ksh|loksh|pdksh|bash|zsh|fish|busybox]";
        exit 1;
    }

}

_shell && _awk;
if try -I "efr = $(cd "$(dirname "${0}")" && pwd)/main/sh/lib/posix-nexus.sh"; then
    startPosixNexus "$(cd "$(dirname "${0}")" && pwd)";
else
    case "$(cd "$(dirname "${0}")" && pwd)" in
        */test/*)
            {
                try -C "L=${0}";
                trap 'try -C "D=${0}"' EXIT;
            };;
        *)
            {
                try -C 'R=run.sh';
                exit 1;
            };;
    esac
fi
