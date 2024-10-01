function _empty(empty_string) {

    # Remove leading and trailing whitespace from empty_string
    # Check if empty_string is not empty after truncation
    if (_truncate(empty_string)) {
        # If not empty, return 1 (indicating the string is not empty)
        return 1;

    } else {
        # If empty, return 0 (indicating the string is empty)
        return 0;

    }

}

function _shell() {
    # Get the current shell from the environment variable SHELL
    __shell = ENVIRON["SHELL"];
    
    # Remove the path, leaving only the shells basename
    gsub(/^.*\//, "", __shell);

    # Check if the shell name matches one of the shells capable of running POSIX scripts
    if (__shell ~ /^((((r)?b|d)?a|z|k|fi)?sh)$/) {
        # If it matches, return the shell name
        return __shell;

    } else {
        # If it doesn't match, return 0
        return 0;

    }

}
