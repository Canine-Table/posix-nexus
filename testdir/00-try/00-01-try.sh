#!/bin/sh

# Source the try function if it's in another script
. ../../run.sh ||  exit 1;

tryN1() {

    # I: Item checks
    try -I "
        R=/tmp,e=tryN1,d = tryN1,\
        f=tryN1,\
        l            =             tryN1     ,                \
        r=tryN1,              \
        s=      tryN1          ,\
        x =tryN1,\
        h= tryN1,\
        L = tryN1,\
        w = tryN1";

    try -C 'D=tryN1';
}


tryN2() {
    # O: OS Exceptions

    try -O "R = /tmp/tryN2,
        C   =     foobar,
        D   =   /tmp/tryN2" -O "

        T   =   /tmp/tryN2/tryN2File.txt,
        F=/tmp/tryN2NamedPipe.fifo,
        M=/tmp/tryN2NamedPipe.fifo:/tmp/tryN2/tryN2NamedPipe.fifo,
        W=/tmp/tryN2/tryN2NamedPipe.fifo:/tmp/tryN2NamedPipe.fifo,
        R=/tmp/tryN2NamedPipe.fifo,
        H=/tmp/tryN2/tryN2File.txt:/tmp/tryN2/tryN2File2.txt,
        A=/tmp/tryN2/tryN2File2.tar:/tmp/tryN2/tryN2File2.txt,
        O=user:wheel:/tmp/tryN2/tryN2File2.tar,




        
        S=/tmp/tryN2/trdyN2File2.txt:/tmp/tryN2/tryN2File3.txt,
        G=wheel:/tmp/tryN2/tryN2File.txt,
        U=/tmp/tryN2/tryN2File3.txt,
                                            P=000:/tmp/tryN2/tryN2File.txt,
        
        
        
        
        
        O=root:wheel:/tmp/tryN2/tryN2File.txt
    ";

    try -C 'D=tryN2';

}

tryN3() {

    (
        try -V "z=H";
        try -V "n=H";
        H="hello"
        try -V "z=H";
        try -V "n=H";

    )

    try -C 'D=tryN3';

}

#tryN1;
tryN2;
#tryN3;

rm -rf /tmp/tryN*;
