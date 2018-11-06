/**************************************************************************************
* TM1638.c
*
* TM1638 LED controller with key-scan interface driver for Atmel AVR
* micro controllers.
*
*   Copyright (C) 2015 Michael Williamson. All rights reserved.
*   Authors: Michael Williamson <mikesmodz@gmail.com>
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in
*    the documentation and/or other materials provided with the
*    distribution.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
* COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
* OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
* AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
* ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*
****************************************************************************/
#ifndef __TM1638_H__
#define __TM1638_H__

/****************************************************************************
* Included Files
****************************************************************************/
#include <mega8.h>

/****************************************************************************
 * Pre-processor Definitions
****************************************************************************/

#define TM1638_PORT	PORTC
#define TM1638_DIR	DDRC
#define TM1638_PINS	PINC

/* Definitions for clock pin */

#define TM1638_CLOCK_PIN	0
#define TM1638_CLOCK_HIGH	TM1638_PORT |= 1 << TM1638_CLOCK_PIN;
#define TM1638_CLOCK_LOW	TM1638_PORT &= ~(1 << TM1638_CLOCK_PIN);

/* Definitions for strobe pin */
#define TM1638_STROBE_PIN	1
#define TM1638_STROBE_HIGH	TM1638_PORT |= 1 << TM1638_STROBE_PIN;
#define TM1638_STROBE_LOW	TM1638_PORT &= ~(1 << TM1638_STROBE_PIN);

/* Definitions for data pin */

#define TM1638_DATA_PIN		2
#define TM1638_DATA_HIGH	TM1638_PORT |= 1 << TM1638_DATA_PIN;
#define TM1638_DATA_LOW		TM1638_PORT &= ~(1 << TM1638_DATA_PIN);

/* Definitions for TM1638 commands */
#define TM1638_ADDR_INSTRUCTION_SET		0xC0
#define TM1638_DATA_WRITE_AUTO_ADDR		0x40
#define TM1638_DATA_WRITE_FIX_ADDR		0x44
#define TM1638_READ_KEY_SCAN_MODE		0x42
#define TM1638_DISPLAY_CONTROL_SET		0x80	

/****************************************************************************
* Public Function Prototypes
****************************************************************************/
void TM1638_Init(const unsigned char intensity);
void TM1638_ClearDigits(void);
void TM1638_SetLED(const unsigned char pos, const unsigned char colour);
void TM1638_SetDigit(const unsigned char pos, const unsigned char segments, unsigned char dot);
unsigned char TM1638_GetKeys(void);
void TM1638_SetDisplayDigit(const unsigned char digit, const unsigned char pos, unsigned char dot);
void TM1638_ClearDisplayDigit(const unsigned char pos, unsigned char dot);
void TM1638_SendData(const unsigned char adr, const unsigned char data);

#endif /* __TM1638_H__ */
