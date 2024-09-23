function _export() {

    # Check if the first argument is non-empty
    [ -n "${1}" ] && {
    
        # Set a trap to unset EXPORT_VARIABLE on function return or error
        trap 'unset EXPORT_VARIABLE' RETURN ERR;

        EXPORT_VARIABLE="$(
            # Use awk to find and print the value of the environment variable
            export -p | awk -v variable="${1}" '{
                if (match($0, " " variable "(=\"|$)")) {
                    if ($NF == variable) {
                        printf("%s", "true");
                        exit 1;
                    } else {

                        value = substr($0, RSTART + RLENGTH - 1);

                        if (substr(value, 1, 1) ~ substr(value, length(value), 1)) {
                            gsub(/(^.)|(.$)/, "", value);
                        }
                    }

                    printf("%s", value);
                    exit 1;
                }
            }';
        )";

        [ $? -eq 1 ] && {

            [ -n "${2}" -a "${2}" != "${EXPORT_VARIABLE}" ] && {
                export "${1}"="${2}";
            }

            # Return 0 (success)
            return 0;

        } || return 228;
    } || return 255; # Return 255 (null)
}

function _awkFactory() {

    command -v awk 1> /dev/null || return 1;
    trap 'unset POSIX_AWK POSIX_AWK_PATH POSIX_AWK_EXPORT POSIX_AWK_ERROR_CODE' RETURN ERR;

    #echo -n "${0}" | grep -q '*-utilities.sh' && {

        POSIX_AWK_PATH="$(realpath "$(dirname "${0}")/../awk")";

        for POSIX_AWK in 'ROOT' 'BIN' 'LIB'; do

            ((++POSIX_AWK_ERROR_CODE)); 
            POSIX_AWK_EXPORT="${POSIX_AWK_PATH}";

            _export "POSIX_AWK_${POSIX_AWK}" || {

                [ "${POSIX_AWK_ERROR_CODE}" != 1 ] && POSIX_AWK_EXPORT="${POSIX_AWK_EXPORT}/${POSIX_AWK,,}";
                [ "${POSIX_AWK}" = 'LIB' ] && unset POSIX_AWK_FILES;
                [ -d "${POSIX_AWK_EXPORT}" -a -r "${POSIX_AWK_EXPORT}" -a -x "${POSIX_AWK_EXPORT}" ] && {
                    _export "POSIX_AWK_${POSIX_AWK}" "${POSIX_AWK_EXPORT}";
                }
            }
        done

        export -p | grep 'export POSIX_AWK_*'
        # _export "POSIX_AWK_FILES" || {
        #     for POSIX_AWK in ${POSIX_AWK_LIB}*; do
            # echo ${POSIX_AWK_LIB}
            # echo ${POSIX_AWK_BIN}
        #     done
        # }


#    } || return 10;

}

# _awkFactory 'testing.awk' # "${@}";
# echo $?
# # echo $POSIX_AWK

    #     POSIX_AWK="$(realpath "$(dirname "${0}")/../awk")";

    #     [ -z "${POSIX_AWK_LIBRARY}" ] && {
    #         [ -d "${POSIX_AWK}/lib" -a -r "${POSIX_AWK}/lib" ] && {
    #             export POSIX_AWK_LIBRARY="${POSIX_AWK}/lib";
    #         } || {
    #             unset POSIX_AWK;
    #             return 2;
    #         }
    #     }

    #     [ -z "${POSIX_AWK_BIN}" ] && {
    #         [ -d "${POSIX_AWK}/bin" -a -r "${POSIX_AWK}/bin" ] && {
    #             export POSIX_AWK_BIN="${POSIX_AWK}/bin";
    #         } || {
    #             unset POSIX_AWK;
    #             return 3;
    #         }
    #     }
    # }

    # [ -z "${POSIX_AWK_FILES}" ] && {
    #     for POSIX_AWK in ${POSIX_AWK_LIBRARY}/*-utilities.awk; do
    #         [ -f "${POSIX_AWK}" -a -r "${POSIX_AWK}" ] && {
    #             POSIX_AWK_FILES="${POSIX_AWK_FILES} -f \"${POSIX_AWK}\"";
    #         }
    #     done
    # }

    # [ -n "${1}" ] && {
    #     POSIX_AWK="${POSIX_AWK_BIN}/${1}";
    #     [ -f "${POSIX_AWK}" -a -r "${POSIX_AWK}" ] && {
    #         POSIX_AWK_FILES="${POSIX_AWK_FILES} -f \"${POSIX_AWK}\"";
    #         echo "${*:2}" | awk -v factory_values="${POSIX_AWK_FILES}";
    #     }
    # } || return 228;

# _awkFactory 'testing.awk' "hello worlld";
