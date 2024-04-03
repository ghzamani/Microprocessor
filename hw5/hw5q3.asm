.MODEL SMALL
.STACK 64

.DATA
   
;store numbers as big endian   
M  DW  2300H, 1874H, 0230H ;023018742300                                                        
N  DW  7091H, 0234H, 4719H ;479102347091 
RESULT    DW  0H, 0H, 0H, 0H, 0H, 0H

 
.CODE
MAIN        PROC FAR
            MOV AX, @DATA
            MOV DS, AX                           
            
            ;M word computation
            ;r0 = n0 * m0
            MOV AX,[M]
            MOV BX,[N]
            MUL BX
            MOV [RESULT],AX  
            MOV [RESULT+2],DX
            
            ;N word computation
            ;r1 = n1 * m0 + n0 * m1 + c0             
            MOV AX,[M]
            MOV BX,[N+2]
            MUL BX
            ADD [RESULT+2],AX
            ADC DX,0
            ADD [RESULT+4],DX
            
            MOV AX,[M+2]
            MOV BX,[N]
            MUL BX            
            ADC DX,0
            ADD [RESULT+2],AX
            ADD [RESULT+4],DX
            
            
            ;third word computation
            ;r2 = n2 * m0 + n1 * m1 + n0 * m2 + c1
            MOV AX,[M]
            MOV BX,[N+4]
            MUL BX
            ADD [RESULT+4],AX             
            ADC DX,0 
            MOV [RESULT+6],DX
            
            MOV AX,[M+2]
            MOV BX,[N+2]
            MUL BX
            ADD [RESULT+4],AX
            ADC DX,0   
            ADD [RESULT+6],DX
            
            MOV AX,[M+4]
            MOV BX,[N]
            MUL BX
            ADD [RESULT+4],AX
            ADC DX,0
            ADD [RESULT+6],DX  
            
            
            ;forth word computation
            ;r3 = n3 * m0 + n2 * m1 + n1 * m2 + n0 * m3 + c2
            MOV AX,[M]
            MOV BX,[N+6]
            MUL BX
            ADD [RESULT+6],AX
            ADC DX,0
            ADD [RESULT+8],DX
            
            MOV AX,[M+2]
            MOV BX,[N+4]
            MUL BX
            ADD [RESULT+6],AX
            ADC DX,0
            ADD [RESULT+8],DX
                            
            MOV AX,[M+4]
            MOV BX,[N+2]
            MUL BX
            ADD [RESULT+6],AX
            ADC DX,0
            ADD [RESULT+8],DX
            
            MOV AX,[M+6]
            MOV BX,[N]
            MUL BX
            ADD [RESULT+6],AX
            ADC DX,0
            ADD [RESULT+8],DX


EXIT:       MOV AH, 4CH
            INT 21H
MAIN        ENDP
            END MAIN      