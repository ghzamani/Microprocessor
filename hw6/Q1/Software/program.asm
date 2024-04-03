.include "m32def.inc"

		LDI		R16,HIGH(RAMEND) 
		OUT		SPH,R16			;stack pointer high
		LDI		R16,LOW(RAMEND)
		OUT		SPL,R16			;stack pointer low

		LDI		R16,0xFF
		OUT		DDRC,R16		;PORTC as output
		OUT		DDRD,R16		;PORTD as output

		;used for storing current fibonaci number
LOAD:	LDI		R20, 0x01 
		LDI		R21, 0x00 
		;used for storing previous fibonaci number
		LDI		R22, 0 
		LDI		R23, 1 
		
CALCULATE:
		MOV		R23, R20
		MOV		R16, R21
		; shift four digits to the left by swapping nibbles
		; and setting lower nibble to 0
		SWAP	R16
		ANDI	R16,0xF0

		ADD		R23, R16

		ADD		R20, R22
		ANDI	R20, 0x0F ;set higher nibble to 0
		CPI		R20, 10
		BRLO	LOW_YEKAN ;branch lower if yekan is less than 10
		
		;else, yekan is greater than 10 
		;so yekan should be subtracted
		;and dahgan should be added
		SUBI	R20, 10
		LDI		R16, 0x01
		ADD		R21, R16

LOW_YEKAN:		
		MOV		R16, R22
		; shift four digits to the right by swapping nibbles
		; and setting higher nibble to 0
		SWAP	R16
		ANDI	R16,0x0F
		
		ADD		R21, R16
		CPI		R21, 10		; if yekan is greater than 10, should be subtracted
		BRLO	NEW_PREV  ; reset to 1
		LDI		R20, 0x01
		LDI		R21, 0X00
		LDI		R23, 0X00

NEW_PREV:
		MOV		R22, R23

SEND:
		LDI		R24,0x17 ;delay for 1 second
DISPLAY:		
		LDI		R16,0b11110111 
		OUT		PORTD,R16
		MOV		R16,R20
		CALL	CONVERT
		OUT		PORTC,R16
		CALL	DELAY_DISP

		LDI		R16,0b11111011
		OUT		PORTD,R16
		MOV		R16,R21
		CALL	CONVERT
		OUT		PORTC,R16
		CALL	DELAY_DISP

		DEC		R24
		BRNE	DISPLAY

		JMP		CALCULATE

DELAY_DISP:	LDI		R17,0x01	
	L1:		LDI		R18,0x15
	L2:		LDI		R19,0xFF
	L3:		DEC		R19
			BRNE	L3
			DEC		R18
			BRNE	L2
			DEC		R17
			BRNE	L1
			RET

CONVERT:				;converts digit to 7seg code 
		CPI		R16,0
		BRNE	C1
		LDI		R16,0x3F
		RET
C1:		CPI		R16,1
		BRNE	C2
		LDI		R16,0x06
		RET
C2:		CPI		R16,2
		BRNE	C3
		LDI		R16,0x5B
		RET
C3:		CPI		R16,3
		BRNE	C4
		LDI		R16,0x4F
		RET
C4:		CPI		R16,4
		BRNE	C5
		LDI		R16,0x66
		RET
C5:		CPI		R16,5
		BRNE	C6
		LDI		R16,0x6D
		RET
C6:		CPI		R16,6
		BRNE	C7
		LDI		R16,0x7D
		RET
C7:		CPI		R16,7
		BRNE	C8
		LDI		R16,0x07
		RET
C8:		CPI		R16,8
		BRNE	C9
		LDI		R16,0x7F
		RET
C9:		CPI		R16,9
		BRNE	C10
		LDI		R16,0x6F
C10:	RET
