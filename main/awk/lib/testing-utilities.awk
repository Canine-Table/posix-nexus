# function __constantExpansion(constantExpansion_string, constantExpansion_array_reference, constantExpansion_array_reference_index) {

# }

function __constantEscape(constantEscape_string) {
    ___constantEscape_escaped_string = "";

    do {

    #___constantEscape_character = substr(constantEscape_string, ___constantEscape_index + 1, 1); # TODO

        ___constantEscape_index = index(constantEscape_string, "\x2f");
 
        ___constantEscape_escaped_string = ___constantEscape_escaped_string "" substr(constantEscape_string, 1, ___constantEscape_index - 1);
        ___constantEscape_character_length = 1;

        ___constantEscape_escaped_character = substr(constantEscape_string, ___constantEscape_index + 1, 1);
        

        print 
        exit

        constantEscape_string = substr(constantEscape_string, ___constantEscape_index + ___constantEscape_character_length);
        print constantEscape_string;
        #print substr(constantEscape_string, ___constantEscape_index + );

    } while (___constantEscape_index > 0);

    ___constantEscape_escaped_string = ___constantEscape_escaped_string "" constantEscape_string;
    constantEscape_string = "";

}



function _toHexadecimal(toHexadecimal_integer) {
    if ((__toHexadecimal_integer = _truncate(toHexadecimal_integer))) {
        print "not empty";
    }
}

function _ascii(ascii_string) {
    __ascii_bytes = split(ascii_string, __ascii_characters, "");

    for (__ascii_byte = 1; __ascii_byte <= __ascii_bytes; ++__ascii_byte) {
        for (__ascii_index = 0; __ascii_index < 128; ++__ascii_index) {
            print __ascii_characters[__ascii_index]
            printf("%X ", __ascii_index);
        }
        break;
    }
    
    delete __ascii_characters;
}