 IDENTIFICATION DIVISION.
 PROGRAM-ID.    CALPRML.
 
 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
     SELECT REPOUT
            ASSIGN TO UT-S-SYSPRINT.
 
 DATA DIVISION.
 FILE SECTION.
 FD  REPOUT
         RECORD CONTAINS 127 CHARACTERS
         LABEL RECORDS ARE OMITTED
         DATA RECORD IS REPREC.
 01  REPREC                     PIC X(127).
 
 WORKING-STORAGE SECTION.
*****************************************************
* MESSAGES FOR SQL CALL                             *
*****************************************************
 01  SQLREC.
         02  BADMSG    PIC X(34) VALUE
               ' SQL CALL FAILED DUE TO SQLCODE = '.
         02  BADCODE   PIC +9(5) USAGE DISPLAY.
         02  FILLER    PIC X(80) VALUE SPACES.
 01  ERRMREC.
         02  ERRMMSG   PIC X(12) VALUE ' SQLERRMC = '.
         02  ERRMCODE  PIC X(70).
         02  FILLER    PIC X(38) VALUE SPACES.
 01  CALLREC.
         02  CALLMSG   PIC X(28) VALUE
               ' GETPRML FAILED DUE TO RC = '.
         02  CALLCODE  PIC +9(5) USAGE DISPLAY.
         02  FILLER    PIC X(42) VALUE SPACES.
 01  RSLTREC.
         02  RSLTMSG   PIC X(15) VALUE
               ' TABLE NAME IS '.
         02  TBLNAME   PIC X(18) VALUE SPACES.
         02  FILLER    PIC X(87) VALUE SPACES.


*****************************************************
* WORK AREAS                                        *
*****************************************************
 01  PROCNM                     PIC X(18).
 01  SCHEMA                     PIC X(8).
 01  OUT-CODE                   PIC S9(9) USAGE COMP.
 01  PARMLST.
     49 PARMLEN         PIC S9(4) USAGE COMP.
     49 PARMTXT         PIC X(254).
 01  PARMBUF REDEFINES PARMLST.
     49 PARBLEN         PIC S9(4) USAGE COMP.
     49 PARMARRY        PIC X(127) OCCURS 2 TIMES.
 01  NAME.
     49 NAMELEN         PIC S9(4) USAGE COMP.
     49 NAMETXT         PIC X(18).
 77  PARMIND            PIC S9(4) COMP.
 77  I                  PIC S9(4) COMP.
 77  NUMLINES           PIC S9(4) COMP.
*****************************************************
* DECLARE A RESULT SET LOCATOR FOR THE RESULT SET   *
* THAT IS RETURNED.                                 *
*****************************************************
 01  LOC                USAGE SQL TYPE IS
                        RESULT-SET-LOCATOR VARYING.
 
*****************************************************
* SQL INCLUDE FOR SQLCA                             *
*****************************************************
     EXEC SQL INCLUDE SQLCA  END-EXEC.
 
 PROCEDURE DIVISION.
*------------------
 PROG-START.
          OPEN OUTPUT REPOUT.
*                   OPEN OUTPUT FILE
          MOVE 'DSN8EP2           ' TO PROCNM.
*                   INPUT PARAMETER -- PROCEDURE TO BE FOUND
          MOVE SPACES TO SCHEMA.
*                   INPUT PARAMETER -- SCHEMA IN SYSROUTINES
          MOVE -1 TO PARMIND.
*                   THE PARMLST PARAMETER IS AN OUTPUT PARM.
*                   MARK PARMLST PARAMETER AS NULL, SO THE DB2
*                   REQUESTER DOES NOT HAVE TO SEND THE ENTIRE
*                   PARMLST VARIABLE TO THE SERVER.  THIS
*                   HELPS REDUCE NETWORK I/O TIME, BECAUSE
*                   PARMLST IS FAIRLY LARGE.
      EXEC SQL
         CALL GETPRML(:PROCNM,
                    :SCHEMA,
                    :OUT-CODE,
                    :PARMLST INDICATOR :PARMIND)
      END-EXEC.

*                   MAKE THE CALL
          IF SQLCODE NOT EQUAL TO +466 THEN
*                   IF CALL RETURNED BAD SQLCODE
            MOVE SQLCODE TO BADCODE
            WRITE REPREC FROM SQLREC
            MOVE SQLERRMC TO ERRMCODE
            WRITE REPREC FROM ERRMREC
          ELSE
            PERFORM GET-PARMS
            PERFORM GET-RESULT-SET.
 PROG-END.
          CLOSE REPOUT.
*                   CLOSE OUTPUT FILE
          GOBACK.
 PARMPRT.
          MOVE SPACES TO REPREC.
          WRITE REPREC FROM PARMARRY(I)
             AFTER ADVANCING 1 LINE.
 GET-PARMS.
*                   IF THE CALL WORKED,
      IF OUT-CODE NOT EQUAL TO 0 THEN
*                   DID GETPRML HIT AN ERROR?
        MOVE OUT-CODE TO CALLCODE
        WRITE REPREC FROM CALLREC
      ELSE
*                   EVERYTHING WORKED
         DIVIDE 127 INTO PARMLEN GIVING NUMLINES ROUNDED
*                   FIND OUT HOW MANY LINES TO PRINT
         PERFORM PARMPRT VARYING I
           FROM 1 BY 1 UNTIL I GREATER THAN NUMLINES.
 GET-RESULT-SET.
*****************************************************
* ASSUME YOU KNOW THAT ONE RESULT SET IS RETURNED,  *
* AND YOU KNOW THE FORMAT OF THAT RESULT SET.       *
* ALLOCATE A CURSOR FOR THE RESULT SET, AND FETCH   *
* THE CONTENTS OF THE RESULT SET.                   *
*****************************************************
      EXEC SQL ASSOCIATE LOCATORS (:LOC)
        WITH PROCEDURE GETPRML
      END-EXEC.
*                   LINK THE RESULT SET TO THE LOCATOR
     EXEC SQL ALLOCATE C1 CURSOR FOR RESULT SET :LOC
     END-EXEC.
*                   LINK THE CURSOR TO THE RESULT SET
     PERFORM GET-ROWS VARYING I
      FROM 1 BY 1 UNTIL SQLCODE EQUAL TO +100.
 GET-ROWS.
     EXEC SQL FETCH C1 INTO :NAME
     END-EXEC.
    MOVE NAME TO TBLNAME.
    WRITE REPREC FROM RSLTREC
      AFTER ADVANCING 1 LINE.