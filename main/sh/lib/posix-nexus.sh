posixNexusDaemon() {
    
    eval "$(
        cat "${POSIX_NEXUS_ROOT}/${1}" | ${AWK} '{
            if ($0 !~ /^[[:space:]]*startPosixNexus[[:space:]]*\(\)[[:space:]]*\{/) {
                print $0;
            } else {
                exit 0;
            }
        }'
    )"

   _import $(_posixNexusLinker sh);

    # Set file creation mask
    umask 027;

    while ! { ps -A -o pid | ${AWK} '{ gsub(/(^[[:space:]]+)|([[:space:]]+$)/, ""); print; }' | grep -q "^$(cat "${POSIX_NEXUS_PID}")$"; }; do
        :;
    done

    _import $(_posixNexusLinker sh);

    export POSIX_NEXUS_DAEMON_ROOT="/var/tmp/posix-nexus/$(cat "${POSIX_NEXUS_PID}")";

    try -O "
        D = ${POSIX_NEXUS_DAEMON_ROOT}
    ";

    (
        # Clean up old directories and start the daemon
        for OLD in /var/tmp/posix-nexus/*; do
            [ "${OLD}" = "${POSIX_NEXUS_DAEMON_ROOT}" ] || rm -rf "${OLD}";
        done
    ) &

    export POSIX_NEXUS_STDIN="${POSIX_NEXUS_DAEMON_ROOT}/stdin-posix-nexus.in";
    export POSIX_NEXUS_STDOUT="${POSIX_NEXUS_DAEMON_ROOT}/stdout-posix-nexus.out";
    export POSIX_NEXUS_STDERR="${POSIX_NEXUS_DAEMON_ROOT}/stderr-posix-nexus.out";

    try -O "
        C = mkfifo,
        F = ${POSIX_NEXUS_STDIN},
        S = ${POSIX_NEXUS_DAEMON_ROOT} : ${POSIX_NEXUS_LINK}
    ";

    while :; do
        cat "${POSIX_NEXUS_STDIN}";
    done 1>"${POSIX_NEXUS_STDOUT}" 2>"${POSIX_NEXUS_STDERR}";

}

posixNexusDaemon "${1}" ""
