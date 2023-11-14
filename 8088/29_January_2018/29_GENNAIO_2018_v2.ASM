.MODEL small
.STACK
.DATA
        OBJ_PRICES DW 50 DUP(15000,13000,13000,10000,9999,7001,5000,4999,2099,1999,1000,1000)
        N DW 11*2
        N_PROD DW 0
        P_ID DW 4 DUP(?)
        MENU DW 4 DUP(ERR, P1, P2, P3, P4)
        PRICE DW 0 
        LN DW 0
        DISCOUNT DW 0
        NL DB 13, 10,"$"
		NUM DB 3, 4 DUP(?)
		ERRMSG DB 13, 10,"ERROR: input 1, 2, 3 or 4.",13, 10,"$"
		ERRMSG2 DB 13, 10,"ERROR: less than previous number or greather than $"
		MSGA DB "Input how many products to buy: $"
		MSGB DB 13, 10,"Input product ID in increasing order (default: 0): $"
		MSGC DB 13, 10,"Resulting price: $"
		MSGD DB 13, 10,"Choose A, B or C: $"
		MSGE DB 13, 10,"Choose A, B, C or D: $"
		MSGF DB 13, 10,"Choose A, B, C, D or E: $"
		MSGG DB ", discount: $"
		MSGH DB ", percentage: $"
.CODE
.STARTUP
        JMP BEG
ERR:
        ;print error
		    MOV DX, OFFSET ERRMSG
		    MOV AH, 9
		    INT 21H
BEG:
        ;I-input how many products in N_PROD
		    MOV DX, OFFSET MSGA
		    MOV AH, 9
		    INT 21H
		    MOV AH, 01H
		    INT 21H
		    XOR AH, AH
		    SUB AL, 48
		    MOV N_PROD, AX
        MOV AX, 4
        CMP N_PROD, AX
        JA ERR
        MOV AX, 0
        CMP N_PROD, AX
        JE ERR
        MOV CX, N_PROD
        MOV SI, CX
        DEC SI
        SHL SI, 1
LOOP1:
        ;I-input product ID (increasing order)
            JMP NEP
EP:         
            MOV DX, OFFSET ERRMSG2
		    MOV AH, 9
		    INT 21H
            MOV AX, N
            SHR AX, 1
		    PUSH AX
	        CALL printud
		    MOV DL, '.'
		    MOV AH, 2H
		    INT 21H   
NEP:
		    MOV DX, OFFSET MSGB
		    MOV AH, 9
		    INT 21H
		    CALL readDecimal
			SHL AX, 1
		    MOV P_ID[SI], AX
		    CMP AX, LN
		    JB EP
        MOV AX, N
        CMP P_ID[SI], AX
        JA EP
		MOV AX, P_ID[SI]
		MOV LN, AX
        SUB SI, 2
        LOOP LOOP1
        MOV SI, N_PROD
        SHL SI, 1
        JMP MENU[SI]
P1:
		CALL FPRICE
		JMP PEND
P2:
		;input A=0, B=1, C=2 in AX
		    MOV DX, OFFSET MSGD
		    MOV AH, 9
		    INT 21H
		    MOV AH, 01H
		    INT 21H
		    XOR AH, AH
		    SUB AL, 65
		CMP AX, 0
		JNE NXT1
		CALL ARULE
		JMP PEND
NXT1:
		CMP AX, 1
		JNE NXT2
		CALL BRULE
		JMP PEND
NXT2:
		CMP AX, 2
		JNE P2
		CALL CRULE
		JMP PEND
P3:     
		;input A=0, B=1, C=2, D=3 in AX
		    MOV DX, OFFSET MSGE
		    MOV AH, 9
		    INT 21H
		    MOV AH, 01H
		    INT 21H
		    XOR AH, AH
		    SUB AL, 65
		CMP AX, 0
		JNE NXT3
		CALL ADGA
		CALL ARULE
		JMP PEND
NXT3:
		CMP AX, 1
		JNE NXT4
		CALL ADGA
		CALL BRULE
		JMP PEND
NXT4:
		CMP AX, 2
		JNE NXT5
		CALL ADGA
		CALL CRULE
		JMP PEND
NXT5:
		CMP AX, 3
		JNE P3		
		CALL DRULE
		JMP PEND
P4:     
		;input A=0, B=1, C=2, D=3, E=4 in AX
		    MOV DX, OFFSET MSGF
		    MOV AH, 9
		    INT 21H
		    MOV AH, 01H
		    INT 21H
		    XOR AH, AH
		    SUB AL, 65
		CMP AX, 0
		JNE NXT6
		CALL ADGB
		CALL ARULE
		JMP PEND
NXT6:
		CMP AX, 1
		JNE NXT7
		CALL ADGB
		CALL BRULE
		JMP PEND
NXT7:
		CMP AX, 2
		JNE NXT8
		CALL ADGB
		CALL CRULE
		JMP PEND
NXT8:
		CMP AX, 3
		JNE NXT9
		CALL ADGC		
		CALL DRULE
		JMP PEND
NXT9:
		CMP AX, 4
		JNE P4	
		CALL ERULE
		JMP PEND
