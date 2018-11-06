#ifndef	encoder_h
#define	encoder_h
#include <mega8.h>

//_________________________________________
//���� � ������ � ������� ��������� �������
#define PORT_Enc 	PORTB 	
#define PIN_Enc 	PINB
#define DDR_Enc 	DDRB
#define Pin1_Enc 	0
#define Pin2_Enc 	1
//______________________
#define RIGHT_SPIN 0x01 
#define LEFT_SPIN 0xff
#define MAX_ENC_VALUE 9
#define MIN_ENC_VALUE 0

void ENC_InitEncoder(void);
void ENC_PollEncoder(void);
unsigned char ENC_GetStateEncoder(void);
#endif  //encoder_h
