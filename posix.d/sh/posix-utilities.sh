function _trapper() {

    # Parse command-line options
    while getopts :S:I OPT; do
        case ${OPT} in
            S)
                for OPT in $(trap -l | awk '{for (i = 2; i <= 64; i+=2) {print $i}}' | awk '{if ($0 !~ /^$/) {printf $1 " "}}') 'RETURN' 'EXIT' 'DEBUG'; do
                    [ "${OPT}" = "${OPTARG^^}" ] && {
                        SIGNAL="${OPTARG^^}";
                    }
                done

                [ -z "${SIGNAL}" ] && {
                    echo -e "\033[1;31m [-] \033[0m \e[1;4;31mInvalid Trap Provided\033[0;1;31m: \e[30;91m Please use one of the following traps:\n\n$(trap -l)65) RETURN\t66) EXIT \t67) DEBUG\033[0m" >&2;
                    return 1;
                } ;;
            I) INITIALIZE='true';;
        esac
    done

    # Shift positional parameters
    shift $((OPTIND - 1));
  
    SIGNAL="${SIGNAL:-EXIT}";

    ${INITIALIZE:-false} && trap - "${SIGNAL}";

    # Loop through all provided commands
    for APPEND in "${@}"; do
        # Get the current trap command for the specified signal
        COMMAND=$(trap -p "${SIGNAL}" | awk -v signal="${SIGNAL}" '{
            sub(/^trap \-\-( \-)?/, "");
            sub(/(")? EXIT$/, "");
            printf("%s", $0);
        }');

        # If the command executes successfully, append it to the existing trap command
        eval '${APPEND}' &> /dev/null && {
            COMMAND="$(trap "echo -n \'${APPEND}; echo -n '; ${COMMANDS}'\'" "${SIGNAL}" | sed "s/^'//; s/'$//; ")";
        }

         # Update the COMMANDS variable with the new trap command
        COMMANDS="${COMMAND}";
    done

    # Set the new trap command for the specified signal
    trap "${COMMANDS}" "${SIGNAL}";

    # Clean up variables
    unset COMMANDS APPEND INITIALIZE OPTIND OPT OPTARG COMMAND SIGNAL;
    return 0;
}


function _cleanup() {

    function _reset() {

        # Initialize PROCESS_IDS to 0
        $((PROCESS_IDS=0));

        for RESET_VALUE in "${@}"; do
            ((PROCESS_IDS++));
 
            # Check if the variable is declared and unset it
            declare -p | grep -q "declare -* ${RESET_VALUE}=" 2> /dev/null && {
                unset "${RESET_VALUE}" & eval "PROCESS_${PROCESS_IDS}"=$!;
            }
        done

        # Wait for all processes to complete and unset process IDs
        for ((ID=1; ID <= ${PROCESS_IDS}; ID++)); do
            wait "$(eval "echo \$PROCESS_${ID}")" && unset PROCESS_${ID};
        done

        # Clean up variables
        unset ID PROCESS_IDS RESET_VALUE;
    }

    # Check for command-line options and call trapper function accordingly
    if [ "${1}" = '--values' -o "${1}" = '-V' ]; then
        shift && trapper -S EXIT "_reset ${@}";
    elif [ "${1}" = '--value' -o "${1}" = '-v' ]; then
        shift && trapper -I -S EXIT "_reset ${@}";
    else
        # Reset the EXIT trap if no options are provided
        trap - EXIT;
    fi

    # Clean up variables
    unset RESET_VALUE PROCESS_IDS;
    return 0;
}

function append_path() {
    case ":${PATH}:" in
        *:"${1}":*) return 1;;
        *) export PATH="${PATH:+${PATH}:}${1}";;
    esac

    return 0;
}


function _import() {

    # Parse options passed to the function
    while getopts VQ:M:L: OPT; do
        case ${OPT} in
            Q|) UNIQUE_PROPERTIES["${OPT}"]='true';;
        esac
    done

    # Shift positional parameters by the number of options parsed
    shift $((OPTIND - 1));

    V='/etc/shells';
    [ -f "${V}" -a -r "${V}" ] && while read -r V; do
        command -v "${V}" &> /dev/null && {
            [ "${V}" = "${0}" ] || {
                _error 'error' 'hello world';
                break;
            }

        }
       # cut -s -d '/' -f 1 "${V}"; # &;
        POSIX_SH_LIBRARY_DIRECTORY
        POSIX_AWK_LIBRARY_DIRECTORY
        POSIX_SED_LIBRARY_DIRECTORY
    done < "${V}";

    awk -v shell="$(ps -p $$ | awk '{ if ( $NF != "CMD" ) { print $NF } }')" 'BEGIN {
        if (shell ~ /)
    }';
        'pwsh'|
        [za]sh
    esac

    unset V F OPTIND OPT OPTARG;
    return 0;
}

_import;