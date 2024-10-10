_pathErrors() {

    _commonPathErrors() {

        PATH_LOCATION="$(realpath "${PATH_LOCATION}/${2}")";

        # Determine the type of error based on the first argument        
        case "${1}" in
            e)
                # Check if the path exists
                [ -e "${PATH_LOCATION}" ] || {
                    printf "No match found for for '%s' in the '%s' root directory" "${2}" "${PATH_LOCATION}";
                    return 1;
                };;
            d)
                # Check if the path is a directory
                [ -d "${PATH_LOCATION}" ] || {
                    printf "The path to '%s' is already in use within the '%s' root directory. '%s' is not a directory" "${2}" "${PATH_LOCATION}" "${2}";
                    return 2;
                };;

            f)
                # Check if the path is a regular file
                [ -f "${PATH_LOCATION}" ] || {
                    printf "The path to '%s' exists within '%s' but '%s' is a not regular file" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 3;
                };;

            r)
                # Check if the path is readable
                [ -r "${PATH_LOCATION}" ] || {
                    printf "The path to '%s' exists within '%s' but '%s' is not readable" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 4;
                };;
            w)
                # Check if the path is writable
                [ -w "${PATH_LOCATION}" ] || {
                    printf "The path to '%s' exists within '%s' but '%s' is not writable" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 5;
                };;

            x)
                # Check if the path is executable
                [ -x "${PATH_LOCATION}" ] || {
                    printf "The path to '%s' exists within the '%s' root directory but '%s' is not executable" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 6;
                };;
            s)
                printf 'Please execute the run.sh script to initialize the POSIX Nexus environment or ensure the correct file path is specified';
                return 7;;

            *)
                # Handle unknown error flags
                printf "Unknown error flag '%s'" "${1}";
                return 127;;
        esac

        return 0;

    }

    (
        trap 'unset PATH_ERROR_COUNT PATH_CHECK PATH_LOCATION' EXIT;

        [ -z "${PATH_LOCATION}" ] && {
            PATH_LOCATION="${1}";
            shift;
        }

        # Process each pair of arguments
        while [ ${#@} -gt 0 ]; do

            # Increment the PATH_ERROR_COUNT
            ((++PATH_ERROR_COUNT));

            # Check for path errors
            PATH_CHECK="$(_commonPathErrors "${1}" "${2}")" || {
                echo -e "\033[1;31m${PATH_CHECK}.\033[0m";
                exit $((PATH_ERROR_COUNT));
            }

            shift 2;
        done

    ) || return $?;

    return 0;
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


startPosixNexus() {

    (

        # Set a trap to unset these variables on exit
        trap 'unset POSIX_NEXUS_LIBRARY POSIX_NEXUS_LIBRARY_INDEX IFS' EXIT;

        # Check various paths and files using the _pathErrors function
        # Ensures all necessary directories and files exist and are accessible
        _pathErrors "${1}" \
            e 'main' d 'main' x 'main' \
            e 'main/awk' d 'main/awk' x 'main/awk' \
            e 'main/awk/lib' d 'main/awk/lib' x 'main/awk/lib' r 'main/awk/lib' \
            e 'main/awk/lib/core-utilities.awk' f 'main/awk/lib/core-utilities.awk' r 'main/awk/lib/core-utilities.awk' \
            e 'main/sh' d 'main/sh' x 'main/sh' \
            e 'main/sh/lib' d 'main/sh/lib' x 'main/sh/lib' r 'main/sh/lib' \
            e 'main/sh/lib/core-utilities.sh' f 'main/sh/lib/core-utilities.sh' r 'main/sh/lib/core-utilities.sh' || exit $?;

        # Set the root directory for POSIX Nexus
        export POSIX_NEXUS_ROOT="${1}";
        shift;

        # Call the _linker function with 'sh' and the delimiter '\x09'
        _linker 'sh' '\x09';

        # Evaluate the POSIX_NEXUS_SH_LINKER variable
        eval "$(
            # trap 'unset POSIX_NEXUS_LIBRARY' EXIT;
            echo "${POSIX_NEXUS_SH_LINKER}" | while IFS="$(echo -en '\x09')" read -r POSIX_NEXUS_LIBRARY; do
                # Concatenate the contents of each file listed in the POSIX_NEXUS_SH_LINKER
                cat "$(_unQuote ${POSIX_NEXUS_LIBRARY})";

            done
            
            # exit $?;
        )";

        _linker 'awk' '-f';
        eval "$(cat "${POSIX_NEXUS_ROOT}/main/sh/lib/core-utilities.sh")$(
            while [ ${#@} -gt 0 ]; do
                echo -en "\x20\x27${1}\x27";
                shift;

            done

        )";

        exit $?;

    ) || exit $?

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
                _pathErrors "" e "${POSIX_NEXUS_LOCATION}" f "${POSIX_NEXUS_LOCATION}" r "${POSIX_NEXUS_LOCATION}" && {
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

if realpath -q -e "$(pwd)/$(dirname "${0}")/main/sh/lib/core-utilities.sh" 1> /dev/null; then
    startPosixNexus "$(pwd)/$(dirname "${0}")" "${@}";
else
    _pathErrors "" s;
    exit 1;
fi
