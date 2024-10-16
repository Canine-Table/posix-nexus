posixNexusDaemon() {
    # _posixNexusLinker "${@}"
    # echo  "$POSIX_NEXUS_SH_LINKER" | xargs $(_unQuote)
    return 0;
}

posixNexusLinker() {

    # Ensure POSIX_NEXUS_ROOT and the first argument are set, or return an error
    _taskErrors value F '_posixNexusLinker' ${#@} 1 || return 255;

    # Ensure POSIX_NEXUS_ROOT is set, or return an error
    _taskErrors other n POSIX_NEXUS_ROOT || return 1;

    # Validate the first argument to ensure it's a valid variable name
    _taskErrors value n "${1}" || return 2;

    export "POSIX_NEXUS_${1:+$(echo -n "${1}" | tr '[:lower:]' '[:upper:]')}_LINKER"="$(

        # Iterate over files in the specified directory that match the pattern
        for POSIX_NEXUS_LOCATION in "${POSIX_NEXUS_ROOT}/main/${1}/lib/"*"-utilities.${1}"; do

            # Check for path errors and add to linker variable if no errors
            _taskErrors item e "${POSIX_NEXUS_LOCATION}" f "${POSIX_NEXUS_LOCATION}" r "${POSIX_NEXUS_LOCATION}" && {
                POSIX_NEXUS_LINKER="${POSIX_NEXUS_LINKER}${POSIX_NEXUS_LOCATION}\x0a";

            }

        done

        POSIX_NEXUS_LINKER="\x22${POSIX_NEXUS_LINKER}\x22"
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
        echo -en "${POSIX_NEXUS_LINKER_VARIABLE}";

    )";

    return 0;
}

