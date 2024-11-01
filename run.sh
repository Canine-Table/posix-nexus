#!/bin/sh

# Function to check if any given commands exist in the system's PATH
cmd() {

    while [ ${#@} -gt 0 ]; do

        # Check if the command exists
        command -v "${1}" && return;

        # Move to the next command
        shift;
    done

    # Return failure if no commands are found
    return 1;
}

# Function to convert a string to lowercase using AWK
tolower() {
    echo -n $* | ${AWK} '{
        printf("%s", tolower($0));
    }';
}

# Function to convert a string to uppercase using AWK
toupper() {
    echo -n $* | ${AWK} '{
        printf("%s", toupper($0));
    }';
}

# Function to format a message by replacing placeholders with provided values
format() {
    echo "${1}:" | ${AWK} -v msg="${2}" '
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

            # Repeat until no delimiter found
            } while ((i = index(param["str"], "\x3a")));
        }
    }

    BEGIN {
        param["msg"] = msg;
    } {
        param["str"] = param["str"] "" $0;
        format();

        # Final whitespace trim
        gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", param["msg"]);
        print param["msg"];
        delete param;
        exit 0;
    }';
}


# Function to parse and process key-value arguments from a string
kwargs() {
    echo $*"," | ${AWK} '
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


# Function to dereference and echo the value of a variable
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

    # Function to apply styling based on message type and enable color if specified
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

    # Function to expand a given value using the format function
    _expand() {
        # Evaluate the formatted value using AWK and format it with the provided template
        eval "$(format "$(awk -v value="${1}" 'BEGIN { print value; }')" "${2}")";
    }

    # Function to manage status file operations
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

    # Function to handle various exception cases and provide feedback
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

        # Handle different exception cases
        case "${KEY-${1}}" in
            R) _error "Please execute the '${VALUE-${2}}' script to initialize the POSIX Nexus environment or ensure the correct file path is specified.";;
            E) _error $(format "${VALUE-${2}}" "The '<1>' subroutine does not support the '-<2>' flag.");;
            I) _error $(format "${KEY-${1}} : ${VALUE-${2}}" "The '-<1>' flag of the '<2>' subroutine requires an argument.");;
            F)  _invalid $(format "${KEY-${1}} : ${VALUE-${2}}" "'<1>' '<2>' <3>");;
            D) _debug "$(basename "${2}") tests completed!";;
            L) _info "Location: '$(cd "$(dirname "${VALUE-${2}}")" && pwd)'";;
            U) _success "The posix-nexus daemon '$(basename ${VALUE-${2}})' has started.";;
            M) _missing "${VALUE-${2}}";;
            *) _invalid "${KEY-${1}} : _exceptionC : REIMFDUL";;
        esac

        return 0;
    }


    # Function to handle various item exceptions and check directory or file properties
    _exceptionI() {

        # Function to check if the key path exists in the root directory
        _item() {
            # Check if the key path exists in the root directory
            [ -${KEY} "${WORKING_DIRECTORY}${VALUE}" ] || {
                return 1;
            }
        }

        # Function to echo formatted error message
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

    # Function to handle value errors and validate variable states
    _exceptionV() {
        # Value Errors

        # Function to check if the variable's value matches the key condition
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

    # Function to handle regex errors and validate naming conventions
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

    # Function to handle various operations and log errors accordingly
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
                    _expand "${VALUE}" "mv '<>' '<>'" 2> /dev/null || {
                        _error "Failed to move $(_expand "${VALUE}" "'<>' to '<>'"). Please ensure the destination directory exists and you have the necessary permissions.";
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
                _expand "${VALUE}" "ln -s '<>' '<>'" 2> /dev/null || {
                    _error "Failed to create a link using command $(_expand  "${VALUE}" "from '<>' to '<>'"). Please ensure the source and target directories exist and you have the necessary permissions.";
                };;

            # Handle hard link creation
            H)
                # Execute the formatted hardlink link command (ln)
                _expand "${VALUE}" "ln '<>' '<>'" 2> /dev/null || {
                    _error "Failed to create a hard link using command $(_expand "${VALUE}" "ln '<>' '<>'"). Please ensure the source and target directories exist and you have the necessary permissions.";
                };;

            # Handle change mode operation
            P)

                # Execute the formatted chmod command
                _expand "${VALUE}" "chmod '<>' '<>'" 2> /dev/null || {
                    _error "Failed to change mode $(_expand "${VALUE}" "'<>' on '<>'"). Please ensure you have the necessary permissions.";
                };;

            # Handle change group operation
            G)
                # Execute the formatted chgrp command
                _expand "${VALUE}" "chgrp '<>' '<>'" 2> /dev/null || {
                    _error "Failed to change group to $(_expand "${VALUE}" "'<>' on '<>'"). Please ensure you have the necessary permissions.";
                };;

            # Handle copy operation
            W)
                # Execute the formatted copy command
                _expand "${VALUE}" "cp -R '<>' '<>'" 2> /dev/null || {
                    _error "Failed to copy $(_expand "${VALUE}" "from '<>' to '<>'"). Please ensure the source and destination directories exist and you have the necessary permissions."
                };;

            # Handle kill operation
            K)
                # Execute the formatted kill command
                kill "${VALUE}" 2> /dev/null || {
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
                _expand "${VALUE}" "tar -cf '<>' '<>'" 2> /dev/null || {
                    _error "Failed to archive $(_expand "${VALUE}" "'<>' to '<>'"). Please ensure the source directory exists and you have the necessary permissions.";
                };;

            # Handle change owner operation
            O)
                # Execute the formatted chown command
                _expand "${VALUE}" "chown '<>:<>' '<>'" 2> /dev/null || {
                    _error "Failed to change owner $(_expand "${VALUE}" "from '<>' to '<>' on '<>'"). Please ensure you have the necessary permissions.";
                };;
        esac
    }

    # Function template to handle various exceptions and provide feedback based on provided flags
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
                    
                    # For even indexed elements, evaluate the function with key and value
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

            # Check the status and exit if necessary
            case "$(_status G)" in
                *11) exit 11;;
            esac

        ) || exit;

    }

    (

        # Ensure the terminal is reset on exit and retrieve the status
        trap '_status R; exec 1>&-' EXIT;

        # Redirecting standard output to standard error, commonly done for logging
        exec 1>&2;

        # Check the terminal type and enable color if it matches one of the listed types
        tty -s && case "${TERM}" in
            screen*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)

                {
                    C_SET=true;
                    trap '_status R; echo -en "${C_SET:+\\x1b[0m}"; exec 1>&-' EXIT;
                };;

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

