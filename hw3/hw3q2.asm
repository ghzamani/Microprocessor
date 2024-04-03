.MODEL  SMALL
.STACK  64
;--------------------------------
.DATA
COUNT DB 10 DUP (?)
NAMES DB    "SA",0H,"UR",0H,"AB",0H,"GH",0H,"ABC",0H,"AB",0H, "SA",0H,"OP",0H,"SA",0H,"XV",0H ;strings are all null terminated
LENGTH  DB  0AH
              
TMP     DW  ?
;------------------------------- 
.CODE
MAIN    PROC    FAR 
        MOV     AX,@DATA
        MOV     DS,AX
        ;
        ;place code here
        MOV     AH,LENGTH
        MOV     SI,OFFSET NAMES
        MOV     DI,OFFSET COUNT
        MOV     DX,DI        
        DEC     DX
        
OUTERLOOP:      MOV CX,SI        
                MOV DI,OFFSET NAMES
                INC DX
                
INNERLOOP:      MOV SI,CX
                CALL CHECK
                INC DI
                CMP [DI],0H
                JNZ INNERLOOP
                
                INC SI
                DEC AH
                CMP AH,0
                JNZ OUTERLOOP
                                
        
         
        MOV     AH,4CH
        INT     21H
MAIN    ENDP  


;-------------------------------------
CHECK PROC
        DEC DI
LABEL1: INC DI        
        LODSB   ;automatically increases si
        CMP [DI],AL
        JNE DIFFERENT
        
        CMP AL,0H   ;check whether reached end of string
        JNE LABEL1  ;loop, till the end of the string
        
        MOV TMP,SI
        MOV SI,DX
        MOV BL,BYTE PTR COUNT[SI]
        INC BL 
        MOV BYTE PTR COUNT[SI],BL
        MOV DX,SI
        MOV SI,TMP
        RET       
         
DIFFERENT:  DEC SI           

ENDOFSTR1:  INC SI
            CMP [SI], 0H
            JNZ ENDOFSTR1
            DEC DI  ;if reached to the last character,decreament di
            
ENDOFSTR2:  INC DI
            CMP [DI],0H
            JNZ ENDOFSTR2
            RET            
            

CHECK ENDP


END MAIN  
