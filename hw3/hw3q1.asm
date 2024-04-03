;;; simplified segment definition
;
.MODEL SMALL
.STACK 64
.DATA    
;
;place data definitions here
GRADES  DB  15H,13H,09H,08H,16H,06H,11H,17H,18H,04H,02H,10H,12H,17H,10H,15H,13H,09H,08H,16H ;all numbers are packed BCD 
LENGTH  DW  14H 

MEDIAN  DB  ?
MAX     DB  ?
MAXSCORE    DB  20H
DIFF     DB  ?
 

HEXSUM1     DW  ?
HEXSUM2     DW  ?
AVG1    DB  ?
AVG2    DB  ? 
BCDAVG1 DW  ?
BCDAVG2 DW  ?
;

.CODE
MAIN    PROC    FAR 
        MOV     AX,@DATA
        MOV     DS,AX
        ;
        ;place code here 
        MOV     SI,OFFSET GRADES ;put offset of array in source index pointer
        CALL    SUM1
        MOV     LENGTH,14H
        CALL    CAL_AVG1
        CALL    BCD_AVG1
        
        CALL    SORT
        CALL    FIND_MEDIAN
         
        CALL    CAL_MAX 
        CALL    CAL_MAXSCORE
        CALL    GRADE_INCREASE  
         
        CALL    SUM2          
        MOV     LENGTH,14H
        CALL    CAL_AVG2 
        CALL    BCD_AVG2
        
        ;
        
        MOV     AH,4CH
        INT     21H
MAIN    ENDP    
 



 ;---------------------------- SORT-------------------------------
SORT PROC 
     MOV    CX,LENGTH
     
OUTERLOOP:  MOV SI,0H
            MOV DI,0H
            INC DI
            JMP INNERLOOP
            RET
                         
INNERLOOP:    MOV   AL,[SI]
              MOV   BL,[DI]
              CMP   AL,BL
              JA    CHANGE 
              INC   DI
              INC   SI
              CMP   DI,CX
              JL   INNERLOOP
              LOOP OUTERLOOP
              RET
                        
    
CHANGE: MOV [SI],BL
        MOV [DI],AL
        MOV AL,BL  
        INC   DI
        INC   SI
        CMP   DI,CX
        JL   INNERLOOP
        LOOP OUTERLOOP
        RET
    
SORT    ENDP  



;----------------------------- MEDIAN ---------------------------
FIND_MEDIAN PROC     
            MOV BX,OFFSET GRADES
            ADD BX,09H  
            MOV AX,WORD PTR [BX]
            ADD BX,01H
            ADD AX,WORD PTR [BX]  
            DAA
            MOV AH,0H
            MOV BL,02H
            DIV BL
            MOV MEDIAN,AL
            RET
    
FIND_MEDIAN ENDP 


;----------------------------- MAX ---------------------------
CAL_MAX PROC
        MOV     SI,0H   ;set source pointer to head of the array
        MOV     CX,LENGTH  ;loop condition checks cx
        
        MOV     MAX,0H
        
LOOP2:  MOV     AL,[SI]
        CMP     AL,MAX
        JA      GREATER
RTN_POINT:      INC     SI
        LOOP    LOOP2
        RET
        
GREATER:MOV     MAX,AL 
        JMP     RTN_POINT
        
CAL_MAX ENDP


;----------------------------- MAXSCORE ---------------------------
;compute the difference between 20 and maximum grade
CAL_MAXSCORE PROC 
            MOV CX,01
            MOV BX,00
            CLC
BACK:       MOV AL,BYTE PTR MAXSCORE[BX]
            SBB AL,BYTE PTR MAX[BX]
            DAS 
            MOV BYTE PTR DIFF[BX],AL
            INC BX
            LOOP BACK
            RET
CAL_MAXSCORE ENDP



;----------------------------- GRADE_INCREASE ---------------------------
GRADE_INCREASE  PROC
                MOV SI,0H
                MOV CX,LENGTH
                
LOOP3:          MOV AL,[SI]
                CMP AL,MEDIAN
                JA  INCREASE
ITERATE:        INC SI
                LOOP LOOP3                                
                RET

INCREASE:       ADD AL,DIFF
                DAA
                MOV BYTE PTR GRADES[SI],AL
                JMP ITERATE    
    
GRADE_INCREASE  ENDP

 


;------------------   BCD SUM TO HEX -----------------------------------
SUM1    PROC          
        
        MOV SI,0H     
        MOV AH,0H
        
LOOPSUM1:  
        MOV BL,[SI]
        AND BL,0FH
        MOV AL,[SI]
        AND AL,11110000B
        MOV CL,04
        ROR AL,CL
        MOV DL,0AH
        MUL DL
        ADD AL,BL 
        
        ADD HEXSUM1,AX
        INC SI 
        DEC LENGTH
        CMP LENGTH,0H
        JNZ LOOPSUM1        
        
        RET

SUM1    ENDP

;------------------ BCD SUM TO HEX -----------------------------------
SUM2    PROC          
        
        MOV SI,0H
        ;MOV CX,LENGTH 
        MOV AH,0H
        
LOOPSUM2:  
        MOV BL,[SI]
        AND BL,0FH
        MOV AL,[SI]
        AND AL,11110000B
        MOV CL,04
        ROR AL,CL
        MOV DL,0AH
        MUL DL
        ADD AL,BL 
        
        ADD HEXSUM2,AX
        INC SI 
        DEC LENGTH
        CMP LENGTH,0H
        JNZ LOOPSUM2
        ;LOOP LOOP1
        
        
        RET

SUM2    ENDP
     
;-----------------------------  AVG1 -------------------------------------
CAL_AVG1    PROC
            MOV AX,HEXSUM1
            XOR DX,DX
            DIV LENGTH
            MOV AVG1,AL
            RET
CAL_AVG1    ENDP    


;-----------------------------  AVG2 -------------------------------------
CAL_AVG2    PROC
            MOV AX,HEXSUM2
            XOR DX,DX
            DIV LENGTH
            MOV AVG2,AL
            RET
CAL_AVG2    ENDP
  


;----------------------------- BCD_AVG1 -------------------------------------  
BCD_AVG1    PROC
            MOV AL,AVG1
            MOV AH,0H 
            MOV CL,64H
            DIV CL
            MOV BH,AL
            MOV AL,AH 
            MOV AH,0H
            MOV CL,0AH
            DIV CL
            MOV CL,04H
            ROL AL,CL
            ADD AL,AH
            MOV BL,AL
            MOV BCDAVG1,BX  
            RET
BCD_AVG1    ENDP    


;----------------------------- BCD_AVG2 -------------------------------------  
BCD_AVG2    PROC
            MOV AL,AVG2
            MOV AH,0H 
            MOV CL,64H
            DIV CL
            MOV BH,AL
            MOV AL,AH 
            MOV AH,0H
            MOV CL,0AH
            DIV CL
            MOV CL,04H
            ROL AL,CL
            ADD AL,AH
            MOV BL,AL
            MOV BCDAVG2,BX  
            RET
BCD_AVG2    ENDP  



END MAIN   


