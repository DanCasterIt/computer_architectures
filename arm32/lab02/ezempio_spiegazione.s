	AREA myCode, READONLY, CODE
	ENTRY
reset_handler
	MOV R0, #200
	;MOV R1, #1001 ;IT'S NOT GOOD BECAUSE OF THE SHIFT REGISTER
	LDR R1, =1001; USE LDR INSTED OF MOV. 1001 IT'S NOT CONSIDERED AN IMMEDIATE 
	;R2 = |R0 - R1|
	;CMP R0, R1
	;BLO isLower
	;SUB R2, R0, R1
	;B next
;isLower
	;SUB R2, R1, R0	
;next
						 
	;R2 = |R0 - R1|
	CMP R0, R1
	SUBHS R2, R0, R1
	SUBLO R2, R1, R0
next
	B reset_handler; i'm stayng in my code area
	END