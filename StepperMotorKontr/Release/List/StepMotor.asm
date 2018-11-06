
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _OldStep=R5
	.DEF _OldDir=R4
	.DEF _OldSpeed=R7
	.DEF _EncState=R6
	.DEF _EncData=R9
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

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
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_Step2:
	.DB  0x53,0x74,0x65,0x70,0x3D,0x31,0x2F,0x32
	.DB  0x0
_Step4:
	.DB  0x53,0x74,0x65,0x70,0x3D,0x31,0x2F,0x34
	.DB  0x0
_rDir:
	.DB  0x90,0x44,0x69,0x72,0x65,0x63,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x3E,0x3E,0x3E,0x0
_lDir:
	.DB  0x50,0x44,0x69,0x72,0x65,0x63,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x3C,0x3C,0x3C,0x0
_mSpd:
	.DB  0x80,0x53,0x70,0x65,0x65,0x64,0x20,0x3D
	.DB  0x0
_msteps16:
	.DB  0x3,0x2,0x9,0x10,0x18,0x30,0x29,0x22
	.DB  0x23,0x26,0x2D,0x34,0x1C,0x14,0xD,0x6
_msteps8:
	.DB  0x3,0x9,0x18,0x29,0x23,0x2D,0x1C,0xD
_mspeed:
	.DB  0xF0,0xD8,0x78,0xEC,0xFB,0xF2,0x3C,0xF6
	.DB  0x30,0xF8,0x7D,0xF9,0x6B,0xFA,0x1E,0xFB
	.DB  0xA9,0xFB,0x18,0xFC

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x09
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 14.11.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <stdlib.h>
;
;// Declare your global variables here
;char OldStep, OldDir, OldSpeed;  // переменные для хранения предыдущих значений
;char Speed[];
;
;static char x = 0 ;            // переменные для работы с энкодером
;unsigned char EncState;
;unsigned char EncData = 0;
;
;
;
;flash unsigned char Step2[]={83,116,101,112,61,49,47,50,0}; /* "Step=1/2"      */
;flash unsigned char Step4[]={83,116,101,112,61,49,47,52,0};   /* "Step=1/4"      */
;flash unsigned char rDir[]={144,68,105,114,101,99,116,105,111,110,32,62,62,62,0};  /* "Direction >>>" */
;flash unsigned char lDir[]={80,68,105,114,101,99,116,105,111,110,32,60,60,60,0};  /* "Direction <<<" */
;flash unsigned char mSpd[]={128,83,112,101,101,100,32,61,0}; /* "Speed =" */
;
;
;
;
;// значения для управления драйверов ШД
;// в режиме 1/4 шага
;const unsigned char msteps16[16] = {
; 0b00000011,
; 0b00000010,
; 0b00001001,
; 0b00010000,
; 0b00011000,
; 0b00110000,
; 0b00101001,
; 0b00100010,
; 0b00100011,
; 0b00100110,
; 0b00101101,
; 0b00110100,
; 0b00011100,
; 0b00010100,
; 0b00001101,
; 0b00000110};
;
;// значения для управления драйверов ШД
;// в режиме 1/2 шага
;const unsigned char msteps8[8] = {
; 0b00000011,
; 0b00001001,
; 0b00011000,
; 0b00101001,
; 0b00100011,
; 0b00101101,
; 0b00011100,
; 0b00001101};
;
;// значения начальной установки таймера TIM1
;// для задания разных скоростей
;const unsigned int mspeed[10] = {
; 0xD8F0,  // 200 шагов в секунду
; 0xEC78,  // 400
; 0xF2FB,  // 600
; 0xF63C,  // 800
; 0xF830,  // 1000
; 0xF97D,  // 1200
; 0xFA6B,  // 1400
; 0xFB1E,  // 1600
; 0xFBA9,  // 1800
; 0xFC18   // 2000
;};
;
;// Объявления функций
;void LcdOut( char, char, char);
;void Step(char);
;void EncoderScan(void);
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0068 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x0
; 0000 0069     // Reinitialize Timer 0 value
; 0000 006A     TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 006B 
; 0000 006C     // Place your code here
; 0000 006D     // опрос энкодера
; 0000 006E     EncoderScan();
	RCALL _EncoderScan
