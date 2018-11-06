//***************************************************************************
//
//  Author(s)...:    
//
//  Target(s)...: ATtiny2313
//
//  Compiler....: CodeVision
//
//  Description.: Опрос матричной клавиатуры. Использование конечного автомата.
//
//  Data........: 06.03.10 
//
//***************************************************************************
#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <tiny2313.h>

//инициализация портов и внутренних переменных
void InitKeyboard(void);

//сканирование клавиатуры
void ScanKeyboard(void);

//возвращает код нажатой кнопки
unsigned char GetKey(void);

#endif //KEYBOARD_H