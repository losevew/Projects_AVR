/**************************************************************************************
* tm1638.c
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

/****************************************************************************
* Included Files
****************************************************************************/
#include <mega8.h>

#include <delay.h>
#include "tm1638.h"
#include "tm1638_fonts.h"

/****************************************************************************
* Private Function Prototypes
****************************************************************************/
static void TM1638_SendCommand(const unsigned char cmd);
//static void TM1638_SendData(const unsigned char adr, const unsigned char data);
static void TM1638_SendByte(unsigned char data);
static unsigned char TM1638_ReceiveByte(void);

/****************************************************************************
* Private Functions
****************************************************************************/

//*****************************************************************************
// Function:     TM1638_SendCommand
// Called with:  cmd = command to send.
// Returns:      Nothing.
// Purpose:      Sends a command to the TM1638.
//*****************************************************************************
static void TM1638_SendCommand(const unsigned char cmd)
{
	TM1638_STROBE_LOW;
	TM1638_SendByte(cmd);
	TM1638_STROBE_HIGH;
}

//*****************************************************************************
// Function:     TM1638_SendData
// Called with:  adr = register address.
//				 data = data to write.
// Returns:      Nothing.
// Purpose:      Sends a data to the TM1638.
//*****************************************************************************
void TM1638_SendData(const unsigned char adr, const unsigned char data)
{
	TM1638_SendCommand(TM1638_DATA_WRITE_FIX_ADDR);
	TM1638_STROBE_LOW;
	TM1638_SendByte(TM1638_ADDR_INSTRUCTION_SET|(adr&0x0F));
	TM1638_SendByte(data);
	TM1638_STROBE_HIGH;
}

//*****************************************************************************
// Function:     TM1638_SendByte
// Called with:  data = data to write.
// Returns:      Nothing.
// Purpose:      Sends a byte to the TM1638.
//*****************************************************************************
static void TM1638_SendByte(unsigned char data)
{
	unsigned char i = 0;
	for (i=0; i<8; i++)
	{
		TM1638_CLOCK_LOW;
		if (data & 0x01)
		{
			TM1638_DATA_HIGH;
		}
		else
		{
			TM1638_DATA_LOW;
		}
		data >>= 1;
		TM1638_CLOCK_HIGH;	
	}
}

//*****************************************************************************
// Function:     TM1638_ReceiveByte
// Called with:  Nothing.
// Returns:      Byte received.
// Purpose:      Reads a byte of data from the TM1638.
//*****************************************************************************
static unsigned char TM1638_ReceiveByte(void)
{
	unsigned char res = 0;
	unsigned char i = 0;
		
	/* Change data pin to input */
	TM1638_DIR	&= ~(1 << TM1638_DATA_PIN);
	
	for (i=0; i<8; i++)
	{
		TM1638_CLOCK_LOW;
		if (TM1638_PINS & (1 << TM1638_DATA_PIN)) res |= 0x80;
		TM1638_CLOCK_HIGH;
		res >>= 1;
	}
	
	/* Change data pin back to output */
	TM1638_DIR	|= 1 << TM1638_DATA_PIN;
	
	/* Return result */
	return res;
}

/****************************************************************************
* Public Functions
****************************************************************************/

//*****************************************************************************
// Function:     TM1638_Init
// Called with:  intensity = display intensity 0-7.
// Returns:      Nothing.
// Purpose:      Initialises the hardware used by the TM1638.
//*****************************************************************************
void TM1638_Init(const unsigned char intensity)
{
	unsigned char i = 0;
	
	/* Initialise clock pin as output */
	TM1638_DIR|= 1 << TM1638_CLOCK_PIN;
	
	/* Initialise strobe pin as output */
	TM1638_DIR|= 1 << TM1638_STROBE_PIN;
	
	/* Initialise data pin as output */
	TM1638_DIR	|= 1 << TM1638_DATA_PIN;
	
	/* Initialise the display */
	TM1638_SendCommand(TM1638_DATA_WRITE_AUTO_ADDR);
	TM1638_SendCommand(TM1638_DISPLAY_CONTROL_SET|0x08|(intensity&0x07));
	
	/* Set strobe low */
	TM1638_STROBE_LOW;
	
	/* Send first register address */
	TM1638_SendByte(TM1638_ADDR_INSTRUCTION_SET);
	
	/* Clear all of the registers */
	for (i=0; i<16; i++)
	{
		TM1638_SendByte(0x00);
	}
	
	/* Set strobe high */
	TM1638_STROBE_HIGH;
}

