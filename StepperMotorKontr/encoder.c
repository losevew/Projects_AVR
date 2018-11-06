#include "encoder.h"

#define SBR(port, bit) port|= (1<<bit)
#define CBR(port, bit) port&= ~(1<<bit)

//��� ��� ����������� ����
#define b00000011 3
#define b11010010 210
#define b11100001 225

volatile unsigned char bufEnc = 0; //����� ��������

//������� �������������
//__________________________________________
void ENC_InitEncoder(void)
{
  CBR(DDR_Enc, Pin1_Enc); //����
  CBR(DDR_Enc, Pin2_Enc);
  SBR(PORT_Enc, Pin1_Enc);//��� ������������� ��������
  SBR(PORT_Enc, Pin2_Enc);
}

//������� ������ ��������
//___________________________________________
void ENC_PollEncoder(void)
{
static unsigned char stateEnc; 	//������ ������������������ ��������� ��������
unsigned char tmp;  
unsigned char currentState = 0;

//��������� ��������� ������� ����������������
if ((PIN_Enc & (1<<Pin1_Enc))!= 0) {SBR(currentState,0);}
if ((PIN_Enc & (1<<Pin2_Enc))!= 0) {SBR(currentState,1);}

//���� ����� �����������, �� �������
tmp = stateEnc;
if (currentState == (tmp & b00000011)) return;

//���� �� �����, �� �������� � ��������� � ���
stateEnc = (tmp<<2)|currentState;

//���������� ������������ ������������������
if (tmp == b11100001) bufEnc = LEFT_SPIN;
if (tmp == b11010010) bufEnc = RIGHT_SPIN;
return;
}

//������� ������������ �������� ������ ��������
//_____________________________________________
unsigned char ENC_GetStateEncoder(void)
{
  unsigned char tmp = bufEnc;
  bufEnc = 0;
  return tmp;
}


