;/*****************************************************************************/
;/* STARTUP.S: Startup file for Philips LPC2000                               */
;/*****************************************************************************/
;/* <<< Use Configuration Wizard in Context Menu >>>                          */ 
;/*****************************************************************************/
;/* This file is part of the uVision/ARM development tools.                   */
;/* Copyright (c) 2005-2007 Keil Software. All rights reserved.               */
;/* This software may only be used under the terms of a valid, current,       */
;/* end user licence from KEIL for a compatible version of KEIL software      */
;/* development tools. Nothing else gives you the right to use this software. */
;/*****************************************************************************/

; Standard definitions of Mode bits and Interrupt (I & F) flags in PSRs

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F

I_Bit           EQU     0x80            ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40            ; when F bit is set, FIQ is disabled


;// <h> Stack Configuration (Stack Sizes in Bytes)
;//   <o0> Undefined Mode      <0x0-0xFFFFFFFF:8>
;//   <o1> Supervisor Mode     <0x0-0xFFFFFFFF:8>
;//   <o2> Abort Mode          <0x0-0xFFFFFFFF:8>
;//   <o3> Fast Interrupt Mode <0x0-0xFFFFFFFF:8>
;//   <o4> Interrupt Mode      <0x0-0xFFFFFFFF:8>
;//   <o5> User/System Mode    <0x0-0xFFFFFFFF:8>
;// </h>

UND_Stack_Size  EQU     0x00000080
SVC_Stack_Size  EQU     0x00000080
ABT_Stack_Size  EQU     0x00000000
FIQ_Stack_Size  EQU     0x00000000
IRQ_Stack_Size  EQU     0x00000080
USR_Stack_Size  EQU     0x00000400

ISR_Stack_Size  EQU     (UND_Stack_Size + SVC_Stack_Size + ABT_Stack_Size + \
                         FIQ_Stack_Size + IRQ_Stack_Size)

                AREA    STACK, NOINIT, READWRITE, ALIGN=3

Stack_Mem       SPACE   USR_Stack_Size
__initial_sp    SPACE   ISR_Stack_Size

Stack_Top


;// <h> Heap Configuration
;//   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF>
;// </h>

N				EQU		7

mem_space		SPACE	N * 4

Heap_Size       EQU     0x00000100

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3

Heap_Mem        SPACE   Heap_Size




                PRESERVE8
                

; Area Definition and Entry Point
;  Startup Code must be linked first at Address at which it expects to run.

                AREA    RESET, CODE, READONLY
                ARM


; Exception vector table handles every type of exceptions.
;  It is mapped to Address 0.
;  Absolute addressing mode must be used.
;  Dummy Handlers are implemented as infinite loops which can be modified.

Vectors         LDR     PC, Reset_Addr			; reset         
                LDR     PC, Undef_Addr			; undefined instruction
                LDR     PC, SWI_Addr			; software interrupt
                LDR     PC, PAbt_Addr			; prefetch abort
                LDR     PC, DAbt_Addr			; data abort
                NOP                             ; reserved vector 
                LDR     PC, IRQ_Addr			; IRQ
                LDR     PC, FIQ_Addr			; FIQ

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0                      ; Reserved Address 
IRQ_Addr        DCD     IRQ_Handler
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
IRQ_Handler     B       IRQ_Handler
FIQ_Handler     B       FIQ_Handler

;SWI management
SWI_Handler	
				STMFD 	sp!, {r0-r1, r3-r12, lr}
				LDR r0, [lr, #-4]
				BIC 	r1, r0, #0xff000000
				; test the identification code of the interrupt
				CMP 	r1, #0x10
				LDR		R2, =0x7FFFFFFF
				B		end_swi

				CMP 	r1, #0x11
				LDR		R2, =0x80000000

				BNE 	end_swi

				; your action here 

end_swi			LDMFD 	sp!, {r0-r1, r3-r12, pc}^


; Reset Handler
Reset_Handler   


; Initialise Interrupt System
;  ...


; Setup Stack for each mode

                LDR     R0, =Stack_Top

;  Enter Undefined Instruction Mode and set its Stack Pointer
; MSR transfers the value of the immediate to the Program Status Register (CPSR).
; CPSR indicates the state of the machine: it contains condition code flags,
; interrupt enable flags, the current mode, and the current state.
; We change the mode by updating CPSR

                MSR     CPSR_c, #Mode_UND:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #UND_Stack_Size

;  Enter Abort Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #ABT_Stack_Size

;  Enter FIQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #FIQ_Stack_Size

;  Enter IRQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #IRQ_Stack_Size

;  Enter Supervisor Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_SVC:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #SVC_Stack_Size

;  Enter User Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_USR
                MOV     SP, R0
                SUB     SL, SP, #USR_Stack_Size

              

; main program starts here.
; The interrupt service routine with identification code 10h is called
			    ;SWI #0x10
						   
				LDR R4, =literal1
				LDR R5, =literal2
			   	LDR R10, =0
loop
				LDR	R0, [R4, R10]
				LDR	R1, [R5, R10]
				ADDS R2, R0, R1
				MRS R6, CPSR
				AND R6, R6, #0xA0000000	;if there was an overflow and number is negative
				CMP R6, #0xA0000000
				SWIEQ 0x11
				BEQ next
				AND R6, R6, #0x20000000	;if there was an overflow and number is positive
				CMP R6, #0x20000000
				SWIEQ 0x10 
next

				LDREQ R3, =mem_space
				STREQ R2, [R3]

				ADD R10, R10, #4	  ; counter -> PARTE DA 0
				CMP R10, #4*N		  ; 4*N
				BLT loop			  ; fin tanto che R10 < 4*N
stop               
				B stop
				;B Reset_Handler

literal1 DCD 0xFFFFFFFF, 0x7FFFFFFF, 0x10, 0x70000000, 0xFFFFFFE0, 0x800000F0, 0x100EC023
literal2 DCD 0x00000001, 0x00000001,0x200, 0x12345678, 0xE00A1238, 0xF0004538, 0xE9800348

                END