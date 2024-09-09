function _unsetMap(hash) {
    if (hash in hash_key) {
        delete hash_key[hash];
    }

    if (hash in hash_value) {
        delete hash_value[hash];
    }

    hash = "";
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

function _boolean(value) {
    value = tolower(value);
    boolean = _octal(_absolute(value));

    if (boolean == _null() && value == _null()) {
        return _null();
    } else if (value == 0 || value ~ /^([[:space:]]*(no|false|off|stop)[[:space:]]*)$/) {
        return 0;
    } else if (boolean ~ /^([[:digit:]])$/ && boolean < 256) {
        return boolean;
    } else if (value ~ /^([[:space:]]*(yes|true|on|(re)?start)[[:space:]]*)$/) {
        return 1;
    } else {
        return _null();
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
            
            if ((hashmap = _list(hash_string, hash_number, ";")) != _boolean("false")) {
                split(hashmap, map, delimiter);

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

function _option(option_string, delimiter) {
    if (_isEmpty(option_string) != _null()) {
        if (length(delimiter) < 1) {
            delimiter = ",";
        }

        option_count = split(option_string, options, delimiter);
        split("", prefix_map, "");

        for (current in options) {

            characters = 0;
            while (current in options) {
                ++characters;

                for (option in options) {

                    if (option != current && characters < length(current)) {

                    }

                    if (characters == length(current) && ! current in prefix_map) {

                    }

                }
            }
        }
    }
}
