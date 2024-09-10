function _unsetMap(hash) {

    if (hash in hash_key) {
        delete hash_key[hash];
    }

    if (hash in hash_value) {
        delete hash_value[hash];
    }

    hash = _null();
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

function _ascii(character, character_class) {

    if (length(ascii_character_map["ascii"]) < 127) {
        split("", ascii_character_map, "");
        ascii_character_map["lower"] = "abcdefghijklmnopqrstuvwxyz";
        ascii_character_map["upper"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        ascii_character_map["digit"] = "0123456789";
        ascii_character_map["punct"] = " !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
        ascii_character_map["cntrl"] = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F";
        ascii_character_map["xdigit"] = sprintf("%s%s%s", substr(ascii_character_map["lower"], 1  , 6), substr(ascii_character_map["upper"], 1  , 6), ascii_character_map["digit"]);
        ascii_character_map["alpha"] = sprintf("%s%s", ascii_character_map["upper"], ascii_character_map["lower"]);
        ascii_character_map["word"] = sprintf("%s%s", ascii_character_map["alpha"], "_");
        ascii_character_map["alnum"] = sprintf("%s%s", ascii_character_map["alpha"], ascii_character_map["digit"]);
        ascii_character_map["ascii"] = ascii_character_map["cntrl"] " !\"#$%&'()*+,-./" ascii_character_map["digit"] ":;<=>?@" ascii_character_map["upper"] "[\\]^_`" ascii_character_map["lower"] "{|}~";
    }

    if (_isEmpty(character) != _null()) {
        if (_isEmpty(character_class) == _null()) {
            character_class = ascii_character_map["ascii"];
        } else if (character_class ~ /^(aln(u(m)?)?)$/) {
            character_class = ascii_character_map["alnum"];
        } else if (character_class ~ /^(w(o(r(d)?)?)?)$/) {
            character_class = ascii_character_map["word"];
        } else if (character_class ~ /^(alp(h(a)?)?)$/) {
            character_class = ascii_character_map["alpha"];
        } else if (character_class ~ /^(x(d(i(g(i(t)?)?)?)?)?)$/) {
            character_class = ascii_character_map["xdigit"];
        } else if (character_class ~ /^(d(i(g(i(t)?)?)?)?)$/) {
            character_class = ascii_character_map["digit"];
        } else if (character_class ~ /^(u(p(p(e(r)?)?)?)?)$/) {
                character_class = ascii_character_map["upper"];
        } else if (character_class ~ /^(l(o(w(e(r)?)?)?)?)$/) {
            character_class = ascii_character_map["lower"];
        } else if (character_class ~ /^(p(u(n(c(t)?)?)?)?)$/) {
            character_class = ascii_character_map["punct"];
        } else {
            character_class = sprintf("%s", ascii_character_map["ascii"]);
        }

        return index(character_class, character);
    }
    
    return _boolean("error");
}

function _hash(string, salt) {

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


function _unique(array_list, delimiter) {

    if (_isEmpty(delimiter) == _null()) {
        delimiter = ",";
    }

    split("", unique, "");
    unique_string = "";

    for (item in array_list) {
        unique[array_list[item]] = 1;
    }

    # Print the unique keys
    for (key in unique) {
        unique_string = unique_string "," key;
    }

    delete unique;
    return split(substr(unique_string, 2), array_list, delimiter);
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

function _clear(array_name) {
    if (_isEmpty(array_name) != _null()) {
        if (length(delimiter) < 1) {
            delimiter = ",";
        }

        index_count = split(array_name, array_list, delimiter);
        for (array_index = 1; array_index <= index_count; ++array_index) {
            delete array_list[array_index];
            split("", array_list[array_index]);
        }

        delete array_list;
    }
}

function _append(string) {
    if (_isEmpty(option_string) != _null()) {
        if (length(delimiter) < 1) {
            delimiter = ",";
        }
    }
}

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

function _shell() {
    shell = ENVIRON["SHELL"];
    print shell;
}