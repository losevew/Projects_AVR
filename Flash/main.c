/*******************************************************
This program was created by the
CodeWizardAVR V3.22 Evaluation
Automatic Program Generator
� Copyright 1998-2015 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 18.01.2016
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <io.h>
#include <stdlib.h>
#include <delay.h>

// I2C Bus functions
#include <i2c.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here

#define addres_eep 0xa0

typedef unsigned char byte;

unsigned char NewState, OldState, OldVol, upState, downState, OldBtnW, OldBtnR;
unsigned char Vol = 0x7F;
char Duty[];


void EncoderScan(void);
void LcdOut (void);
byte read_eep(byte);
void write_eep(byte, byte);

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Reinitialize Timer 0 value
    TCNT0=0xCE;
    // Place your code here
    EncoderScan();
}


void EncoderScan(void)
{
    NewState = PINB & 0x03; 
    if (NewState != OldState) { 
        switch (OldState) {
            case 2:
                {
                if (NewState == 3)upState++;
                if (NewState == 0)downState++;
                break;
                }
            case 0:
                {
                if (NewState == 2)upState++;
                if (NewState == 1)downState++;  
                break;
                }
            case 1:
                {
                if (NewState == 0)upState++;
                if (NewState == 3)downState++; 
                break;
                }
            case 3:
                {
                if (NewState == 1)upState++;
                if (NewState == 2)downState++; 
                break;
                }
        }; 
        OldState = NewState;  
        if (upState >= 4) { 
            Vol+=1;
            upState = 0;
        };
        if (downState >= 4) { 
            Vol-=1;
            downState = 0;
        }; 
        if (Vol > 255) Vol = 255;
        if (Vol < 0) Vol = 0;
    
    };

}

void LcdOut (void)
{
     
     lcd_clear();
     lcd_putsf("Select num = ");
     itoa(Vol,Duty);
     lcd_puts(Duty);

}



byte read_eep(byte address_byte) 
{

    byte data;	                // ���������� ���������� data, � ������� �����
                                // ��������� ��������� �������� 
    i2c_start();	            // ���������� ��������� �������
    i2c_write(addres_eep);      // ������� � ���� I2C ����� EEPROM � �������
                                // ������ = 0, �. �. ��������� �������� - ������                         
    i2c_write(0x00);            // ������� � ���� I2C ����� �����,               
    i2c_write(address_byte);    // ������� ��������� ���������                                 
    i2c_start();	            // ���������� ��������� �������
    i2c_write(addres_eep | 1);   // �������� ����� ������� ���� ������
                                 // EEPROM �� 1, �. �. ����� ����������� 
                                 // �������� �����
    data=i2c_read(0);           // ������ ���� �� ���� I2C � ���������� dat           	        
    i2c_stop();	                // ���������� �������� �������
    return data;	            // ���������� �������� ���������� data

}

void write_eep(byte address_byte, byte data) 
{

    i2c_start();	            //	���������� ��������� �������
    i2c_write(addres_eep);      //	������� � ���� I2C ����� EEPROM            
    i2c_write(0x00);            //	������� � ���� I2C ����� ������,
    i2c_write(address_byte);    //	���� ��������� �������� ����                            
    i2c_write(data);           //	���������� ���� ������ data
    i2c_stop();	                //	���������� �������� �������
    delay_ms(10);	            //	��������� �������� ������ ��������� 10 ��

}



void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0xCE;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 0
// I2C SCL bit: 1
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTD Bit 1
// EN - PORTD Bit 2
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);

// Globally enable interrupts
#asm("sei")


while (1)
      {
      // Place your code here
      if (Vol != OldVol) {   
          LcdOut();
          OldVol = Vol;
        };  
      if(~PINB.2)
          {
              delay_ms(10);
              if((~PINB.2)&(~OldBtnW))
                {  
                    write_eep(0x12,Vol);
                    lcd_clear();
                    lcd_gotoxy(0, 1); 
                    lcd_puts("Write num = ");
                    itoa(Vol,Duty);
                    lcd_puts(Duty); 
                    OldBtnW=1;
           
                }; 
           }else
               { 
                    OldBtnW=0;
               }; 
      if(~PINB.3)
          {   
              delay_ms(10);    
              if((~PINB.3)&(~OldBtnR))
                {  
                    lcd_clear();
                    lcd_gotoxy(0, 1);
                    lcd_puts("Read num = ");
                    itoa(read_eep(0x12),Duty);
                    lcd_puts(Duty);  
                    OldBtnR=1;
                };
          }else
            {
               OldBtnR=0; 
            };        
        
      }
}
