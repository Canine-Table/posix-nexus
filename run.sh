function _pathErrors() {

    function _commonPathErrors() {

        # Determine the type of error based on the first argument        
        case "${1}" in
            e)
                # Check if the path exists
                [ -e "${PATH_LOCATION}/${2}" ] || {
                    printf "No match found for for '%s' in the '%s' root directory" "${2}" "${PATH_LOCATION}";
                    return 1;
                };;
            d)
                # Check if the path is a directory
                [ -d "${PATH_LOCATION}/${2}" ] || {
                    printf "The path to '%s' is already in use within the '%s' root directory. '%s' is not a directory" "${2}" "${PATH_LOCATION}" "${2}";
                    return 1;
                };;

            f)
                # Check if the path is a regular file
                [ -f "${PATH_LOCATION}/${2}" ] || {
                    printf "The path to '%s' exists within '%s' but '%s' is a not regular file" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 1;
                };;

            r)
                # Check if the path is readable
                [ -r "${PATH_LOCATION}/${2}" ] || {
                    printf "The path to '%s' exists within '%s' but '%s' is not readable" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 1;
                };;
            w)
                # Check if the path is writable
                [ -w "${PATH_LOCATION}/${2}" ] || {
                    printf "The path to '%s' exists within '%s' but '%s' is not writable" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 1;
                };;

            x)
                # Check if the path is executable
                [ -x "${PATH_LOCATION}/${2}" ] || {
                    printf "The path to '%s' exists within the '%s' root directory but '%s' is not executable" "${2}" "${PATH_LOCATION}" "$(basename "${2}")";
                    return 1;
                };;

            *)
                # Handle unknown error flags
                printf "Unknown error flag '%s'" "${1}";;
        esac

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
                printf "\n\033[1;31m%s.\033[0m\n" "${PATH_CHECK}";
                exit $((PATH_ERROR_COUNT));
            }

            shift 2;
        done

    ) || exit $?;

    return 0;
}


function run() {

    (

        _pathErrors "$(realpath "$(dirname "${_}")")" \
            e 'main' d 'main' x 'main' \
            e 'main/awk' d 'main/awk' x 'main/awk' \
            e 'main/awk/lib' d 'main/awk/lib' x 'main/awk/lib' r 'main/awk/lib' \
            e 'main/awk/lib/core-utilities.awk' f 'main/awk/lib/core-utilities.awk' r 'main/awk/lib/core-utilities.awk' \
            e 'main/sh' d 'main/sh' x 'main/sh' \
            e 'main/sh/lib' d 'main/sh/lib' x 'main/sh/lib' r 'main/sh/lib' \
            e 'main/sh/lib/core-utilities.sh' f 'main/sh/lib/core-utilities.sh' r 'main/sh/lib/core-utilities.sh';

    ) || return $?;

    (
        . "$(realpath "$(dirname "${_}")")/main/sh/lib/core-utilities.sh";

        _nexus

        exit $?;
    )


    return $?;

}

run;
