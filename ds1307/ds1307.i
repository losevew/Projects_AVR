
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

#pragma used+

unsigned char rtc_read(unsigned char address);
void rtc_write(unsigned char address,unsigned char data);
void rtc_init(unsigned char rs,unsigned char sqwe,unsigned char out);
void rtc_get_time(unsigned char *hour,unsigned char *min,unsigned char *sec);
void rtc_set_time(unsigned char hour,unsigned char min,unsigned char sec);
void rtc_get_date(unsigned char *week_day, unsigned char *day,unsigned char *month,unsigned char *year);
void rtc_set_date(unsigned char week_day, unsigned char day,unsigned char month,unsigned char year);

#pragma used-

#pragma library ds1307.lib

void _lcd_write_data(unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_write_byte(unsigned char addr, unsigned char data);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

void lcd_putse(char eeprom *str);

void lcd_init(unsigned char lcd_columns);

#pragma library alcd.lib

char hour=0,min=0,sek=0,day=0,month=0,year=0,week_day=0;
bit time_flag=0;
char menu=0;

interrupt [3] void ext_int1_isr(void)
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

PORTC=0x0F;
DDRC=0x00;

PORTD=0x08;
DDRD=0x00;

i2c_init();

rtc_init(0,1,0);

GICR|=0x80;
MCUCR=0x00;
GIFR=0x80;

lcd_init(16);
rtc_set_time(21,15,0);
rtc_set_date(3,22,10,14);

#asm("sei")

while (1)
{ 

if((PINC.0==0))
{  

}                 

if(time_flag==1)
{
show_time();              
}

};
}
