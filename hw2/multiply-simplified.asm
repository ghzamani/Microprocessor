; simplified segment definition

.MODEL SMALL
.STACK 64
.DATA
;
;place data definitions here
DATA1   DW  32H
DATA2   DW  23H
SUM     DW  ?
;

.CODE
MAIN    PROC    FAR
        MOV     AX,@DATA
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
        END     MAIN