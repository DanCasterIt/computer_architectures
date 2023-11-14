#include "button.h"
#include "lpc17xx.h"
#include "../led/led.h"
#include <stdint.h>

/* Led external variables from funct_led */
extern uint8_t CurrentLedValue;					/* defined in funct_led								*/
extern uint8_t SavedLedValue;					/* defined in funct_led								*/

void EINT0_IRQHandler (void)	{
	LPC_SC->EXTINT |= (1 << 0);     /* clear pending interrupt         */
	// If INT0 pressed, move to reset LED configuration.
	SavedLedValue = 0x08;
	LED_Out(0x08);
}

void EINT1_IRQHandler (void)	{ 
	LPC_SC->EXTINT |= (1 << 1);     /* clear pending interrupt */
	// If KEY1 pressed, switch off current led and turn on the next one on the left
	if (CurrentLedValue == 0)	CurrentLedValue = SavedLedValue;
	if (CurrentLedValue == 0x80)	CurrentLedValue = 0x1;
	else	CurrentLedValue = CurrentLedValue << 1;
	LED_Out(CurrentLedValue);
	SavedLedValue = CurrentLedValue;
}

void EINT2_IRQHandler (void)	{ 
	LPC_SC->EXTINT |= (1 << 2);     /* clear pending interrupt         */
	// If KEY1 pressed, switch off current led and turn on the next one on the right
	if (CurrentLedValue == 0)	CurrentLedValue = SavedLedValue;
	if (CurrentLedValue == 0x1)	CurrentLedValue = 0x80;
	else	CurrentLedValue = CurrentLedValue >> 1;
	LED_Out(CurrentLedValue);
	SavedLedValue = CurrentLedValue;
}
