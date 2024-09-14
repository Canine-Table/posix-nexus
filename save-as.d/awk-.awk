# ################################################################################################################


# function _null() {
#     return "";
# }


# ################################################################################################################


# function _absolute(parameter_integer) {
#     if (length(parameter_integer) > 0) {
#         if (parameter_integer < 0) {
#             return -parameter_integer;
#         } else {
#             return parameter_integer;
#         }
#     }
# }


# ################################################################################################################33


# function _removeSpaces(parameter_string) {
#     gsub(/([[:space:]]+$)|(^[[:space:]]+)/, _null(), parameter_string);
#     return parameter_string;
# }


# ################################################################################################################


# function _octal(value) {

#     ###############################################
#     # the return value uses the regular expression:
#     #   ^([1-9]|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ 
#     # which matches:
#     #   - Any single digit from 1 to 9.
#     #   - Any number from 10 to 199.
#     #   - Any number from 200 to 249.
#     #   - The numbers 250 to 255
#     # or no value:
#     #   - Any single digit from 1 to 1
#     ###############################################

#     _absolute(value);
#     gsub(/([^[:digit:]])/, _null(), value);

#     if (length(value) > 0) {
#         if (value ~ /^([1-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])$/) {
#             return int(value);
#         } else {
#             return 0;
#         }
#     }

#     value = _null();
#     return value;
# }


# ################################################################################################################


# function _boolean(value) {
#     value = tolower(value);
#     boolean = _octal(_absolute(value));

#     if (boolean == _null() && value == _null()) {
#         return _null();
#     } else if (value == 0 || value ~ /^([[:space:]]*(no|false|off|stop)[[:space:]]*)$/) {
#         return 0;
#     } else if (boolean ~ /^([[:digit:]])$/ && boolean < 256) {
#         return boolean;
#     } else if (value ~ /^([[:space:]]*(yes|true|on|(re)?start)[[:space:]]*)$/) {
#         return 1;
#     } else {
#         return _null();
#     }
# }


# ################################################################################################################


# function _isEmpty(variable) {
#     if ((parameter_string = _removeSpaces(parameter_string)) == _null() || length(parameter_string) < 1) {
#         return _null();
#     } else {
#         return _boolean("true");
#     }
# }


# ################################################################################################################


# function _yield(parameter_subroutine) {
#     if (length(parameter_subroutine) > 0) {
#         return parameter_subroutine;
#     } else {
#         return _null();
#     }
# }


# ################################################################################################################


# function _ascii(character, character_class) {

#     if (length(ascii_character_map["ascii"]) < 127) {
#         split("", ascii_character_map, "");
#         ascii_character_map["lower"] = "abcdefghijklmnopqrstuvwxyz";
#         ascii_character_map["upper"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
#         ascii_character_map["digit"] = "0123456789";
#         ascii_character_map["punct"] = " !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
#         ascii_character_map["cntrl"] = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F";
#         ascii_character_map["xdigit"] = sprintf("%s%s%s", substr(ascii_character_map["lower"], 1  , 6), substr(ascii_character_map["upper"], 1  , 6), ascii_character_map["digit"]);
#         ascii_character_map["alpha"] = sprintf("%s%s", ascii_character_map["upper"], ascii_character_map["lower"]);
#         ascii_character_map["word"] = sprintf("%s%s", ascii_character_map["alpha"], "_");
#         ascii_character_map["alnum"] = sprintf("%s%s", ascii_character_map["alpha"], ascii_character_map["digit"]);
#         ascii_character_map["ascii"] = ascii_character_map["cntrl"] " !\"#$%&'()*+,-./" ascii_character_map["digit"] ":;<=>?@" ascii_character_map["upper"] "[\\]^_`" ascii_character_map["lower"] "{|}~";
#     }

