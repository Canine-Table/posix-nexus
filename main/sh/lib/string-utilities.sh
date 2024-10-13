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

}
