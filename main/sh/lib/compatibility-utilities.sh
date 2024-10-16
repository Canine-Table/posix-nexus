

#     function _treeCleaner() {
#             # Check if the posix-nexus-location is a symbolic link, if not, create it
# [ -h '/var/run/posix-nexus/posix-nexus-location' ] || {
#     touch '/var/run/posix-nexus/posix-nexus-location' || exit 3;
# }
#         POSIX_NEXUS_LOCATION="$(readlink -f '/var/run/posix-nexus/posix-nexus-location')";

#         [ -d "${POSIX_NEXUS_LOCATION}" ] && {
#             rm -rf "${POSIX_NEXUS_LOCATION}" || exit 5;
#         }
#     }

# function _nexus() {

# [ -f '/var/run/posix-nexus.pid' ] || {

#     [ -e '/var/run/posix-nexus.pid' ] && {
#         mv '/var/run/posix-nexus.pid' "/var/run/.posix-nexus-$(date +"%s").pid.bak" || exit 1;

#     }

#     touch '/var/run/posix-nexus.pid' || exit 2;

# }

# chmod 644 '/var/run/posix-nexus.pid' || exit 3;

# kill "$(cat '/var/run/posix-nexus.pid')";
# rm -rf "/var/run/posix-nexus-directory";

# ps -A | grep -q "^$(cat '/var/run/posix-nexus.pid')$" || {

#     [ -d "/var/tmp/posix-nexus-$$" ] || {

#         [ -e "/var/tmp/posix-nexus-$$" ] && {
#             mv "/var/tmp/posix-nexus-$$" "/var/tmp/posix-nexus-$(date +"%s")-${$}.bak" || exit 5;
#         }

#         mkdir "/var/tmp/posix-nexus-$$" || exit 6;
#     }

#     ln -sf "/var/tmp/posix-nexus-$$" "/var/run/posix-nexus-directory" || exit 7;

#     [ -p "/var/run/posix-nexus-directory/stdin-posix-nexus-${$}.in" ] || {
#         command -v mkfifo 1> /dev/null || exit 7;
#         mkfifo "/var/run/posix-nexus-directory/stdin-posix-nexus-${$}.in";
#     }

#     nohup sh -c 'while :; do  sleep 3; cat "/var/run/posix-nexus-directory/stdin-posix-nexus-${$}.in"; done' \
#         1> "/var/run/posix-nexus-directory/stdout-posix-nexus-${$}.out" \
#         2> "/var/run/posix-nexus-directory/stderr-posix-nexus-${$}.out" \
#         & printf "%d" $! > '/var/run/posix-nexus.pid' || exit 8;

# }

# }