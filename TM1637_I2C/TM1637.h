
//-------------------------------------------------<   ������� ���������� ����������� TM1637  >----------------------------------------------------



#ifndef TM1637_H_
#define TM1637_H_


//-------------------------------------------------------------------------
//                            ������������ ����������
//-------------------------------------------------------------------------

#include <i2c.h>
#include <delay.h>




//-------------------------------------------------------------------------
//                        ���������� ��������� �����������
//-------------------------------------------------------------------------

#define ADDR_AUTO  0x40
#define ADDR_FIXED 0x44
#define READ_KEY   0x42	
#define TEST_MODE  0x48

#define STARTADDR  0xC0 
#define IND_1      0xC1
#define IND_2      0xC2
#define IND_3      0xC3
#define IND_4      0xC4
#define IND_5      0xC5
#define IND_6      0xC6

#define BRIGHT_1   0x80
#define BRIGHT_2   0x81
#define BRIGHT_4   0x82
#define BRIGHT_10  0x83
#define BRIGHT_11  0x84
#define BRIGHT_12  0x85
#define BRIGHT_13  0x86
#define BRIGHT_14  0x87

#define DISPLAY_ON 0x88
#define DISPLAY_Off 0x00

#define POINT_ON   1
#define POINT_OFF  0

#define INDEX_NEGATIVE_SIGN	16
#define INDEX_BLANK			17

#define TM1637_start  i2c_start()
#define TM1637_stop   i2c_stop()


#define D4036B 0
#define D4056A 1



//-------------------------------------------------------------------------
//                            ������������� ����������
//-------------------------------------------------------------------------

		unsigned char Cmd_SetAddr;
		unsigned char Cmd_DispCtrl;
		unsigned char _PointFlag; 	//_PointFlag=1:the clock point on
		unsigned char _DispType;
		unsigned char DecPoint;
		unsigned char BlankingFlag;  
        
        //nsigned char coding(unsigned char DispData);

static unsigned char TubeTab[] = {0x3f,0x06,0x5b,0x4f,
                                  0x66,0x6d,0x7d,0x07,
                                  0x7f,0x6f,0x77,0x7c,
                                  0x39,0x5e,0x79,0x71,
                                  0x40,0x00};               // �������������� 0~9,A,b,C,d,E,F,"-"," "    

void TM1637_writeByte(int wr_data) // �������� ������ ������ ������ �� ��������� I2C, � �������������� (ACK)
{
     i2c_write(wr_data);  
}



void TM1637_coding_all(unsigned char DispData[])// �������� ���� ���������
{
	unsigned char PointData; 
    char i;
	if(_PointFlag == POINT_ON) PointData = 0x80;
	else PointData = 0;
	for( i = 0;i < 4;i ++)
	{
		if(DispData[i] == 0x7f)DispData[i] = 0x00;
		else DispData[i] = TubeTab[DispData[i]] + PointData; 
	DispData[i] += 0x80;
	}
	if((_DispType == D4056A)&&(DecPoint != 3))
	{
	DispData[DecPoint] += 0x80;
	DecPoint = 3;
	}
}

unsigned char TM1637_coding(unsigned char DispData)//�������� 
{
	unsigned char PointData;
	if(_PointFlag == POINT_ON)PointData = 0x80;
	else PointData = 0;
	if(DispData == 0x7f) DispData = 0x00 + PointData;
	else DispData = TubeTab[DispData] + PointData;
	return DispData;
}

void TM1637_display_all(unsigned char DispData[]) // ���������! ���������� ���������� ������� ���� �� ������. 
											//�� ��������, ��� ����� ���������� ������ ����� �� 0x00 �� 0x0F ��� ��-������ �� 0 �� 15
{
  unsigned char SegData[4];
  char i;
  for(i = 0;i < 4;i ++)
  {
    SegData[i] = DispData[i];
  }
  TM1637_coding_all(SegData);
  TM1637_start;
  TM1637_writeByte(ADDR_AUTO);
  TM1637_stop;
  TM1637_start;
  TM1637_writeByte(Cmd_SetAddr);
  for(i=0;i < 4;i ++)
  {
    TM1637_writeByte(SegData[i]);
  }
  TM1637_stop;
  TM1637_start;
  TM1637_writeByte(Cmd_DispCtrl);
  TM1637_stop;
}

