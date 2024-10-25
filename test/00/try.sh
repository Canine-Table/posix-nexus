#!/bin/sh

# Source the try function if it's in another script
. ../../run.sh ||  exit 1;

tryN1() {

    # I: Item checks
    try -I "
        R=/tmp,e=tryN1,d = tryN1,
        f=tryN1,
        l            =             tryN1     ,                
        r=tryN1,              
        s=      tryN1          ,
        x =tryN1,
        h= tryN1,
        L = tryN1,
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
        try -V "z = H, n = H";
        try -R 'N=*ree';

    )

    try -C 'D=tryN3';

}

tryN4() {

    # mkdir a directory, touch a file, then remove the directory
    try -O '
        D = /tmp/tryN4a,
        T = /tmp/tryN4a/tryN4a.txt,
        R = /tmp/tryN4a
    ';

    # make a directory, create a symbolic link and a hard link
    try -O '
        R = /tmp/tryN4b,
        D = /tmp/tryN4b,
        T = /tmp/tryN4b/tryN4b.txt,
        H = /tmp/tryN4b/tryN4b.txt : /tmp/tryN4b/tryN4b-Hardlink.txt,
        S = /tmp/tryN4b :  /tmp/tryN4b/tryN4b-Softlink.txt,
    ';

    try -C 'D=tryN4';

}


tryN5() {

    try -O '
        D   =   /tmp/tryN5,
        T   =   /tmp/tryN5/tryN5File.txt,
        G = wheel : /tmp/tryN5/tryN5File.txt,
        T   =   /tmp/tryN5/tryN5File2.txt,
        O = user : root : /tmp/tryN5/tryN5File.txt,
        R = /tmp/tryN5
    ';

    try -O '
        D = /tmp/tryN5b,
        T = /tmp/tryN5b/tryN5bTar,
        A = /tmp/tryN5b/tryN5bTar.tar : /tmp/tryN5b/tryN5bTar,
        M = /tmp/tryN5b/tryN5bTar : /tmp/tryN5b/tryN5bTar.tar,
        S = /tmp/tryN5b/tryN5bTar.tar : /tmp/tryN5b/tryN5bTarLink.tar,
        U = /tmp/tryN5b/tryN5bTarLink.tar,
        H = /tmp/tryN5b/tryN5bTar.tar : /tmp/tryN5b/tryN5bTarLink.tar,
        W = /tmp/tryN5b/tryN5bTarLink.tar : /tmp/tryN5b/tryN5bTarLink.tar.copy,
        F = /tmp/tryN5b/tryN5b.fifo,
        C = awk,
        R = /tmp/tryN5b
    ';

    try -O "
        C = basename,
        C = dirname,
        C = mkdir,
        C = touch,
        C = ln,
        C = nohup,
        C = mkdir,
        C = touch,
        C = cat,
        C = grep
    " || exit;

    try -C 'D=tryN5';

}


# tryN1;
# tryN2;
 tryN3;
 echo hi
# tryN4;
#tryN5;
#rm -rf /tmp/tryN*;
