/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Калибратор (для НИР Синхрон)
Version : 0.28
Date    : 04.07.2014
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
unsigned char flchet = 0x00;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
   if (ind > 0x63) {           // если значение переменной ind больше 99
         ind = 0x00;           // обнуляем ее
       };
   PORTB = bin2bcd(ind);       // преобразуем в BCD формат и выводим в порт В
   ++ind;                      // инкрементируем переменную  ind
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    TCNT0 = 0x0B;                  // выполняем предустановку таймера Т0
    if (flchet) {                  // проверяем  флаг четности, если
       flchet = 0x00;              // если установлен то сбрасываем его
       PORTD.6 = 0x00;             // и устанавливаем на выводе PD6 0
    }
    else {
       flchet = 0x01;              // в противном случае устанавливаем флаг четности 
       PORTD.6 = 0x01;             // и выводим в PD6 1
       if (ind > 0x63) {           // если значение переменной ind больше 99
         ind = 0x00;               // обнуляем ее
       };
       PORTB = bin2bcd(ind);       // преобразуем в BCD формат и выводим в порт В
       ++ind;                      // инкрементируем переменную  ind
    };  
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

// Настройка порта В
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Настройка порта D
// Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=0 State5=0 State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x60;


//насторйка таймера Т0
TCCR0 = (0<<CS02)|(1<<CS01)|(0<<CS00); //предделитель 8
TCNT0 = 0x0B; //прерывания каждые 0.490 мкс при частоте 4 Мгц

// Настройка внешнего прерывания
// INT0: включен
// INT0 Mode: Восходящий фронт
MCUCR = (1<<ISC01)|(1<<ISC00); //  установка прерывания по восходящему фронту


// Global enable interrupts
#asm("sei")

PORTD.5 = 0x00;       // зажигаем индикатор готовности

while (1)
   {
      // Place your code here
      if (~PIND.0 ) {                // проверка нажатия кнопки пуск
        key = PIND.0;                // если в течении установленной задержки
        delay_ms(10);                // сохраняется значение 
        if (PIND.0 == key) {         // то кнопка считается нажатой
            if (flstart) {           // проверяем установку флага старт
               TIMSK = (0<<TOIE0);   // запрещаем прерывания переполнению таймера T0
               GIMSK = (0<<INT0);    // запрещаем прерывания по INT0 
               PORTB = 0x00;         // обнуляем индикатор 
               ind = 0x00;
               PORTD.5 = 0x00;       // зажигаем индикатор готовности
               flstart = 0x00;       // сбрасываем флаг старт
               flchet = 0x00;        // сбрасываем флаг четности
               PORTD.6 = 0x00;       // устанавливаем на выводе PD6 0
            } 
            else {
               if (PIND.1) {         // проверяем стоит ли переключатель в положении внутр
                  TCNT0 = 0x0B;      // предустановка таймера Т0
                  TIMSK = (1<<TOIE0);// разрешение прерывания по переполнению таймера T0  
               } 
               else {
                  GIMSK = (1<<INT0); // разрешение прерывания по INT0
               }
               flstart = 0x01;       // устанавливаем флаг старт 
               PORTD.5 = 0x01;       // гасим индикатор готовности
            }
          key = 0x01;                // сброс нажатия кнопки
        }
        do  { 
          delay_ms(10);              // задержка с последующей проверкой  
        }
        while (~PIND.0);              // отпускания кнопки
      }
    }
}

