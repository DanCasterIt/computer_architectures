	AREA myCode, READONLY, CODE
	ENTRY
	MOV R0, #6
	MOV R1, #2
	MOV R2, #4
			
	CMP R0, R1
	MOVGT R8, R0 
	MOVGT R0, R1
	MOVGT R1, R8
				
	CMP R1, R2
	MOVGT R8, R1 ; R1 > R2
	MOVGT R1, R2
	MOVGT R2, R8

	CMP R0, R1
	MOVGT R8, R0 
	MOVGT R0, R1
	MOVGT R1, R8

	MOV R4, #0
	MOV R8, R1
LOOP1
	SUB R8, R8, R0
	ADD R4, R4, #1
	CMP R8, #0 
	BGT LOOP1 ; R8 > R0 (R1- R2)
	BEQ NEXT1
	MOV R4, #0
NEXT1
		  		   
	MOV R5, #0	
	MOV R8, R2
LOOP2 
	SUB R8, R8, R0 
	ADD R5, R5, #1
	CMP R8, #0
	BGT LOOP2 ; R8 > R0 (R1- R2)  
	BEQ NEXT2
	MOV R5, #0
NEXT2

reset_handler
	B reset_handler; i'm stayng in my code area
	END