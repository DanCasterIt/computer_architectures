	AREA myCode, READONLY, CODE
	ENTRY
	MOV R0, #0
	MOV R1, #0
	MOV R9, #4
	MOV R10, #0	 
	MOV R11, #0
	MOV R12, #0	 
LOOP1
	LDR R13, =SEQUENCE
	LDR R0, [R13,R10]
	LDR R13, =SEQUENCE	
	LDR R1, [R13,R9]
	CMP R0, R1
	MOVGT R11, #1	  	  ; R0 > R1 [R1- R2] -> DECRESCENTE
	MOVLT R12, #1	  	  ; R0 < R1 [R1- R2] -> CRESCENTE 
	ADD R10, R10, #4	  ; counter 1 -> PARTE DA 0	
	ADD R9, R9, #4		  ; counter 2 -> PARTE DA 4
	CMP R10, #28		  ; 4*7 = 28
	BLT LOOP1			  ; fin tanto che R10 < 32

	CMP R11, #0
	BNE next1
	CMP R12, #0
	BEQ	next2 
	; R11 = 0, R12 = 1 -> CRESCENTE -> VALORE MEDIO
	MOV R0, #0
	MOV R1, #0
	MOV R10, #0	
LOOP2
	LDR R13, =SEQUENCE
	LDR R0, [R13,R10]
	ADD R1, R1, R0
	ADD R10, R10, #4	  ; counter
	CMP R10, #32		  ; 4*8 = 32
	BLT LOOP2			  ; fin tanto che R10 <  32
	MOV R1, R1, LSR #3	  ; R1 = R1/8
	B pend
next1
	CMP R12, #0
	BEQ	next2
	; R11 = 1, R12 = 1  -> DISORDINATA -> VALORE PIù GRAMDE E PIù PICCOLO
	MOV R0, #0
	MOV R1, #0
	MOV R2, #8
	MOV R10, #0	
LOOP3
	LDR R13, =SEQUENCE
	LDR R0, [R13,R10]
	CMP	R0, R1
	MOVGT R1, R0		  ; se R0 > R1 
	CMP	R0, R2
	MOVLT R2, R0		  ; se R0 < R2
	ADD R10, R10, #4	  ; counter
	CMP R10, #32		  ; 4*8 = 32
	BLT LOOP3			  ; fin tanto che R10 <  32
	B pend
next2
	; R11 = 1, R12 = 0 -> DECRESCENTE -> LA DIFFERENZA PIù GRANDE
	MOV R0, #0
	MOV R1, #0	
	MOV R2, #0
	MOV R9, #4
	MOV R10, #0	 
	MOV R11, #0
	MOV R12, #0
LOOP4
	LDR R13, =SEQUENCE
	LDR R0, [R13,R10]
	LDR R13, =SEQUENCE	
	LDR R1, [R13,R9]
	SUB R0, R0, R1
	CMP R0, R2			  
	MOVGT R2, R0		  ; se R0 > R2
	ADD R10, R10, #4	  ; counter 1 -> PARTE DA 0	
	ADD R9, R9, #4		  ; counter 2 -> PARTE DA 4
	CMP R10, #28		  ; 4*7 = 28
	BLT LOOP4			  ; fin tanto che R10 < 28
pend	

reset_handler
	B reset_handler
;SEQUENCE DCD 6, 9, 5, 3, 1, 2, 0, 8
;SEQUENCE DCD 1, 2, 3, 4, 5, 6, 7, 8
SEQUENCE DCD 8, 7, 6, 5, 4, 3, 2, 1
	END