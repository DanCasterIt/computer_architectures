.MODEL .small
.STACK
.DATA
FLAG DW 0
BUFFER DW 0
;H_LEAVE DW 0700H 
;H_LEAVE DW 1037H
;H_LEAVE DW 151EH
H_LEAVE DW 0814H
N_A DW 12
N_B DW 12
N_C DW 12
N_D DW 12
A_SCHED DW N_A DUP(080AH,0900H,092DH,0A1EH,0B1EH,0C1EH,0D0FH,0E00H,0F00H,1000H,1100H,1200H)
B_SCHED DW N_B DUP(070AH,080FH,0905H,0A28H,0B00H,0E00H,0E1EH,0F00H,0F1EH,100FH,102DH,110FH)
C_SCHED DW N_C DUP(081EH,0928H,0A32H,0C00H,0D0AH,0E14H,0F1EH,1028H,1132H,1300H,140AH,1514H)
D_SCHED DW N_D DUP(0700H,0828H,0928H,0A28H,0B28H,0C1EH,0D1EH,0F00H,101EH,121EH,141EH,1500H)
A_TO_B DW 16
C_TO_D DW 4
B_TO_TP DW 29
D_TO_TP DW 45
CMSG1 DB 'First choice C:',13,10,'Leave time : $'
AMSG1 DB 'First choice A:',13,10,'Leave time : $'
CMSG2 DB 13,10,13,10,'Second choice C:',13,10,'Leave time : $' 
AMSG2 DB 13,10,13,10,'Second choice A:',13,10,'Leave time : $'
MSG3 DB ', swap arrival at: $'
DMSG4 DB ', D swap bus at: $' 
BMSG4 DB ', B swap bus at: $' 
MSG5 DB ', arrival at: $'
MSG6 DB 13,10,'Travel duration: $'
MSG0 DB 'Input time to leave: $' 
ROW DB 10,11 DUP(?)
.CODE
.STARTUP
        ;JMP INIT
        
        MOV DX, OFFSET MSG0
        MOV AH, 9
        INT 21H
        MOV DX, OFFSET ROW
        MOV AH, 0AH
        INT 21H
        
        MOV DX, 13
        MOV AH, 02H                            
        INT 21H
        MOV DX, 10
        MOV AH, 02H                            
        INT 21H
        
        MOV BX, OFFSET ROW
        MOV CX, 10
        XOR AX, AX
        CALL ASCII_TO_INTEGER 
        
        CALL DISPLAY
        JMP EXIT
INIT:
        
		MOV AX, H_LEAVE
		MOV BX, OFFSET A_SCHED
		MOV CX, N_A
		CALL SEARCH
		MOV SI, FLAG
		MOV BUFFER, SI
		PUSH AX
		MOV AX, H_LEAVE
		MOV BX, OFFSET C_SCHED
		MOV CX, N_C
		CALL SEARCH
		POP BX
		CMP AX, BX
		PUSH BX
		JA GREATER
		
		MOV DX, OFFSET CMSG1
		    CALL PRNT_MSG
		ADD AX, C_TO_D
		CALL CNTRL
		
		MOV DX, OFFSET MSG3
		    CALL PRNT_MSG
		MOV BX, OFFSET D_SCHED
		MOV CX, N_D
		CALL SEARCH
		
		MOV DX, OFFSET DMSG4
		    CALL PRNT_MSG
		ADD AX, D_TO_TP
		CALL CNTRL
		
		MOV DX, OFFSET MSG5
		    CALL PRNT_MSG
		CALL CALC
		MOV SI, BUFFER
		MOV FLAG, SI
		POP AX
		
		MOV DX, OFFSET AMSG2
		    CALL PRNT_MSG
		ADD AX, A_TO_B
		CALL CNTRL
		
		MOV DX, OFFSET MSG3
		    CALL PRNT_MSG
		MOV BX, OFFSET B_SCHED
		MOV CX, N_B
		CALL SEARCH
		
		MOV DX, OFFSET BMSG4
		    CALL PRNT_MSG
		ADD AX, B_TO_TP
		CALL CNTRL
		
		MOV DX, OFFSET MSG5
		    CALL PRNT_MSG
		CALL CALC
		JMP EXIT
GREATER:
		PUSH AX
		MOV AX, BX
		MOV SI, FLAG
		PUSH SI
		MOV SI, BUFFER
		MOV FLAG, SI
		
		MOV DX, OFFSET AMSG1
		    CALL PRNT_MSG
		ADD AX, A_TO_B
		CALL CNTRL
		
		MOV DX, OFFSET MSG3
		    CALL PRNT_MSG
		MOV BX, OFFSET B_SCHED
		MOV CX, N_B
		CALL SEARCH
		
		MOV DX, OFFSET BMSG4
		    CALL PRNT_MSG
		ADD AX, B_TO_TP
		CALL CNTRL
		
		MOV DX, OFFSET MSG5
		    CALL PRNT_MSG
		CALL CALC
		POP SI
		MOV FLAG, SI
		POP AX
		
		MOV DX, OFFSET CMSG2
		    CALL PRNT_MSG
		ADD AX, C_TO_D
		CALL CNTRL
		
		MOV DX, OFFSET MSG3
		    CALL PRNT_MSG
		MOV BX, OFFSET D_SCHED
		MOV CX, N_D
		CALL SEARCH
		
		MOV DX, OFFSET DMSG4
		    CALL PRNT_MSG
		ADD AX, D_TO_TP
		CALL CNTRL
		
		MOV DX, OFFSET MSG5
		    CALL PRNT_MSG
		CALL CALC
