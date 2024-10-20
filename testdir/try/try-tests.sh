#!/bin/sh

# Source the try function if it's in another script
. ../../run.sh ||  exit 1;

function _test_n1() {
    # Test command not found
    try -O 'C=foobar'

    # Test touch operation
    try -O 'T=/tmp/testfile'

    # Test directory creation
    try -O 'D=/tmp/testdir'

    # Test FIFO creation
    try -O 'F=/tmp/testfifo'

    # Test move operation
    try -O 'M=/tmp/testfile:/tmp/testdir/movedfile'

    # Test remove operation
    try -O 'R=/tmp/testdir/movedfile'

    # Test link creation
    try -O 'L=/tmp/testfile:/tmp/testlink'

    # Test change mode
    try -O 'P=755:/tmp/testfile'

    # Test change owner (you may need to run as root or change owner to your username)
    try -O 'O=root:root:/tmp/testfile'

    # Test change group
    try -O 'G=root:/tmp/testfile'

    # Test copy operation
    try -O 'W=/tmp/testfile:/tmp/testfilecopy'

    # Test unlink operation
    try -O 'U=/tmp/testlink'

    # Test archive operation (tar)
    try -O 'A=/tmp/testarchive.tar:/tmp/testfilecopy'

    # Test kill operation (try to kill a non-existent process)
    try -O 'K=99999'

}


_test_n1;
echo $?;
