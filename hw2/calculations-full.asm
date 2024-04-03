; full segment definition

;-------STACK SEGMENT ------
STSEG   SEGMENT
        DB      64 DUP(?)
STSEG   ENDS

;-------DATA SEGMENT ------
DTSEG   SEGMENT    
;
;place data definitions here
NUMBERS DB  0H, 2H, 4H, 6H, 8H, 9H, 7H, 5H, 3H, 1H
SUM     DB  ?
MAX     DB  ?
MIN     DB  ?
AVG     DB  ?
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
        MOV     SI,OFFSET NUMBERS ;put offset of array in source index pointer
        CALL    CAL_SUM 
        CALL    CAL_AVG  
        CALL    CAL_MAX 
        CALL    CAL_MIN
        ;
        
        MOV     AH,4CH
        INT     21H
MAIN    ENDP
        
                           
                           
;-------SUM ------
CAL_SUM PROC
        MOV     SI,0H
        MOV     CX,0AH
        
LOOP1:  MOV     AL,[SI]
        ADD     SUM,AL        
        INC     SI  ;increment source ptr by 1
        LOOP    LOOP1
        RET
CAL_SUM ENDP
     
     
;-------AVG ------
CAL_AVG PROC
        MOV     AL,SUM     
        MOV     AH,0
        MOV     BL,0AH     
        DIV     BL     ;al / bl    
        MOV     AVG,AH
        RET
CAL_AVG ENDP 


;-------MAX ------ 
CAL_MAX PROC
        MOV     SI,0H   ;set source pointer to head of the array
        MOV     CX,0AH  ;loop condition checks cx
        
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


;-------MIN ------
CAL_MIN PROC
        MOV     SI,0H   ;set source pointer to head of the array
        MOV     CX,0AH  ;loop condition checks cx
        
        MOV     MIN,0FFH
        
LOOP3:  MOV     AL,[SI]
        CMP     AL,MIN
        JB      LOWER
RTN_POINT2:     INC     SI
        LOOP    LOOP3
        RET
        
LOWER:  MOV     MIN,AL 
        JMP     RTN_POINT2
        
CAL_MIN ENDP



CDSEG   ENDS
        END     MAIN