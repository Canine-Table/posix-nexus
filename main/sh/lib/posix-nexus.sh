posixNexusDaemon() {

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
 _replace "hello world" "world" "hello"
 exit
    # echo "line 34 posix-nexus.sh";
    # exit;
#    _posixNexusDaemonGlobals;

    {

        # Set file creation mask
        umask 027;

        export POSIX_NEXUS_PID="/var/run/posix-nexus/posix-nexus.pid";
        export POSIX_NEXUS_LINK="/var/run/posix-nexus/posix-nexus-directory";

        [ -h "${POSIX_NEXUS_LINK}" ] && {
           try -O "
                C = unlink, 
                U = ${POSIX_NEXUS_LINK}
            " || exit;
        }

        nohup ${SHELL} -c "
            _import $(_posixNexusLinker sh);

            while [ -z '${POSIX_NEXUS_DAEMON_ROOT}' ]; do
                sleep 2;
                echo hi;
            done

        " & printf "%d" $! > "${POSIX_NEXUS_PID}";

        # Set environment variables for various paths
        export POSIX_NEXUS_DAEMON_ROOT="/var/tmp/posix-nexus/$(cat "${POSIX_NEXUS_PID}")";
        export POSIX_NEXUS_STDIN="${POSIX_NEXUS_DAEMON_ROOT}/stdin-posix-nexus.in";
        export POSIX_NEXUS_STDOUT="${POSIX_NEXUS_DAEMON_ROOT}/stdout-posix-nexus.out";
        export POSIX_NEXUS_STDERR="${POSIX_NEXUS_DAEMON_ROOT}/stderr-posix-nexus.out";

#        try -O "S = ${POSIX_NEXUS_DAEMON_ROOT} : ${POSIX_NEXUS_LINK}";
        try -C 'U=run.sh';

    } || exit;

}
