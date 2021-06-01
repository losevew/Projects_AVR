//------------------------------------------------------
/* File:       Library for HD44780 compatible displays  */
/* Version:	   v2.01  						 			*/
//------------------------------------------------------

#include <delay.h>
#include "hd44780.h"

/*!	\brief	Macro-definitions. */
#define BIT(n)						(1u << (n))
#define SET(x,n)           			((x) |= BIT(n))
#define CLR(x,n)  		  			((x) &= ~BIT(n))
#define GET(x,n)   		  			(((x) & BIT(n)) ? 1u : 0u)



#define ENABLE_CYCLE_TIME			1u	/* Minimal value ~ 1us */
#define AC_UPDATE_TIME				1u	/* Minimal value ~ 4us */

#define CMD 0u // command
#define DTA 1u // data

#if (USE_PROGRESS_BAR)
/*!	\brief	Progress bar definitions. */
#define CGROM_PROGRESS_BAR_SIZE		6u
#define FULL_LOAD					5u
#define EMPTY_LOAD					0u
#define EMPTY_ROW					0x00u /* xxx00000 */

static const uint8_t progress_bar[CGROM_PROGRESS_BAR_SIZE] = {0x00u,0x10u,0x18u,0x1Cu,0x1Eu,0x1Fu};
static uint8_t current_bar_pixel;
static uint8_t current_cell_load;
static void lcd_initbar(void);
#endif

/*!	\brief	Low-level functions. */
static void lcd_config(uint8_t param);
static void lcd_write(uint8_t data, uint8_t mode);
static void lcd_10us_delay(volatile uint32_t us);
static uint32_t lcd_pow10(uint8_t n);


/*!	\brief	Creates delay multiples of 10us. */
static void lcd_10us_delay(volatile uint32_t us)
{
	/* Сonversion to us */
	us *= MCU_FREQ_VALUE;
	/* Wait */
	while (us > 0u)
	{
		us--;
	}
}


/*!	\brief	Send data/commands to the display. */
static void lcd_write(uint8_t data, uint8_t mode)
{/* Low level function. */

	uint8_t LCD_data[4];
	
	LCD_data[0]=(data & 0xF0)|(mode<<LCD_RS)|(1<<LCD_E);
    LCD_data[1]=LCD_data[0]&~(1<<LCD_E); 
	LCD_data[2]=(data<<4)|(mode<<LCD_RS)|(1<<LCD_E); 
    LCD_data[3]=LCD_data[02]&~(1<<LCD_E);; 
    twi_master_trans(I2C_ADR_PCF8574,LCD_data,4,0,0);
	

	lcd_10us_delay(BUSY_CYCLE_TIME);
}

/*!	\brief	Initializing by instruction. 4-bit interface initialization. */
static void lcd_config(uint8_t param)
{/* Low level function. */
	uint8_t LCD_data[2];

	/* Send commands to LCD. */
	
	LCD_data[0]=(param & 0xF0)|(CMD<<LCD_RS)|(1<<LCD_E);// Change 8-bit interface to 4-bit interface
    LCD_data[1]=LCD_data[0] &~(1<<LCD_E);
	twi_master_trans(I2C_ADR_PCF8574,LCD_data,2,0,0);
	
	lcd_10us_delay(BUSY_CYCLE_TIME);
	
		
	LCD_data[0]=(param & 0xF0)|(CMD<<LCD_RS)|(1<<LCD_E);/* DB7 to DB4 of the "Function set" instruction is written twice. */
    LCD_data[1]=LCD_data[0] &~(1<<LCD_E); 
	twi_master_trans(I2C_ADR_PCF8574,LCD_data,2,0,0);
	
	lcd_10us_delay(BUSY_CYCLE_TIME);
	
	
	LCD_data[0]=(param<<4)|(CMD<<LCD_RS)|(1<<LCD_E); // 4-bit, two lines, 5x8 pixel
    LCD_data[1]=LCD_data[0] &~(1<<LCD_E);; 
    twi_master_trans(I2C_ADR_PCF8574,LCD_data,2,0,0);
	
	lcd_10us_delay(BUSY_CYCLE_TIME);
	/* Note: The number of display lines and character font cannot be changed after this point. */
}

							//-----------------------------//
							/*         LCDlib API          */
							//-----------------------------//

