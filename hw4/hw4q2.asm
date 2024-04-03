.MODEL SMALL
.STACK 64
.DATA
MSG DB "ENTER NUMBER: $"  
MSG2  DB     'CHOOSE A NUMBER FOR:',10,13,
      DB     'SUM (0)',10,13,
      DB     'SUB (1)',10,13,
      DB     'MUL (2)',10,13,
      DB     'DIV (3)',10,13,
      DB     'QUIT (4)',10,13,'$'
NUM1 DB 0  
NUM2 DB 0
VALUE DB 0 
RES  DW ?   


.CODE
MAIN PROC FAR
    
    MOV AX, @DATA
    MOV DS, AX    
    
    ;;;;;;;;;;;;;;;      
    ;GET FIRST NUMBER FROM KEYBOARD
    MOV AH, 9
    LEA DX, MSG
    INT 21H
    
    
READ: MOV AH, 1
    INT 21H
    
    CMP AL, 13
    JE ENDOFNUMBER
    
    MOV VALUE, AL
    SUB VALUE, 48
    
    MOV AL, NUM1
    MOV BL, 10
    MUL BL
    
    ADD AL, VALUE
    
    MOV NUM1, AL
    
    JMP READ

    ENDOFNUMBER:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    CALL CLEAR  
    
    ;GET SECOND NUMBER FROM KEYBOARD
    MOV AH, 9
    LEA DX, MSG
    INT 21H
    
    READ2:
    MOV AH, 1
    INT 21H
    
    CMP AL, 13
    JE ENDOFNUMBER2
    
    MOV VALUE, AL
    SUB VALUE, 48
    
    MOV AL, NUM2
    MOV BL, 10
    MUL BL
    
    ADD AL, VALUE
    
    MOV NUM2, AL
    
    JMP READ2

    ENDOFNUMBER2:   
    ;;;;;;;;;;;;;;;;;;;;;;;
       
    
    CALL CLEAR   
    ;;;;;;;;;;;;;;;;;;;;;;;
    ;GET OPERATION NUMBER AND STORE IN VALUE
    MOV AH, 9
    LEA DX, MSG2
    INT 21H 
    
    MOV     AH,01 
    INT     21H 
    MOV     BL,AL
    AND     BL,0FH 
    MOV     VALUE,BL
    ;;;;;;;;;;;;;;;;;;;;;;;;;; 
    CALL    CLEAR
    ;GO TO DIFFERENT LABELS BASED ON VALUE
    CMP     VALUE,0
    JZ      SUM
    CMP     VALUE,01H
    JZ      SUBTRACT
    CMP     VALUE,02H
    JZ      MULTI
    CMP     VALUE,03H
    JZ      DIVISION
    CMP     VALUE,04H
    JZ      END
    
    
    
    
SUM: MOV AH,0 
    MOV AL,NUM1
    ADD AL,NUM2 
    MOV RES,AX
    CALL PRINT
    JMP END 
       
SUBTRACT: MOV AH,0
          MOV BH,0
          MOV AL,NUM1
          MOV BL,NUM2
          CMP AL,BL
          JL  SUB2
          SUB AL,BL
          MOV AH,0 
          MOV RES,AX 
          CALL PRINT
          JMP END 
          
SUB2:     MOV RES,AX
          MOV AL,BL
          MOV BX,RES
          SUB AL,BL
          MOV AH,0
          MOV RES,AX
          CALL PRINT
          JMP END   
          
          
MULTI:    MOV AH,0
          MOV AL,NUM1
          MOV BL,NUM2
          MUL BL
          MOV RES,AX
          CALL PRINT
          JMP END        
                         
DIVISION: MOV AH,0 
          MOV AL,NUM1
          MOV BL,NUM2
          CMP AL,BL
          JL  DIV2 
          DIV BL 
          MOV RES,AX
          CALL PRINT
          JMP END
          
          
          
DIV2:     MOV RES,AX
          MOV AL,BL
          MOV BX,RES 
          DIV BL 
          MOV RES,AX
          CALL PRINT
          JMP END         
          
              
    
END: MOV  AH,4CH
    INT  21H
MAIN   ENDP    
    
    
    
    
    
;-------------------CLEAR
CLEAR   PROC
        MOV AX,0600H
        MOV BH,07
        MOV CX,0000
        MOV DX,184FH
        INT 10H
        RET
CLEAR   ENDP    



HEX2DEC PROC NEAR
    MOV CX,0
    MOV BX,10
   
LOOP1: MOV DX,0
       DIV BX
       ADD DL,30H
       PUSH DX
       INC CX
       CMP AX,9
       JG LOOP1
     
       ADD AL,30H
       MOV [SI],AL
     
LOOP2: POP AX
       INC SI
       MOV [SI],AL
       LOOP LOOP2
       RET
HEX2DEC ENDP    


PRINT PROC          
     
    ;initialize count
    mov cx,0
    mov dx,0
    label1:
        ; if ax is zero
        cmp ax,0
        je print1     
         
        ;initialize bx to 10
        mov bx,10       
         
        ; extract the last digit
        div bx                 
         
        ;push it in the stack
        push dx             
         
        ;increment the count
        inc cx             
         
        ;set dx to 0
        xor dx,dx
        jmp label1
    print1:
        ;check if count
        ;is greater than zero
        cmp cx,0
        je exit
         
        ;pop the top of stack
        pop dx
         
        ;add 48 so that it
        ;represents the ASCII
        ;value of digits
        add dx,48
         
        ;interrupt to print a
        ;character
        mov ah,02h
        int 21h
         
        ;decrease the count
        dec cx
        jmp print1
exit:
ret
PRINT ENDP




END MAIN    