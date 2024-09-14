function _uniqueList(unique_list, unique_delimiter) {
    
    unique_new_indexes = 0;

    if (! 0 in __unique_new) {
        split("", __unique_new, "");
    }

    for (__unique_item in unique_list) {
        __unique_new[unique_list[__unique_item]] = __unique_item;
    }

    for (__unique in __unique_new) {
        
        if (++unique_new_indexes != 1) {
            __unique_new[0] = unique_delimiter "" __unique_new[0];
        }

        __unique_new[0] = __unique_new[0] "" __unique;
    }
}

# function _listString(list_string, list_iterator, list_delimiter) {
    
#     # Use "," as the fallback completion_delimiter if the 3rd parameter 'completion_delimiter' is empty or not provided
#     if (length(list_delimiter)  < 1) {
#         list_delimiter = ",";

#     }

#     __list_count = split(list_string, __list_array, list_delimiter);
#     __list_array[0] = "";

#     for (__list_index = 1; __list_index < __list_count) {
#         print 
#     }
# }

# function _stringList(list_string, delimiter) {

# }

BEGIN {

    split("dog, dog, dog, cat, frog, donkey, zod", array, "[[:space:]]*,[[:space:]]*")
    _uniqueList(array);

}

# function _leading() {donkses

# } 

# function trailing() {

# }