/*!	\details	Clear display writes space code 20H into all DDRAM addresses.
 * 				It then sets DDRAM address 0 into the address counter,
 * 				and returns the display to its original status if it was shifted.
 * 				In other words, the display disappears and the cursor
 * 				or blinking goes to the left edge of the display (in the first line if 2 lines are displayed).
 * 				It also sets I/D to 1 (increment mode) in entry mode (S of entry mode does not change). */
void lcd_clrscr(void)
{

	/* Clear screen */
	lcd_write(0x01u, CMD);
	lcd_10us_delay(CLRSCR_CYCLE_TIME);

}

/*!	\details	"Return home" sets DDRAM address 0 into the address counter,
 * 				and returns the display to its original status if it was shifted.
 * 				The DDRAM contents do not change.
 * 				The cursor or blinking go to the left edge of the display
 * 				(in the first line if 2 lines are displayed). */
void lcd_return(void)
{
	/* Return home */
	lcd_write(0x02u, CMD);
	/* Busy delay */
	lcd_10us_delay(RETHOME_CYCLE_TIME);

}

/*!	\details	lcd_scroll shifts the display to the right or left without writing or reading display data.
 * 				This function is used to correct or search the display.
 *	\note		The first and second line displays will shift at the same time. */
void lcd_scroll(uint8_t direction)
{

	/* Scroll display */
	switch (direction)
	{
	/* To left */
		case LEFT  :
			lcd_write(0x18u,CMD);
			break;

		/* To right */
		case RIGHT :
			lcd_write(0x1Cu, CMD);
			break;

		default:
			/* Ignore this command */
			break;
	}
}

/*!	\details	"Cursor shift" shifts the cursor position to the right or left,
 * 				without writing or reading display data.
 * 				This function is used to correct or search the display.
 * 				In a 2-line display, the cursor moves to the second line
 * 				when it passes the 40th digit of the first line. */
void cursor_shift(uint8_t direction)
{

	/* Shift cursor */
	switch (direction)
	{
		/* To left */
		case LEFT  :
			lcd_write(0x10u, CMD);
			break;

		/* To right */
		case RIGHT :
			lcd_write(0x14u, CMD);
			break;

		default:
			/* Ignore this command */
			break;
	}
}

/*!	\details	Go to the specified (DDRAM/CGRAM) memory address.*/
void lcd_goto(uint8_t line, uint8_t address)
{
	/* Set DDRAM/CGRAM address. */
	switch (line)
	{
		/* Set DDRAM address. */
		case LCD_1st_LINE: lcd_write(0x80u | START_ADDRESS_1st_LINE | address, CMD); break;
		case LCD_2nd_LINE: lcd_write(0x80u | START_ADDRESS_2nd_LINE | address, CMD); break;
		case LCD_3rd_LINE: lcd_write(0x80u | START_ADDRESS_3rd_LINE | address, CMD); break;
		case LCD_4th_LINE: lcd_write(0x80u | START_ADDRESS_4th_LINE | address, CMD); break;
		/* Set CGRAM address. */
		case CGRAM : lcd_write(0x40u | address, CMD); break;

		default:
			/* Ignore this command */
			break;
	}
}

/*!	\details	Change LCD settings. */
void lcd_setmode(uint8_t param)
{
	/* Send a command to LCD. */
	lcd_write(param, CMD);
}

/*!	\details	Write a single char to the current memory space (DDRAM/CGRAM). */
void lcd_putc(uint8_t data)
{
	/* Send data to LCD. */
	lcd_write(data, DTA);
	/* Note:
	 * After execution of the CGRAM/DDRAM data write/read instruction, the RAM address counter is incremented
	 * or decremented by 1. The RAM address counter is updated after the busy flag turns off.
	 * tADD is the time elapsed after the busy flag turns off until the address counter is updated. */
	lcd_10us_delay(AC_UPDATE_TIME);	/* Update RAM address counter delay. */
}

