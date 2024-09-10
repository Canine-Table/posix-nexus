echo "${0}"

function stringHash() {

    # Parse options passed to the function
    while getopts VQ:M:L: OPT; do
        case ${OPT} in
            H|S) UNIQUE_PROPERTIES["${OPT}"]='true';;
        esac
    done

    # Shift positional parameters by the number of options parsed
    shift $((OPTIND - 1));

    for HASH in \
        'whirlpoolsum' \
        'sha512sum' \
        'sha384sum' \
        'sha256sum' \
        'sha224sum' \
        'sha1sum' \
        'b2sum' \
        'cksum';
    do
        command -v "${HASH}" &> /dev/null && {
            STRING_HASH="$("${HASH}" "${STRING}")";
            echo "${HASH}_${STRING_HASH}"="${STRING}";
        }
    done

    unset HASH STRING OPT OPTARG OPTIND;
    return 0;
}