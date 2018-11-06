//------------------------------------------------------------------------------
// This is Open source software. You can place this code on your site, but don't
// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
// ��� ����������� ����������� ���������������� ��������. �� ������ ���������
// ��� �� ����� �����, �� �� �������� ������� ������ �� ��� YouTube-����� 
// "����������� � ���������" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
// �����: �������� ������ / Nadyrshin Ruslan
//------------------------------------------------------------------------------
#ifndef _LEDMATRIX_H
#define _LEDMATRIX_H

#include "..\types.h"


extern uint8_t ledmatrix_screenbuff[];


// ��������� �������������� �������
void ledmatrix_init(void);
// ��������� ��������� ������� Test �������
void ledmatrix_testmatrix(uint8_t TestOn);
// ��������� ������������� ������� �������. �������� 0-15
void ledmatrix_set_brightness(uint8_t Value);
// ��������� ��������� ����� ����� ��������� FillValue
void ledmatrix_fill_screenbuff(uint8_t FillValue);
// ��������� �������� ���������� ������ ����� �����
// ����� ������ ������� ��������� ��� ���� ��� ������ ��������
void ledmatrix_ScrollLeft(void);
// ��������� �������� ���������� ������ ����� ������
// ����� ����� ������� ��������� ��� ���� ��� ������ ��������
void ledmatrix_ScrollRight(void);
// ��������� ��������� ��������� ����������� � ������������ � ������� ������ ledmatrix_screenbuff
void ledmatrix_update_from_buff(void);

#endif