; 0000 006F 
; 0000 0070      // проверка не изменялись ли состояния кнопок и энкодера
; 0000 0071      if ((PINB.2 != OldDir) || (PINB.3 != OldStep)||(EncData != OldSpeed)) {
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	MOV  R30,R4
	RCALL SUBOPT_0x1
	BRNE _0x4
	LDI  R26,0
	SBIC 0x16,3
	LDI  R26,1
	MOV  R30,R5
	RCALL SUBOPT_0x1
	BRNE _0x4
	CP   R7,R9
	BREQ _0x3
_0x4:
; 0000 0072 
; 0000 0073      // присвоения переменным текущих состояний кнопок и энкодера
; 0000 0074      OldDir = PINB.2;
	RCALL SUBOPT_0x2
	MOV  R4,R30
; 0000 0075      OldStep = PINB.3;
	RCALL SUBOPT_0x3
	MOV  R5,R30
; 0000 0076      OldSpeed = EncData;
	MOV  R7,R9
; 0000 0077 
; 0000 0078      // вывод на LCD состояний кнопок и энкодера
; 0000 0079      LcdOut(PINB.2, PINB.3, EncData);
	RCALL SUBOPT_0x2
	ST   -Y,R30
	RCALL SUBOPT_0x3
	ST   -Y,R30
	MOV  R26,R9
	RCALL _LcdOut
; 0000 007A 
; 0000 007B      };
_0x3:
; 0000 007C 
; 0000 007D }
	RJMP _0x26
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0081 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x0
; 0000 0082     // Reinitialize Timer1 value
; 0000 0083     TCNT1H=mspeed[EncData] >> 8;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0084     TCNT1L=mspeed[EncData] & 0xff;
	LPM  R30,Z
	OUT  0x2C,R30
