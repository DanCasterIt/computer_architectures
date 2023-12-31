/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through EINT buttons
 * Note(s):
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2017 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "timer/timer.h"

/* Led external variables from funct_led */
extern uint8_t CurrentLedValue;					/* defined in funct_led								*/

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) {  
 	SystemInit(); // System Initialization (i.e., PLL)
 	LED_init();   // LED Initialization
 	BUTTON_init(); // BUTTON Initialization
 	init_timer (0, 10000000);
	enable_timer (0);
 	LED_Out(0x08); // All leds off at reset time.
 	while (1);  /* Loop forever */
}
