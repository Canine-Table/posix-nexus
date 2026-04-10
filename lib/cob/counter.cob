       IDENTIFICATION DIVISION.
       PROGRAM-ID. DFS-SAMPLE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 NX-INDEX        PIC 9(4) VALUE 0.
       01 NX-ROOT          PIC 9(4) VALUE 0.
       01 NX-TOP           PIC 9(4) VALUE 0.
       01 NX-DEPTH         PIC 9(4) VALUE 0.
       01 NX-DONE          PIC X VALUE "N".

       PROCEDURE DIVISION.
      *> Call the DFS logic
           PERFORM NXDFS

           DISPLAY "DEPTH = " NX-DEPTH
           STOP RUN.

       NXDFS.
      *> This is your DFS "function" as a paragraph
      *> You can put any pseudo-code here

           MOVE 1 TO NX-ROOT
           MOVE 0 TO NX-DEPTH

           PERFORM UNTIL NX-DONE = "Y"
               ADD 1 TO NX-DEPTH
               IF NX-DEPTH > 10
                   MOVE "Y" TO NX-DONE
               END-IF
           END-PERFORM
           EXIT.

