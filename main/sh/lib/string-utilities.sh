_notify() {

    # Check if arguments are provided
    [ -n "${*}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }

    (


        # Process the input arguments using awk
        echo -n "${*}" | awk '
            function output(message, symbol) {
                # Convert the symbol to uppercase
                _symbol = toupper(symbol);

                # Assign symbols and color codes based on the symbol
                if (_symbol) {

                    # Assign symbols and color codes based on the symbol
                    if (_symbol == "E") {
                        _symbol = "\x5e";  # Caret symbol
                        _color_code = 1;   # Red color

                    } else if (_symbol == "S") {
                        _symbol = "\x76";  # Check mark
                        _color_code = 2;   # Green color

                    } else if (_symbol == "W") {
                        _symbol = "\x21";  # Exclamation mark
                        _color_code = 3;   # Yellow color

                    } else if (_symbol == "I") {
                        _symbol = "\x69";  # Information symbol
                        _color_code = 4;   # Blue color

                    } else if (_symbol == "D") {
                        _symbol = "\x25";  # Percent symbol
                        _color_code = 5;   # Purple color

                    } else if (_symbol == "A") {
                        _symbol = "\x2d";
                        _color_code = 6;

                    } else if (_symbol == "N") {
                        _symbol = "\x3e";  # Greater than symbol
                        _color_code = 7;   # White color

                    }

                    # Determine color code for uppercase vs lowercase symbols
                    if (symbol ~ /^[[:upper:]]$/) {
                        _color_code = 3 _color_code;  # Bright colors for uppercase

                    } else {
                        _color_code = 9 _color_code;  # Dim colors for lowercase

                    }

                } else {
                    _symbol = "\x2a";

                }

                if (_color_code) {
                    _color_code = ";" _color_code;

                }

                # Extract the message until the category symbol
                if (match(message, /(^|[[:space:]]+)(E|e|S|s|W|w|I|i|D|d|A|a|N|n)([[:space:]]+|$)/)) {
                    message = substr(message, 1, RSTART);
                    _old_message = substr(message, 1, RSTART + RLENGTH);

                } else {
                    _old_message = "";

                }

                # Remove leading and trailing whitespace from the message
                gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", message);

                # Print the formatted message with color and symbol
                printf("\x1b[1%sm\x5b%s\x5d %s\x2e\x1b[0m\x0a", _color_code, _symbol, message);

                return "^.*" _old_message;
            }

            {

                # Find the first match of the category symbol in the message
                match($0, /(^|[[:space:]]+)(E|e|S|s|W|w|I|i|D|d|A|a|N|n)([[:space:]]+|$)/);

                if (! RSTART) {
                    output($0);
                    exit 0;

                }

                # If the match is found before the start, process the message up to that point
                if (RSTART > 1) {
                    sub(output(substr($0, 1, RSTART + 1)), "");

                }

                # Define categories for matching symbols
                categories = "EeSsWwIiDdAaNn";

                do {

                    # Iterate over each character in the categories string
                    for (current_index = 1; current_index <= length(categories); ++current_index) {
                        # Match the category symbol in the message
                        match($0, /(^|[[:space:]]+)(E|e|S|s|W|w|I|i|D|d|A|a|N|n)([[:space:]]+|$)/);

                        # Get the matched category from the message
                        category = substr($0, RSTART, 1);
                        
                        # Get the current category from the categories string
                        current_category = substr(categories, current_index, 1);

                        # Check if the matched category is the same as the current category
                        if (current_category == category) {

                            # Substitute the message with the formatted output and remove it from the original message
                            if (! sub(output(substr($0, 2), current_category), "")) {
                                sub($0, "");

                            }

                            break;
                        }

                    }

                # Continue looping until there are no more categories to process in the message
                } while ($0);

                # Exit the awk script
                exit 0;

            }';


    )

}

_export() {

    # Check if arguments are provided
    [ -n "${*}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }
    
    (
        # Set a trap to unset variables on exit
        trap "$(_trap -S 'EXIT' -E "unset OPT OPTARG OPTIND EXPORT_N EXPORT_V EXPORT_E" "$(trap -p)")" EXIT;

        # Parse command-line options
        while getopts :N:V:E: OPT; do
            case ${OPT} in
                N|V) eval "EXPORT_${OPT}"="'${OPTARG}'";;
                E) eval "EXPORT_${OPT}"+="'${OPTARG}'";;
            esac
        done

        # Shift positional parameters
        shift $((OPTIND - 1));

        # Check if EXPORT_N is set
        [ -n "${EXPORT_N}" ] || {
            exit 1;
        } && {
            # Use awk to process the export command output
            export -p | awk \
                -v name="${EXPORT_N}" \
                -v value="${EXPORT_V}" \
                -v extend="${EXPORT_E}" \
            'BEGIN {
                # Remove leading and trailing whitespace from the name
                gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", name);

            } {
                line = $0;

                do {
                    # Extract the variable name
                    variable = substr(line, 1, index(line, "\x3d"));

                    # Check if the variable name matches the provided name
                    if (substr(variable, index(variable, "\x20") + 1) == name "=") {
                        # Extract the variable value
                        variable_value = substr(line, index(line, "\x3d") + 1);

                        # Find the start and end delimiters
                        start_index = index(variable_value, "[[:punct:]]+");
                        start_delimiter = substr(variable_value, start_index, 1);
                        end_index = index(substr(variable_value, 2), start_delimiter)
                        variable_value = substr(substr(variable_value, start_index + 2), start_index, end_index - start_index - 1);

                        if ((length(variable_value) + 2 + length(variable)) != length(line)) {
                            variable_value = variable_value "" start_delimiter;
                        }

                        # Check if the variable value length matches the line length
                        if (value && value !~ variable_value) {
                            printf("%s", value);

                        } else {
                            printf("%s", variable_value);
                        }

                        # Print the extension if provided
                        if (extend) {
                           printf("%s", extend);
                        } 
                      
                        exit 0;

                    }

                } while((getline line) > 0);

                exit 1;

            }';

        }

        exit $?;

    )

    return $?;
   
}


