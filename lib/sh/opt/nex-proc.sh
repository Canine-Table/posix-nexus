nx_proc_clean() (
    tmpa="$NEXUS_ENV/hash/$1"
    test -d "$tmpa" || {
        nx_io_printf -W "$1 has vanished!" 2>&1
        return 1
    }

    tmpb="$(nx_info_path -b "$tmpa/.nx-pid")"

    rm -rf "$NEXUS_ENV/pid/$tmpb" && {
        find "$NEXUS_ENV/by/" -type l -name "*-$tmpb" -exec rm -f {} \;
        rm -rf "$tmpa"
    }

    test -d "$tmpa" && rm -rf "$tmpa"
)

