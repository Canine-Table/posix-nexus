posixNexusDaemon() {

    _posixNexusDaemonGlobals() {

        # Set file creation mask
        umask 027;

        # Set environment variables for various paths
        export POSIX_NEXUS_RUN_ROOT="/var/run/posix-nexus";
        export POSIX_NEXUS_LOG_ROOT="/var/log/posix-nexus";
        export POSIX_NEXUS_TEMP_ROOT="/var/tmp/posix-nexus";
        export POSIX_NEXUS_DAEMON_ROOT="${POSIX_NEXUS_TEMP_ROOT}/posix-nexus-$$";
        export POSIX_NEXUS_PID="${POSIX_NEXUS_RUN_ROOT}/posix-nexus.pid";
        export POSIX_NEXUS_LINK="${POSIX_NEXUS_RUN_ROOT}/posix-nexus-directory";
        export POSIX_NEXUS_STDIN="${POSIX_NEXUS_DAEMON_ROOT}/stdin-posix-nexus.in";
        export POSIX_NEXUS_STDOUT="${POSIX_NEXUS_DAEMON_ROOT}/stdout-posix-nexus.out";
        export POSIX_NEXUS_STDERR="${POSIX_NEXUS_DAEMON_ROOT}/stderr-posix-nexus.out";

    }

    _posixNexusLinker() {

        # Ensure POSIX_NEXUS_ROOT is set, or return an error
        # Validate the first argument to ensure it's a valid variable name
        try -V 'n=POSIX_NEXUS_ROOT' -R "N=${1}" || return 1;

        # Export linker variable
        export "POSIX_NEXUS_${1:+$(echo -n "${1}" | tr '[:lower:]' '[:upper:]')}_LINKER"="$(
            LINKER_PROCESS_IDS="";
            # Iterate over files in the specified directory that match the pattern
            for POSIX_NEXUS_LOCATION in "${POSIX_NEXUS_ROOT}/main/${1}/lib/"*"-utilities.${1}"; do
                (
                    try -I "e=${POSIX_NEXUS_LOCATION},f=${POSIX_NEXUS_LOCATION},r=${POSIX_NEXUS_LOCATION}" && {
                        echo -n "${POSIX_NEXUS_LOCATION},";
                    }
                ) & LINKER_PROCESS_IDS="${LINKER_PROCESS_IDS} $!";
            done

            wait ${LINKER_PROCESS_IDS};
        )";

        return 0;
    }

    _replace() {

        # Replace occurrences of match_value with replace_value using AWK
        echo -n "${1}" | awk \
            -v match_value="${2}" \
            -v replace_value="${3}" \
        '{
            gsub(match_value, replace_value);
            print;
        }'

    }

    _posixNexusDaemonGlobals;

    {
        # Setup necessary directory trees
        [ -h "${POSIX_NEXUS_LINK}" ] && {
            try -O "C = unlink, U = ${POSIX_NEXUS_LINK}" || exit;
        }

        try -E -O "
            D=${POSIX_NEXUS_TEMP_ROOT},
            D=${POSIX_NEXUS_RUN_ROOT},
            D=${POSIX_NEXUS_LOG_ROOT},
            C=ln, C=mkfifo,
            T=${POSIX_NEXUS_PID},
            D=${POSIX_NEXUS_DAEMON_ROOT},
            F=${POSIX_NEXUS_STDIN},
            T=${POSIX_NEXUS_STDOUT},
            T=${POSIX_NEXUS_STDERR},
            S=${POSIX_NEXUS_DAEMON_ROOT} : ${POSIX_NEXUS_LINK}" -Q -I "
            d=/var, w=/var, x=/var,
            d=/var/run, x=/var/run, w=/var/run,
            d=/var/tmp, x=/var/tmp, w=/var/tmp,
            d=/var/log, x=/var/log, w=/var/log,
            d=${POSIX_NEXUS_TEMP_ROOT}, x=${POSIX_NEXUS_TEMP_ROOT}, w=${POSIX_NEXUS_TEMP_ROOT},
            d=${POSIX_NEXUS_RUN_ROOT}, x=${POSIX_NEXUS_RUN_ROOT}, w=${POSIX_NEXUS_RUN_ROOT},
            d=${POSIX_NEXUS_LOG_ROOT}, x=${POSIX_NEXUS_LOG_ROOT}, w=${POSIX_NEXUS_LOG_ROOT},
            f=${POSIX_NEXUS_PID}, r=${POSIX_NEXUS_PID},w=${POSIX_NEXUS_PID},
            d=${POSIX_NEXUS_DAEMON_ROOT}, x=${POSIX_NEXUS_DAEMON_ROOT},
            p=${POSIX_NEXUS_STDIN}, r=${POSIX_NEXUS_STDOUT},
            f=${POSIX_NEXUS_STDOUT}, r=${POSIX_NEXUS_STDOUT}, w = ${POSIX_NEXUS_STDOUT},
            f=${POSIX_NEXUS_STDERR}, r=${POSIX_NEXUS_STDERR}, w = ${POSIX_NEXUS_STDERR},
            h=${POSIX_NEXUS_LINK}, x=${POSIX_NEXUS_LINK}" || exit;
  
        ps -o pid | grep -q "^$(cat "${POSIX_NEXUS_PID}")$" || {
            kill "$(cat "${POSIX_NEXUS_PID}")" 2> /dev/null;

            {
                # Clean up old directories and start the daemon
                for OLD in ${POSIX_NEXUS_TEMP_ROOT}/*; do
                    [ "${OLD}" = "${POSIX_NEXUS_DAEMON_ROOT}" ] || rm -rf "${OLD}" 2> /dev/null;
                done

                unset OLD;

            } &

            # Link necessary utilities for AWK
            _posixNexusLinker 'awk' || exit 2;

            # Start the posix-nexus daemon with nohup, redirecting stdout and stderr, and store the PID
            nohup ${AWK} -f $(_replace "${POSIX_NEXUS_AWK_LINKER}" ',' ' -f ')${POSIX_NEXUS_ROOT}/main/awk/lib/awk-interpreter.awk \
                1> "${POSIX_NEXUS_STDOUT}" \
                2> "${POSIX_NEXUS_STDERR}" \
                & printf "%d" $! > "${POSIX_NEXUS_PID}" || exit 3;

        }

        try -C 'U=run.sh';

    } || exit;

}