_signalList() {

    _awk || return 228;

    # Check if the first argument is not empty
    [ -n "${1}" ] || {
        # Return 255 if the first argument is empty
        return 255;

    }

    # List all signal names and numbers, replace newlines with spaces, and process with awk
    trap -l | tr '\n' ' ' | ${AWK} -F ' ' -v trap="${1}" 'BEGIN {

        # Remove leading and trailing spaces from the trap argument and convert to uppercase
        gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", trap);
        trap = toupper(trap);

    } {
        # Remove closing parenthesis from the input
        gsub("\x29", "", $0);

        # Loop through the signals
        for (signal = 1; signal <= NF; signal += 2) {
            # Get the signal name
            signal_name = $(signal + 1);

            # Create a match pattern
            signal_match = sprintf("%s\x7c%s", $signal, signal_name);

            pseudo_signal = signal_name;

            # Remove 'SIG' prefix from the signal name if present
            if (sub(/^(SIG)/, "", pseudo_signal) && pseudo_signal) {
                signal_match = sprintf("%s\x7c%s", signal_match, pseudo_signal);

            }

            # Check if the trap argument matches the signal pattern
            if (trap ~ "\x5e\x28" signal_match "\x29\x24") {
                if (pseudo_signal) {
                    # Print the pseudo signal name if present                    
                    printf("%s", pseudo_signal);

                } else {
                    # Otherwise, print the signal name
                    printf("%s", signal_name);

                }

                # Exit with the signal number
                exit 0;
            }
        }

        # Exit with 0 if no match is found
        exit 1;

    }' || {

        [ -n "${2}" ] && {
            echo -n "${2}" | ${AWK} -v trap="${1}" 'BEGIN {
                # Remove leading and trailing spaces from the trap argument and convert to uppercase
                gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", trap);
                trap = toupper(trap);

            } {
                line = $0;

                do {

                    # Check if the line matches the pattern
                    if (match(line, /^(.*[[:space:]]+)/)) {
                        # Remove the matched part from the line
                        line = substr(line, RSTART + RLENGTH);
                        sub(/^(.*[[:space:]]+)/, "", value);

                        # Check if the trap matches the remaining line
                        if (trap ~ "^" line "$") {
                            print trap;
                            exit 0;

                        }

                    }

                } while ((getline line) > 0);

                # Exit with status 1 if no match is found
                exit 1;
            }';

        }

    }

    # Return the exit status of the awk command
    return $?;

}


