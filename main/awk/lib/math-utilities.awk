function _absolute(parameter_integer) {

    # Check if parameter_integer is provided
    if (parameter_integer ~ /^$/) {

        # If parameter_integer is less than 0, return its positive value
        if (parameter_integer < 0) {
            # return its positive value
            return -parameter_integer;

        # Otherwise parameter_integer is already positive
        } else {
            # return parameter_integer as
            return parameter_integer;

        }
    } else {
        # If parameter_integer is not provided, return 0
        return 0;

    }

}
