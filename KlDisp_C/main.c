//***************************************************************************
//
//  Author(s)...:    
//
//  Target(s)...: ATtyny2313
//
//  Compiler....: CodeVision
//
//  Description.: ����� ��������� ����������. ������������� ��������� ��������.
//
//  Data........:  
//
//***************************************************************************
#include <tiny2313.h>
#include "keyboard.h"

#define SDO PORTB.1
#define SCK PORTB.0

//���������� ������� �0 - ����� ����������
interrupt [TIM0_OVF] void Timer0Ovf(void)
{
   TCNT0 = 0x83;
   ScanKeyboard();   
}

void spi_write ( unsigned char datum )
{
    int k;
    for (k=0; k<4; k++)
    {
        if((datum & 0x08)) { SDO = 1;}
        else {SDO = 0;}
        datum = datum <<1;
        SCK = 1;
        SCK = 0;   
    }
    SDO = 0;
}

void main( void )
{
  unsigned char key;
  
    
  //������������� ������� �0
  TIMSK = (1<<TOIE0); //���������� ���������� �� ������������
  TCCR0 = (1<<CS02)|(0<<CS01)|(0<<CS00); //������������ 256
  TCNT0 = 0x83; //���������� ������ 8 ��  ��� �������� ������� 4 ���
  
  //������������� ������ � ���������� 
  InitKeyboard();
  #asm("sei");
  
  while(1){
    //���� ������������� �������, 
    //��������� ��� ������ � ��������
    key = GetKey();
    if (key)
      spi_write(key);
  }
}