; 0000 0085 
; 0000 0086     // Place your code here
; 0000 0087     //вывод управляющей последовательности на доайвер ШД
; 0000 0088     //в режиме шага зависящего от состояния кнопки
; 0000 0089     if (PINB.2) {
	SBIS 0x16,2
	RJMP _0x6
; 0000 008A                 Step(1);
	LDI  R26,LOW(1)
	RJMP _0x22
; 0000 008B             }
; 0000 008C             else  {
_0x6:
; 0000 008D                 Step(-1);
	LDI  R26,LOW(255)
_0x22:
	RCALL _Step
; 0000 008E             };
; 0000 008F 
; 0000 0090 }
_0x26:
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
; .FEND
;
;
;// Функция для работы с энкодером
;// EncState глобальная переменная  -- предыдущее состояние энкодера
;// EncData глобальная переменная  -- счетный регистр энкодера
;void EncoderScan(void)
; 0000 0097 {
_EncoderScan:
; .FSTART _EncoderScan
; 0000 0098     unsigned char New;
; 0000 0099     New = PINB & 0x03;   // Берем текущее значение
	ST   -Y,R17
;	New -> R17
	IN   R30,0x16
	ANDI R30,LOW(0x3)
	MOV  R17,R30
; 0000 009A                         // И сравниваем со старым
; 0000 009B                         // Смотря в какую сторону оно поменялось -- увеличиваем
; 0000 009C                         // Или уменьшаем счетный регистр
; 0000 009D     switch(EncState)
	MOV  R30,R6
	LDI  R31,0
; 0000 009E         {
; 0000 009F         case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB
; 0000 00A0                 {
; 0000 00A1                 if(New == 3) EncData++;
	CPI  R17,3
	BRNE _0xC
	INC  R9
; 0000 00A2                 if(New == 0) EncData--;
_0xC:
	CPI  R17,0
	BRNE _0xD
	DEC  R9
; 0000 00A3                 break;
_0xD:
	RJMP _0xA
; 0000 00A4                 }
; 0000 00A5         case 0:
_0xB:
	SBIW R30,0
	BRNE _0xE
; 0000 00A6                 {
; 0000 00A7                 if(New == 2) EncData++;
	CPI  R17,2
	BRNE _0xF
	INC  R9
; 0000 00A8                 if(New == 1) EncData--;
_0xF:
	CPI  R17,1
	BRNE _0x10
	DEC  R9
; 0000 00A9                 break;
_0x10:
	RJMP _0xA
; 0000 00AA                 }
; 0000 00AB         case 1:
_0xE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11
; 0000 00AC                 {
; 0000 00AD                 if(New == 0) EncData++;
	CPI  R17,0
	BRNE _0x12
	INC  R9
; 0000 00AE                 if(New == 3) EncData--;
_0x12:
	CPI  R17,3
	BRNE _0x13
	DEC  R9
; 0000 00AF                 break;
_0x13:
	RJMP _0xA
; 0000 00B0                 }
; 0000 00B1         case 3:
_0x11:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA
; 0000 00B2                 {
; 0000 00B3                 if(New == 1) EncData++;
	CPI  R17,1
	BRNE _0x15
	INC  R9
; 0000 00B4                 if(New == 2) EncData--;
_0x15:
	CPI  R17,2
	BRNE _0x16
	DEC  R9
; 0000 00B5                 break;
_0x16:
; 0000 00B6                 }
; 0000 00B7         }
_0xA:
; 0000 00B8     EncState = New; // Записываем новое значение
	MOV  R6,R17
; 0000 00B9                     // Предыдущего состояния
; 0000 00BA     if (EncData > 9) {
	LDI  R30,LOW(9)
	CP   R30,R9
	BRSH _0x17
; 0000 00BB        EncData = 0;     // ограничиваем выходное значение
	CLR  R9
; 0000 00BC     };
_0x17:
; 0000 00BD 
; 0000 00BE }
	LD   R17,Y+
	RET
; .FEND
;
;
;// функция для вывода значений на LCD
;void LcdOut(char Dir, char NStp, char Spd)
; 0000 00C3 {
_LcdOut:
; .FSTART _LcdOut
; 0000 00C4     lcd_clear();
	ST   -Y,R26
;	Dir -> Y+2
;	NStp -> Y+1
;	Spd -> Y+0
	RCALL _lcd_clear
; 0000 00C5     if (NStp) {
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x18
; 0000 00C6             //lcd_putsf("Step=1/2");
; 0000 00C7             lcd_putsf(Step2);
	LDI  R26,LOW(_Step2*2)
	LDI  R27,HIGH(_Step2*2)
	RJMP _0x23
; 0000 00C8          }
; 0000 00C9          else  {
_0x18:
; 0000 00CA             //lcd_putsf("Step=1/4");
; 0000 00CB             lcd_putsf(Step4);
	LDI  R26,LOW(_Step4*2)
	LDI  R27,HIGH(_Step4*2)
_0x23:
	RCALL _lcd_putsf
; 0000 00CC     };
; 0000 00CD     itoa(Spd+1,Speed);
	LD   R30,Y
	LDI  R31,0
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Speed)
	LDI  R27,HIGH(_Speed)
	RCALL _itoa
; 0000 00CE     //lcd_putsf(" Speed=");
; 0000 00CF     lcd_putsf(mSpd);
	LDI  R26,LOW(_mSpd*2)
	LDI  R27,HIGH(_mSpd*2)
	RCALL _lcd_putsf
; 0000 00D0     lcd_puts(Speed);
	LDI  R26,LOW(_Speed)
	LDI  R27,HIGH(_Speed)
	RCALL _lcd_puts
