split() {
    # Process the input string using Awk with the specified delimiters
    echo -n "${*}" | awk -v delimeters="${1}" '{

        # Remove the delimiters from the start of the string
        string = substr($0, length(delimeters) + 1);
        
        # Remove leading and trailing whitespace from the string
        gsub(/((^[[:space:]]+)|([[:space:]]+$))/, "", string);

        # Check if the string contains any of the delimiters
        if (match(string, "[" delimeters "]")) {
            do {
                # Extract the item before the delimiter
                item = substr(string, 1, RSTART - RLENGTH);
                
                # Remove leading and trailing whitespace from the item
                gsub(/((^[[:space:]]+)|([[:space:]]+$))/, "", string);
                
                # Remove the processed part from the string
                sub(substr(string, 1, RSTART), "", string);
                
                if (item) {
                    # Print each non-empty field
                    print item;
                }
            } while (match(string, "[" delimeters "]"));
            
            # Print the remaining part of the string
            print string;
            exit 0;
        }

        exit 1;

    }';
}

iterator() {

    # Process the input string using Awk with the specified field separator (FS)
    echo -n $* | awk -v FS="${1}" '{
        for (i = 1; i <= NF; ++i) {
            # Remove leading and trailing whitespace from each field
            gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", $i);
            if ($i) {
                # Print each non-empty field
                print $i;
            }
        }
    }'

    return 0;
}

