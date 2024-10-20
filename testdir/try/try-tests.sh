#!/bin/sh

# Source the try function if it's in another script
. ../../run.sh ||  exit 1;

testN1() {

    # Create test directory and files
    mkdir -p /tmp/testdir || { echo "Failed to create test directory"; return 1; }
    touch /tmp/testdir/testfile1 || { echo "Failed to create testfile1"; return 1; }
    mkfifo /tmp/testdir/testfifo || { echo "Failed to create testfifo"; return 1; }

    # Perform operations
    try -O 'M=/tmp/testdir/testfile1:/tmp/testdir/testfile1-moved';
    try -O 'S=/tmp/testdir/testfile1-moved:/tmp/testdir/testsymlink';
    try -O 'P=755:/tmp/testdir/testfile1-moved';
    try -O 'G=root:/tmp/testdir/testfile1-moved';
    try -O 'W=/tmp/testdir/testfile1-moved:/tmp/testdir/testfile1-copied';

    # Cleanup files and directory
    try -O 'U=/tmp/testdir/testsymlink,R=/tmp/testdir/testfile1-moved,R=/tmp/testdir/testfifo,R=/tmp/testdir,R=/tmp/testdir/testfile1-copied';
    echo "Test 1 complete and cleanup done!";

}

testN2() {
    # Create necessary directories and files for testing
    mkdir -p /tmp/testdir2 || { echo "Failed to create test directory"; return 1; }
    touch /tmp/testdir2/testfile2 || { echo "Failed to create testfile2"; return 1; }

    # Perform operations
    try -O 'D=/tmp/testdir2/';
    try -O 'D=/tmp/testdir2/subdir';
    try -O 'F=/tmp/testdir2/testfifo2';
    try -O 'H=/tmp/testdir2/testfile2:/tmp/testdir2/testhardlink';
    try -O 'A=/tmp/testdir2/testarchive.tar:/tmp/testdir2/testfile2';
    try -O 'K=99999' # This is expected to fail since the PID won't exist
    try -O 'O=root:root:/tmp/testdir2/testfile2';

    # Cleanup files and directories
    try -O 'R=/tmp/testdir2/subdir';
    try -O 'R=/tmp/testdir2/testhardlink';
    try -O 'R=/tmp/testdir2/testarchive.tar';
    try -O 'R=/tmp/testdir2/testfile2';
    try -O 'R=/tmp/testdir2/testfifo2';
    try -O 'R=/tmp/testdir2';

    echo "Test 2 complete and cleanup done!";

}

testN1;
echo "Result: $?";

testN2;
echo "Result: $?";
