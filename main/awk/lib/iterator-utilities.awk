function _parser(parser_string) {

    # Remove leading spaces from parser_string
    sub(/^[[:space:]]*/, "", parser_string);

    # Check if the parser_string starts with a parenthesis
    if (parser_string ~ /^\(/) {

        # Extract the substring starting from the second character
        arguments = substr(parser_string, 2);

        if (parser_string !~ /[^\)]*$/) {
            # end of line reached and closing bracket not found.
            return 3;
        }

        # Remove everything after the closing parenthesis
        gsub(/[^\)]*$/, "", arguments);

        # Replace tabs with spaces
        gsub(/\\t/, "    ", arguments);
        gsub(/\\v/, "    \n", arguments);

        # Remove the last character (closing parenthesis)
        arguments = substr(arguments, 1, length(arguments) - 1);
        argument_length = length(arguments);

        # Initialize variables
        parameter_string = "";
        escaped_character = "";
        last_character = "";
        argument_index = 0;

        # Iterate through each character in arguments
        while ((character = substr(arguments, ++argument_index, 1))) {

            # Check if the current character is a single quote (\x27) or double quote (\x22)
            # and matches the escaped character, ensuring the last character is not a forward slash (\x2f)
            if (((escaped_character == "\x27" || escaped_character == "\x22") && character == escaped_character) && last_character != "\x2f") {
                # Reset the escaped character since the quote is closed
                escaped_character = "";

            # Check if the current character is a forward slash (\x2f) and either the escaped character is a single quote (\x27)
            # or the last character is a forward slash (\x2f)
            } else if ((((character == "\x27" || character == "\x22") && last_character != "\x2f")) && escaped_character == "") {
                # Set the escaped character to the current character since a new quote is opened
                escaped_character = character;

            # Check if the current character is a forward slash (\x2f) and either the escaped character is a single quote (\x27)
            # or the last character is a forward slash (\x2f)
            } else if ((escaped_character == "\x27" || last_character == "\x2f") && character == "\x2f") {
                parameter_string = sprintf("%s%s", parameter_string, "\x2f");

            # Check if the current character is a comma (\x2c) and is not within quotes or escaped
            } else if (! (escaped_character == "\x22" || escaped_character == "\x27") && last_character != "\x2f" && character == "\x2c") {
                # Append a tab character (\x09) to the parameter string
                parameter_string = sprintf("%s\x09", parameter_string);

            # If the current character is not a forward slash (\x2f)
            } else if (character != "\x2f") {

                if (escaped_character == "" && character == "\x2d") {
                } else if (escaped_character == "" && last_character == "\x2d" && character == "\x3e") {
                    parameter_string = sprintf("%s\x0b\x0d", parameter_string);
                } else {
                    
                    if (escaped_character == "" && last_character == "\x2d" && character != "\x3e") {
                        parameter_string = sprintf("%s\x2d", parameter_string);

                    }

                    # Append the current character to the parameter string
                    parameter_string = sprintf("%s%s", parameter_string, character);
                
                }

            }

            # Update the last character to the current character
            last_character = character;

        }

    }
    
    return parameter_string;
}