#     if (_isEmpty(character) != _null()) {
#         if (_isEmpty(character_class) == _null()) {
#             character_class = ascii_character_map["ascii"];
#         } else if (character_class ~ /^(aln(u(m)?)?)$/) {
#             character_class = ascii_character_map["alnum"];
#         } else if (character_class ~ /^(w(o(r(d)?)?)?)$/) {
#             character_class = ascii_character_map["word"];
#         } else if (character_class ~ /^(alp(h(a)?)?)$/) {
#             character_class = ascii_character_map["alpha"];
#         } else if (character_class ~ /^(x(d(i(g(i(t)?)?)?)?)?)$/) {
#             character_class = ascii_character_map["xdigit"];
#         } else if (character_class ~ /^(d(i(g(i(t)?)?)?)?)$/) {
#             character_class = ascii_character_map["digit"];
#         } else if (character_class ~ /^(u(p(p(e(r)?)?)?)?)$/) {
#                 character_class = ascii_character_map["upper"];
#         } else if (character_class ~ /^(l(o(w(e(r)?)?)?)?)$/) {
#             character_class = ascii_character_map["lower"];
#         } else if (character_class ~ /^(p(u(n(c(t)?)?)?)?)$/) {
#             character_class = ascii_character_map["punct"];
#         } else {
#             character_class = sprintf("%s", ascii_character_map["ascii"]);
#         }

#         return index(character_class, character);
#     }
    
#     return _boolean("error");
# }


# ################################################################################################################


# function _unique(array_list, delimiter) {

#     if (_isEmpty(delimiter) == _null()) {
#         delimiter = ",";

#     }

#     split("", unique, "");
#     unique_string = "";

#     for (item in array_list) {
#         unique[array_list[item]] = 1;

#     }

#     # Print the unique keys
#     for (key in unique) {
#         unique_string = unique_string "," key;

#     }

#     delete unique;
#     return split(substr(unique_string, 2), array_list, delimiter);
# }


# ################################################################################################################


# function _longest(parameter_longest_string, delimiter) {

#     if (_isEmpty(delimiter) == _null()) {
#         delimiter = ",";

#     }

#     parameter_longest_length = 0;
#     parameter_longest_count = split(parameter_longest_string, parameter_longest_list, delimiter);
#     split("", longest_string_list, "");

#     for (parameter_longest_index = 1; parameter_longest_index <= parameter_longest_count; ++parameter_longest_index) {

#         if ((parameter_current_index = length(parameter_longest_list[parameter_longest_index])) > parameter_longest_length) {
#             parameter_longest_length = parameter_current_index;

#         }
#     }

#     delete parameter_longest_list;
#     return parameter_longest_length;

# }


# ################################################################################################################
#  print parameter_string;




# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################





# ################################################################################################################


#     IGNORECASE = _boolean("false");
#     parameter_completion_count = 0;
#     parameter_completion_remainder = _null();

#     for (parameter_completion_index in parameter_completion_list) {
#         ++parameter_completion_count;
#         parameter_completion_remainder = parameter_completion_remainder "\033[0m  \n\033[1;31m  - \033[33m" parameter_completion_list[parameter_completion_index];
#     }

#     information = sprintf("\n\033[1;32mAll parameters are care insensitive\033[0m");
#     delete parameter_completion_list;

#     if (parameter_completion_count > 1) {
#             printf("%s\n\033[1;31mThe term \033[37m'\033[33m%s\033[37m'\033[31m is to ambiguous\033[37m.\033[31m\nDid you mean\033[37m?\033[0m%s", information, parameter_completion_input, parameter_completion_remainder);
#     } else if (parameter_completion_count == 0) {
#             printf("%s\n\033[1;31mThe term \033[37m'\033[36m%s\033[37m'\033[31m matched none of the prefixes.\nYour options are\033[37m:\033[0m\n%s", information, parameter_completion_input, no_match_found);
#     } else if (parameter_completion_count == 1) {
#         return parameter_completion_match;
#     }

#     return _null();
# }

# function _arguments(argument_string, parameter_string) {

# }

function _isScalar(variable) {
    if (length(variable) > 1) {
    return sprintf("%s", variable);

    }
}

function _isArray(variable) {
    print variable
    # for (__value in variable) {
    #     print __value
    # }

    # return sprintf("%s", __value);

}

function _isDefined(variable) {

    if (_isScalar(variable)) {
        return "scalar";
    } if ((_isArray(variable) > /dev/null)) {
        return "array";
    } else {
        return "null";
    }
}

{
    
   split("", var, "");
#      var[1] = "hi";
    var[2] = "bye";
    var[3] = "";
    #  var = "hi";
    if (_isDefined(var)) {
        print "arrat";
    }

#     print _arguments("hello , delim  c ,,,  ,,s, s, the , help")
#{for (value in __variable) {print value}}
}


