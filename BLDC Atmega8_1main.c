// Подключение бесколлекторного двигателя к AVR(без датчиков)
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>
 
// Фаза U(Верхнее плечо)
#define UH_ON   TCCR1A |= (1 << COM1A1);
#define UH_OFF  TCCR1A &= ~(1 << COM1A1);
 
// Фаза U(Нижнее плечо)
#define UL_ON   PORTB |= (1 << PB5);
#define UL_OFF  PORTB &= ~(1 << PB5);
 
// Фаза V(Верхнее плечо)
#define VH_ON   TCCR2 |= (1 << COM21);
#define VH_OFF  TCCR2 &= ~(1 << COM21);
 
// Фаза V(Нижнее плечо)
#define VL_ON   PORTB |= (1 << PB0);
#define VL_OFF  PORTB &= ~(1 << PB0);
 
// Фаза W(Верхнее плечо)
#define WH_ON   TCCR1A |= (1 << COM1B1);
#define WH_OFF  TCCR1A &= ~(1 << COM1B1);
 
// Фаза W(Нижнее плечо)
#define WL_ON   PORTB |= (1 << PB4);
#define WL_OFF  PORTB &= ~(1 << PB4);
 
#define PHASE_ALL_OFF   UH_OFF;UL_OFF;VH_OFF;VL_OFF;WH_OFF;WL_OFF;
 
#define SENSE_U     ADMUX = 0; // Вход обратной ЭДС фазы U
#define SENSE_V     ADMUX = 1; // Вход обратной ЭДС фазы V
#define SENSE_W     ADMUX = 2; // Вход обратной ЭДС фазы W
 
#define SENSE_UVW   (ACSR&(1 << ACO)) // Выход компаратора
 
#define START_PWM   10 // Минимальный ШИМ при запуске
#define WORK_PWM   100 // Максимальный уровень ШИМ при запуске
 
unsigned char start = 0, start_stop = 0, start_pwm;
unsigned char direction = 1; // 0 - против часовой, 1 - по часовой
volatile unsigned char motor_pwm = WORK_PWM;
volatile unsigned char commutation_step = 0;
volatile unsigned char rotor_run = 0; // Счетчик импульсов обратной ЭДС
 
// Функция переключения обмоток двигателя
void commutation(unsigned char startup)
{
    switch (commutation_step)
    {
        case (0):
            if(!SENSE_UVW || startup)
            {
                if(direction)
                {
                UH_ON; WH_OFF; SENSE_W;
                }
                else
                {
                UH_OFF; WH_ON; SENSE_U;
                }
                commutation_step = 1; // Следующий шаг
                TCNT0 = 0; // Обнуляем счетчик T0
            }
            break;
 
        case (1):
            if(SENSE_UVW || startup)
            {
                if(direction)
                {
                VL_OFF; WL_ON; SENSE_V;
                }
                else
                {
                VL_OFF; UL_ON; SENSE_V;
                }
                commutation_step = 2;
                TCNT0 = 0; // Обнуляем счетчик T0
            }
            break;
 
        case (2):
            if(!SENSE_UVW || startup)
            {
                if(direction)
                {
                UH_OFF; VH_ON; SENSE_U;
                }
                else
                {
                VH_ON; WH_OFF; SENSE_W;            
                }
                commutation_step = 3;
                TCNT0 = 0; // Обнуляем счетчик T0
            }
            break;
     
        case (3):
            if(SENSE_UVW || startup)
            {
                if(direction)
                {
                UL_ON; WL_OFF; SENSE_W;
                }
                else
                {
                UL_OFF; WL_ON; SENSE_U;
                }
                commutation_step = 4;
                TCNT0 = 0; // Обнуляем счетчик T0
            }
            break;
 
        case (4):
            if(!SENSE_UVW || startup)
            {
                if(direction)
                {
                VH_OFF; WH_ON; SENSE_V;
                }
                else
                {
                VH_OFF; UH_ON; SENSE_V;
                }
                commutation_step = 5;
                TCNT0 = 0; // Обнуляем счетчик T0
            }
            break;
 
        case (5):
            if(SENSE_UVW || startup)
            {
                if(direction)
                {
                UL_OFF; VL_ON; SENSE_U;
                }
                else
                {
                VL_ON; WL_OFF; SENSE_W;
                }
                commutation_step = 0;
                TCNT0 = 0; // Обнуляем счетчик T0
            }
            break;
    }
}
// Обработчик прерывания по компаратору. Детектор обратной ЭДС
ISR(ANA_COMP_vect)
{
rotor_run++; // инкрементируем импульсы
if(rotor_run > 200) rotor_run = 200;
if(rotor_run == 200) // Если импульсы обратной ЭДС присутствуют, крутим наполную
commutation(0); // Переключаем обмотки по сигналу компаратора
}
// Обработчик прерывания по переполнению Т0. Работа двигателя без сигналов обратной ЭДС
// Если сработало прерывание, есть пропуски импульсов обратной ЭДС
ISR(TIMER0_OVF_vect)
{  
rotor_run = 0; // Сбрасываем счетчик импульсов
OCR1A = START_PWM; // ШИМ минимум
OCR1B = START_PWM;
OCR2 = START_PWM;
commutation(1); // Переключаем обмотки безусловно
}
// Обработчик внешнего прерывания INT0. Энкодер
ISR(INT0_vect){
    _delay_us(100);
    if ((PIND & ( 1 << PD2)) == 0){
        _delay_us(100);
// Крутим против часовой стрелки
        if ((PIND & ( 1 << PD1)) == 0)
        {
          if(motor_pwm != START_PWM) motor_pwm -= 5; // Уменьшаем ШИМ
        }
// Крутим по часовой стрелке
        else
        {
          if(motor_pwm != 255) motor_pwm += 5; // Увеличиваем ШИМ
        }
    }
    GIFR = (1 << INTF0); // Сбрасываем флаг внешнего прерывания
    return;
}
 
