/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 06.09.2018
Author  : 
Company : 
Comments: 


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <delay.h>

// Declare your global variables here

static char x = 0 ;
unsigned char TimerValue = 0x83;
char StepState, DirState, SpeedState;

const unsigned char mstepsA32[32] = { 
 0b00111100, //0                        
 0b00111100, //1  
 0b00111100, //2
 0b00111000, //3
 0b00110100, //4
 0b00110000, //5
 0b00101100, //6
 0b00101000, //7
 0b00100100, //8
 0b00100000, //9
 0b00011100, //10
 0b00011000, //11
 0b00010100, //12
 0b00010000, //13
 0b00001100, //14
 0b00001000, //15
 0b00000110, //16
 0b00001001, //17
 0b00001101, //18
 0b00010001, //19
 0b00010101, //20
 0b00011001, //21
 0b00011101, //22
 0b00100001, //23
 0b00100101, //24
 0b00101001, //25
 0b00101101, //26
 0b00110001, //27
 0b00110101, //28
 0b00111001, //29
 0b00111101, //30
 0b00111101};//31
 
 
 // �������� ��� ���������� ��������� ��
// � ������ 1/8 ���� ���� B

const unsigned char mstepsB32[32] = { 
 0b00001010, //0
 0b00001000, //1
 0b00001100, //2
 0b00010000, //3
 0b00010100, //4
 0b00011000, //5
 0b00011100, //6
 0b00100000, //7
 0b00100100, //8
 0b00101000, //9
 0b00101100, //10
 0b00110000, //11
 0b00110100, //12
 0b00111000, //13
 0b00111100, //14
 0b00111100, //15
 0b00111100, //16                       
 0b00111100, //17  
 0b00111100, //18
 0b00111000, //19
 0b00110100, //20
 0b00110000, //21
 0b00101100, //22
 0b00101000, //23
 0b00100100, //24
 0b00100000, //25
 0b00011100, //26
 0b00011000, //27
 0b00010100, //28
 0b00010000, //29
 0b00001100, //30
 0b00001000};//31        
 
 
 
 void Step(char);
 

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0 = TimerValue;
// Place your code here

//����� ����������� ������������������ �� ������� ��
    //� ������ ���� ���������� �� ��������� ������
    if (DirState) {
                Step(1);
            }
            else  {
                Step(-1);    
            };

}

// ������� ��� ������ ����������� �������������������
// � ���� ��������� ��������� ��
void Step(char Dir)
{
    if (StepState) {
        x = (32 + x + Dir) & 31;
        PORTD = mstepsA32[x];
        PORTC = mstepsB32[x];     
    }
    else  {
        x = (32 +  x + (2*Dir)) & 31;
        PORTD = mstepsA32[x];
        PORTC = mstepsB32[x]; 
        
    };

}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=P Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=TimerValue;

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

StepState = PINB.0; 
DirState = PINB.1; 
SpeedState = PINB.2; 

// Global enable interrupts
#asm("sei")


while (1)
      {
      // Place your code here 
      if ( StepState != PINB.0) {
         delay_us(250);
         StepState = PINB.0;
      }
      
      if (DirState != PINB.1) {
         delay_us(250);
         DirState = PINB.1;
      }
      
       if (SpeedState != PINB.2) {
         delay_us(250);
         SpeedState = PINB.2;
         if (SpeedState) {
            TimerValue = 0x83;
         } 
         else {
            TimerValue = 0xC2;
         }
      }
      
      }
}