//*****************************************************************************
// Function:     TM1638_ClearDigits
// Called with:  Nothing.
// Returns:      Nothing.
// Purpose:      Clears all of the digits.
//*****************************************************************************
void TM1638_ClearDigits(void)
{
	unsigned char i = 0;
	for (i=0; i<8; i++)
	{	
		TM1638_SendData(i<<1, 0x00);
	}
}

//*****************************************************************************
// Function:     TM1638_SetLED
// Called with:  pos = LED position 0-7.
//				 colour = LED colour 0x00 (off), 0x01 (red) or 
//				 0x02 (green).
// Returns:      Nothing.
// Purpose:      Sets an LED state.
//*****************************************************************************
void TM1638_SetLED(const unsigned char pos, const unsigned char colour)
{
	TM1638_SendData(((pos&0x07)<<1)+1, colour);
}

//*****************************************************************************
// Function:     TM1638_SetDigit
// Called with:  pos = digit position 0-7.
//				 segments = segment data.
//				 dot = include dot segment.
// Returns:      Nothing.
// Purpose:      Sets a digits segments.
//*****************************************************************************
void TM1638_SetDigit(const unsigned char pos, const unsigned char segments, unsigned char dot)
{
	TM1638_SendData((pos&0x07)<<1, segments|(dot?0x80:0));
}

//*****************************************************************************
// Function:     TM1638_SetDisplayDigit
// Called with:  digit = value to display 0x00-0x0F.
//				 pos = digit position 0-7.
//				 dot = include dot segment.
// Returns:      Nothing.
// Purpose:      Sets a digits segments.
//*****************************************************************************
void TM1638_SetDisplayDigit(const unsigned char digit, const unsigned char pos, unsigned char dot)
{
	TM1638_SetDigit(pos, NUMBER_FONT[digit & 0x0F], dot);
}

//*****************************************************************************
// Function:     TM1638_ClearDisplayDigit
// Called with:  pos = digit position 0-7.
//				 dot = include dot segment.
// Returns:      Nothing.
// Purpose:      Sets a digits segments.
//*****************************************************************************
void TM1638_ClearDisplayDigit(const unsigned char pos, unsigned char dot)
{
	TM1638_SetDigit(pos, 0, dot);
}

//*****************************************************************************
// Function:     TM1638_GetKeys
// Called with:  Nothing.
// Returns:      Key states.
// Purpose:      Reads all of the button states.
//*****************************************************************************
unsigned char TM1638_GetKeys(void)
{
	unsigned char i = 0;
	unsigned char res = 0;
	unsigned char keys = 0;
	
	/* Set strobe low */
	TM1638_STROBE_LOW;
	
	/* Send read scan keys command */
	TM1638_SendByte(TM1638_READ_KEY_SCAN_MODE);
	
	/* Read four bytes containing the key states */
	for (i=0; i<4; i++)
	{
		/* Get key states byte */
		res = TM1638_ReceiveByte();
		
		/* All keys are on key scan data input K3 which are bits 
		   B0 and B4 of the result. See data sheet page 4.
		   Read these bits and ignore the rest. */ 
		if (res&0x01) keys |= (0x01<<i);
		if (res&0x10) keys |= (0x01<<(i+4));
	}
	
	/* Set strobe high */
	TM1638_STROBE_HIGH;
	
	/* Return key states */
	return keys;
}
