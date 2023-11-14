;/*****************************************************************************
; * @file:    startup_LPC17xx.s
; * @purpose: CMSIS Cortex-M3 Core Device Startup File 
; *           for the NXP LPC17xx Device Series 
; * @version: V1.01
; * @date:    21. December 2009
; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------
; *
; * Copyright (C) 2009 ARM Limited. All rights reserved.
; * ARM Limited (ARM) is supplying this software for use with Cortex-M3 
; * processor based microcontrollers.  This file can be freely distributed 
; * within development tools that are supporting such ARM based processors. 
; *
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; *****************************************************************************/


; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
				DCD		USBActivity_IRQHandler    ; USB Activity interrupt to wakeup
				DCD		CANActivity_IRQHandler    ; CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
;Problem_6_2017-3---------------------------------------------------------
	;AREA myCode, READONLY, CODE
	;ENTRY
	MOV R0, #0
	MOV R1, #0
	MOV R9, #4
	MOV R10, #0	 
	MOV R11, #0
	MOV R12, #0	 
LOOP1A
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
	BLT LOOP1A			  ; fin tanto che R10 < 32

	CMP R11, #0
	BNE next1A
	CMP R12, #0
	BEQ	next2A 
	; R11 = 0, R12 = 1 -> CRESCENTE -> VALORE MEDIO
	MOV R0, #0
	MOV R1, #0
	MOV R10, #0	
LOOP2A
	LDR R13, =SEQUENCE
	LDR R0, [R13,R10]
	ADD R1, R1, R0
	ADD R10, R10, #4	  ; counter
	CMP R10, #32		  ; 4*8 = 32
	BLT LOOP2A			  ; fin tanto che R10 <  32
	MOV R1, R1, LSR #3	  ; R1 = R1/8
	B pend
next1A
	CMP R12, #0
	BEQ	next2A
	; R11 = 1, R12 = 1  -> DISORDINATA -> VALORE PIù GRAMDE E PIù PICCOLO
	MOV R0, #0
	MOV R1, #0
	MOV R2, #8
	MOV R10, #0	
LOOP3A
	LDR R13, =SEQUENCE
	LDR R0, [R13,R10]
	CMP	R0, R1
	MOVGT R1, R0		  ; se R0 > R1 
	CMP	R0, R2
	MOVLT R2, R0		  ; se R0 < R2
	ADD R10, R10, #4	  ; counter
	CMP R10, #32		  ; 4*8 = 32
	BLT LOOP3A			  ; fin tanto che R10 <  32
	B pend
next2A
	; R11 = 1, R12 = 0 -> DECRESCENTE -> LA DIFFERENZA PIù GRANDE
	MOV R0, #0
	MOV R1, #0	
	MOV R2, #0
	MOV R9, #4
	MOV R10, #0	 
	MOV R11, #0
	MOV R12, #0
LOOP4A
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
	BLT LOOP4A			  ; fin tanto che R10 < 28
pend
;Problem_6_2017-2---------------------------------------------------------
;	AREA myCode, READONLY, CODE
;	ENTRY
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
LOOP1B
	SUB R8, R8, R0
	ADD R4, R4, #1
	CMP R8, #0 
	BGT LOOP1B ; R8 > R0 (R1- R2)
	BEQ NEXT1B
	MOV R4, #0
NEXT1B
		  		   
	MOV R5, #0	
	MOV R8, R2
LOOP2B 
	SUB R8, R8, R0 
	ADD R5, R5, #1
	CMP R8, #0
	BGT LOOP2B ; R8 > R0 (R1- R2)  
	BEQ NEXT2B
	MOV R5, #0
NEXT2B
;Problem_6_2017-1---------------------------------------------------------
	;AREA myCode, READONLY, CODE
	;ENTRY
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
	
do_notthing
	B do_notthing

;SEQUENCE DCD 6, 9, 5, 3, 1, 2, 0, 8
;SEQUENCE DCD 1, 2, 3, 4, 5, 6, 7, 8
SEQUENCE DCD 8, 7, 6, 5, 4, 3, 2, 1
	
                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)                

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
				EXPORT  USBActivity_IRQHandler    [WEAK]
				EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler           
TIMER0_IRQHandler         
TIMER1_IRQHandler         
TIMER2_IRQHandler         
TIMER3_IRQHandler         
UART0_IRQHandler          
UART1_IRQHandler          
UART2_IRQHandler          
UART3_IRQHandler          
PWM1_IRQHandler           
I2C0_IRQHandler           
I2C1_IRQHandler           
I2C2_IRQHandler           
SPI_IRQHandler            
SSP0_IRQHandler           
SSP1_IRQHandler           
PLL0_IRQHandler           
RTC_IRQHandler            
EINT0_IRQHandler          
EINT1_IRQHandler          
EINT2_IRQHandler          
EINT3_IRQHandler          
ADC_IRQHandler            
BOD_IRQHandler            
USB_IRQHandler            
CAN_IRQHandler            
DMA_IRQHandler          
I2S_IRQHandler            
ENET_IRQHandler       
RIT_IRQHandler          
MCPWM_IRQHandler             
QEI_IRQHandler            
PLL1_IRQHandler           
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB
                
                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit
                
                ELSE
                
                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
	end