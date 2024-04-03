; full segment definition

;-------STACK SEGMENT ------
STSEG   SEGMENT
        DB      64 DUP(?)
STSEG   ENDS

;-------DATA SEGMENT ------
DTSEG   SEGMENT    
;
;place data definitions here
DATA1   DW  32H
DATA2   DW  23H
SUM     DW  ?
;
DTSEG   ENDS 

;-------CODE SEGMENT ------
CDSEG   SEGMENT
MAIN    PROC    FAR 
        ASSUME  CS:CDSEG,DS:DTSEG,SS:STSEG
        MOV     AX,DTSEG
        MOV     DS,AX
        ;
        ;place code here 
        MOV     AX,DATA1
        MOV     CX,DATA2
        MULTIPLY:ADD SUM,AX
        LOOP    MULTIPLY
        ;
        
        MOV     AH,4CH
        INT     21H
MAIN    ENDP

        
CDSEG   ENDS   
END     MAIN   