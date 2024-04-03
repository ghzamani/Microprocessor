CURSOR  MACRO ROW,COLUMN
        MOV AH,02H
        MOV BH,00
        MOV DH,ROW
        MOV DL,COLUMN
        INT 10H
        ENDM


DISPLAY MACRO STRING
        MOV AH,09H
        MOV DX,OFFSET STRING ;load string address
        INT 21H
        ENDM


SHOW_DOT   MACRO   COL
        MOV     AH, 09  ;display option
        MOV     BH, 00  ;page 0                
        MOV     AL, 09  ;dot ascii code is 9
        MOV     CX, 1   ;repeat
        MOV     BL, COL ;set favorite color to cga
        SHL     BL, 1   ;shift to next color
        ENDM


CLEAR   MACRO
        MOV AX,0600H ;scroll the screen
        MOV BH,07    ;normal attribute
        MOV CX,0000  ;from row=00, column=00
        MOV DX,184FH ;to row=18h, column=4fh
        INT 10H      ;invoke interrupt to change mode
CLEAR   ENDM
 

CONVERT MACRO
        SHR AX,3
        MOV TMP,10
        SUB AH,AH
        DIV TMP
        OR  AX,3030H
        
CONVERT ENDM


.MODEL  SMALL
.STACK  64
;---------------------------
.DATA   

RESET      DB  '*** R E S E T *** ','$'  
MOUSE_POS  DB  'MOUSE POSITION: ','$'
          
X      DB  ?,?,', $' 
Y      DB  ?,?,'$'

DOT_COLOR   DB  20H 
TMP    DB  00H      

.CODE
MAIN        PROC    FAR
            MOV     AX, @DATA
            MOV     DS, AX  
                           
            MOV     AH, 00  
            MOV     AL, 03H
            INT     10H  
SHOW_RESET: MOV     DOT_COLOR,20H ;reset the color
            CURSOR  12,32
            DISPLAY RESET    
                                    
INITIAL:    MOV     AX, 03  ;mouse initialization
            INT     33H 
            
            CMP     BX, 1   ;BX contains mouse button status
            JZ      POSITION
            JMP     INITIAL 
    
            
POSITION:   SHR     CX, 3   ;cx/8 contains horizontal coordinate
            SHR     DX, 3   ;dx/8 contains vertical coordinate
            

  
;IF  DX=12 AND 32<CX<48
;THEN CLEAR THE SCREEN AND RESET
ON_RESET_CLK:    CMP    DX,12
                 JNE    MOUSE_CLK
                 
                 CMP    CX,32
                 JB     MOUSE_CLK
                 CMP    CX,48
                 JA     MOUSE_CLK
                 CLEAR
                 
                 JMP    SHOW_RESET     
                                  

MOUSE_CLK:  CURSOR  DL,CL         
            SHOW_DOT DOT_COLOR
            CMP     BL, 40H    ;compare the color with red
            JNA     FIND_COLOR ;if the color is in the range print the position
            MOV     BL,10H
            
           
FIND_COLOR: MOV     DOT_COLOR, BL
            INT     10H  
            
            MOV     AX, 03
            INT     33H  
            
            MOV     AX,DX
            CONVERT
            MOV     X,AL
            MOV     X+1,AH
            
            MOV     AX,CX
            CONVERT
            MOV     Y,AL
            MOV     Y+1,AH
            
            CURSOR  22,30
            DISPLAY MOUSE_POS
            DISPLAY X
            DISPLAY Y 
           
            JMP     INITIAL 
            
            MOV     AH, 4CH
            INT     21H
MAIN        ENDP

            END MAIN