; 0000 00D1     if (Dir) {
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x1A
; 0000 00D2             //lcd_putsf(" Direction >>>");
; 0000 00D3             lcd_putsf(rDir);
	LDI  R26,LOW(_rDir*2)
	LDI  R27,HIGH(_rDir*2)
	RJMP _0x24
; 0000 00D4          }
; 0000 00D5          else  {
_0x1A:
; 0000 00D6             //lcd_putsf(" Direction <<<");
; 0000 00D7             lcd_putsf(lDir);
	LDI  R26,LOW(_lDir*2)
	LDI  R27,HIGH(_lDir*2)
_0x24:
	RCALL _lcd_putsf
; 0000 00D8     };
; 0000 00D9 
; 0000 00DA }
	RJMP _0x20A0003
; .FEND
;
;// функция для вывода управляющих последовательностей
;// в порт упавления драйверов ШД
;void Step(char Dir)
; 0000 00DF {
_Step:
; .FSTART _Step
; 0000 00E0     if (PINB.3) {
	ST   -Y,R26
;	Dir -> Y+0
	SBIS 0x16,3
	RJMP _0x1C
; 0000 00E1         x = (8 + x + Dir) & 7;
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(8)
	LD   R26,Y
	ADD  R26,R30
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x7
; 0000 00E2         PORTD = msteps8[x];
	SUBI R30,LOW(-_msteps8*2)
	SBCI R31,HIGH(-_msteps8*2)
	RJMP _0x25
; 0000 00E3     }
; 0000 00E4     else  {
_0x1C:
; 0000 00E5         x = (16 + x + Dir) & 15;
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(16)
	LD   R26,Y
	ADD  R26,R30
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x7
; 0000 00E6         PORTD = msteps16[x];
	SUBI R30,LOW(-_msteps16*2)
	SBCI R31,HIGH(-_msteps16*2)
_0x25:
	LPM  R0,Z
	OUT  0x12,R0
; 0000 00E7 
; 0000 00E8     };
; 0000 00E9 
; 0000 00EA }
	RJMP _0x20A0001
