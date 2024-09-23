function _completion(completion_string, completion_input, completion_delimiter) {

    # Use "," as the fallback completion_delimiter if the 3rd parameter 'completion_delimiter' is empty or not provided
    if (length(completion_delimiter)  < 1) {
        completion_delimiter = ",";

    }

    # Split the completion_string into an array using the specified completion_delimiter
    split(completion_string, __completion_list, "[[:space:]]*" completion_delimiter "[[:space:]]*");

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

    # If __match_input is empty, return 255 to indicate an error
    if (length(__match_input)  < 1) {
        return 255;

    }

    # Initialize __unique_string as an empty string
    __unique_string = "";
 
    # Iterate over each character length from 1 to the length of __match_input
    for (__character_length = 1; __character_length <= length(__match_input); ++__character_length) {

        # Iterate over each unique element in __unique_list
        for (__unique in __unique_list) {

            # Append __unique to __unique_string with completion_delimiter in between
            __unique_string = __unique_string "" completion_delimiter "" __unique;

            # Check if __unique does not match the pattern "^__unique.*$"
            if (__match_input !~  "^" substr(__unique, 1, __character_length) ".*$") {
                # If it doesn't match, delete the element from __unique_list
                delete __unique_list[__unique];

                # If __unique_list is empty, __match_input did not match any element. Return 0 to indicate an error.
                if (length(__unique_list) == 0) {
                    return 0;

                }

            # Otherwise check if __unique_list has only one element or if __match_input exactly matches __unique
            } else if (length(__unique_list) == 1 || __match_input ~ "^" __unique "$") {
                # Enable case-sensitive string comparisons
                IGNORECASE = 0;

                # Delete all elements from the __completion_list array
                delete __unique_list;

                #  Return the value of __unique and exit the _completion subroutine
                return __unique;

            }
        }
    }

    # Enable case-sensitive string comparisons
    IGNORECASE = 0;

    # Initialize __character_length to 0 and __closest_match to an empty string
    __character_length = 0; __closest_match = "";

    # Iterate over each unique element in __unique_list
    for (__unique in __unique_list) {

        # If __character_length is 0 or the length of __unique is less than __character_length
        if (__character_length == 0 || length(__unique) < __character_length) {
            # Update __character_length to the length of __unique
            __character_length = length(__unique);

            # Set __closest_match to the current __unique element
            __closest_match = __unique;

        }
    }

    # Delete all elements from the __completion_list array
    delete __unique_list;

    # Return the value of __closest_match and exit the function
    return __closest_match;

}


function _truncate(truncate_string) {
    # Remove leading and trailing whitespace from truncate_string
    gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "", truncate_string);

    # Return the modified truncate_string
    return truncate_string;

}



function _constant(constant_string_delimiter, constant_string) {
    if (! constant_string_delimiter) {
        constant_string_delimiter = ",";
    }

    __constant_delimiter_pairs = constant_string_delimiter;
    gsub("[^" constant_string_delimiter "]", "", __constant_delimiter_pairs);
    #print __constant_delimiter_pairs
    # print __constant_delimiter_pairs;
}

