//------------------------------------------------------------------------------
// This is Open source software. You can place this code on your site, but don't
// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
// ��� ����������� ����������� ���������������� ��������. �� ������ ���������
// ��� �� ����� �����, �� �� �������� ������� ������ �� ��� YouTube-����� 
// "����������� � ���������" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
// �����: �������� ������ / Nadyrshin Ruslan
//------------------------------------------------------------------------------
#include "font.h"
#include "f6x8m.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>


// ������� ����� ��� ������ ������
uint8_t FontID = FONTID_6X8M;

// ������� � ����������� �� ������� ���������� ������� ������� ������. ����� ���� ����
const t_font_getchar font_table_funcs[] = 
{
  f6x8_GetCharTable
};


//==============================================================================
// ��������� ������ �����
//==============================================================================
void font_ChangeFont(uint8_t NewFont)
{
  FontID = NewFont;
}
//==============================================================================


//==============================================================================
// ������� ���������� ������ ������� Char � ��������
//==============================================================================
uint8_t font_GetCharWidth(uint8_t Char)
{
  uint8_t *pCharTable = font_table_funcs[FontID](Char);
  return *pCharTable;  // ������ �������
}
//==============================================================================

const uint8_t Table[] = {
   f6x8_MONO_WIDTH,
   f6x8_MONO_HEIGHT,
   ________,
   ________,
   X__X____,
   X_X_X___,
   XXX_X___,
   X_X_X___,
   X__X____,
   ________};

//==============================================================================
// ������� ������ ������� Char � ����� �� ������ ����
// 1 ���� ������ = 1 ������� ������������ ����������
// ���������� ���-�� �������������� ��������, 0 - ���� �� ������� ����� ������ (BuffLen)
//==============================================================================
uint8_t font_DrawChar(uint8_t Char, uint8_t *pColumnBuff, uint16_t BuffLen)
{
  // ��������� �� ����������� ����������� ������� ������
  uint8_t *pCharTable = font_table_funcs[FontID](Char);
  uint8_t CharWidth = *(pCharTable++);  // ������ �������
  uint8_t CharHeight = *(pCharTable++); // ������ �������
  uint8_t col;
  uint8_t row;    
  
  if (CharWidth > BuffLen)
    return 0;
  for (col = 0; col < CharWidth; col++)
  {
    uint8_t ColBuff = 0;
    
    for (row = 0; row < CharHeight; row++)
    {
      if (pCharTable[row] & (1 << (7 - col)))
        ColBuff |= (1 << row);
    }
    
    *pColumnBuff = ColBuff;
    pColumnBuff++;
  }
  
  return CharWidth;
}
//==============================================================================


//==============================================================================
// ������� ������ ������ �� ������ Str � ����� �� ������ ����
// 1 ���� ������ = 1 ������� ������������ ����������
// ���������� ���-�� �������������� ��������, 0 - ���� �� ������� ����� ������ (BuffLen)
//==============================================================================
uint16_t font_DrawString(uint8_t *Str, uint8_t *pColumnBuff, uint16_t BuffLen)
{
  uint16_t BuffOffset = 0;
  uint8_t *StrTemp = Str;
    
  // ������� ����� ������������ ������ ��� ���������� ���� �������� ������
  while (*StrTemp != '\0')
  {
    BuffOffset += font_GetCharWidth(*StrTemp);
    StrTemp++;

    if (BuffOffset > BuffLen)     // �������������� ������ �� ��������� � ������
      return 0;
  }
  
  BuffOffset = 0;
  StrTemp = Str;
  
  // ������� ����� ������������ ������ ��� ���������� ���� �������� ������
  while (*StrTemp != '\0')
  {
    // ������� ��������� ������
    uint8_t Width = font_DrawChar(*StrTemp, pColumnBuff, BuffLen - BuffOffset);
    BuffOffset += Width;
    pColumnBuff += Width;
    StrTemp++;
  }

  return BuffOffset;
}
//==============================================================================


//==============================================================================
// ������� ���������������� ������ � ����� �� ������ ����
// 1 ���� ������ = 1 ������� ������������ ����������
// ���������� ���-�� �������������� ��������, 0 - ���� �� ������� ����� ������ (BuffLen)
//==============================================================================
uint16_t font_printf(uint8_t *pColumnBuff, uint16_t BuffLen, flash char *args, ...)
{
  char font_Buff[40];
  char len;
  
  va_list ap;
  va_start(ap, args);
  len = vsnprintf(font_Buff, sizeof(font_Buff), args, ap);
  va_end(ap);

  return font_DrawString((uint8_t *)font_Buff, pColumnBuff, BuffLen);
}
//==============================================================================