void TM1637_display(unsigned char BitAddr,unsigned char DispData)// ���������� ���� ������ (�� 0 �� 15)� ������������ �����  (�� 0 �� 3)
{
  unsigned char SegData;
  SegData = TM1637_coding(DispData);
  TM1637_writeByte(ADDR_FIXED);
  TM1637_stop;
  TM1637_start;
  TM1637_writeByte(BitAddr|STARTADDR);
  TM1637_writeByte(SegData);
  TM1637_stop;
  TM1637_start;
  TM1637_writeByte(Cmd_DispCtrl);
  TM1637_stop;
}


void TM1637_display_int_decimal(int Decimal)// ������ � ������������ ���������� ������������ � ������������ ����������.
                                                // ������� ����� ����� �� -999 �� 9999
{
	unsigned char temp[4];
	if((Decimal > 9999)||(Decimal < -999))return;
	if(Decimal < 0)
	{
		temp[0] = INDEX_NEGATIVE_SIGN;
		Decimal = (Decimal & 0x7fff);
		temp[1] = Decimal/100;
		Decimal %= 100;
		temp[2] = Decimal / 10;
		temp[3] = Decimal % 10;
		if(BlankingFlag)
		{
			if(temp[1] == 0)
			{
				temp[1] = INDEX_BLANK;
				if(temp[2] == 0) temp[2] = INDEX_BLANK;
			}
		}
	}
	else
	{
		temp[0] = Decimal/1000;
		Decimal %= 1000;
		temp[1] = Decimal/100;
		Decimal %= 100;
		temp[2] = Decimal / 10;
		temp[3] = Decimal % 10;
		if(BlankingFlag)
		{
			if(temp[0] == 0)
			{
				temp[0] = INDEX_BLANK;
				if(temp[1] == 0)
				{
					temp[1] = INDEX_BLANK;
					if(temp[2] == 0) temp[2] = INDEX_BLANK;
				}
			}
		}
	}
	BlankingFlag = 1;
	TM1637_display_all(temp);
} 

void TM1637_display_float_decimal(float Decimal) // ������ � ������������ ���������� ������������ � ������������ ����������. 
{												// ������� ����� � ��������� ������ �� -999 �� 9999
  int temp; 
  char i;
  if(Decimal > 9999)return;
  else if(Decimal < -999)return;
  if(Decimal > 0)
  {
	for(i = 3 ;i > 0; i --)
	{
	  if(Decimal < 1000)Decimal *= 10;
	  else break;
	}
	temp = (int)Decimal;
	if((Decimal - temp)>0.5)temp++;
  }
   else
  {
	for( i = 3;i > 1; i --)
	{
	  if(Decimal > -100)Decimal *= 10;
	  else break;
	}
	temp = (int)Decimal;
	if((temp - Decimal)>0.5)temp--;
  }
  DecPoint = i;
  BlankingFlag = 0;
  TM1637_display_int_decimal(temp);
}

void TM1637_clearDisplay(void) // ������ �������
{
  TM1637_display(0x00,INDEX_BLANK);
  TM1637_display(0x01,INDEX_BLANK);
  TM1637_display(0x02,INDEX_BLANK);
  TM1637_display(0x03,INDEX_BLANK);  
}


void TM1637_init(unsigned char DispType)// �������������� ����������, � ����� ������ �������
{
	i2c_init();  
    delay_us(10);
    _DispType = DispType;
	BlankingFlag = 1; 
    if(_DispType == D4056A) _PointFlag = POINT_ON;
    else _PointFlag = POINT_OFF;
	DecPoint = 3;
	TM1637_clearDisplay();
}


void TM1637_set(unsigned char brightness,unsigned char DispOnOff,unsigned char SetAddr)// �� �������� ����� ������ �� ��������� ������� �����
{
  Cmd_SetAddr = SetAddr;
  Cmd_DispCtrl = DispOnOff + brightness;
}


void TM1637_point(unsigned char PointFlag)//�� ���� ����� ����������, ����� �����
{
  if(_DispType == D4056A) _PointFlag = PointFlag;
}

#endif /* TM1637_H_ */