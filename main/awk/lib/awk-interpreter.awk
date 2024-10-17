BEGIN {
    while (1) {
        while ((getline line < ENVIRON["POSIX_NEXUS_STDIN"]) > 0) {
            print line;

#            fflush(ENVIRON["POSIX_NEXUS_STDOUT"])
        }

    } 

#    close(ENVIRON["POSIX_NEXUS_STDIN"])
}