int main (void)
{
// Порты ввода/вывода
DDRB  = 0xFF;
PORTB = 0x00;
DDRD |= (1 << PD7);
DDRD &= ~(1 << PD6)|(1 << PD3)|(1 << PD2)|(1 << PD1)|(1 << PD0);
PORTD |= (1 << PD3)|(1 << PD2)|(1 << PD1)|(1 << PD0);  
PORTD &= ~(1 << PD7)|(1 << PD6);
 
// T0 - для старта и работы двигателя без сигналов обратной ЭДС
TCCR0 |= (1 << CS02)|(1 << CS00); // Предделитель на 1024
TIMSK |= (1 << TOIE0); // Разрешаем прерывание по переполнению T0
// T1 и T2 ШИМ
TCCR1A |= (1 << COM1A1)|(1 << COM1B1)| // Clear OC1A/OC1B, set OC1A/OC1B at BOTTOM
          (1 << WGM10);  // Режим Fast PWM, 8-bit
TCCR1B |= (1 << CS10)|(1 << WGM12); // Без предделителя
TCCR2 |= (1 << COM21)| // Clear OC2, set OC2 at BOTTOM
         (1 << WGM21)|(1 << WGM20)| // Режим Fast PWM
         (1 << CS20); // Без предделителя
 
PHASE_ALL_OFF; // Выключаем все фазы
     
// Аналаговый компаратор
ADCSRA &= ~(1 << ADEN); // Выключаем АЦП
SFIOR |= (1 << ACME); // Отрицательный вход компаратора подключаем к выходу мультиплексора АЦП
ACSR |= (1 << ACIE); // Разрешаем прерывания от компаратора
 
// Внешнее прерывание(Энкодер)
MCUCR |= (1 << ISC01); // Прерывание по заднему фронту INT0(по спаду импульса)
GIFR |= (1 << INTF0); // Очищаем флаг внешнего прерывания
GICR |= (1 << INT0); // Разрешаем внешние прерывания INT0
         
sei(); // Глобально разрешаем прерывания
 
while(1)
{  
if((PIND&(1 << PD0)) == 0) // Старт/Стоп
{
_delay_ms(20);
start_stop ^= 1; // Переключаем состояние
while((PIND&(1 << PD0)) == 0){} // Ждем отпускания кнопки
}
 
if(start_stop)
{
ACSR |= (1 << ACIE); // Разрешаем прерывание от компаратора
TIMSK |= (1 << TOIE0); // Разрешаем прерывание по переполнению T0
GICR |= (1 << INT0); // Разрешаем внешние прерывания INT0 
// Плавный старт
  if(rotor_run == 200 && start == 0) // Если импульсы обратной ЭДС присутствуют и двигатель не был запущен
  {
    for(start_pwm = START_PWM; start_pwm < motor_pwm; start_pwm++)
    {
      _delay_ms(10); // Задержка
      OCR1A = start_pwm;
      OCR1B = start_pwm;
      OCR2 = start_pwm;
    }
  start = 1; // Запуск произошел    
  PORTD |= (1 << PD7); // Включаем светодиод
  }
 
  if(rotor_run == 200) // Если импульсы обратной ЭДС присутствуют, можем менять ШИМ
  {
  OCR1A = motor_pwm;
  OCR1B = motor_pwm;
  OCR2 = motor_pwm;
  }
}
else
{
 
if(PIND&(1 << PD3)) direction = 1; // Выбор направления вращения вала
else direction = 0;
 
start = 0; // Двигатель остановлен
PORTD &= ~(1 << PD7); // Выключаем светодиод
PHASE_ALL_OFF; // Все фазы выключены
ACSR &= ~(1 << ACIE); // Запрещаем прерывание от компаратора
TIMSK &= ~(1 << TOIE0); // Запрещаем прерывание по переполнению T0
GICR &= ~(1 << INT0); // Запрещаем внешние прерывания INT0
}
 
}
}