/*!	\details	Writes ANSI-C string to LCD (DDRAM memory space). */
void lcd_puts(const uint8_t *str)
{
	/* Send a ANSI-C string to LCD. */
	while ('\0' != *str)
	{
#if ( USE_FORMATTED_OUTPUT )
		if(('\n' == *str))
		{/*New line */
			lcd_goto(LCD_2nd_LINE, 0u);
		}
		else if(('\r' == *str))
		{/* Return home */
			lcd_return();
		}
		else if(('\t' == *str))
		{/* Tab space */
			uint8_t i;

			for(i=0u; i<TAB_SPACE; i++)
			{/* Shift cursor to the right. */
				cursor_shift(RIGHT);
			}
		}
		else
#endif
		{
			/* Display a symbol. */
			lcd_putc(*str);
		}
		/* Get the next symbol. */
		str++;
	}
}

/*!	\details	Load the user-defined symbol into the CGRAM memory. */
void lcd_loadchar(uint8_t* vector, uint8_t position)
{
	uint8_t i;
	/* Go to the CGRAM memory space: 0 to 7 */
	lcd_goto(CGRAM, (position * FONT_HEIGHT));

	for(i = 0u; i < FONT_HEIGHT; i++)
	{/* Load one row of pixels into the CGRAM register. */
		lcd_putc(vector[i]);
	}

	/* Return to the DDRAM memory space. */
	lcd_goto(LCD_1st_LINE, 0u);
}

/*!	\details	Load and display the user-defined symbol. */
void lcd_drawchar( uint8_t* vector,
			   	   uint8_t position,
			   	   uint8_t line,
			   	   uint8_t address )
{
	/* Load the user-defined symbol into the CGRAM memory. */
	lcd_loadchar(vector, position);
	/* Select LCD position. */
	lcd_goto(line, address);
	/* Display the user-defined symbol. */
	lcd_putc(position);
}

/*!	\details	Erase a symbol from the left of the cursor. */
void lcd_backspace(void)
{
	cursor_shift(LEFT);		// Сдвигаем курсор на одну позицию влево
	lcd_putc(' ');			// Очищаем, после чего происходит автоинкремент вправо
	cursor_shift(LEFT);		// Сдвигаем курсор на одну позицию влево
}

/*!	\brief	Returns 10^n value. */
static uint32_t lcd_pow10(uint8_t n)
{
	uint32_t retval = 1u;

	while (n > 0u)
	{
		retval *= 10u;
		n--;
	}

	return retval;
}

/*!	\brief	Display a integer number: +/- 2147483647. */
void lcd_itos(int32_t value)
{
	int32_t i;

	if (value < 0)
	{
		lcd_putc('-');
		value = -value;
	}

	i = 1;
	while ((value / i) > 9)
	{
		i *= 10;
	}

	lcd_putc(value/i + '0');	/* Display at least one symbol */
	i /= 10;

	while (i > 0)
	{
		lcd_putc('0' + ((value % (i*10)) / i));
		i /= 10;
	}
}

/*!	\brief	Display a floating point number. */
void lcd_ftos(float value, uint8_t n)
{
	if (value < 0.0)
	{
		lcd_putc('-');
		value = -value;
	}

	lcd_itos((int32_t)value); // Вывод целой части

	if (n > 0u)
	{
		lcd_putc('.'); // Точка

		lcd_ntos((uint32_t)(value * (float)lcd_pow10(n)), n); // Вывод дробной части
	}
}

/*!	\brief	Display "n" right digits of "value". */
void lcd_ntos(uint32_t value, uint8_t n)
{
	if (n > 0u)
	{
		uint32_t i = lcd_pow10(n - 1u);

		while (i > 0u)	/* Display at least one symbol */
		{
			lcd_putc('0' + ((value/i) % 10u));

			i /= 10u;
		}
	}
}

#if ( USE_PROGRESS_BAR )
/*!	\brief	Initialize the progress bar
 * 			(i.e. preload elements of the progress bar into CGRAM and reset all variables). */
