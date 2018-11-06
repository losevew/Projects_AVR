//***************************************************************************
//
//  Author(s)...:    
//
//  Target(s)...: ATtiny2313
//
//  Compiler....: CodeVision
//
//  Description.: ����� ��������� ����������. ������������� ��������� ��������.
//
//  Data........: 06.03.10 
//
//***************************************************************************
#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <tiny2313.h>

//������������� ������ � ���������� ����������
void InitKeyboard(void);

//������������ ����������
void ScanKeyboard(void);

//���������� ��� ������� ������
unsigned char GetKey(void);

#endif //KEYBOARD_H