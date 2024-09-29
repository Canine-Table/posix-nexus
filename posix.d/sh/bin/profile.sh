function _appendPath() {

    # Loop through all arguments passed to the function
    while [ ${#@} -gt 0 ]; do

        # Check if the directory is already in the PATH
        case ":${PATH}:" in
            *:"${1}":*) ;; # If the directory is already in the PATH, do nothing
            *)  
                # If the directory is not in the PATH, check if it is a valid directory
                # that is executable and readable, then add it to the PATH
                [ -d "${1}" -a -x "${1}" -a -r "${1}" ] && export PATH="${PATH:+${PATH}:}${1}";;
        esac

        # Shift to the next argument
        shift;

    done

    # Return success
    return 0;
}


function profile() {

    umask 022;

    tty -s && {

        case ${TERM} in
            Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*) PROMPT_COMMAND+=('printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"');;
            screen*) PROMPT_COMMAND+=('printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"');;
        esac

        printf '\x0a';
        command -v neofetch &> /dev/null && {
            neofetch | (command -v lolcat 1> /dev/null && lolcat || tee);
            printf '\x0a';
        }

    }
}

function _stty() {

    [ -n "${1}" ] && {
        tty -s && {
            stty -a | awk -v property="${1}" '{
                entry_count = split($0, entries, "\x3b");

                do {
                    if (entries[entry_count]) {

                        if (sub(/^[[:space:]]+/, "", entries[entry_count])) {
                            print substr(entries[entry_count], 1, index(entries[entry_count], "\"));
                        }

                    }

                    delete entries[entry_count--];

                } while(entry_count);

                delete entries;

            }'
        } || return 1;
    } || return 255;
}



#_stty "${1}";

function _octalHex

# appendPath ''

# for \
#     '/usr/local/sbin' \
#     '/usr/local/bin' \

# do

# done

#         # Append our default paths
#         append_path ;
#         append_path ;
#         append_path '/usr/local/sbin';
#         append_path '/usr/local/bin';
#         append_path '/usr/sbin';
#         append_path '/usr/bin';

# tty -s && {

# } || {
#     :
# }

# wait;

#while ${#@}; do
#done
