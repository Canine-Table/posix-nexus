function _completion(completion_string, completion_input, delimiter) {

    # Use "," as the fallback delimiter if the 3rd parameter 'delimiter' is empty or not provided
    if (length(delimiter)  < 1) {
        delimiter = ",";

    }

    # Split the completion_string into an array using the specified delimiter
    split(completion_string, __completion_list, "[[:space:]]*" delimiter "[[:space:]]*");

    # Enable case-insensitive string comparisons
    IGNORECASE = 1;

    # Split an empty string into an array named __unique_list using an empty string as the delimiter
    split("", __unique_list, "");

    # Iterate over each key in __completion_list
    for (__completion_key in __completion_list) {
        # Assign the key to the corresponding value in __unique_list
        __unique_list[__completion_list[__completion_key]] = __completion_key;

    }

    # Delete all elements from the __completion_list array
    delete __completion_list;

    # Assign the value of completion_input to __match_input
   __match_input = completion_input;

   # Remove leading and trailing whitespace from __match_input
    gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", __match_input);

    # Initialize __unique_string as an empty string
    __unique_string = "";
 
    # Iterate over each character length from 1 to the length of __match_input
    for (__character_length = 1; __character_length <= length(__match_input); ++__character_length) {

        # Iterate over each unique element in __unique_list
        for (__unique in __unique_list) {
            __unique_string = __unique_string "" delimiter "" __unique;

            # Check if __unique does not match the pattern "^__unique.*$"
            if (__unique !~  "^" __unique ".*$") {

                # If it doesn't match, delete the element from __unique_list
                delete __unique_list[__unique];

            # Otherwise check if __unique_list has only one element or if __match_input exactly matches __unique
            } else if (length(__unique_list) == 1 || __match_input ~ "^" __unique "$") {

                # Enable case-sensitive string comparisons
                IGNORECASE = 0;

                # Delete all elements from the __completion_list array
                delete __unique_list;

                #  Return the value of __unique and exit the _completion subroutine
                return __unique;
            }

        #         __completion_regex = "/(" delimiter "" __unique_list[__unique_key] ")|(" __unique_list[__unique_key] "" delimiter ")/";

        #         if (match(completion_string, __completion_regex)) {
        #             print completion_string #, 1, RSTART + RLENGTH);
        #         }

        }
    }

    # Enable case-sensitive string comparisons
    IGNORECASE = 0;

    delete __unique_list;
}

BEGIN {
   print _completion("dog, dog, dog, cat, frog, donkey", "do")
}

# else if (__character_length == length(completion_input)) {
#                 return 0; # TODOS