_signalLookup() {

    _awk || return 228;

    # Check if both arguments are provided
    [ -n "${1}" -a -n "${2}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }

    # Use awk to process the input
    echo -n "${1}" | ${AWK} -v trap="${2}" 'BEGIN {
        # Remove leading and trailing spaces from the trap argument and convert to uppercase
        gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", trap);
        trap = toupper(trap);

    } {
        line = $0;

        do {

            if (match(line, /^(.*[[:space:]]+)/)) {
                current_signal = line;
                sub("^" substr(line, RSTART, RLENGTH), "", current_signal);

                if (trap ~ "\x5e\x28" current_signal "\x29\x24") {
                    current_delimiter = substr(line, index(line, current_signal) - 2, 1);

                    # If the delimiter is '-', exit with status 3
                    if (current_delimiter ~ /^-$/) {
                        exit 3;

                    } else {
                        # Remove the signal and delimiter from the line and print the remaining part
                        sub("\x28" current_delimiter "[[:space:]]+" current_signal "\x29\x24", "", line);
                        printf("%s", substr(substr(line, RSTART, RLENGTH), index(line, current_delimiter) + 1));
                        exit 0;
                    
                    }

                }

            } else {
                # Exit with status 2 if no match is found
                exit 2;
            }

        } while ((getline line) > 0);

        # Exit with status 1 if the end of the input is reached without a match
        exit 1;
    }';

    # Return the exit status of the awk command
    return $?;

}


_trap() {

    # Check arguments are provided
    [ -n "${*}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }

    (

        # Set a trap to unset variables on exit
        trap 'unset OPT OPTARG OPTIND SIGNAL_S SIGNAL_E SIGNAL_P' EXIT;

        # Parse command-line options
        while getopts :S:E: OPT; do
            case ${OPT} in
                S|E) eval "SIGNAL_${OPT}"="'${OPTARG}'";;
            esac
        done

        # Shift positional parameters
        shift $((OPTIND - 1));

        # Get the signal list and store it in SIGNAL_S
        SIGNAL_S="$(_signalList "${SIGNAL_S}" "${1}")" || exit 1;
    
        # Lookup the signal and store it in SIGNAL_P
        SIGNAL_P="$(_signalLookup "${1}" "${SIGNAL_S}")" && {
            # Print the signal
            printf "%s" "${SIGNAL_P}";

            # If SIGNAL_E is not empty, print a semicolon
            [ -z "${SIGNAL_E}" ] || {
                printf "\x3b";
            }

        }

        # Print SIGNAL_E
        printf "%s" "${SIGNAL_E}";

        # Exit with the status of the last command
        exit $?;

    )

    # Return the exit status of the subshell
    return $?;

}


_noClobber() {
    # Move the file to a backup location with a timestamp, or exit with the given exit code (default 1)
    _pathErrors item dir "${1}" e "${2}" && mv "${2}" "${2}-$(date +"%s").bak" || exit ${2:-1};

}_shell() {

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
        # If no shell is found, return 1 (failure)
        return 1;
    } && {
        # If a shell is found and arguments are provided, run the shell with those arguments
        [ -n "${*}" ] && {
            ${SHELL} "${*}";
        }
        # Return 0 (success)
        return 0;
    }
}


_awk() {

    # Attempt to find and set an awk variant, prioritizing common and lightweight versions
    export AWK="$(
        command -v mawk ||          # Mawk is a fast and lightweight version of awk
        command -v nawk ||          # Nawk is the new awk, often used as the default on many systems
        command -v gawk ||          # Gawk is the GNU version of awk, feature-rich and widely used
        command -v awk ||           # Awk is the original version, often a symlink to another variant
        command -v busybox awk ||   # BusyBox awk is used in embedded systems
        false;                      # Ensure the chain returns a non-zero status if no awk variant is found

    )" || {
        # If no variant of awk is found, return 1 (failure)
        return 1;

    } && {
        # Return 0 (success)
        return 0;

    }

}


