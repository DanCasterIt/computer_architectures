/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "timer.h"
#include "../led/led.h"
#include <stdint.h>

uint8_t SavedLedValue = 0;
extern uint8_t CurrentLedValue;

/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

void TIMER0_IRQHandler (void)	{
 	LPC_TIM0->IR = 1;			/* clear interrupt flag */
	if (CurrentLedValue != 0) {
		SavedLedValue = CurrentLedValue;
		LED_Out (0);
	}
 	else	LED_Out (SavedLedValue);
	disable_timer(0);
	reset_timer(0);										//reset timer and restart
	enable_timer(0);
 	return;
}

/******************************************************************************
** Function name:		Timer1_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER1_IRQHandler (void)	{
 	LPC_TIM1->IR = 1;			/* clear interrupt flag */
 	return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
