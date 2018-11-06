#include "keyboard.h"
#include "delay.h"
//������ ������� ��������� ��������
unsigned char keyState;
//������ ��� ������� ������
unsigned char keyCode;
//������ ���������� �������� ������� ������
unsigned char keyValue;
//�������� ���������� - ���������������, ���� ������ ������������
unsigned char keyDown;
//�������� ���������� -  ���������������, ����� ������ ����� ������
unsigned char keyNew;

//������� �������������
__flash unsigned char keyTable[][2] = { 
{ 0x11, '1'},
{ 0x12, '2'},
{ 0x14, '3'},
{ 0x21, '4'},
{ 0x22, '5'},
{ 0x24, '6'},
{ 0x41, '7'},
{ 0x42, '8'},
{ 0x44, '9'},
{ 0x81, '*'},
{ 0x82, '0'},
{ 0x84, '#'}
};

//��������� ������� ������������ ���������
unsigned char AnyKey(void);
unsigned char SameKey(void);
void ScanKey(void);
unsigned char FindKey(void);
void ClearKey(void);

//������������� ������, ��������� ����������
void InitKeyboard(void)
{
  DDRB = 0xff;
  PORTB = 0x00;
  DDRD = 0x00;
  PORTD = 0xf8;
  
  keyState = 0;
  keyCode = 0;
  keyValue = 0;
  keyDown = 0;
  keyNew = 0;
}

//������� ����������� ����� ����������, ������ �� ��������
// � ������������� ������� ������
void ScanKeyboard(void)
{
   switch (keyState){
     case 0: 
       if (AnyKey()) {
         ScanKey();
         keyState = 1;
       }
       break;

     case 1: 
       if (SameKey()) {
           FindKey();
           keyState = 2;
       }
       else keyState = 0;
       break;
     
     case 2: 
        if (SameKey()){}
        else keyState = 3;
        break;
    
     case 3: 
       if (SameKey()) {
         keyState = 2;
       }
       else {
         ClearKey();
         keyState = 0;
       }
       break;
     
     default:
        break;
   }
   
}

//���������� true ���� �����-������ ������ ������
unsigned char AnyKey(void) 
{
  unsigned char temp;
  PORTB |= 0xf0;
  delay_us(5);
  temp = (PIND & 0x07);
  PORTB &= 0x0f;
  return temp;
}


//���������� ������ ������� �� ������
//��������� ��� ������� ������
void ScanKey(void) 
{
  unsigned char activeRow = (1<<4);
  while (activeRow) {
    PORTB = (PINB & 0x0f)|activeRow; 
    delay_us(5);
    if (PIND & 0x07) {
      keyCode = (PIND & 0x07);
      keyCode |= (PINB & 0xf0);
    }
    activeRow <<= 1;
  }
  PORTB &= 0x0f;
}

// ���������� true ���� ������������ �� �� ������
//��� � � ���������� ����� ������
unsigned char SameKey(void) 
{
  unsigned char temp;
  PORTB = (PINB & 0x0f) | ( keyCode & 0xf0);
  delay_us(5);
  temp = ((PIND & keyCode) & 0x07);
  PORTB &= 0x0f;
  return temp;
}

// ����������� ��� ������ � ��������������� ������
// ������������ �����
unsigned char FindKey(void) 
{
  unsigned char index;
  for (index = 0; index < 12; index++) {
    if (keyTable [index][0] == keyCode) {
      keyValue = keyTable [index][1];
      keyDown = 1;
      keyNew = 1;
      return 1;
    }
  }
  return 0;
}

//���������� ���� 
void ClearKey(void) 
{
  keyDown = 0;
}

//���� ������������� ������� ������
//���������� �� ���
unsigned char GetKey(void)
{ 
  if (keyNew){
    keyNew = 0;
    return keyValue;
  }
  else 
    return 0;
}