_unQuote() {

    # Check if arguments are provided
    [ -n "${*}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }

    echo -n "${*}" | awk '{
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


_nexus() {

    # Check if the ${1} directory exists, if not, create it
    _setupTree() {

        while [ ${#@} -gt 0 ]; do
            [ -d "${POSIX_NEXUS_ROOT}/${1}" ] || {
                # If ${1} exists but is not a directory, back it up or return ${2}
                [ -e "${POSIX_NEXUS_ROOT}/${1}" ] && {
                    _noClobber "${POSIX_NEXUS_ROOT}/${1}" $((${POSIX_NEXUS_LIBRARY_INDEX} + 1));
                }
                
                # make ${1} or return ${2} + 1
                mkdir -p "${POSIX_NEXUS_ROOT}/${1}" || exit $((${POSIX_NEXUS_LIBRARY_INDEX} + 2));

            }

            POSIX_NEXUS_LIBRARY_INDEX=$((POSIX_NEXUS_LIBRARY_INDEX + 2));
            shift;

        done

        return 0;

    }

   _setupTree '/var/run/posix-nexus' '/var/log/posix-nexus' '/var/tmp/posix-nexus' || exit $?;

    # Check if the posix-nexus.pid file exists, if not, create it
    [ -f '/var/run/posix-nexus/posix-nexus.pid' ] || {
        # Retry deletion if permission is denied
        [ -e '/var/tmp/posix-nexus' ] && rm -rf '/var/run/posix-nexus/posix-nexus.pid' || _pathErrors  '' '!D' '/var/run/posix-nexus/posix-nexus.pid' $((${POSIX_NEXUS_LIBRARY_INDEX} + 1));
        touch '/var/run/posix-nexus/posix-nexus.pid' || _pathErrors '' '!C' '/var/run/posix-nexus/posix-nexus.pid' $((${POSIX_NEXUS_LIBRARY_INDEX} + 2));

    }

    POSIX_NEXUS_LIBRARY_INDEX=$((POSIX_NEXUS_LIBRARY_INDEX + 2));

    # (

    #     # Set a trap to unset variables on exit
    #     trap "$(_trap -S 'EXIT' -E "unset POSIX_NEXUS_LOCATION POSIX_NEXUS_PID POSIX_NEXUS_GARBAGE; rm -f '/tmp/posix-nexus/posix-nexus.pid'; jobs -p | xargs kill" "$(trap -p)")" EXIT;

    #     POSIX_NEXUS_PID="$(cat '/var/run/posix-nexus/posix-nexus.pid')";

    #     # Check if the process with POSIX_NEXUS_PID is running, if not, exit
    #     ps -o pid | awk '{print $1}' | grep -q "^[[:space:]]*${POSIX_NEXUS_PID}$" && {
    #         kill -n 0 "${POSIX_NEXUS_PID}" || exit 10;
    #     }

    #     # Create the POSIX_NEXUS_LOCATION directory
    #     export POSIX_NEXUS_LOCATION="/var/tmp/posix-nexus/posix-nexus-$$";

    #     # Create the POSIX_NEXUS_LOCATION directory
    #     mkdir "${POSIX_NEXUS_LOCATION}" || exit 11;

    #     # Check if the posix-nexus-location symlink exists and is a symlink, if not, exit
    #     [ -e '/var/run/posix-nexus/posix-nexus-location' ] && {
    #         # Remove the existing posix-nexus-location symlink
    #         rm '/var/run/posix-nexus/posix-nexus-location' || exit 12;
    #     }

    #     # Check if mkfifo command is available
    #     command -v mkfifo 1> /dev/null || exit 13;

    #     # Create a named pipe (FIFO) at POSIX_NEXUS_LOCATION/stdin
    #     mkfifo "${POSIX_NEXUS_LOCATION}/stdin" || exit 14;

    #     # Check if nohup command is available
    #     command -v nohup 1> /dev/null || exit 15;

    #     # Select the fastest installed shell to run the script in the background using nohup
    #     _shell || exit 16;

    #     # If SHELL is set, use nohup to run a shell script in the background
    #     nohup "${SHELL}" -c '

    #         # Wait until the posix-nexus-location symlink exists
    #         while [ ! -h '/var/run/posix-nexus/posix-nexus-location' ]; do
    #             sleep 1;
    #         done

    #         # Continuously read from the named pipe and output to stdout
    #         while :; do
    #             cat "${POSIX_NEXUS_LOCATION}/stdin" | awk "{
    #                 print $0

    #             }";
    #         done
    #     ' \
    #         1> "${POSIX_NEXUS_LOCATION}/stdout" \
    #         2> "${POSIX_NEXUS_LOCATION}/stderr" \
    #         & printf "%d" $! > '/var/run/posix-nexus/posix-nexus.pid' || exit 17;

    #     POSIX_NEXUS_PID="$(cat '/var/run/posix-nexus/posix-nexus.pid')";

    #     for POSIX_NEXUS_GARBAGE in $(ls --color=never '/var/tmp/posix-nexus/'); do
    #         [ "${POSIX_NEXUS_GARBAGE}" = "posix-nexus-$$" ] || rm -rf "/var/tmp/posix-nexus/${POSIX_NEXUS_GARBAGE}";
    #     done &

    #     # Create a symbolic link to POSIX_NEXUS_LOCATION
    #     ln -sf "${POSIX_NEXUS_LOCATION}" '/var/run/posix-nexus/posix-nexus-location' || exit 18;

    #     ln -sf '/var/run/posix-nexus/posix-nexus.pid' '/tmp/posix-nexus/posix-nexus.pid';
    #     chmod 444 '/tmp/posix-nexus/posix-nexus.pid';

    # ) || exit $?;

    return 0;

}


_linker() {

    # Ensure POSIX_NEXUS_ROOT and the first argument are set, or return an error
    [ -z "${1}" ] && return 255;


    # Ensure POSIX_NEXUS_ROOT is set, or return an error
    [ -z "${POSIX_NEXUS_ROOT}" ] && return 1;

    # Validate the first argument to ensure it's a valid variable name
    echo -n "${1}" | awk '{ if ($0 ~ /^((_)?[[:alpha:]]{1}(_)?[[:alnum:]_]*)$/) { exit 0; } else { exit 1; } }' || {
        exit 2;
    }

    export "POSIX_NEXUS_${1:+$(echo -n "${1}" | tr '[:lower:]' '[:upper:]')}_LINKER"="$(

        # Set a trap to unset variables on exit
        trap 'unset POSIX_NEXUS_LOCATION POSIX_NEXUS_LINKER POSIX_NEXUS_LINKER_VARIABLE IFS' EXIT;

        # Iterate over files in the specified directory that match the pattern
        for POSIX_NEXUS_LOCATION in "${POSIX_NEXUS_ROOT}/main/${1}/lib/"*"-utilities.${1}"; do

            # Skip the core-utilities file
            [ "$(basename "${POSIX_NEXUS_LOCATION}")" = "core-utilities.${1}" ] || {

                # Check for path errors and add to linker variable if no errors
                _taskErrors item dir "${POSIX_NEXUS_ROOT}" e "${POSIX_NEXUS_LOCATION}" f "${POSIX_NEXUS_LOCATION}" r "${POSIX_NEXUS_LOCATION}" && {
                    POSIX_NEXUS_LINKER="${POSIX_NEXUS_LINKER}${POSIX_NEXUS_LOCATION}\x22\x0b\x0d\x22";

                }

            }

        done

        # Add the core-utilities file to the linker variable
        POSIX_NEXUS_LINKER="\x22${POSIX_NEXUS_LINKER}${POSIX_NEXUS_ROOT}/main/${1}/lib/core-utilities.${1}\x22";

        # Determine the delimiter based on whether the second argument is set
        [ -z "${2}" ] && {
            # If no second argument, set the linker variable directly
            POSIX_NEXUS_LINKER_VARIABLE="$(echo -n "${POSIX_NEXUS_LINKER}")";

        } || POSIX_NEXUS_LINKER_VARIABLE=$(

            # Set the IFS to the specified delimiters and read the linker variable
            IFS_DELIMITER="$(echo -en "${2}")";

            echo -en "${POSIX_NEXUS_LINKER}" | while IFS="$(echo -en '\x0b\x0d')" read -r -d "$(echo -en '\x0d')" POSIX_NEXUS_LOCATION; do
               echo "${IFS_DELIMITER} ${POSIX_NEXUS_LOCATION} ";
            done
        );

        # Export the linker variable
        echo -n "${POSIX_NEXUS_LINKER_VARIABLE}";

    )";
    return 0;
}

_nexus

