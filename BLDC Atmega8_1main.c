// ����������� ���������������� ��������� � AVR(��� ��������)
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>
 
// ���� U(������� �����)
#define UH_ON   TCCR1A |= (1 << COM1A1);
#define UH_OFF  TCCR1A &= ~(1 << COM1A1);
 
// ���� U(������ �����)
#define UL_ON   PORTB |= (1 << PB5);
#define UL_OFF  PORTB &= ~(1 << PB5);
 
// ���� V(������� �����)
#define VH_ON   TCCR2 |= (1 << COM21);
#define VH_OFF  TCCR2 &= ~(1 << COM21);
 
// ���� V(������ �����)
#define VL_ON   PORTB |= (1 << PB0);
#define VL_OFF  PORTB &= ~(1 << PB0);
 
// ���� W(������� �����)
#define WH_ON   TCCR1A |= (1 << COM1B1);
#define WH_OFF  TCCR1A &= ~(1 << COM1B1);
 
// ���� W(������ �����)
#define WL_ON   PORTB |= (1 << PB4);
#define WL_OFF  PORTB &= ~(1 << PB4);
 
#define PHASE_ALL_OFF   UH_OFF;UL_OFF;VH_OFF;VL_OFF;WH_OFF;WL_OFF;
 
#define SENSE_U     ADMUX = 0; // ���� �������� ��� ���� U
#define SENSE_V     ADMUX = 1; // ���� �������� ��� ���� V
#define SENSE_W     ADMUX = 2; // ���� �������� ��� ���� W
 
#define SENSE_UVW   (ACSR&(1 << ACO)) // ����� �����������
 
#define START_PWM   10 // ����������� ��� ��� �������
#define WORK_PWM   100 // ������������ ������� ��� ��� �������
 
unsigned char start = 0, start_stop = 0, start_pwm;
unsigned char direction = 1; // 0 - ������ �������, 1 - �� �������
volatile unsigned char motor_pwm = WORK_PWM;
volatile unsigned char commutation_step = 0;
volatile unsigned char rotor_run = 0; // ������� ��������� �������� ���
 
// ������� ������������ ������� ���������
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
                commutation_step = 1; // ��������� ���
                TCNT0 = 0; // �������� ������� T0
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
                TCNT0 = 0; // �������� ������� T0
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
                TCNT0 = 0; // �������� ������� T0
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
                TCNT0 = 0; // �������� ������� T0
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
                TCNT0 = 0; // �������� ������� T0
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
                TCNT0 = 0; // �������� ������� T0
            }
            break;
    }
}
// ���������� ���������� �� �����������. �������� �������� ���
ISR(ANA_COMP_vect)
{
rotor_run++; // �������������� ��������
if(rotor_run > 200) rotor_run = 200;
if(rotor_run == 200) // ���� �������� �������� ��� ������������, ������ ��������
commutation(0); // ����������� ������� �� ������� �����������
}
// ���������� ���������� �� ������������ �0. ������ ��������� ��� �������� �������� ���
// ���� ��������� ����������, ���� �������� ��������� �������� ���
ISR(TIMER0_OVF_vect)
{  
rotor_run = 0; // ���������� ������� ���������
OCR1A = START_PWM; // ��� �������
OCR1B = START_PWM;
OCR2 = START_PWM;
commutation(1); // ����������� ������� ����������
}
// ���������� �������� ���������� INT0. �������
ISR(INT0_vect){
    _delay_us(100);
    if ((PIND & ( 1 << PD2)) == 0){
        _delay_us(100);
// ������ ������ ������� �������
        if ((PIND & ( 1 << PD1)) == 0)
        {
          if(motor_pwm != START_PWM) motor_pwm -= 5; // ��������� ���
        }
// ������ �� ������� �������
        else
        {
          if(motor_pwm != 255) motor_pwm += 5; // ����������� ���
        }
    }
    GIFR = (1 << INTF0); // ���������� ���� �������� ����������
    return;
}
 
int main (void)
{
// ����� �����/������
DDRB  = 0xFF;
PORTB = 0x00;
DDRD |= (1 << PD7);
DDRD &= ~(1 << PD6)|(1 << PD3)|(1 << PD2)|(1 << PD1)|(1 << PD0);
PORTD |= (1 << PD3)|(1 << PD2)|(1 << PD1)|(1 << PD0);  
PORTD &= ~(1 << PD7)|(1 << PD6);
 
// T0 - ��� ������ � ������ ��������� ��� �������� �������� ���
TCCR0 |= (1 << CS02)|(1 << CS00); // ������������ �� 1024
TIMSK |= (1 << TOIE0); // ��������� ���������� �� ������������ T0
// T1 � T2 ���
TCCR1A |= (1 << COM1A1)|(1 << COM1B1)| // Clear OC1A/OC1B, set OC1A/OC1B at BOTTOM
          (1 << WGM10);  // ����� Fast PWM, 8-bit
TCCR1B |= (1 << CS10)|(1 << WGM12); // ��� ������������
TCCR2 |= (1 << COM21)| // Clear OC2, set OC2 at BOTTOM
         (1 << WGM21)|(1 << WGM20)| // ����� Fast PWM
         (1 << CS20); // ��� ������������
 
PHASE_ALL_OFF; // ��������� ��� ����
     
// ���������� ����������
ADCSRA &= ~(1 << ADEN); // ��������� ���
SFIOR |= (1 << ACME); // ������������� ���� ����������� ���������� � ������ �������������� ���
ACSR |= (1 << ACIE); // ��������� ���������� �� �����������
 
// ������� ����������(�������)
MCUCR |= (1 << ISC01); // ���������� �� ������� ������ INT0(�� ����� ��������)
GIFR |= (1 << INTF0); // ������� ���� �������� ����������
GICR |= (1 << INT0); // ��������� ������� ���������� INT0
         
sei(); // ��������� ��������� ����������
 
while(1)
{  
if((PIND&(1 << PD0)) == 0) // �����/����
{
_delay_ms(20);
start_stop ^= 1; // ����������� ���������
while((PIND&(1 << PD0)) == 0){} // ���� ���������� ������
}
 
if(start_stop)
{
ACSR |= (1 << ACIE); // ��������� ���������� �� �����������
TIMSK |= (1 << TOIE0); // ��������� ���������� �� ������������ T0
GICR |= (1 << INT0); // ��������� ������� ���������� INT0 
// ������� �����
  if(rotor_run == 200 && start == 0) // ���� �������� �������� ��� ������������ � ��������� �� ��� �������
  {
    for(start_pwm = START_PWM; start_pwm < motor_pwm; start_pwm++)
    {
      _delay_ms(10); // ��������
      OCR1A = start_pwm;
      OCR1B = start_pwm;
      OCR2 = start_pwm;
    }
  start = 1; // ������ ���������    
  PORTD |= (1 << PD7); // �������� ���������
  }
 
  if(rotor_run == 200) // ���� �������� �������� ��� ������������, ����� ������ ���
  {
  OCR1A = motor_pwm;
  OCR1B = motor_pwm;
  OCR2 = motor_pwm;
  }
}
else
{
 
if(PIND&(1 << PD3)) direction = 1; // ����� ����������� �������� ����
else direction = 0;
 
start = 0; // ��������� ����������
PORTD &= ~(1 << PD7); // ��������� ���������
PHASE_ALL_OFF; // ��� ���� ���������
ACSR &= ~(1 << ACIE); // ��������� ���������� �� �����������
TIMSK &= ~(1 << TOIE0); // ��������� ���������� �� ������������ T0
GICR &= ~(1 << INT0); // ��������� ������� ���������� INT0
}
 
}
}
