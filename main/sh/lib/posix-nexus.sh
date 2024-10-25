trap 'kill -- -$$' EXIT INT TERM;

posixNexusDaemon() {

    while ! ps -A -o pid | ${AWK} '{ gsub(/(^[[:space:]]+)|([[:space:]]+$)/, ""); print; }' | grep -q "^$(cat "${POSIX_NEXUS_PID}")$"; do
        :;
    done

    # Set file creation mask
    umask 027;

    export POSIX_NEXUS_DAEMON_ROOT="/var/tmp/posix-nexus/$(cat "${POSIX_NEXUS_PID}")";

    try -O "
        D = ${POSIX_NEXUS_DAEMON_ROOT},
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

    exec 1>"${POSIX_NEXUS_STDOUT}";
    exec 2>"${POSIX_NEXUS_STDERR}";

    try -O "
        F = ${POSIX_NEXUS_STDIN},
        S = ${POSIX_NEXUS_DAEMON_ROOT} : ${POSIX_NEXUS_LINK}
    ";

    while :; do
        cat "${POSIX_NEXUS_STDIN}";
    done

}
