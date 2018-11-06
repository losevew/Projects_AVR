
//-------------------------------------------------<                axlib v1.1                 >----------------------------------------------------
//-------------------------------------------------<   Функции управления микросхемой MAX7219  >----------------------------------------------------
//-------------------------------------------------< Кузнецов Алексей 2016 http://www.avrki.ru >----------------------------------------------------


#ifndef MAX7219_H_
#define MAX7219_H_


//-------------------------------------------------------------------------
//							Подключаемые библиотеки
//-------------------------------------------------------------------------

#include <spi.h>
#include <delay.h>

// Выводы для управление микросхемой MAX7219
#define MAX7219_DIN_DDR		DDRC
#define MAX7219_CS_DDR		DDRC
#define MAX7219_CLK_DDR		DDRC

#define MAX7219_DIN_PORT	PORTC
#define MAX7219_CS_PORT		PORTC
#define MAX7219_CLK_PORT	PORTC

#define MAX7219_DIN_PIN		0
#define MAX7219_CS_PIN		1
#define MAX7219_CLK_PIN		2

//-------------------------------------------------------------------------
//						Объявление служебных псевдонимов
//-------------------------------------------------------------------------

#define MAX7219_REG_DECODE		0x0900
#define MAX7219_REG_LIGHT		0x0A00
#define MAX7219_REG_NDIG		0x0B00
#define MAX7219_REG_SLEEP		0x0C00
#define MAX7219_REG_TEST		0x0F00

#define MAX7219_DECODE			0x0001
#define MAX7219_UNDECODE		0x0000
#define MAX7219_TEST_ON			0x01
#define MAX7219_TEST_OFF		0x00
#define MAX7219_POINT_ON		0x80
#define MAX7219_POINT_OFF		0x7F
#define MAX7219_POINT_NO		0x00

#define MAX7219_CS_LOW()		(MAX7219_CS_PORT &= ~(1 << MAX7219_CS_PIN))
#define MAX7219_CS_HIGHT()		(MAX7219_CS_PORT |= (1 << MAX7219_CS_PIN))

#define SBYTE	signed char
#define BYTE	char
#define UBYTE	unsigned char
#define WORD	int
#define UWORD	unsigned int
#define DWORD	long
#define ADATA	float

#define FALSE	0
#define TRUE	(!FALSE)

#define hibyte(a) ((a>>8) & 0xFF)
#define lobyte(a) ((a) & 0xFF)



//-------------------------------------------------------------------------
//							Инициализация переменных
//-------------------------------------------------------------------------


//-------------------------------------------------------------------------
//						Функция настройки портов и пинов
//-------------------------------------------------------------------------
void max7219_init_port(void)
{
	MAX7219_DIN_DDR |= (1 << MAX7219_DIN_PIN);
	MAX7219_CS_DDR |= (1 << MAX7219_CS_PIN);
	MAX7219_CLK_DDR |= (1 << MAX7219_CLK_PIN);
	
	MAX7219_DIN_PORT &= ~(1 << MAX7219_DIN_PIN);
	MAX7219_CS_PORT |= (1 << MAX7219_CS_PIN);
	MAX7219_CLK_PORT &= ~(1 << MAX7219_CLK_PIN);
}


//-------------------------------------------------------------------------
//						Функция передачи слова
//-------------------------------------------------------------------------

void max7219_out_word(WORD data)
{

    BYTE i = 0;
	WORD temp = 0;
	
	MAX7219_CS_LOW();
    delay_us(5);
	
	while(i<16)
	{
		temp = data;
		
		if((temp << i) & 0x8000)
		{
			MAX7219_DIN_PORT |= (1 << MAX7219_DIN_PIN);
		}
		else
		{
			MAX7219_DIN_PORT &= ~(1 << MAX7219_DIN_PIN);
		}
		
        delay_us(5);
		MAX7219_CLK_PORT |= (1 << MAX7219_CLK_PIN);
        delay_us(5);
		MAX7219_CLK_PORT &= ~(1 << MAX7219_CLK_PIN);
		
		i++;
	}
	delay_us(5);
	MAX7219_CS_HIGHT();

}

//-------------------------------------------------------------------------
//						Функция тест
//-------------------------------------------------------------------------

void max7219_test(void)
{
	max7219_out_word(MAX7219_REG_TEST | 0x0001);
	delay_ms(1000);
	max7219_out_word(MAX7219_REG_TEST & 0xFFFE);
}

//-------------------------------------------------------------------------
//						Функция инициализации микросхемы
//
//	Принимает аргументы
//						BYTE test - Включает/Выключает тест режим при инициализации
//							MAX7219_TEST_ON - Включить тест
//							MAX7219_TEST_OFF - Выключить тест
//
//						BYTE decod - Кодировать/не кодировать
//							MAX7219_DECODE - Кодировать
//							MAX7219_UNDECODE - Не кодировать
//
//						BYTE diglimit - Количество знаков от 1 до 8
//-------------------------------------------------------------------------

void max7219_init(BYTE test, BYTE decode, BYTE diglimit)
{	
	BYTE i = 0;
	BYTE code = 0;
	
	if(diglimit <= 0) diglimit = 1;
	if(diglimit >= 8) diglimit = 7;
	
    max7219_init_port();
	max7219_out_word(MAX7219_REG_TEST & 0xFFFE);
	if(test == MAX7219_TEST_ON) max7219_test();
	
	
	if(decode == MAX7219_DECODE)
	{
		while (i <= diglimit) 
		{
			code |= (1 << i);
			i++;
		}
	}
	else if(decode == MAX7219_UNDECODE)
	{
		while (i <= diglimit)
		{
			code &= ~(1 << i);
			i++;
		}
	}
	else
	{
		code = decode;
	}
	
	max7219_out_word(MAX7219_REG_DECODE | code);
	max7219_out_word(MAX7219_REG_NDIG | diglimit);   
    max7219_out_word(MAX7219_REG_SLEEP | 0x0001);
}

//-------------------------------------------------------------------------
//						Функция установки яркости свечения
//
//	Принимает аргументы
//						BYTE light - Уровень яркости от 0 до 15
//							
//-------------------------------------------------------------------------

void max7219_light(BYTE light)
{
	max7219_out_word(MAX7219_REG_LIGHT | light);
}

//-------------------------------------------------------------------------
//						Функция вывода одного разряда
//
//	Принимает аргументы
//						BYTE add - Адрес разряда от 1 до 8
//						BYTE dig - Цифра от 0 до 15
//						BYTE point - Включает/Выключает точку текущего разряда
//							MAX7219_POINT_ON - Включить точку
//							MAX7219_POINT_OFF - Выключить точку
//							MAX7219_POINT_NO - Не обрабатывать разряд D7
//
//-------------------------------------------------------------------------

void max7219_data_out(BYTE add, BYTE dig, BYTE point)
{
	WORD data = 0x00;
	
	if(add <= 0) add =1;
	if(add >= 8) add = 8;
	
	if(point == MAX7219_POINT_ON) 
	{
		dig |= MAX7219_POINT_ON;
	}
	else
	{
		dig &= MAX7219_POINT_OFF;
	}
	
	data = add;
	data = ((data << 8) | dig);
	
	max7219_out_word(data);
}

//-------------------------------------------------------------------------
//						Функция очистка дисплея
//-------------------------------------------------------------------------

void max7219_clear()
{
	BYTE i = 1;
	while(i <= 8)
	{
		max7219_data_out(i, 15, MAX7219_POINT_OFF);
		i++;
	}
}

#endif /* MAX7219_H_ */