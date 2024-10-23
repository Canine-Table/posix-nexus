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

    # echo "line 34 posix-nexus.sh";
    # exit;
    _posixNexusDaemonGlobals;

    {
        # Setup necessary directory trees
        [ -h "${POSIX_NEXUS_LINK}" ] && {
           try -O "
                C = unlink, 
                U = ${POSIX_NEXUS_LINK}
            " || exit;
        }

        try -E -O "
            D = ${POSIX_NEXUS_TEMP_ROOT},
            D = ${POSIX_NEXUS_RUN_ROOT},
            D = ${POSIX_NEXUS_LOG_ROOT},
            D = ${POSIX_NEXUS_DAEMON_ROOT}
        " -O "
            C = ln, C = mkfifo,
            T = ${POSIX_NEXUS_PID},
            F = ${POSIX_NEXUS_STDIN},
            T = ${POSIX_NEXUS_STDOUT},
            T = ${POSIX_NEXUS_STDERR},
            S = ${POSIX_NEXUS_DAEMON_ROOT} : ${POSIX_NEXUS_LINK}" -I "
        " -I "
            edwx = /var,
            R = /var,
            edx = run,
            edx = log
        " -I "
            edxw = ${POSIX_NEXUS_TEMP_ROOT},
            edxw = ${POSIX_NEXUS_RUN_ROOT},
            edwx = ${POSIX_NEXUS_LOG_ROOT},
            edx = ${POSIX_NEXUS_DAEMON_ROOT}
        " -I "
            epr = ${POSIX_NEXUS_STDIN},
            ehx = ${POSIX_NEXUS_LINK},
            efrw = ${POSIX_NEXUS_PID},
            efrw = ${POSIX_NEXUS_STDERR},
            efrw = ${POSIX_NEXUS_STDOUT}
        " || exit;

#         export -f _import;
#         export -f _posixNexusLinker;

#         sh -c "
#         _import $(_posixNexusLinker sh);
#                 echo $!
# sleep 33
#         " & echo $!
# wait
#         exit;

        ps -o pid | grep -q "^$(cat "${POSIX_NEXUS_PID}")$" || {
#            kill "$(cat "${POSIX_NEXUS_PID}")" 2> /dev/null;

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
#echo            ${AWK} -f $(_replace "${POSIX_NEXUS_AWK_LINKER}" ',' ' -f ')${POSIX_NEXUS_ROOT}/main/awk/lib/awk-interpreter.awk
exit
            #     1> "${POSIX_NEXUS_STDOUT}" \
            #     2> "${POSIX_NEXUS_STDERR}" \
            #     & printf "%d" $! > "${POSIX_NEXUS_PID}" || exit 3;

        }

        try -C 'U=run.sh';

    } || exit;

}

