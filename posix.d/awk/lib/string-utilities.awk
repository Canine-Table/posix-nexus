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


function _characterCounter(characterCounter_string, characterCounter_character) {

    # Check if the input string is provided
    if (characterCounter_string) {
 
        # If the character to count is not provided, default to a space
        if (! characterCounter_character) {
            characterCounter_character = " ";

        }

        # Use gsub to replace all occurrences of the character with an empty string
        # gsub returns the number of replacements made, which is the count of the character
        return gsub(characterCounter_character, "", characterCounter_string);

    } else {
        # If the input string is not provided, return 0
        return 0;

    }

}


function _constant(constant_string, constant_array_reference) {

    # Check if the input string is provided.
    if (constant_string) {
        # Clear the array to ensure it's empty before starting.
        split("", constant_array_reference, "");
        constant_array_reference[0] = "";

        # Define a constant character using its ASCII code (0x27 is the ASCII code for the single quote character ')
        __constant_character = sprintf("%c", "\x27");
 
        # Define a delimiter character using its ASCII code (0x2c is the ASCII code for the comma character ,)
        __constant_delimiter_character = sprintf("%c", "\x2c");

        # Define a escape character using its ASCII code (0x2f is the ASCII code for the forward slash character /)
        __constant_escape_character = sprintf("%c", "\x2f");

        # Temporary string to hold the current field.
        __constant_result = "";

        # Define and set last index to 0 for empty
        __constant_result_index = 0;

        # Loop while constant_string is not empty.
        while (constant_string) {
            # Find the index of the constant character in the string.
            __constant_index = index(constant_string, __constant_character);

            # Find the index of the delimiter character in the string.
            __constant_delimiter_index = index(constant_string, __constant_delimiter_character);

            # Check if the constant character appears in the string.
            if (_characterCounter(constant_string, __constant_character) > 0) {

                # Check if the constant character appears before the delimiter.
                if (_characterCounter(constant_string, __constant_delimiter_character) > 0 && __constant_index < __constant_delimiter_index) {

                    # Check if the character immediately before the constant character is the escape character
                    if (substr(constant_string, __constant_index - 1, 1) == __constant_escape_character) {
                        __constantEscape(constant_string " " __constant_index);
                        exit; # TODO testing

                    # Check if the string matches the pattern: any characters, a constant character, any characters, another constant character, and optional spaces
                    } else if (match(constant_string, "^.*" __constant_character ".*" __constant_character "[[:space:]]*")) {
                        # Extract the substring from the start to the end of the matched pattern
                        __constant_placeholder = substr(constant_string, 1, RSTART + RLENGTH);

                        # Check if the placeholder matches the pattern: constant character, optional spaces, delimiter character, optional spaces, end of string
                        if (match(__constant_placeholder, __constant_character "[[:space:]]*" __constant_delimiter_character "[[:space:]]*$")) {
                            # Extract the substring from the start of the matched pattern to the end
                            __constant_end = substr(__constant_placeholder, RSTART, RLENGTH);

                            # Remove the matched pattern from the placeholder
                            sub(__constant_end, "", __constant_placeholder);

                            # Remove the delimiter character from the end pattern
                            sub(__constant_delimiter_character, "", __constant_end);
                            
                            # Append the placeholder and end pattern to the result
                            __constant_result = __constant_result "" __constant_placeholder "" __constant_end;

                             # Clear the placeholder and end pattern
                            __constant_placeholder = ""; 
                            __constant_end = "";

                        }

                        constant_array_reference[++__constant_result_index] = "\x22" __constant_result "\x22";

                        # Check if the value 0 is present in constant_array_reference
                        if (constant_array_reference[0] != "") {
                            # Append the result __constant_delimiter_character to constant_array_reference[0] if index 0 of constant_array_reference is not empty.
                            constant_array_reference[0] = "\x51" constant_array_reference[0] "" __constant_delimiter_character "\x51";

                        }

                        # Concatenate the result at the current index to the value at index 0
                        constant_array_reference[0] = constant_array_reference[0] ""  constant_array_reference[__constant_result_index];
                        
                        # Update constant_string to the substring starting after the matched pattern
                        constant_string = substr(constant_string, RSTART + RLENGTH + 1);

                        # Reset __constant_result to an empty string
                        __constant_result = "";
 
                    }
                }

            } else {
                # Split constant_string into __constant_values using __constant_delimiter_character and store the count in __constant_value_count
                __constant_value_count = split(constant_string, __constant_values, __constant_delimiter_character);

                # Loop through each value except the first one
                for (__constant_value_index = 1; __constant_value_index < __constant_value_count; ++__constant_value_index) {

                    # Check if the value 0 is present in constant_array_reference
                    if (constant_array_reference[0] != "") {
                        # Append the result __constant_delimiter_character to constant_array_reference[0] if index 0 of constant_array_reference is not empty.
                        constant_array_reference[0] = constant_array_reference[0] "" __constant_delimiter_character;

                    }

                    # Update constant_array_reference at the next index with the concatenation of __constant_result and the value at __constant_value_index
                    onstant_array_reference[++__constant_result_index] = __constant_result "" __constant_values[__constant_value_index];


                    # Concatenate multiple values and characters to the value at index 0 of constant_array_reference
                    constant_array_reference[0] = constant_array_reference[0] "" __constant_character "" __constant_result "" constant_array_reference[__constant_result_index] "" __constant_character;

                    # Reset __constant_result to an empty string
                    __constant_result = "";

                    # Extract substring from constant_string starting from the first character
                    # up to the character just before the first occurrence of __constant_delimiter_character
                    sub(substr(constant_string, 1, index(constant_string, __constant_delimiter_character) - 1), "", constant_string);

                    # Find the position of the first occurrence of __constant_delimiter_character
                    # Move the position to just after the delimiter
                    # Extract the substring starting from the position just after the delimiter to the end of constant_string
                    constant_string = substr(constant_string, index(constant_string, __constant_delimiter_character) + 1);
                }

                #Check if the value 0 is present in constant_array_reference
                if (constant_array_reference[0] != "") {
                    # Append the result __constant_delimiter_character to constant_array_reference[0] if index 0 of constant_array_reference is not empty.
                    constant_array_reference[0] = constant_array_reference[0] "" __constant_delimiter_character;

                }


                # Update constant_array_reference at the next index with the concatenation of __constant_result and the value at __constant_value_index
                constant_array_reference[++__constant_result_index] = constant_string;

                # Concatenate multiple values and characters to the value at index 0 of constant_array_reference
                constant_array_reference[0] = constant_array_reference[0] "" __constant_character "" __constant_result "" constant_array_reference[__constant_result_index] "" __constant_character;

                # Reset constant_string and __constant_result to empty strings
                constant_string = ""; __constant_result = "";

            }

        }

        delete __constant_values;
        for (__constant_value_index = 0; __constant_value_index < length(constant_array_reference); ++__constant_value_index) {
            print constant_array_reference[__constant_value_index];

        }

    }

}

