/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : ����������� ���������������� ��������� � AVR(��� ��������)
Version : 
Date    : 28.07.2019
Author  : 
Company : 
Comments: 


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/



#include <mega8.h>
#include <delay.h>

// ���� U(������� �����)
#define UH_ON    TCCR1A |= (1 << COM1A1);
#define UH_OFF    TCCR1A &= ~(1 << COM1A1);

// ���� U(������ �����)
#define UL_ON    PORTB |= (1 << PORTB5);
#define UL_OFF    PORTB &= ~(1 << PORTB5);

// ���� V(������� �����)
#define VH_ON    TCCR2 |= (1 << COM21);
#define VH_OFF    TCCR2 &= ~(1 << COM21);

// ���� V(������ �����)
#define VL_ON    PORTB |= (1 << PORTB0);
#define VL_OFF    PORTB &= ~(1 << PORTB0);

// ���� W(������� �����)
#define WH_ON    TCCR1A |= (1 << COM1B1);
#define WH_OFF    TCCR1A &= ~(1 << COM1B1);

// ���� W(������ �����)
#define WL_ON    PORTB |= (1 << PORTB4);
#define WL_OFF    PORTB &= ~(1 << PORTB4);

#define PHASE_ALL_OFF	UH_OFF;UL_OFF;VH_OFF;VL_OFF;WH_OFF;WL_OFF;

#define SENSE_U		ADMUX = 0; // ���� �������� ��� ���� U 
#define SENSE_V		ADMUX = 1; // ���� �������� ��� ���� V
#define SENSE_W		ADMUX = 2; // ���� �������� ��� ���� W

#define SENSE_UVW	(ACSR&(1 << ACO)) // ����� �����������

#define START_PWM   10 // ����������� ��� ��� �������
#define WORK_PWM   100 // ������������ ������� ��� ��� ������� 


// Declare your global variables here

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
				VL_OFF;	WL_ON; SENSE_V;
				}
				else
				{
				VL_OFF;	UL_ON; SENSE_V;
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
				VH_OFF;	UH_ON; SENSE_V;
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
				UL_OFF;	VL_ON; SENSE_U;
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


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
    delay_us(100);
        if ((PIND & ( 1 << PIND2)) == 0){
            delay_us(100);
    // ������ ������ ������� �������
            if ((PIND & ( 1 << PIND1)) == 0)
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

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    rotor_run = 0; // ���������� ������� ���������
    OCR1A = START_PWM; // ��� �������
    OCR1B = START_PWM;
    OCR2 = START_PWM;
    commutation(1); // ����������� ������� ����������

}

// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
// Place your code here
    rotor_run++; // �������������� ��������
    if(rotor_run > 200) rotor_run = 200;
    if(rotor_run == 200) // ���� �������� �������� ��� ������������, ������ �������� 
    commutation(0); // ����������� ������� �� ������� �����������

}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,016 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
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
// Clock value: 16000,000 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
// Timer Period: 0,016 ms
// Output Pulse(s):
// OC2 Period: 0,016 ms Width: 0 us
ASSR=0<<AS2;
TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2=START_PWM;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
GICR|=(0<<INT1) | (1<<INT0);
MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
GIFR=(0<<INTF1) | (1<<INTF0);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: On
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the ADC multiplexer
// Interrupt on Output Toggle
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(1<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")

while (1)
    {
      // Place your code here
      if((PIND&(1 << PIND0)) == 0) // �����/���� 
        {
            delay_ms(20);
            start_stop ^= 1; // ����������� ���������
            while((PIND&(1 << PIND0)) == 0){} // ���� ���������� ������
           // while((PIND.0) == 0){}
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
                      delay_ms(10); // ��������
                      OCR1A = start_pwm;
                      OCR1B = start_pwm;
                      OCR2 = start_pwm;
                    }
                  start = 1; // ������ ���������	 
                  PORTD |= (1 << PORTD7); // �������� ���������
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

            if(PIND&(1 << PIND3)) direction = 1; // ����� ����������� �������� ����
            else direction = 0;

            start = 0; // ��������� ����������
            PORTD &= ~(1 << PORTD7); // ��������� ���������
            PHASE_ALL_OFF; // ��� ���� ���������
            ACSR &= ~(1 << ACIE); // ��������� ���������� �� �����������
            TIMSK &= ~(1 << TOIE0); // ��������� ���������� �� ������������ T0
            GICR &= ~(1 << INT0); // ��������� ������� ���������� INT0
        }


      }
}
