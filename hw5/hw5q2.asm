DISPLAY MACRO STRING
        MOV AH,09H
        MOV DX,OFFSET STRING ;load string address
        INT 21H
        ENDM
             
       
CONVERT MACRO
        MOV CL,10
        SUB AH,AH
        DIV CL
        OR AX,3030H             
        ENDM
                
MOVEMENT    MACRO M
            LOCAL DISK_ID
            
            ;calculate number of times (m) can be divided by 2 
            MOV TMP,2
            MOV AX, M             
            MOV CX,0
DISK_ID:    INC CX
            MOV DX, 0
            DIV TMP
            CMP DX, 0
            JE  DISK_ID
            MOV AX, CX 
            
            CONVERT
            MOV DISK_NUM, AL
            MOV DISK_NUM+1,AH
            DISPLAY MSG1
            DISPLAY DISK_NUM
            
            
            ;(m&m-1) % 3
            MOV TMP,M
            DEC TMP
            AND TMP,M 
            MOV AX,TMP
            MOV CX,3
            MOV DX,0    ;in 16bit mode, remainder is stored in DX
            DIV CX
            OR  DL,30H
            MOV T1,DL
            DISPLAY MSG2
            DISPLAY T1
            
            
            ;(m|m-1)+1 % 3
            MOV TMP,M
            DEC TMP
            OR  TMP,M 
            INC TMP
            MOV AX,TMP
            MOV CX,3
            MOV DX,0    ;in 16bit mode, remainder is stored in DX
            DIV CX
            OR  DL,30H
            MOV T3,DL 
            DISPLAY MSG3
            DISPLAY T3
            DISPLAY NEW_LINE
            ENDM
            
 
HANOI   MACRO
        LOCAL LOOP1
        LOCAL FINISH
        MOV BX, 1
LOOP1:  CMP BX, CALL_COUNT
        JE  FINISH
        MOVEMENT BX
        INC BX
        JMP LOOP1

FINISH:    
        ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF MACROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
.MODEL SMALL
.STACK 64

.DATA

MSG1 DB ' disk ','$' 
MSG2 DB ' from ','$' 
MSG3 DB  ' to ', '$'
NEW_LINE DB 13, 10, "$"

T1 DB ?,?,'$'
T3 DB ?,?,'$'
DISK_NUM DB ?,?,'$'
CALL_COUNT DW 0
TMP  DW 0

;--------------------------
.CODE
MAIN	PROC FAR
	    MOV AX,@DATA
	    MOV DS,AX
	    
	    
	    MOV AH,00
	    MOV AL,03
	    INT 10H
	    
	    ;CX = DISKS - 1 
	    MOV AX,2
	    MOV BX,2
	    MOV CX,3
BITS_NEEDE:	MUL BX
            LOOP BITS_NEEDE
        
        MOV CALL_COUNT,AX
        HANOI    	    
	  
	    MOV AH,4CH
	    INT 21H
        MAIN ENDP            

END MAIN   