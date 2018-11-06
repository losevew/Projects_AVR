/**************************************************************************************
* tm1638_fonts.h
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
#ifndef __TM1638_FONTS_H__
#define __TM1638_FONTS_H__

/****************************************************************************
* Included Files
****************************************************************************/


const unsigned char LOWER_LEFT_BAR = 0x10;
const unsigned char UPPER_LEFT_BAR = 0x20;
const unsigned char LOWER_RIGHT_BAR = 0x04;
const unsigned char UPPER_RIGHT_BAR = 0x02;
const unsigned char LOWER_BAR = 0x08;
const unsigned char UPPER_BAR = 0x01;

/* Definition for standard hexadecimal numbers */
const unsigned char NUMBER_FONT[] = {
	0x3F,								//0
	0x06,								//1
	0x5B,								//2
	0x4F,								//3
	0x66,								//4
	0x6D,								//5
	0x7D,								//6
	0x07,								//7
	0x7F,								//8
	0x6F,								//9
	0x77,								//A
	0x7C,								//B
	0x39,								//C
	0x5E,								//D
	0x79,								//E
	0x71								//F
};

#endif /* __TM1638_FONTS_H__ */
