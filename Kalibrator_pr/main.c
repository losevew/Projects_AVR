/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : ���������� �����
Version : 0.1
Date    : 16.07.2014
Author  : LEW
Company : 
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>
#include <bcd.h>

// Declare your global variables here

unsigned char key = 0x01;
unsigned char flstart = 0x00;
unsigned char ind = 0x00;


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
   if (ind > 0x63) {           // ���� �������� ���������� ind ������ 99
         ind = 0x00;           // �������� ��
       };
   PORTB = bin2bcd(ind);       // ����������� � BCD ������ � ������� � ���� �
   ++ind;                      // �������������� ����������  ind 

}




void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization

// ��������� ����� �
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// ��������� ����� D
// Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x70;



// ��������� �������� ����������
// INT0: �������
// INT0 Mode: ���������� �����
MCUCR = (1<<ISC01)|(1<<ISC00); // ��������� ���������� �� ����������� ������


// Global enable interrupts
#asm("sei")

PORTD.5 = 0x00;       // �������� ��������� ����������
PORTD.4 = 0x01; 

while (1)
   {
      // Place your code here
      if (~PIND.0) {                 // �������� ������� ������
        key = PIND.0;                // ���� � ������� ������������� ��������
        delay_ms(10);                // ����������� �������� 
        if (~PIND.0) {               // �� ������ ��������� �������
            if (flstart) {           // ��������� ��������� ����� �����
               GIMSK = (0<<INT0);    // ��������� ���������� �� INT0 
               PORTB = 0x00;         // �������� ��������� 
               ind = 0x00;
               PORTD.5 = 0x00;       // �������� ��������� ���������� 
               PORTD.4 = 0x01;
               flstart = 0x00;       // ���������� ���� �����
            } 
            else {
               if (~PIND.1) {        // ��������� ����� �� ������������� � ��������� �����
                  GIMSK = (1<<INT0); // ���������� ���������� �� INT0 
                  PORTD.4 = 0x00;
               } 
               
               flstart = 0x01;       // ������������� ���� ����� 
               PORTD.5 = 0x01;       // ����� ��������� ����������
            }
          key = 0x01;                // ����� ������� ������
        }
        do  { 
          delay_ms(10);              // �������� � ����������� ���������  
        }
        while (~PIND.0);              // ���������� ������
      }
    }
}