static void lcd_initbar(void)
{
	uint8_t i, j;

	for (i = 0u; i < CGROM_PROGRESS_BAR_SIZE; i++)
	{
		lcd_goto(CGRAM, (i * FONT_HEIGHT));

		for (j = 0u; j < FONT_HEIGHT; j++)
		{
			if (j < PROGRESS_BAR_HEIGHT)
			{
				lcd_putc(progress_bar[i]);
			}
			else
			{/* Load an empty row of pixels in CGRAM. */
				lcd_putc(EMPTY_ROW);
			}
		}
	}

	/* Clear the entire bar and initialize all variables. */
	lcd_clrbar();
}

/*!	\brief	Draw progress bar. */
void lcd_drawbar(uint8_t next_bar_pixel)
{
	/* Go to the current cell position in the progress bar. */
	lcd_goto(PROGRESS_BAR_LINE, (current_bar_pixel / FONT_WIDTH));

	if (next_bar_pixel > current_bar_pixel)
	{
		/* Increment LCD cursor */
		lcd_setmode(ENTRY_MODE_INC_NO_SHIFT);

		/* Prevent the progress bar overflow */
		if (next_bar_pixel > PROGRESS_BAR_MAX_LOAD)
		{
			next_bar_pixel = PROGRESS_BAR_MAX_LOAD;
		}

		while (current_bar_pixel != next_bar_pixel)
		{
			/* Go to the next pixel. */
			current_bar_pixel++;
			current_cell_load++;
			/* Display the load of the current cell. */
			lcd_putc(current_cell_load);

			if (current_cell_load < FULL_LOAD)
			{/* Return the cursor to the current cell. */
				cursor_shift(LEFT);
			}
			else
			{/* Go to the next cell. */
				current_cell_load = EMPTY_LOAD;
			}
		}
	 }
#if (USE_REGRESS_BAR)
	 else if (next_bar_pixel < current_bar_pixel)
	 {
		 /* Decrement LCD cursor */
		lcd_setmode(ENTRY_MODE_DEC_NO_SHIFT);

		do
		{
			if (EMPTY_LOAD == current_cell_load)
			{/* Go to the next cell. */
				cursor_shift(LEFT);
				current_cell_load = FULL_LOAD;
			}
			/* Go to the next pixel. */
			current_bar_pixel--;
			current_cell_load--;
			/* Display the load of the current cell. */
			lcd_putc(current_cell_load);
			/* Return the cursor to the current cell. */
			cursor_shift(RIGHT);
		}
		while (current_bar_pixel != next_bar_pixel);
	 }
#endif /* USE_REGRESS_BAR */
	 else
	 {
		 /* Nothing to do. */
	 }

	/* Restore the default entry mode. */
	lcd_setmode(DEFAULT_ENTRY_MODE);
	/* Return home. */
	lcd_goto(LCD_1st_LINE, 0u);
}

/*!	\brief	Clear the entire progress bar. */
void lcd_clrbar(void)
{
	uint8_t i;
	/* Go to the last cell in the progress bar. */
	lcd_goto(PROGRESS_BAR_LINE, (PROGRESS_BAR_WIDTH - 1u));
	/* Set the decrement mode. */
	lcd_setmode(ENTRY_MODE_DEC_NO_SHIFT);

	for(i = 0u; i < PROGRESS_BAR_WIDTH; i++)
	{/* Display the "empty cell" symbol (i.e. clear the LCD cell). */
		lcd_putc(EMPTY_LOAD);
	}

	/* Reset the progress bar variables. */
	current_bar_pixel = 0u;
	current_cell_load = EMPTY_LOAD;

	/* Restore the default entry mode. */
	lcd_setmode(DEFAULT_ENTRY_MODE);
	/* Return home. */
	lcd_goto(LCD_1st_LINE, 0u);
}
#endif

/*!	\brief	Initialize the LCD.
 * 	\note	This library use the 4-bit interface. */
void lcd_init(void)
{
	/* LCD initialization. */
	lcd_config(DEFAULT_DISPLAY_CONFIG);
	lcd_setmode(DEFAULT_VIEW_MODE);
	lcd_setmode(DEFAULT_ENTRY_MODE);
	lcd_clrscr();
	lcd_return();
#if (USE_PROGRESS_BAR)
	lcd_initbar();
#endif
}

//-------------------------------
/* END OF FILE */
//-------------------------------
