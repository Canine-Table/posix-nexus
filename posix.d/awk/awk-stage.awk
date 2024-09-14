


# function _unsetMap(hash) {

#     if (hash in hash_key) {
#         delete hash_key[hash];
#     }

#     if (hash in hash_value) {
#         delete hash_value[hash];
#     }

#     hash = _null();
# }

# function _hash(hash_string, salt) {

#     if (_isEmpty(hash_string) != _null()) {
#         for (i = 1; i <= 100; i++) {
#             hash_string = hash_string "" i; hash = 0;

#             for (j = 1; j <= length(hash_string); j++) {
#                 hash += (hash * 31 + _ascii(substr(hash_string, j, 1))) % 1000000007;
#             }

#             return sprintf("%s\n", hash);
#         }
#     }
# }

# function _list(string, index_number, delimiter) {

#     if (_isEmpty(string) != _null()) {

#         if (length(delimiter) < 1 || delimiter == "=>") {
#             delimiter = ",";
#         }

#         if ((index_count = split(string, indexes, delimiter)) >= index_number) {
#             return _yield(indexes[index_number]);
#         }

#         if (index_count == index_number) {
#             delete indexes;
#             return _boolean("false");
#         }
#     } else {
#         return _boolean("false");
#     }
# }


# function _hashmap(hash_string, hash_number, delimiter) {
#     if (_isEmpty(hash_string) != _null()) {
#         if (length(delimiter) < 1 || delimiter == ",") {
#             delimiter = "=>";
#         }

#         if ((hash_count = split(hash_string, hashes, delimiter)) >= hash_number) {
            
#             if ((hashmap = _list(hash_string, hash_number, ";")) != _boolean("false")) {
#                 split(hashmap, map, delimiter);

#                 hash = _hash(hash_string "" hash_number);

#                 hash_key[hash] = _removeSpaces(map[1]);
#                 hash_value[hash] = _removeSpaces(map[2]);
#                 delete map;
#                 return hash;
#             }

#             if (hash_count == hash_number) {
#                 delete hashes;
#                 return _boolean("false");
#             }

#         }
#     } else {
#         return _boolean("false");
#     }

# }

# function _clear(array_name) {
#     if (_isEmpty(array_name) != _null()) {
#         if (length(delimiter) < 1) {
#             delimiter = ",";
#         }

#         index_count = split(array_name, array_list, delimiter);
#         for (array_index = 1; array_index <= index_count; ++array_index) {
#             delete array_list[array_index];
#             split("", array_list[array_index]);
#         }

#         delete array_list;
#     }
# }



