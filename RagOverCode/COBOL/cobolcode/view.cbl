IDENTIFICATION DIVISION.
PROGRAM-ID. View.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 DISPLAY-DATA PIC X(50).
01 USER-INPUT PIC X(5).

PROCEDURE DIVISION USING DISPLAY-DATA.
    DISPLAY "Enter a number: ".
    ACCEPT USER-INPUT.

    MOVE "Input: " USER-INPUT " Calculated: " DISPLAY-DATA TO DISPLAY-DATA.
    DISPLAY DISPLAY-DATA.
    EXIT PROGRAM.