PEND:
.EXIT
PERCENTAGE PROC
        MOV AX, 100
        MUL DISCOUNT
        MOV BX, DISCOUNT
        ADD BX, PRICE
        DIV BX
        PUSH AX
        MOV DX, OFFSET MSGH
		MOV AH, 9
		INT 21H
	    CALL printud
		MOV DL, '%'
		MOV AH, 2H
		INT 21H
        RET
PERCENTAGE ENDP    
PRINT PROC
        MOV DX, OFFSET MSGC
		MOV AH, 9
		INT 21H
		PUSH PRICE
	    CALL printud
        MOV DX, OFFSET MSGG
		MOV AH, 9
		INT 21H
		CMP DISCOUNT, 0
		JGE GO
		NEG DISCOUNT
		MOV DL, '-'
		MOV AH, 2H
		INT 21H
		PUSH DISCOUNT
		CALL printud
		JMP GOE
		    
GO:     
		PUSH DISCOUNT
		CALL printud
		CMP DISCOUNT, 0
		JE GOE
		CALL PERCENTAGE
GOE:
        RET
PRINT ENDP
FPRICE PROC
		MOV SI, P_ID[0]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		;print total price
		    CALL PRINT
		RET
FPRICE ENDP
ARULE PROC
		MOV SI, P_ID[0]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 1
		ADD DISCOUNT, AX
		SUB PRICE, AX
		MOV SI, P_ID[2]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		;print total price
		    CALL PRINT
		RET
ARULE ENDP
BRULE PROC
		MOV SI, P_ID[0]
		MOV AX, OBJ_PRICES[SI]
		ADD DISCOUNT, AX
		MOV SI, P_ID[2]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 2
		SUB DISCOUNT, AX
		ADD PRICE, AX
		;print total price
		    CALL PRINT
		RET
BRULE ENDP
CRULE PROC
		MOV SI, P_ID[0]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 2 
		ADD DISCOUNT, AX
		SUB PRICE, AX
		MOV SI, P_ID[2]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 3      
		ADD DISCOUNT, AX
		SUB PRICE, AX
		;print total price
		    CALL PRINT
		RET
CRULE ENDP
DRULE PROC
		MOV SI, P_ID[0]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 2       
		ADD DISCOUNT, AX
		SUB PRICE, AX
		MOV SI, P_ID[2]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 3       
		ADD DISCOUNT, AX
		SUB PRICE, AX
		MOV SI, P_ID[4]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		SHR AX, 4       
		ADD DISCOUNT, AX
		SUB PRICE, AX
		;print total price
		    CALL PRINT
		RET
DRULE ENDP
ERULE PROC
		MOV SI, P_ID[0]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		MOV SI, P_ID[2]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		MOV SI, P_ID[4]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		MOV SI, P_ID[6]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
		MOV AX, PRICE
		SHR AX, 3       
		ADD DISCOUNT, AX
		SUB PRICE, AX
		;print total price
		    CALL PRINT
		RET
ERULE ENDP
ADGA PROC
        MOV BX, P_ID[2]
        MOV AX, P_ID[4]
        MOV P_ID[2], AX
        MOV P_ID[4], BX           
		MOV SI, P_ID[4]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
        RET
ADGA ENDP
ADGB PROC
        MOV BX, P_ID[2]
        MOV AX, P_ID[6]
        MOV P_ID[2], AX
        MOV P_ID[6], BX           
		MOV SI, P_ID[4]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX           
		MOV SI, P_ID[6]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
        RET
ADGB ENDP
ADGC PROC            
        MOV DX, P_ID[2]
        MOV BX, P_ID[4]
        MOV AX, P_ID[6]
        MOV P_ID[2], BX
        MOV P_ID[4], AX
        MOV P_ID[6], DX         
		MOV SI, P_ID[6]
		MOV AX, OBJ_PRICES[SI]
		ADD PRICE, AX
        RET
ADGC ENDP    
readDecimal PROC
        PUSH BP
        MOV BP, SP
    
        PUSH CX
        PUSH DX
    
        MOV CX, 5
        MOV DX, 0

readLoop:
        MOV AH, 1
        INT 21h
        CMP AL, 13
        JE endReadLoop
    
        SUB AL, '0'
        MOV CH, AL
    
        MOV AX, DX
        MOV DX, 10
        MUL DX
        MOV DX, AX
    
        ADD DL, CH
        ADC DH, 0
    
        XOR CH, CH
        LOOP readLoop

endReadLoop:    
        MOV AX, DX
          
        POP DX
        POP CX

        POP BP
        RET
readDecimal ENDP                       
printud  PROC
        PUSH BP
        MOV  BP, SP

        PUSH AX  
        PUSH BX
        PUSH CX    
        PUSH DX
    
        MOV  AX, WORD PTR [BP + 4]

        MOV  DX, 0
        MOV  CX, 10
        DIV  CX

        CMP  AX, 0
        JNE  L4

        ADD  DL, '0'
        MOV  AH, 2
        INT  21h

        JMP  L5

L4:
        PUSH AX
        CALL printud
        ADD  DL, '0'
        MOV  AH, 2
        INT  21h        

L5:
        POP  DX
        POP  CX
        POP  BX
        POP  AX
    
        POP  BP
        RET  2 
printud  ENDP
		END