awk '
function parameters(parameter_string, selected_option, delimiter) {

    if (length(delimiter) < 1) {
        delimiter = ",";
    }

    string_length = 0; parameter_count = split(parameter_string, parameter_values, delimiter);
    if (length(parameter_string) > 0) {
        {
            for (parameter_index in parameter_values) {
                gsub(/([[:space:]]+$)|(^[[:space:]]+)/, "", parameter_values[parameter_index]);
                current_index = parameter_index; is_uniq = "true";
                current_substring = substr(parameter_values[current_index], 1, ++string_length);

                if (string_length > length(parameter_values[current_index])) {
                    break;
                }

                for (substring_index in parameter_values) {
                    substring = substr(parameter_values[substring_index], 1, string_length);
                                   print substring

                    if (current_index != substring_index && current_substring == substring) {
                        is_uniq = "false";
                        break;
                    }
                }
            }

            if (is_uniq == "true" || parameter_count == 1) {
                prefix_suffix_map[parameter_values[current_index]] = substr(parameter_values[current_index], string_length);
                print parameter_values[current_index] " " prefix_suffix_map[parameter_values[current_index]];
                delete parameter_values[current_index];
                string_length = 0; substring = ""; parameter_count = parameter_count - 1;
            }
        }

    } while (length(parameter_values) != length(parameter_values) + int(duplicates));

    delete parameter_values;
    delete prefix_suffix_map;
}

function _absolute(integer) {
    if (length(integer) > 0) {
        if (integer < 0) {
            return -integer;
        } else {
            return integer;
        }
    }
}

function _null() {
    return "";
}

function _ascii(character) {
    return index("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", character);
}

function _hash(hash_string, indexes) {
    if (_isEmpty(hash_string) != _null()) {
        for (i = 1; i <= 100; i++) {
            hash_string = hash_string "" i; hash = 0;

            for (j = 1; j <= length(hash_string); j++) {
                hash += (hash * 31 + _ascii(substr(hash_string, j, 1))) % 1000000007;
            }

            return sprintf("%s\n", hash);
        }
    }
}

function _octal(value) {

    ###############################################
    # the return value uses the regular expression:
    #   ^([1-9]|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ 
    # which matches:
    #   - Any single digit from 1 to 9.
    #   - Any number from 10 to 199.
    #   - Any number from 200 to 249.
    #   - The numbers 250 to 255
    # or no value:
    #   - Any single digit from 1 to 1
    ###############################################

    _absolute(value);
    gsub(/([^[:digit:]])/, _null(), value);

    if (length(value) > 0) {
        if (value ~ /^([1-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])$/) {
            return int(value);
        } else {
            return 0;
        }
    }

    return _null();
}

function _removeSpaces(string) {
    gsub(/([[:space:]]+$)|(^[[:space:]]+)/, _null(), string);
    return string;
}

function _isEmpty(value) {
    if ((value = _removeSpaces(value)) == _null() || length(value) < 1) {
        return _null();
    } else {
        return _boolean("true");
    }
}

function _yield(value) {
    if (length(value) > 0) {
        return value;
    } else {
        return _null();
    }
}

function _list(string, index_number, delimiter) {

    if (_isEmpty(string) != _null()) {

        if (length(delimiter) < 1 || delimiter == "=>") {
            delimiter = ",";
        }

        if ((index_count = split(string, indexes, delimiter)) >= index_number) {
            return _yield(indexes[index_number]);
        }

        if (index_count == index_number) {
            delete indexes;
            return _boolean("false");
        }
    } else {
        return _boolean("false");
    }
}

function _hashmap(hash_string, hash_number, delimiter) {
    if (_isEmpty(hash_string) != _null()) {
        if (length(delimiter) < 1 || delimiter == ",") {
            delimiter = "=>";
        }

        if ((hash_count = split(hash_string, hashes, delimiter)) >= hash_number) {
            
            if ((list = _list(hash_string, hash_number, ";")) != _boolean("false")) {
                split(list, map, delimiter);

                hash = _hash(hash_string "" hash_number);

                hash_key[hash] = _removeSpaces(map[1]);
                hash_value[hash] = _removeSpaces(map[2]);
                delete map;
                return hash;
            }

            if (hash_count == hash_number) {
                delete hashes;
            return _boolean("false");
        }

        }
    } else {
        return _boolean("false");
    }

}

