
                            s) 
                                _exceptionI "e=${ROOT_DIRECTORY}${J}" && [ -s "${J}" ] && continue || {
                                    ERROR_OCCURED=true;
                                };;


                            h|L) 
                                _exceptionI "e=${ROOT_DIRECTORY}${J}" && [ -h "${J}" ] && continue || {
                                    ERROR_OCCURED=true;
                                };;


                            t) 
                                _exists "${ROOT_DIRECTORY}${J}" "t" || {
                                    ERROR_OCCURED=true;
                                };;


                            r) 
                                _exists "${J}" "r=${J}" || {
                                    ERROR_OCCURED=true;
                                };;


                            w) 
                                _exceptionI="e=${J}" && [ -w "${J}" ] && continue || {
                                    ERROR_OCCURED=true;
                                };;



# case "${1}" in
#     e)
        # Check if the path exists
        [ -e "${PATH_LOCATION}" ] || {
            printf "No match found for the relative path '%s' in the '%s' working directory" "${2}" "${WORKING_DIRECTORY}";
            ERROR_OCCURED=true;

        };;

#     d)
        # Check if the path is a directory
        [ -d "${PATH_LOCATION}" ] || {
            printf "[${1}] The relative path to '%s' is already in use within the '%s' working directory" "${2}" "${WORKING_DIRECTORY}";
            ERROR_OCCURED=true;

        };;

#     f)
#         # Check if the path is a regular file
#         [ -f "${PATH_LOCATION}" ] || {
#             printf "[${1}] The the relative path to '%s' exists within '%s' but '%s' is a not regular file" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
#             ERROR_OCCURED=true;

#         };;

#     r)
#         # Check if the path is readable
#         [ -r "${PATH_LOCATION}" ] || {
#             printf "[${1}] The path to '%s' exists within '%s' but '%s' is not readable" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
#             ERROR_OCCURED=true;

#         };;
#     w)
#         # Check if the path is writable
#         [ -w "${PATH_LOCATION}" ] || {
#             printf "[${1}] The path to '%s' exists within '%s' but '%s' is not writable" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
#             ERROR_OCCURED=true;

#         };;

    x)
        # Check if the path is executable
        [ -x "${PATH_LOCATION}" ] || {
            printf "[${1}] The path to '%s' exists within the '%s' root directory but '%s' is not executable" "${2}" "${WORKING_DIRECTORY}" "$(basename "${2}")";
            ERROR_OCCURED=true;

        };;

#     t)
#         # Check if the path is associated with a terminal.
#         [ -t "${PATH_LOCATION}" ] || {
#             printf "[%s] The path to '%s' is not associated with a terminal in the '%s' directory.\x0a" "${1}" "${2}" "${WORKING_DIRECTORY}"
#             ERROR_OCCURED=true;

#         };;


#     h|L)
#         # Check if the path is a symbolic link.
#         [ -h "${PATH_LOCATION}" ] || {
#             printf "[%s] The path to '%s' in the '%s' directory is not a symbolic link.\x0a" "${1}" "${2}" "${WORKING_DIRECTORY}";
#             ERROR_OCCURED=true;

#         };;

#     s)
#         # Check if the path is a non-empty file.
#         [ -s "${PATH_LOCATION}" ] || {
#             printf "[%s] The file at '%s' in the '%s' directory is empty.\x0a" "${1}" "${2}" "${WORKING_DIRECTORY}";
#             ERROR_OCCURED=true;

#         };;

#     item|static|other|value)
#         # Handle common errors
#         _commonErrors "${@}" &
#         exit 0;;
# esac
