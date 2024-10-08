#!/bin/sh

function run() {

        printf "%s" "$(realpath "$(dirname "${_}")")/main" | xargs -I "{}" sh -c '
            MESSAGE="$(
                [ -e "{}" ] || { printf "The path to main does not exist."; exit 1; };
                [ -d "{}" ] || { printf "The path to main exists but is not a directory."; exit 2; };
                [ -x "{}" ] || { printf "The main directory exists but is not executable."; exit 3; };

                [ -e "{}/awk" ] || { printf "The path to awk in main does not exist."; exit 4; };
                [ -d "{}/awk" ] || { printf "The path to awk in main exists but is not a directory."; exit 5; };
                [ -x "{}/awk" ] || { printf "The awk directory in the main directory exists but is not executable."; exit 6; };

                [ -e "{}/awk/lib" ] || { printf "The path to lib in main/awk does not exist."; exit 7; };
                [ -d "{}/awk/lib" ] || { printf "The path to lib in main/awk exists but is not a directory."; exit 8; };
                [ -r "{}/awk/lib" ] || { printf "The lib directory in main/awk in the directory exists but is not readable."; exit 9; };
                [ -x "{}/awk/lib" ] || { printf "The lib directory in the main/awk directory exists but is not executable."; exit 10; };

                [ -e "{}/sh" ] || { printf "The path to sh in main does not exist."; exit 11; };
                [ -d "{}/sh" ] || { printf "The path to sh in main exists but is not a directory."; exit 12; };
                [ -x "{}/sh" ] || { printf "The sh directory in the main directory exists but is not executable."; exit 13; };

                [ -e "{}/sh/lib" ] || { printf "The path to lib in main/sh does not exist."; exit 14; };
                [ -d "{}/sh/lib" ] || { printf "The path to lib in main/sh exists but is not a directory."; exit 15; };
                [ -r "{}/sh/lib" ] || { printf "The lib directory in main/sh in the directory exists but is not readable."; exit 16; };
                [ -x "{}/sh/lib" ] || { printf "The lib directory in the main/sh directory exists but is not executable."; exit 17; };

                [ -e "{}/sh/lib/core-utilities.sh" ] || { printf "The path to core-utilities.sh in main/sh/lib does not exist."; exit 18; };
                [ -f "{}/sh/lib/core-utilities.sh" ] || { printf "The path to core-utilities.sh in main/sh/lib exists but is not a file."; exit 19; };
                [ -r "{}/sh/lib/core-utilities.sh" ] || { printf "The core-utilities.sh file in main/sh/lib exists but is not readable."; exit 20; };

                [ -e "{}/awk/lib/core-logic.sh" ] || { printf "The path to core-logic.awk in main/awk/lib does not exist."; exit 18; };
                [ -f "{}/awk/lib/core-logic.sh" ] || { printf "The path to core-logic.awk in main/awk/lib exists but is not a file."; exit 19; };
                [ -r "{}/awk/lib/core-logic.sh" ] || { printf "The core-logic.awk file in main/awk/lib exists but is not readable."; exit 20; };

            )" || {
                STATUS=$?;
                echo -e "\033[1;31m${MESSAGE}\033[0m";

            }

            exit ${STATUS:-0};
    ' || exit $?;

    (
        . "$(realpath "$(dirname "${_}")")/main/sh/lib/core-utilities.sh";

        _nexus;

        exit $?;
    )

    return $?;

}

run;
