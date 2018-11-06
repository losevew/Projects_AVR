#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include <stdio.h>
#include <delay.h>
// I2C Bus functions
#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
#include <lcd.h>

char lcd_buf[33];

char hour,min,sek;

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
      rtc_get_time(&hour,&min,&sek);

      lcd_clear();
      lcd_gotoxy(0,0);
          sprintf(lcd_buf,"%02d:%02d:%02d\n",hour,min,sek);
          lcd_puts(lcd_buf);

}

void main(void)
{


// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=T State5=T State4=T State3=P State2=P State1=P State0=P
PORTC=0x0F;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// I2C Bus initialization
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: On
// Square wave frequency: 1Hz
rtc_init(0,1,0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Low level
GICR|=0x80;
MCUCR=0x00;
GIFR=0x80;

// LCD module initialization
lcd_init(16);
rtc_set_time(0,0,0);

while (1)
      {

          if((PINC.0==0))
          {
          rtc_set_time(hour+1,0,0);
          }
      };
}
