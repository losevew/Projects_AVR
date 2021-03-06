#include <mega8.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Alphanumeric LCD functions
#include <alcd.h>
                  
char hour=0,min=0,sek=0,day=0,month=0,year=0,week_day=0;
bit time_flag=0;
char menu=0;

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
 time_flag=1;    
}
void show_time()
{
          rtc_get_time(&hour,&min,&sek);
          rtc_get_date(&week_day,&day,&month,&year);

          lcd_gotoxy(5,0);
           
          lcd_putchar(hour/10+0x30);
          lcd_putchar(hour%10+0x30);        
          lcd_putchar(':');
          lcd_putchar(min/10+0x30);
          lcd_putchar(min%10+0x30);
          lcd_putchar(':');
          lcd_putchar(sek/10+0x30);
          lcd_putchar(sek%10+0x30);
          
          lcd_gotoxy(5,1);
          lcd_putchar(day/10+0x30);
          lcd_putchar(day%10+0x30);
          lcd_putchar('/');
          lcd_putchar(month/10+0x30);
          lcd_putchar(month%10+0x30);
          lcd_putchar('/');
          lcd_putchar(year/10+0x30);
          lcd_putchar(year%10+0x30);

          time_flag=0;
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
// State7=T State6=T State5=T State4=T State3=P State2=T State1=T State0=T 
PORTD=0x08;
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
rtc_set_time(21,15,0);
rtc_set_date(3,22,10,14);

#asm("sei")

while (1)
      { 

          if((PINC.0==0))
          {  
            // rtc_set_time(hour+1,0,0);
          }                 

          if(time_flag==1)
          {
              show_time();              
          }
          
          
          
          
      };
}
