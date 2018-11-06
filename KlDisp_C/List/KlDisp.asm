
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 4,000000 MHz
;Memory model             : Tiny
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _keyState=R3
	.DEF _keyCode=R2
	.DEF _keyValue=R5
	.DEF _keyDown=R4
	.DEF _keyNew=R7

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _Timer0Ovf
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_keyTable:
	.DB  0x11,0x31,0x12,0x32,0x14,0x33,0x21,0x34
	.DB  0x22,0x35,0x24,0x36,0x41,0x37,0x42,0x38
	.DB  0x44,0x39,0x81,0x2A,0x82,0x30,0x84,0x23

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;//***************************************************************************
;//
;//  Author(s)...:
;//
;//  Target(s)...: ATtyny2313
;//
;//  Compiler....: CodeVision
;//
;//  Description.: Опрос матричной клавиатуры. Использование конечного автомата.
;//
;//  Data........:
;//
;//***************************************************************************
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include "keyboard.h"
;
;#define SDO PORTB.1
;#define SCK PORTB.0
;
;//прерывание таймера Т0 - опрос клавиатуры
;interrupt [TIM0_OVF] void Timer0Ovf(void)
; 0000 0016 {

	.CSEG
_Timer0Ovf:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0017    TCNT0 = 0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0018    ScanKeyboard();
	RCALL _ScanKeyboard
; 0000 0019 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void spi_write ( unsigned char datum )
; 0000 001C {
_spi_write:
; 0000 001D     int k;
; 0000 001E     for (k=0; k<4; k++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	datum -> Y+2
;	k -> R16,R17
	__GETWRN 16,17,0
_0x4:
	__CPWRN 16,17,4
	BRGE _0x5
; 0000 001F     {
; 0000 0020         if((datum & 0x08)) { SDO = 1;}
	LDD  R30,Y+2
	ANDI R30,LOW(0x8)
	BREQ _0x6
	SBI  0x18,1
; 0000 0021         else {SDO = 0;}
	RJMP _0x9
_0x6:
	CBI  0x18,1
_0x9:
; 0000 0022         datum = datum <<1;
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0000 0023         SCK = 1;
	SBI  0x18,0
; 0000 0024         SCK = 0;
	CBI  0x18,0
; 0000 0025     }
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0026     SDO = 0;
	CBI  0x18,1
; 0000 0027 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;void main( void )
; 0000 002A {
_main:
; 0000 002B   unsigned char key;
; 0000 002C 
; 0000 002D 
; 0000 002E   //инициализация таймера Т0
; 0000 002F   TIMSK = (1<<TOIE0); //разрешение прерывания по переполнению
;	key -> R17
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0030   TCCR0 = (1<<CS02)|(0<<CS01)|(0<<CS00); //предделитель 256
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0031   TCNT0 = 0x83; //прерывания каждые 8 мс  при тактовой частоте 4 МГц
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0032 
; 0000 0033   //инициализация портов и переменных
; 0000 0034   InitKeyboard();
	RCALL _InitKeyboard
; 0000 0035   #asm("sei");
	sei
; 0000 0036 
; 0000 0037   while(1){
_0x12:
; 0000 0038     //если зафиксировано нажатие,
; 0000 0039     //отправить код кнопки в терминал
; 0000 003A     key = GetKey();
	RCALL _GetKey
	MOV  R17,R30
; 0000 003B     if (key)
	CPI  R17,0
	BREQ _0x15
; 0000 003C       spi_write(key);
	MOV  R26,R17
	RCALL _spi_write
; 0000 003D   }
_0x15:
	RJMP _0x12
; 0000 003E }
_0x16:
	RJMP _0x16
;#include "keyboard.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include "delay.h"
;//хранит текущее состояние автомата
;unsigned char keyState;
;//хранит код нажатой кнопки
;unsigned char keyCode;
;//хранит символьное значение нажатой кнопки
;unsigned char keyValue;
;//флаговая переменная - устанавливается, если кнопка удерживается
;unsigned char keyDown;
;//флаговая переменная -  устанавливается, когда нажата новая кнопка
;unsigned char keyNew;
;
;//таблица перекодировки
;__flash unsigned char keyTable[][2] = {
;{ 0x11, '1'},
;{ 0x12, '2'},
;{ 0x14, '3'},
;{ 0x21, '4'},
;{ 0x22, '5'},
;{ 0x24, '6'},
;{ 0x41, '7'},
;{ 0x42, '8'},
;{ 0x44, '9'},
;{ 0x81, '*'},
;{ 0x82, '0'},
;{ 0x84, '#'}
;};
;
;//прототипы функций используемых автоматом
;unsigned char AnyKey(void);
;unsigned char SameKey(void);
;void ScanKey(void);
;unsigned char FindKey(void);
;void ClearKey(void);
;
;//инициализация портов, обнуление переменных
;void InitKeyboard(void)
; 0001 0027 {

	.CSEG
_InitKeyboard:
; 0001 0028   DDRB = 0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 0029   PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 002A   DDRD = 0x00;
	OUT  0x11,R30
; 0001 002B   PORTD = 0xf8;
	LDI  R30,LOW(248)
	OUT  0x12,R30
; 0001 002C 
; 0001 002D   keyState = 0;
	CLR  R3
; 0001 002E   keyCode = 0;
	CLR  R2
; 0001 002F   keyValue = 0;
	CLR  R5
; 0001 0030   keyDown = 0;
	CLR  R4
; 0001 0031   keyNew = 0;
	CLR  R7
; 0001 0032 }
	RET
;
;//автомат реализующий опрос клавиатуры, защиту от дребезга
;// и распознование нажатой кнопки
;void ScanKeyboard(void)
; 0001 0037 {
_ScanKeyboard:
; 0001 0038    switch (keyState){
	MOV  R30,R3
	LDI  R31,0
; 0001 0039      case 0:
	SBIW R30,0
	BRNE _0x20006
; 0001 003A        if (AnyKey()) {
	RCALL _AnyKey
	CPI  R30,0
	BREQ _0x20007
; 0001 003B          ScanKey();
	RCALL _ScanKey
; 0001 003C          keyState = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0001 003D        }
; 0001 003E        break;
_0x20007:
	RJMP _0x20005
; 0001 003F 
; 0001 0040      case 1:
_0x20006:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20008
; 0001 0041        if (SameKey()) {
	RCALL _SameKey
	CPI  R30,0
	BREQ _0x20009
; 0001 0042            FindKey();
	RCALL _FindKey
; 0001 0043            keyState = 2;
	LDI  R30,LOW(2)
	MOV  R3,R30
; 0001 0044        }
; 0001 0045        else keyState = 0;
	RJMP _0x2000A
_0x20009:
	CLR  R3
; 0001 0046        break;
_0x2000A:
	RJMP _0x20005
; 0001 0047 
; 0001 0048      case 2:
_0x20008:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2000B
; 0001 0049         if (SameKey()){}
	RCALL _SameKey
	CPI  R30,0
	BRNE _0x2000D
; 0001 004A         else keyState = 3;
	LDI  R30,LOW(3)
	MOV  R3,R30
; 0001 004B         break;
_0x2000D:
	RJMP _0x20005
; 0001 004C 
; 0001 004D      case 3:
_0x2000B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20011
; 0001 004E        if (SameKey()) {
	RCALL _SameKey
	CPI  R30,0
	BREQ _0x2000F
; 0001 004F          keyState = 2;
	LDI  R30,LOW(2)
	MOV  R3,R30
; 0001 0050        }
; 0001 0051        else {
	RJMP _0x20010
_0x2000F:
; 0001 0052          ClearKey();
	RCALL _ClearKey
; 0001 0053          keyState = 0;
	CLR  R3
; 0001 0054        }
_0x20010:
; 0001 0055        break;
; 0001 0056 
; 0001 0057      default:
_0x20011:
; 0001 0058         break;
; 0001 0059    }
_0x20005:
; 0001 005A 
; 0001 005B }
	RET
;
;//возвращает true если какая-нибудь кнопка нажата
;unsigned char AnyKey(void)
; 0001 005F {
_AnyKey:
; 0001 0060   unsigned char temp;
; 0001 0061   PORTB |= 0xf0;
	ST   -Y,R17
;	temp -> R17
	IN   R30,0x18
	ORI  R30,LOW(0xF0)
	OUT  0x18,R30
; 0001 0062   delay_us(5);
	__DELAY_USB 7
; 0001 0063   temp = (PIND & 0x07);
	IN   R30,0x10
	ANDI R30,LOW(0x7)
	MOV  R17,R30
; 0001 0064   PORTB &= 0x0f;
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0001 0065   return temp;
	MOV  R30,R17
	RJMP _0x2000001
; 0001 0066 }
;
;
;//Генерирует нужные сигналы на линиях
;//считывает код нажатой кнопки
;void ScanKey(void)
; 0001 006C {
_ScanKey:
; 0001 006D   unsigned char activeRow = (1<<4);
; 0001 006E   while (activeRow) {
	ST   -Y,R17
;	activeRow -> R17
	LDI  R17,16
_0x20012:
	CPI  R17,0
	BREQ _0x20014
; 0001 006F     PORTB = (PINB & 0x0f)|activeRow;
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	OR   R30,R17
	OUT  0x18,R30
; 0001 0070     delay_us(5);
	__DELAY_USB 7
; 0001 0071     if (PIND & 0x07) {
	IN   R30,0x10
	ANDI R30,LOW(0x7)
	BREQ _0x20015
; 0001 0072       keyCode = (PIND & 0x07);
	IN   R30,0x10
	ANDI R30,LOW(0x7)
	MOV  R2,R30
; 0001 0073       keyCode |= (PINB & 0xf0);
	IN   R30,0x16
	ANDI R30,LOW(0xF0)
	OR   R2,R30
; 0001 0074     }
; 0001 0075     activeRow <<= 1;
_0x20015:
	LSL  R17
; 0001 0076   }
	RJMP _0x20012
_0x20014:
; 0001 0077   PORTB &= 0x0f;
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0001 0078 }
	RJMP _0x2000001
;
;// возвращает true если удерживается та же кнопка
;//что и в предыдущем цикле опроса
;unsigned char SameKey(void)
; 0001 007D {
_SameKey:
; 0001 007E   unsigned char temp;
; 0001 007F   PORTB = (PINB & 0x0f) | ( keyCode & 0xf0);
	ST   -Y,R17
;	temp -> R17
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R2
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
; 0001 0080   delay_us(5);
	__DELAY_USB 7
; 0001 0081   temp = ((PIND & keyCode) & 0x07);
	IN   R30,0x10
	AND  R30,R2
	ANDI R30,LOW(0x7)
	MOV  R17,R30
; 0001 0082   PORTB &= 0x0f;
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0001 0083   return temp;
	MOV  R30,R17
	RJMP _0x2000001
; 0001 0084 }
;
;// преобразует код кнопки в соответствующий символ
;// устанавивает флаги
;unsigned char FindKey(void)
; 0001 0089 {
_FindKey:
; 0001 008A   unsigned char index;
; 0001 008B   for (index = 0; index < 12; index++) {
	ST   -Y,R17
;	index -> R17
	LDI  R17,LOW(0)
_0x20017:
	CPI  R17,12
	BRSH _0x20018
; 0001 008C     if (keyTable [index][0] == keyCode) {
	MOV  R30,R17
	LDI  R26,LOW(_keyTable*2)
	LDI  R27,HIGH(_keyTable*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LPM  R26,Z
	CP   R2,R26
	BRNE _0x20019
; 0001 008D       keyValue = keyTable [index][1];
	MOV  R30,R17
	LDI  R26,LOW(_keyTable*2)
	LDI  R27,HIGH(_keyTable*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	LPM  R5,Z
; 0001 008E       keyDown = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0001 008F       keyNew = 1;
	MOV  R7,R30
; 0001 0090       return 1;
	RJMP _0x2000001
; 0001 0091     }
; 0001 0092   }
_0x20019:
	SUBI R17,-1
	RJMP _0x20017
_0x20018:
; 0001 0093   return 0;
	LDI  R30,LOW(0)
_0x2000001:
	LD   R17,Y+
	RET
; 0001 0094 }
;
;//сбрасывает флаг
;void ClearKey(void)
; 0001 0098 {
_ClearKey:
; 0001 0099   keyDown = 0;
	CLR  R4
; 0001 009A }
	RET
;
;//если зафиксировано нажатие кнопки
;//возвращает ее код
;unsigned char GetKey(void)
; 0001 009F {
_GetKey:
; 0001 00A0   if (keyNew){
	TST  R7
	BREQ _0x2001A
; 0001 00A1     keyNew = 0;
	CLR  R7
; 0001 00A2     return keyValue;
	MOV  R30,R5
	RET
; 0001 00A3   }
; 0001 00A4   else
_0x2001A:
; 0001 00A5     return 0;
	LDI  R30,LOW(0)
	RET
; 0001 00A6 }
	RET

	.CSEG

	.CSEG
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
