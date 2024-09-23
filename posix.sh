#!/bin/sh

function _posix() {
    "/usr/local/include/posix/posix.d/sh/posix-utilities.sh" "${@}";
    return $?;
}

_posix "${@}";
echo "Returned: ${?}";

# X=$(shift 2> /dev/null) || echo "empty";
# echo $X
# function _flag() {

#     [ -n "${1}" ] && {
#         awk -v flag_string="${-}" -v check="${1}" 'BEGIN {
#             flag_count = split(flag_string, flag_list, "");

#             do {
#                 if (flag_list[flag_count] ~ "^[[:space:]]*" check "[[:space:]]*$") {
#                     exit 0;
#                 };

#             } while(--flag_count);
#             exit 1;
#         }';

#         return $?;
#     }

#     return 255;
# }


# function _exist() {
#     [ -e "$(realpath "${1}")" ] && {
#         realpath "${1}";
#         return 0;
#     }

#     return 1;
# }

# function _classify() {

#     _trapper 'unset CLASSIFY_LOCATION CLASSIFY_CLASSIFICATION CLASSIFY_DIRNAME CLASSIFY_BASENAME' EXIT;

#     CLASSIFY_LOCATION="$(_exist "${1}")" && shift || return 228;
#     CLASSIFY_BASENAME="$(basename "${CLASSIFY_LOCATION}")";
#     CLASSIFY_DIRNAME="$(realpath "$(dirname "${CLASSIFY_LOCATION}")")";

#     [ -d "${CLASSIFY_LOCATION}" ] && {
#         CLASSIFY_DIRNAME="$(realpath "${CLASSIFY_LOCATION}/..")";
#     }

#     CLASSIFY_CLASSIFICATION="$(ls --color=never -al "${CLASSIFY_DIRNAME}" | grep "${CLASSIFY_BASENAME}" | cut -c1)" && case "${CLASSIFY_CLASSIFICATION}" in
#         -|l|b|p|c|d)
#             [ -z "${1}" ] && {
#                 echo -n "${CLASSIFY_CLASSIFICATION}";
#                 return 0;
#             } || [ "${CLASSIFY_CLASSIFICATION}" = "${1}" ] && {
#                 return 0;
#             }
#         ;; *) return 228;;
#     esac

#     return 1;
# }


# function _import() {
    # basename "${0}" | grep -q 'utilities.sh' && {
    #     [ "$(_classify "${0}")" = 'f' ] 
    # }

# }

# # POSIX_SH_UTILITY_DIRECTORY=
# # POSIX_SH_UTILITY_FILE=
# # "$(realpath "${0}")";
# # "$(dirname "${0}")";
        
# #         for 
# #         [ -x "${POSIX_SH_UTILITY_FILE}" -a -r "${POSIX_SH_UTILITY_FILE}" ] && {
# #             export POSIX_SH_UTILITY_FILE;

# #         } || return 2;

# #         [ -d "${POSIX_SH_UTILITY_DIRECTORY}" -a -x "${POSIX_SH_UTILITY_DIRECTORY}" -a -r "${POSIX_SH_UTILITY_DIRECTORY}" ] && {
        
# #         }

# #     }

# #     # Declare local variables
# #     # OPT OPTARG OPTIND;

# #     # Parse command-line options
# #     # while getopts :F: OPT; do
# #     #     case ${OPT} in
# #     #         q)  INDEX_QUERIER_PROPERTIES["${OPT}"]='true';;
# #     #     esac
# #     # done

# # }


# _import "${@}";

