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

    # Return the exit status of the last command
    return $?;
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
