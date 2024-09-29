function _signalList() {

    # Check if the first argument is not empty
    [ -n "${1}" ] || {
        # Return 255 if the first argument is empty
        return 255;

    } && {

        # List all signal names and numbers, replace newlines with spaces, and process with awk
        trap -l | tr '\n' ' ' | awk -F ' ' -v trap="${1}" 'BEGIN {

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
                echo -n "${2}" | awk -v trap="${1}" 'BEGIN {
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

    }

    # Return the exit status of the awk command
    return $?;

}

function _signalLookup() {

    # Check if both arguments are provided
    [ -n "${1}" -a -n "${2}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    } && {

        # Use awk to process the input
        echo -n "${1}" | awk -v trap="${2}" 'BEGIN {
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

    }

    # Return the exit status of the awk command
    return $?;

}

function _trap() {

    # Check if both arguments are provided
    [ -n "${@}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    } && (
        
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
        SIGNAL_S="$(_signalList "${SIGNAL_S}" "${1}")" || {
            exit 1;
        } && {
    
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
            printf "%s" "${SIGNAL_E}"

        }

        # Exit with the status of the last command
        exit $?;

    );

    # Return the exit status of the subshell
    return $?;

}

function _jobs() {

    # Check if both arguments are provided
    [ -n "${@}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    } && (
        # Set a trap to unset variables on exit
        trap "$(_trap -S 'EXIT' -E "unset OPT OPTARG OPTIND JOBS_" "$(trap -p)")" EXIT;
 1
        # Parse command-line options
        while getopts :: OPT; do
            case ${OPT} in
                ) eval "JOBS_${OPT}"="'${OPTARG}'";;
            esac
        done

        # Shift positional parameters
        shift $((OPTIND - 1));

        exit $?;
    );

    return $?
}


