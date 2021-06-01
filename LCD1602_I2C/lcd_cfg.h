//------------------------------------------------------
/* File:       Library for HD44780 compatible displays  */
/* Version:	   v2.01  						 			*/
//------------------------------------------------------


#ifndef LCD_CFG_H
#define LCD_CFG_H

/* Include here the header file of your microcontroller */
//#include "stm32f10x.h"
//#include <avr/io.h>
#include <twi.h>

//-------------------------------
/* SET LCD<->MCU CONNECTIONS */
//-------------------------------
/* E - Starts data read/write. */

// LCD HD44780
#define LCD_RS  0
#define LCD_RW  1
#define LCD_E   2
#define LCD_BL  3
#define LCD_D4  4
#define LCD_D5  5
#define LCD_D6  6
#define LCD_D7  7

#define I2C_ADR_PCF8574 0x27

//-------------------------------
// DEFAULT CONFIGURATIONS
//------------------------------- 
#define DEFAULT_DISPLAY_CONFIG		DISPLAY_CONFIG_4bit_2L_5x8
#define DEFAULT_ENTRY_MODE			ENTRY_MODE_INC_NO_SHIFT
#define DEFAULT_VIEW_MODE			VIEW_MODE_DispOn_BlkOff_CrsOff

//-------------------------------
// SET MCU TIMINGS
//-------------------------------
#define MCU_FREQ_VALUE				8u		/* MHz. Minimal value = 1 MHz */
#define BUSY_CYCLE_TIME				5u		/* x 10us. See datasheet for minimal value. */
#define CLRSCR_CYCLE_TIME			200u	/* x 10us. See datasheet for minimal value. */
#define RETHOME_CYCLE_TIME			200u	/* x 10us. See datasheet for minimal value. */


//-------------------------------
// SET FORMATTED OUTPUT OPTIONS
//-------------------------------
#define USE_FORMATTED_OUTPUT	 	1u	/* 1 (true) or 0 (false) */
#define TAB_SPACE					4u	/* 1 .. 255 */

//-------------------------------
// PROGRESS BAR OPTIONS
//-------------------------------
#define USE_PROGRESS_BAR			1u	/* 1 (true) or 0 (false) */
#define USE_REGRESS_BAR				1u	/* 1 (true) or 0 (false) */
#define PROGRESS_BAR_LINE			LCD_2nd_LINE	/* Select lcd line: 1, 2, 3, 4, ... */
#define PROGRESS_BAR_HEIGHT			3u  /* in pixel: 1(min), 2, 3, 4, 5, 6, 7, 8(max) */
#define PROGRESS_BAR_WIDTH			10u /* Number of chars in lcd line:  1, 2, .. , 8, 16, 20 */



#endif /* LCD_CFG_H */

//-------------------------------
/* THE END */
//-------------------------------