function parameters(parameter_string, selected_option, delimiter) {

    if (length(delimiter) < 1) {
        delimiter = ",";
    }

    string_length = 0; parameter_count = split(parameter_string, parameter_values, delimiter);
    if (length(parameter_string) > 0) {
        {
            for (parameter_index in parameter_values) {
                gsub(/([[:space:]]+$)|(^[[:space:]]+)/, "", parameter_values[parameter_index]);
                current_index = parameter_index; is_uniq = "true";
                current_substring = substr(parameter_values[current_index], 1, ++string_length);

                if (string_length > length(parameter_values[current_index])) {
                    break;
                }

                for (substring_index in parameter_values) {
                    substring = substr(parameter_values[substring_index], 1, string_length);
                                   print substring

                    if (current_index != substring_index && current_substring == substring) {
                        is_uniq = "false";
                        break;
                    }
                }
            }

            if (is_uniq == "true" || parameter_count == 1) {
                prefix_suffix_map[parameter_values[current_index]] = substr(parameter_values[current_index], string_length);
                print parameter_values[current_index] " " prefix_suffix_map[parameter_values[current_index]];
                delete parameter_values[current_index];
                string_length = 0; substring = ""; parameter_count = parameter_count - 1;
            }
        }

    } while (length(parameter_values) != length(parameter_values) + int(duplicates));

    delete parameter_values;
    delete prefix_suffix_map;
}

function _unsetMap(hash) {
    if (hash in hash_key) {
        delete hash_key[hash];
    }

    if (hash in hash_value) {
        delete hash_value[hash];
    }
}

function _option(option_string) {
    while ((option = _list(option_string, ++option_index)) != _boolean("false")) {
        print option #[option_index];
    }
}

function _prefixes(string, prefix_length) {
    if (_isEmpty(string) != _null()) {
        if (_isEmpty(prefix_length) == _null()) {
            prefix_length = 1;
        }
        for (character_index = prefix_length; character_index <= length(string); ++character_index) {
            printf("%s", substr(string, 1, prefix_length - 1));
            printf("%s\n", substr(string, prefix_length));
        }
    } else {
        return _null();
    }
}

BEGIN {
        _prefixes("hello world", 3);
}';




##################################

function _option(option_string, delimiter) {
    if (_isEmpty(option_string) != _null()) {
        if (length(delimiter) < 1) {
            delimiter = ",";
        }

        if (option_string !~ /,[[:space:]]$/) {
            option_string = option_string ",";
        }

        seen_string = _null();
        split(option_string, options, delimiter);
        option_count = _unique(options);

    while (length(option_string) > 0) {
            # Iterate over each word
            for (option in options) {
                current_option = _removeSpaces(options[option]);
                current_prefix = _null();

                option_search = "^[[:space:]]*" current_option "[[:space:]]*,";
                sub(option_search, "", option_string);
                option_search = "^[[:space:]]*" current_option "[[:space:]]*,";

                # Find the shortest unique prefix
                for (characters = 1; characters <= length(current_option); ++characters) {
                    current_prefix = substr(current_option, 1, characters);

                    # print option_string
                    if (!(current_prefix in seen_options) && seen_string !~ option_search) {
                        seen_options[current_prefix] = substr(current_option, length(current_prefix) + 1);
                        seen_string = seen_string "," current_option;
                        gsub(current_option ",", "", option_string);
                        break;
                    }
                }
            }
        }

        for (seen in seen_options) {
            print seen " + " seen_options[seen]; # " + "seen_options[seen];
        }

        delete seen_options;
        delete options;

        return _boolean("true");
    }

    return _boolean("false");
}

######################