EXIT:
.EXIT
SEARCH PROC
		XOR SI, SI
LOOP1:
		CMP AX, WORD PTR [BX+SI]
		JA NXT1
		MOV AX, WORD PTR [BX+SI]
		JMP NXT2
NXT1:
		ADD SI, 2
		LOOP LOOP1
		MOV AX, WORD PTR [BX]
		MOV SI, 1
		MOV FLAG, 1
NXT2:
		RET
SEARCH ENDP
CNTRL PROC
		CMP AX, 1800H
		JB NXT3
		MOV DI, 1
		MOV FLAG, DI
		SUB AX, 1800H
NXT3:   
        CMP AL, 3CH
        JB NXT4
        SUB AL, 3CH
        INC AH
NXT4:
		RET
CNTRL ENDP
DISPLAY PROC                            ;Procedure TO DISPLAY AVERAGE
        PUSH BX
        PUSH DX
        PUSH CX 
        PUSH SI
        PUSH AX
        
        MOV SI, FLAG
        CMP SI, 0
        JE FORWARD
        PUSH AX
        MOV DX, '*'
        MOV AH, 02H                            
        INT 21H
        POP AX
FORWARD:
        PUSH AX   
        MOV AL, AH
        XOR AH, AH
        XOR SI, SI
        JMP NEXT
RELOOP:
        MOV DX, ':'
        MOV AH, 02H                            
        INT 21H
        POP AX
        XOR AH, AH
        MOV SI, 1
NEXT:
        MOV BX, 10                      ;Initializes divisor
        MOV DX, 0000H                   ;Clears DX
        MOV CX, 0000H                   ;Clears CX
                                        ;Splitting process starts here
.Dloop1:                
		MOV DX, 0000H                   ;Clears DX during jump
        DIV BX                          ;Divides AX by BX
        PUSH DX                         ;Pushes DX(remainder) to stack
        INC CX                          ;Increments counter to track the number of digits
        CMP AX, 0                       ;Checks if there is still something in AX to divide
        JNE .Dloop1                     ;Jumps if AX is not zero
.Dloop2:                
		POP DX                          ;Pops from stack to DX
        ADD DX, 30H                     ;Converts to it's ASCII equivalent
        MOV AH, 02H                            
        INT 21H                         ;calls DOS to display character
        LOOP .Dloop2                    ;Loops till CX equals zero
        CMP SI, 0
        JE RELOOP
         
        POP AX   
        POP SI
        POP CX
        POP DX
        POP BX
        RET                             ;returns control
DISPLAY ENDP              
PRNT_MSG PROC 
        PUSH AX
        PUSH DX
        
        MOV AH, 9
        INT 21H 
        
        POP DX
        POP AX
        CALL DISPLAY
        RET
PRNT_MSG ENDP
CALC PROC
        PUSH BX
        PUSH SI
        
        MOV BX, H_LEAVE
        MOV SI, FLAG
        CMP SI, 0
        JE ENDA:
        ADD AH, 24
		XOR SI, SI
		MOV FLAG, SI
ENDA:   
        CMP AL, BL
        JA ENDB   
        JE ENDB
        DEC AH
        ADD AL, 60
ENDB:
        SUB AX, BX
		MOV DX, OFFSET MSG6
        CALL PRNT_MSG
        POP SI
        POP BX 
        RET
CALC ENDP
ASCII_TO_INTEGER PROC
        MOV AL, 0DH
LOOPA:       
        MOV SI, CX
        CMP AL, BYTE PTR [BX+SI]
            PUSH AX
            MOV AL, BYTE PTR [BX+SI]
            POP AX
        JNE DO_NOTTHING
        DEC CX
        JMP LOOPB
DO_NOTTHING:
        LOOP LOOPA
LOOPB:  
        MOV SI, CX
        MOV AL, BYTE PTR [BX+SI]
        
        PUSH CX
        PUSH BX
        PUSH AX
        MOV AL, 1
MULT:   
        MOV BL, 10
        MUL BL
        LOOP MULT
        MOV SI, AX
        POP AX
        POP BX
        POP CX
        
        PUSH BX
        MOV BX, SI
        MUL AL
        POP BX
         
        LOOP LOOPB
        RET
ASCII_TO_INTEGER ENDP
END                       