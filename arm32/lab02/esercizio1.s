	AREA myCode, READONLY, CODE
	ENTRY
	MOV R0, #4
	MOV R1, #4
	MOV R2, #6
	MOV R3, #7
	MOV R4, #9
	MOV R5, #12
	MOV R6, #8
	MOV R7, #8

	CMP R0, R1
	ADDNE R8, R0, R1
	MOVNE R8, R8, LSR #1
	MULEQ R8, R0, R1

	CMP R2, R3 
	ADDNE R9, R2, R3
	MOVNE R9, R9, LSR #1
	MULEQ R9, R2, R3

	CMP R4, R5	
	ADDNE R10, R4, R5
	MOVNE R10, R10, LSR #1
	MULEQ R10, R4, R5

	CMP R6, R7	
	ADDNE R11, R6, R7
	MOVNE R11, R11, LSR #1
	MULEQ R11, R6, R7

reset_handler
	B reset_handler; i'm stayng in my code area
	END