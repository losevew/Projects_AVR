/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12.09.2017
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

// Graphic Display functions
#include <glcd.h>

// Font used for displaying text
// on the graphic display
#include "font5x7ru.h"

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)



// USART Receiver buffer
#define RX_BUFFER_SIZE 90
unsigned char gga_data[RX_BUFFER_SIZE];
unsigned char gga_count=0;
//unsigned char rx_wr_index=0,rx_rd_index=0;

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

unsigned char search_gga_field (unsigned char x)//Search x-th field in GGA packet
{ 
    unsigned char i, c;
    c=0;
    for (i=0;i<gga_count;i++)
    {
    if (gga_data[i]==',') c++;
    if (c==x) return i+1;
    }
    return 0;
}

void write_gps_data (unsigned char crc_valid)    //Write GPS data on LCD
{ 
    unsigned char i,temp;
    if (crc_valid==0) {
        //If CRC not confirm
        glcd_clear();
        glcd_outtextf("������ ������");
        return;
    }                                        
     
    if (gga_data[search_gga_field(6)]=='0') 
    {//If no GPS signal 
        glcd_clear();
        glcd_outtextf("��� �������");
         
        pcd8544_wrbyte(gga_data[search_gga_field(7)+1]); 
        glcd_outtextxyf(15,8," ��������� ");
        glcd_outtextxyf(10,15,"����������");
        return;
    }                                                       
    //Write Latitude and Longitude
    glcd_clear(); 
    glcd_outtextf("������:");
    glcd_moveto(0,8);
    temp=search_gga_field(2);
    for (i=temp;i<temp+9;i++)//Write Latitude
    {
         if ((i-temp)==2) glcd_putchar (0xB0);
         glcd_putchar (gga_data[i]);
    }
    glcd_putchar (gga_data[search_gga_field(3)]);
     
    glcd_outtextxyf(0,15,"�������:");
    glcd_moveto(0,23);
    temp=search_gga_field(4);
    for (i=temp;i<temp+10;i++)    //Write Longitude
    {
         if ((i-temp)==3) glcd_putchar (0xB0);
         glcd_putchar (gga_data[i]);
    }
    glcd_putchar (gga_data[search_gga_field(5)]); 
        
    glcd_outtextxyf(0,32,"H:");
    temp=search_gga_field(9);
    while (gga_data[temp]!=',')	//Write altitude
    {
         glcd_putchar(gga_data[temp]);
         temp++;
    }
    glcd_putchar('�'); 
    
    glcd_outtextf(" Sat:");
    temp=search_gga_field(7);
    glcd_putchar (gga_data[temp]);	//Write satellites
    if (gga_data[temp+1]!=',') glcd_putchar (gga_data[temp+1]); 
        
    glcd_outtextxyf(0,41,"UTC:"); 
    temp=search_gga_field(1);
    for (i=temp;i<temp+6;i++)	//Write UTC
    {
         if (((i-temp)==2)||((i-temp)==4) ) glcd_putchar (':');
         glcd_putchar (gga_data[i]);
    } 
        
   
     
    return; 
}

unsigned char check_crc (void)		//Check CRC16
{ /*unsigned char i,gga_crc,vtg_crc;
 
     gga_crc=0x00;
     
     i=1;
     while ((gga_data[i]!='*')&&(i<90))
      {
       gga_crc^=gga_data[i];
       i++;
      }
     i++;
     if (gga_data[i]!=(0x30+(gga_crc>>4))) return 0;
     i++;
     if (gga_data[i]!=(0x30+(gga_crc&0x0f))) return 0;
     
     vtg_crc=0x00;
     
     i=1;
     while ((vtg_data[i]!='*')&&(i<90))
      {
       vtg_crc^=vtg_data[i];
       i++;
      }
     i++;
     if (vtg_data[i]!=(0x30+(vtg_crc>>4))) return 0;
     i++;
     if (vtg_data[i]!=(0x30+(vtg_crc&0x0f))) return 0; */
     
     return 1;
}

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status;
status=UCSRA;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {  
        gga_count=0;
        gga_data[gga_count]=UDR;//Get first byte to GGA packet
        gga_count++;
        do {			//Receive GGA packet 
 
            while ( !(UCSRA & (1<<RXC)) );
            gga_data[gga_count]=UDR;
	        gga_count++;
 
        } while ((gga_data[gga_count-1]!=0x0a)&&(gga_count<90));
   
   if (gga_count == RX_BUFFER_SIZE) gga_count=0;
   } 
   write_gps_data(check_crc());	//Write data and check CRC16 
   return;
}

//#ifndef _DEBUG_TERMINAL_IO_
//// Get a character from the USART Receiver buffer
//#define _ALTERNATE_GETCHAR_
//#pragma used+
//char getchar(void)
//{
//char data;
//while (rx_counter==0);
//data=rx_buffer[rx_rd_index++];
//#if RX_BUFFER_SIZE != 256
//if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
//#endif
//#asm("cli")
//--rx_counter;
//#asm("sei")
//return data;
//}
//#pragma used-
//#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];
unsigned char tx_rd_index=0;
unsigned char tx_counter=0;

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

//#ifndef _DEBUG_TERMINAL_IO_
//// Write a character to the USART Transmitter buffer
//#define _ALTERNATE_PUTCHAR_
//#pragma used+
//void putchar(char c)
//{
//while (tx_counter == TX_BUFFER_SIZE);
//#asm("cli")
//if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
//   {
//   tx_buffer[tx_wr_index++]=c;
//#if TX_BUFFER_SIZE != 256
//   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
//#endif
//   ++tx_counter;
//   }
//else
//   UDR=c;
//#asm("sei")
//}
//#pragma used-
//#endif



// Standard Input/Output functions
#include <stdio.h>

void main(void)
{
// Declare your local variables here
// Variable used to store graphic display
// controller initialization data
GLCDINIT_t glcd_init_data;

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
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
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Graphic Display Controller initialization
// The PCD8544 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// SDIN - PORTC Bit 0
// SCLK - PORTC Bit 1
// D /C - PORTC Bit 2
// /SCE - PORTC Bit 3
// /RES - PORTC Bit 4

// Specify the current font for displaying text
glcd_init_data.font=font5x7ru;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;
// Set the LCD temperature coefficient
glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
// Set the LCD bias
glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
// Set the LCD contrast control voltage VLCD
glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;

glcd_init(&glcd_init_data);

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      }
}
