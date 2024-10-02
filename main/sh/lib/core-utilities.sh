function _shell() {

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


function _awk() {

    # Attempt to find and set an awk variant, prioritizing common and lightweight versions
    [ -z "${AWK}" -o "${1}" = '-R' -o "${1}" = '--reload' ] && export AWK="$(
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


function _ckeck() {

    _awk || return 228;

    # Check if both arguments are provided
    [ -n "${1}" -a -n "${2}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }
    
    (

        # List directory details and pipe to awk for processing
        ls --color=never -dal "${2}" | ${AWK} \
            -v validation_string="${1}" \
            -v user="$(whoami)" \
            -v groups="$(groups "$(whoami)")" \
            -v container="$(ls --color=never -dal "$(dirname "${2}")" | awk '{printf("%s %s %s", substr($1, 2), $4, $3)}')" \
        '{

            if (validation_string) {
                # Initialize flag count and flag types
                flag_count = length(validation_string);
                type_flags = "lbpcd-";
                permission_flags = "rwx";
                split(groups, group_list, " ");

                do {
                    # Extract the current flag
                    flag = substr(validation_string, flag_count--, 1);

                    # Check if the flag is a type flag
                    if (flag ~ /^([lbpcd]|\-)$/) {

                        # Check if the flag is a type flag
                        if (index(type_flags, flag)) {
                           # Remove the flag from type_flags
                            sub(flag, "", type_flags);

                            # Check if the flag matches the file type
                            if (flag !~ substr($1, 1, 1)) {
                                # A type flag (one of l, b, p, c, d, -) is found in validation_string but does not match the file type.
                                exit 4;
                            }

                        } else {
                            # A type flag is found in validation_string but it is not in the type_flags string.
                            exit 2;

                        }

                    # Check if the flag is a permission flag
                    } else if (flag ~ /^([rwx])$/) {
                        
                        # Extract the permission part of the file details
                        if (substr(permission_flags, index(permission_flags, flag), 1)) {
                            type_permission = substr($1, 2);

                            # Determine the symbolic index for the permission flag
                            if (flag == "r") {
                                symbolic = 1;

                            } else if (flag == "w") {
                                symbolic = 2;

                            } else if (flag == "x") {
                                symbolic = 3;

                            }

                            permission_index = symbolic + 6;

                            # Determine the symbolic index for the permission flag
                            for (; symbolic <= permission_index; symbolic += 3) {
                                member = int(symbolic / 3);

                                if ((member == 0 && user == $3) || (member == 1 && $4 in group_list) || (member == 2)) {

                                    if (substr(type_permission, symbolic, 1) == flag) {

                                        for (symbolic_parent; symbolic_parent <= 9; ++symbolic_parent) {

                                            if (substr(container, symbolic_parent, 1) == "x") {

                                                space_index = index(substr(container, 11), " ");

                                                if ((symbolic_parent == 3 && user != substr(container, 11 + space_index)) && (symbolic_parent == 6 && ! substr(container, 11, space_index) in group_list)) {
                                                    delete group_list;
                                                    exit 8;

                                                }

                                                break;

                                            } else if (symbolic_parent == 9) {
                                                delete group_list;
                                                exit 7;
                                            }

                                        }

                                    }

                                } else if (member >= 3) {
                                    delete group_list;
                                    
                                    # The script is checking permissions and the user is not the owner, not in the group, and not others.
                                    exit 5;

                                }

                            }

                            delete group_list;

                            # Determine the symbolic index for the permission flag
                            sub(flag, "", permission_flags);

                        } else {
                            # A permission flag (one of r, w, x) is found in validation_string but it is not in the permission_flags string.
                            exit 3;

                        }

                    } else {
                        # A flag in validation_string is neither a type flag nor a permission flag.
                        exit 1;

                    }

                } while(flag_count);
                # All flags in validation_string are successfully validated.
                exit 0;

            }

        }';

        exit $?;

    );

    return $?;

}


function _signalList() {

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


function _signalLookup() {

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


function _trap() {

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


function _export() {

    # Check if arguments are provided
    [ -n "${*}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    } && (
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


function _directoryLinker() {

    POSIX_LINKER_VARIABLE="$(_export -N POSIX_LINKER_MAIN)" || for POSIX_LINKER_VARIABLE in $(
        # Set a trap to unset variables on exit
        trap "$(_trap -S 'EXIT' -E "unset POSIX_LINKER_DIRECTORY POSIX_LINKER_VARIABLE POSIX_LINKER_NAME" "$(trap -p)")" EXIT;

        [ "$(basename "${0}")" = 'core-utilities.sh' ] && {
            POSIX_LINKER_DIRECTORY="$(realpath "$(dirname "${0}")/../..")";
            
            [ "$(basename "${POSIX_LINKER_DIRECTORY}")" = 'main' ] || {
                exit 1;

            }

        }

        # Iterate over directories in POSIX_LINKER_DIRECTORY
        for POSIX_LINKER_VARIABLE in $(find "${POSIX_LINKER_DIRECTORY}" -maxdepth 1 -readable -writable -executable -type d -exec basename '{}' \;); do
            # Set POSIX_LINKER_NAME to the uppercase directory name
            POSIX_LINKER_NAME="POSIX_LINKER_$(printf "%s" "${POSIX_LINKER_VARIABLE^^}" | sed 's/\.//')_DIRECTORY";

            # Attempt to export the directory name, or set it if it fails
            "${POSIX_LINKER_NAME}"="$(_export -N "${POSIX_LINKER_NAME}")" 2> /dev/null || {
                echo "${POSIX_LINKER_NAME}=${POSIX_LINKER_DIRECTORY}/${POSIX_LINKER_VARIABLE}";
            }

        done

        exit $?;

    ); do

        [ -n "${POSIX_LINKER_VARIABLE}" ] && {
            export "${POSIX_LINKER_VARIABLE}";

        }
        
        unset POSIX_LINKER_VARIABLE;

    done

    unset POSIX_LINKER_VARIABLE;
    return $?;
}


function _import() {

    # Check arguments are provided
    [ -n "${*}" ] || {
        # Return 255 if the arguments are not provided
        return 255;

    }
    # for _ in $*
    # while [ ${#@} -gt 0 ]

        # Set a trap to unset variables on exit
     #   trap "$(_trap -S 'EXIT' -E "unset ERROR_COUNT" "$(trap -p)")" EXIT;

    #     while [ ${#@} -gt 0 ]; do
    #         _ckeck 'r-' "${1}" && {
    #             realpath "${1}";
    #         } || {
    #             ((++ERROR_COUNT));
    #         }

    #         # Shift to the next argument
    #         shift;

    #     done

    #     exit ${ERROR_COUNT};
    # ) && echo $_ || echo " $?"

    # while (

    # ); do
    #     [ "${_}" = "]" ] && break || echo "${_}";
    # done

}