# Any function defined beyond startPosixNexus will NOT be included in the daemon's environment.

# Main function to initialize and start POSIX Nexus.
startPosixNexus() {

    # Set file creation mask
    umask 027;

    # Check various paths and files using the try function
    # Ensures all necessary directories and files exist and are accessible
    try -E -I "
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
        edxr = lib
    " -I "
        R = /var,
        edx = run,
        edx = tmp
    " -O "
        D = /var/run/posix-nexus,
        D = /var/tmp/posix-nexus,
        T = /var/run/posix-nexus/posix-nexus.pid
    " -I "
        dw = /var/run/posix-nexus,
        dw = /var/tmp/posix-nexus,
        fwr = /var/run/posix-nexus/posix-nexus.pid
    " || exit;

    # Set the root directory for POSIX Nexus
    export POSIX_NEXUS_ROOT="${1}";
    shift;

    # Set required run files
    export POSIX_NEXUS_PID="/var/run/posix-nexus/posix-nexus.pid";
    kill -TERM $(cat "${POSIX_NEXUS_PID}") 2> /dev/null;

    export POSIX_NEXUS_LINK="/var/run/posix-nexus/posix-nexus-directory";

    [ -h "${POSIX_NEXUS_LINK}" ] && {
        try -O "
            U = ${POSIX_NEXUS_LINK}
        " || exit;
    }

    # Start the daemon process in a new session
    setsid nohup ${SHELL} -c "

        eval $(
            # Import function for loading additional scripts
            _import() {
                echo -n $* | ${AWK} -F ',' '{
                    for(i = 1; i < NF; ++i) {
                        while ((getline line < $i) > 0) {
                            print line;
                        }

                        close($i);
                    }

                }'

            }
    
            # Function to link required utilities for POSIX Nexus
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

            cat "${POSIX_NEXUS_ROOT}/$(basename ${0})" | ${AWK} '{
                if ($0 !~ /^[[:space:]]*startPosixNexus[[:space:]]*\(\)[[:space:]]*\{/) {
                    print $0;
                } else {
                    exit 0;
                }
            }'

            _import $(_posixNexusLinker sh);

            cat "${POSIX_NEXUS_ROOT}/main/sh/lib/posix-nexus.sh";
            echo posixNexusDaemon;
        ) &

        wait;
        trap 'kill -$!; exit' EXIT INT TERM;

    " 1> /dev/null 2>&1 & printf "%d" $! > "${POSIX_NEXUS_PID}" && {
        tty -s && try -C "U = ${0}, L = ${0}";
    }

}


# Function to find and set the fastest an AWK variant
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

# Function to find and set the fastest an shell variant
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

# Ensure AWK and SHELL variants are set
_shell && _awk;

# Define the path to posix-nexus.sh
if [ -e "$(cd "$(dirname "${0}")" && pwd)/main/sh/lib/posix-nexus.sh" ]; then
    
    # Import posix-nexus.sh if it exists
    try -I "fr = $(cd "$(dirname "${0}")" && pwd)/main/sh/lib/posix-nexus.sh" && {
        startPosixNexus "$(cd "$(dirname "${0}")" && pwd)";
    } || exit;
else
    case "$(cd "$(dirname "${0}")" && pwd)" in
        */test/*)
            {
                try -C "L=${0}";
                trap 'try -C "D=${0}"' EXIT;
            };;
        *)
            {
                try -C "R=${0}";
                exit 1;
            };;
    esac
fi