function _option(option_string, delimiter) {
    if (_isEmpty(option_string) != _null()) {
        if (length(delimiter) < 1) {
            delimiter = ",";
        }

        if (option_string !~ /,[[:space:]]*$/) {
            option_string = option_string ",";
        }

        seen_string = _null();
        option_count = split(option_string, options, delimiter);

        # Iterate over each word
        for (i = 1; i <= option_count; i++) {
            current_option = _removeSpaces(options[i]);
            current_prefix = _null();

            # Find the shortest unique prefix
            for (characters = 1; characters <= length(current_option); ++characters) {
                current_prefix = substr(current_option, 1, characters);

                if (!(current_prefix in seen_options)) {
                    seen_options[current_prefix] = current_option;
                    break;
                }
            }
        }

        # Print the results in the order of the original list
        for (i = 1; i <= option_count; i++) {
            current_option = _removeSpaces(options[i]);

            for (characters = 1; characters <= length(current_option); ++characters) {
                current_prefix = substr(current_option, 1, characters);
                if (seen_options[current_prefix] == current_option) {
                    print current_prefix " + " substr(current_option, length(current_prefix) + 1);
                    break;
                }
            }
        }

        delete seen_options;
        delete options;

        return _boolean("true");
    }

    return _boolean("false");
}

##########################



function _option(option_string, delimiter) {
    if (_isEmpty(option_string) != _null()) {
        
        if (length(delimiter) < 1) {
            delimiter = ",";
        }

        split(option_string, list_of_options, delimiter);
        _unique(list_of_options);

        for (current_option in list_of_options) {

            characters = 0;
            increment = _boolean("false");

            while (current_option in list_of_options) {

                if (characters == 0 || increment == _boolean("true")) {
                    current_prefix = substr(list_of_options[current_option], 1, characters++);
                    increment = _boolean("false");
                }

                prefix = "^" substr(list_of_options[option], 1, characters);
                unique_prefix = _boolean("false");

                for (option in list_of_options) {
                    if (current_prefix !~ prefix && current_option !~ option) {
                        unique_prefix = _boolean("true");
                        break;
                    } else if (length(current_option) < characters || length(list_of_options) == 1) {
                        unique_prefix = _boolean("true");
                        break;
                    } else {
                        increment = _boolean("true");
                        break;
                    }
                }

                if (unique_prefix == _boolean("true")) {
                    prefix_map[current_prefix] = substr(list_of_options[current_option], length(current_prefix) + 1);
                    delete list_of_options[current_option];
                    unique_prefix = _boolean("false");
                }
            }
        }

        delete list_of_options;

        for (prefix in prefix_map) {
            print prefix "  =  " prefix_map[prefix];
        }

        delete prefix_map;
    }
}

# function _append(string, delimiter) {
    # if (_isEmpty(string) != _null()) {
    #     if (length(delimiter) < 1) {
    #         delimiter = ",";
    #     }

#         number = 0; hashmap = _null();
#         while ((hashmap = _hashmap(string, ++number, delimiter)) != _boolean(false)) {
#             if  (hash_key[hashmap] ~ /)
#             print hash_key[hashmap]
#         }

#         _unsetMap(hashmap);
#     }
# }


function _complete(parameter_string, argument, delimiter) {

    if (length(delimiter) < 1) {
        delimiter = ",";
    }
    
    parameter_count = split(parameter_string, parameters, delimiter);
    characters = 0;

    for (parameter in parameters) {
        for (characters = 1; characters <= length(parameters[parameter]); ++characters) {
            current_prefix = "^" substr(parameters[parameter], 1, characters);

            if (length(parameters) == 1) {
                if (argument !~ current_prefix) {
                    return _null();
                } else {
                    break; 
                }

            } else if (argument !~ current_prefix) {
                delete parameters[parameter_index];
            }
        }

        if (length(parameters) == 1) {
            break;
        }
    }

    if (length(parameters) > 1) {
        for (parameter in parameters) {
            if (++remainder >= 1) {
                if (remainder == 1) {
                    printf("\n\033[1;33m %s\033[31m %s \033[0m\n", argument, "is to \033[33mvague\033[31m\033[37m,\033[31m did you mean one of these\033[1;37m?\033[0m");
                }
                printf("  \033[1;37m %s \033[0m-\033[1;37m %s\033[0m\n", parameter, parameters[parameter]);
            };
        }

        delete parameters;
        return _boolean("false");
    } else {
        for (parameter in parameters) {
            parameter = parameters[parameter];
        }
    }

    delete parameters;
    return parameter;
}