; .FEND
;
;
;void main(void)
; 0000 00EE {
_main:
; .FSTART _main
; 0000 00EF // Declare your local variables here
; 0000 00F0 
; 0000 00F1 // Input/Output Ports initialization
; 0000 00F2 // Port B initialization
; 0000 00F3 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00F4 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(16)
	OUT  0x17,R30
; 0000 00F5 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 00F6 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 00F7 
; 0000 00F8 // Port C initialization
; 0000 00F9 // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00FA DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(63)
	OUT  0x14,R30
; 0000 00FB // State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00FC PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00FD 
; 0000 00FE // Port D initialization
; 0000 00FF // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0100 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0101 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0102 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0103 
; 0000 0104 // Timer/Counter 0 initialization
; 0000 0105 // Clock source: System Clock
; 0000 0106 // Clock value: 250,000 kHz
; 0000 0107 TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0108 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0109 
; 0000 010A // Timer/Counter 1 initialization
; 0000 010B // Clock source: System Clock
; 0000 010C // Clock value: 2000,000 kHz
; 0000 010D // Mode: Normal top=0xFFFF
; 0000 010E // OC1A output: Disconnected
; 0000 010F // OC1B output: Disconnected
; 0000 0110 // Noise Canceler: Off
; 0000 0111 // Input Capture on Falling Edge
; 0000 0112 // Timer Period: 5 ms
; 0000 0113 // Timer1 Overflow Interrupt: On
; 0000 0114 // Input Capture Interrupt: Off
; 0000 0115 // Compare A Match Interrupt: Off
; 0000 0116 // Compare B Match Interrupt: Off
; 0000 0117 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0118 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0119 TCNT1H=mspeed[EncData] >> 8;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 011A TCNT1L=mspeed[EncData] & 0xff;
	LPM  R30,Z
	OUT  0x2C,R30
; 0000 011B ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 011C ICR1L=0x00;
	OUT  0x26,R30
; 0000 011D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 011E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 011F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0120 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0121 
; 0000 0122 // Timer/Counter 2 initialization
; 0000 0123 // Clock source: System Clock
; 0000 0124 // Clock value: Timer2 Stopped
; 0000 0125 // Mode: Normal top=0xFF
; 0000 0126 // OC2 output: Disconnected
; 0000 0127 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0128 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0129 TCNT2=0x00;
	OUT  0x24,R30
; 0000 012A OCR2=0x00;
	OUT  0x23,R30
; 0000 012B 
; 0000 012C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 012D TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 012E 
; 0000 012F // External Interrupt(s) initialization
; 0000 0130 // INT0: Off
; 0000 0131 // INT1: Off
; 0000 0132 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0133 
; 0000 0134 // USART initialization
; 0000 0135 // USART disabled
; 0000 0136 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0137 
; 0000 0138 // Analog Comparator initialization
; 0000 0139 // Analog Comparator: Off
; 0000 013A // The Analog Comparator's positive input is
; 0000 013B // connected to the AIN0 pin
; 0000 013C // The Analog Comparator's negative input is
; 0000 013D // connected to the AIN1 pin
; 0000 013E ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 013F SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0140 
; 0000 0141 // ADC initialization
; 0000 0142 // ADC disabled
; 0000 0143 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0144 
; 0000 0145 // SPI initialization
; 0000 0146 // SPI disabled
; 0000 0147 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0148 
; 0000 0149 // TWI initialization
; 0000 014A // TWI disabled
; 0000 014B TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 014C 
; 0000 014D // Alphanumeric LCD initialization
; 0000 014E // Connections are specified in the
; 0000 014F // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0150 // RS - PORTC Bit 0
; 0000 0151 // RD - PORTB Bit 4
; 0000 0152 // EN - PORTC Bit 1
; 0000 0153 // D4 - PORTC Bit 2
; 0000 0154 // D5 - PORTC Bit 3
; 0000 0155 // D6 - PORTC Bit 4
; 0000 0156 // D7 - PORTC Bit 5
; 0000 0157 // Characters/line: 16
; 0000 0158 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0159 
; 0000 015A // Вывод на индикатор начальных состояний кнопок и скорости
; 0000 015B LcdOut(PINB.2, PINB.3, EncData);
	RCALL SUBOPT_0x2
	ST   -Y,R30
	RCALL SUBOPT_0x3
	ST   -Y,R30
	MOV  R26,R9
	RCALL _LcdOut
; 0000 015C 
; 0000 015D // Global enable interrupts
; 0000 015E #asm("sei")
	sei
; 0000 015F 
; 0000 0160 while (1)
_0x1E:
; 0000 0161       {
; 0000 0162       // Place your code here
; 0000 0163 
; 0000 0164       }
	RJMP _0x1E
; 0000 0165 }
_0x21:
	RJMP _0x21
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,2
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,2
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,3
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,3
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,4
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,4
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,5
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,5
_0x200000B:
	RCALL SUBOPT_0x8
	SBI  0x15,1
	RCALL SUBOPT_0x8
	CBI  0x15,1
	RCALL SUBOPT_0x8
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R11,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x9
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R8,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R8,R10
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R11
	MOV  R26,R11
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20A0001
_0x2000013:
_0x2000010:
	INC  R8
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	RJMP _0x20A0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
_0x20A0002:
	LDD  R17,Y+0
_0x20A0003:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,2
	SBI  0x14,3
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,1
	SBI  0x14,0
	SBI  0x17,4
	CBI  0x15,1
	CBI  0x15,0
	CBI  0x18,4
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xA
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_Speed:
	.BYTE 0x1
_x_G000:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,0
	SBIC 0x16,3
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4:
	MOV  R30,R9
	LDI  R26,LOW(_mspeed*2)
	LDI  R27,HIGH(_mspeed*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	RCALL __GETW1PF
	MOV  R30,R31
	LDI  R31,0
	OUT  0x2D,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,_x_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	AND  R30,R26
	STS  _x_G000,R30
	RCALL SUBOPT_0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

;END OF CODE MARKER
__END_OF_CODE:
