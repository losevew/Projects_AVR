
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
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
	.DEF _NewState=R5
	.DEF _OldState=R4
	.DEF _upState=R7
	.DEF _downState=R6
	.DEF _OldVol=R8
	.DEF _OldVol_msb=R9
	.DEF _Vol=R10
	.DEF _Vol_msb=R11
	.DEF _MaxVol=R12
	.DEF _MaxVol_msb=R13

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
	RJMP 0x00
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

_progress_bar_G001:
	.DB  0x0,0x10,0x18,0x1C,0x1E,0x1F

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x7F,0x0,0xFF,0x0

_0x3:
	.DB  0x43,0xBA,0xB3,0x61,0xB6,0xBD,0x6F,0x63
	.DB  0xBF,0xC4
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x0A
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _Mes0
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

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
;Date    : 05.01.2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;//#include <mega8.h>
;#include "hd44780.h"
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
;// Declare your global variables here
;
;unsigned char NewState, OldState,  upState, downState;
;int OldVol ;
;int Vol = 127;
;uint8_t Mes0[]={67,186,179,97,182,189,111,99,191,196,0};

	.DSEG
;int MaxVol = 255;
;int MinVol = 0;
;
;void EncoderScan(void);
;void LcdOut (unsigned char);
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0029 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
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
; 0000 002A     // Reinitialize Timer 0 value
; 0000 002B     TCNT0=0xAD;
	LDI  R30,LOW(173)
	OUT  0x32,R30
; 0000 002C     // Place your code here
; 0000 002D     EncoderScan();
	RCALL _EncoderScan
; 0000 002E 
; 0000 002F }
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
;void EncoderScan(void)
; 0000 0032 {
_EncoderScan:
; .FSTART _EncoderScan
; 0000 0033     NewState = PINB & 0x03;
	IN   R30,0x16
	ANDI R30,LOW(0x3)
	MOV  R5,R30
; 0000 0034     if (NewState != OldState) {
	CP   R4,R5
	BRNE PC+2
	RJMP _0x4
; 0000 0035         switch (OldState) {
	MOV  R30,R4
	LDI  R31,0
; 0000 0036             case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8
; 0000 0037                 {
; 0000 0038                 if (NewState == 3)upState++;
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x9
	INC  R7
; 0000 0039                 if (NewState == 0)downState++;
_0x9:
	TST  R5
	BRNE _0xA
	INC  R6
; 0000 003A                 break;
_0xA:
	RJMP _0x7
; 0000 003B                 }
; 0000 003C             case 0:
_0x8:
	SBIW R30,0
	BRNE _0xB
; 0000 003D                 {
; 0000 003E                 if (NewState == 2)upState++;
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0xC
	INC  R7
; 0000 003F                 if (NewState == 1)downState++;
_0xC:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xD
	INC  R6
; 0000 0040                 break;
_0xD:
	RJMP _0x7
; 0000 0041                 }
; 0000 0042             case 1:
_0xB:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE
; 0000 0043                 {
; 0000 0044                 if (NewState == 0)upState++;
	TST  R5
	BRNE _0xF
	INC  R7
; 0000 0045                 if (NewState == 3)downState++;
_0xF:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x10
	INC  R6
; 0000 0046                 break;
_0x10:
	RJMP _0x7
; 0000 0047                 }
; 0000 0048             case 3:
_0xE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7
; 0000 0049                 {
; 0000 004A                 if (NewState == 1)upState++;
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x12
	INC  R7
; 0000 004B                 if (NewState == 2)downState++;
_0x12:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x13
	INC  R6
; 0000 004C                 break;
_0x13:
; 0000 004D                 }
; 0000 004E         };
_0x7:
; 0000 004F         OldState = NewState;
	MOV  R4,R5
; 0000 0050         if (upState >= 4) {
	LDI  R30,LOW(4)
	CP   R7,R30
	BRLO _0x14
; 0000 0051             Vol+=5;
	MOVW R30,R10
	ADIW R30,5
	MOVW R10,R30
; 0000 0052             upState = 0;
	CLR  R7
; 0000 0053         };
_0x14:
; 0000 0054         if (downState >= 4) {
	LDI  R30,LOW(4)
	CP   R6,R30
	BRLO _0x15
; 0000 0055             Vol-=5;
	MOVW R30,R10
	SBIW R30,5
	MOVW R10,R30
; 0000 0056             downState = 0;
	CLR  R6
; 0000 0057         };
_0x15:
; 0000 0058 
; 0000 0059     };
_0x4:
; 0000 005A 
; 0000 005B }
	RET
; .FEND
;
;
;
;void main(void)
; 0000 0060 {
_main:
; .FSTART _main
; 0000 0061 // Declare your local variables here
; 0000 0062 
; 0000 0063 // Input/Output Ports initialization
; 0000 0064 // Port B initialization
; 0000 0065 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0066 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(24)
	OUT  0x17,R30
; 0000 0067 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=P Bit0=P
; 0000 0068 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(3)
	OUT  0x18,R30
; 0000 0069 
; 0000 006A // Port C initialization
; 0000 006B // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 006C DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(63)
	OUT  0x14,R30
; 0000 006D // State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 006E PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 006F 
; 0000 0070 // Port D initialization
; 0000 0071 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0072 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0073 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0074 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0075 
; 0000 0076 // Timer/Counter 0 initialization
; 0000 0077 // Clock source: System Clock
; 0000 0078 // Clock value: Timer 0 Stopped
; 0000 0079 TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 007A TCNT0=0xAD;
	LDI  R30,LOW(173)
	OUT  0x32,R30
; 0000 007B 
; 0000 007C // Timer/Counter 1 initialization
; 0000 007D // Clock source: System Clock
; 0000 007E // Clock value: Timer1 Stopped
; 0000 007F // Mode: Normal top=0xFFFF
; 0000 0080 // OC1A output: Disconnected
; 0000 0081 // OC1B output: Disconnected
; 0000 0082 // Noise Canceler: Off
; 0000 0083 // Input Capture on Falling Edge
; 0000 0084 // Timer1 Overflow Interrupt: Off
; 0000 0085 // Input Capture Interrupt: Off
; 0000 0086 // Compare A Match Interrupt: Off
; 0000 0087 // Compare B Match Interrupt: Off
; 0000 0088 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0089 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 008A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 008B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008C ICR1H=0x00;
	OUT  0x27,R30
; 0000 008D ICR1L=0x00;
	OUT  0x26,R30
; 0000 008E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0090 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0091 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0092 
; 0000 0093 // Timer/Counter 2 initialization
; 0000 0094 // Clock source: System Clock
; 0000 0095 // Clock value: 125,000 kHz
; 0000 0096 // Mode: Fast PWM top=0xFF
; 0000 0097 // OC2 output: Non-Inverted PWM
; 0000 0098 // Timer Period: 2,048 ms
; 0000 0099 // Output Pulse(s):
; 0000 009A // OC2 Period: 2,048 ms Width: 1,0521 ms
; 0000 009B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 009C TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 009D TCNT2=0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 009E OCR2=Vol;
	OUT  0x23,R10
; 0000 009F 
; 0000 00A0 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A1 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00A2 
; 0000 00A3 // External Interrupt(s) initialization
; 0000 00A4 // INT0: Off
; 0000 00A5 // INT1: Off
; 0000 00A6 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00A7 
; 0000 00A8 // USART initialization
; 0000 00A9 // USART disabled
; 0000 00AA UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00AB 
; 0000 00AC // Analog Comparator initialization
; 0000 00AD // Analog Comparator: Off
; 0000 00AE // The Analog Comparator's positive input is
; 0000 00AF // connected to the AIN0 pin
; 0000 00B0 // The Analog Comparator's negative input is
; 0000 00B1 // connected to the AIN1 pin
; 0000 00B2 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B3 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B4 
; 0000 00B5 // ADC initialization
; 0000 00B6 // ADC disabled
; 0000 00B7 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B8 
; 0000 00B9 // SPI initialization
; 0000 00BA // SPI disabled
; 0000 00BB SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00BC 
; 0000 00BD // TWI initialization
; 0000 00BE // TWI disabled
; 0000 00BF TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00C0 
; 0000 00C1 // Alphanumeric LCD initialization
; 0000 00C2 // Connections are specified in the
; 0000 00C3 // RS - PORTC Bit 0
; 0000 00C4 // RD - PORTB Bit 4
; 0000 00C5 // EN - PORTC Bit 1
; 0000 00C6 // D4 - PORTC Bit 2
; 0000 00C7 // D5 - PORTC Bit 3
; 0000 00C8 // D6 - PORTC Bit 4
; 0000 00C9 // D7 - PORTC Bit 5
; 0000 00CA // Characters/line: 16
; 0000 00CB     lcd_init();
	RCALL _lcd_init
; 0000 00CC 	lcd_puts(Mes0);
	RCALL SUBOPT_0x0
; 0000 00CD 	lcd_clrbar();
; 0000 00CE 	lcd_drawbar(Vol*50/MaxVol);
; 0000 00CF 	lcd_goto(2,11);
; 0000 00D0 	lcd_itos(Vol*100/MaxVol);
; 0000 00D1 	lcd_putc('%');
; 0000 00D2 
; 0000 00D3 
; 0000 00D4 // Global enable interrupts
; 0000 00D5 #asm("sei")
	sei
; 0000 00D6 
; 0000 00D7 while (1)
_0x16:
; 0000 00D8       {
; 0000 00D9       // Place your code here
; 0000 00DA       if (Vol > MaxVol) Vol = MaxVol;
	__CPWRR 12,13,10,11
	BRGE _0x19
	MOVW R10,R12
; 0000 00DB 		if (Vol < MinVol) Vol = MinVol;
_0x19:
	LDS  R30,_MinVol
	LDS  R31,_MinVol+1
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x1A
	__GETWRMN 10,11,0,_MinVol
; 0000 00DC 		if (Vol != OldVol)
_0x1A:
	__CPWRR 8,9,10,11
	BREQ _0x1B
; 0000 00DD 		{
; 0000 00DE 				lcd_clrscr();
	RCALL _lcd_clrscr
; 0000 00DF 				lcd_puts(Mes0);
	RCALL SUBOPT_0x0
; 0000 00E0 				lcd_clrbar();
; 0000 00E1 				lcd_drawbar(Vol*50/MaxVol);
; 0000 00E2 				lcd_goto(2,11);
; 0000 00E3 				lcd_itos(Vol*100/MaxVol);
; 0000 00E4 				lcd_putc('%');
; 0000 00E5 				OldVol = Vol;
	MOVW R8,R10
; 0000 00E6                 OCR2=Vol;
	OUT  0x23,R10
; 0000 00E7 
; 0000 00E8 		}
; 0000 00E9 
; 0000 00EA 
; 0000 00EB       }
_0x1B:
	RJMP _0x16
; 0000 00EC }
_0x1C:
	RJMP _0x1C
; .FEND
;//------------------------------------------------------
;/* File:       Library for HD44780 compatible displays  */
;/* Version:	   v2.01  						 			*/
;/* Author:     GrAnd/www.MakeSystem.net		 			*/
;/* Tested on:  AVR, STM32F10X		 	 	 		 	*/
;/* License:	   GNU LGPLv2.1		 		 	 			*/
;//------------------------------------------------------
;/* Copyright (C)2014 GrAnd. All right reserved 			*/
;//------------------------------------------------------
;
;/*
;	This library is free software; you can redistribute it and/or
;	modify it under the terms of the GNU Lesser General Public
;	License as published by the Free Software Foundation; either
;	version 2.1 of the License, or (at your option) any later version.
;
;	This library is distributed in the hope that it will be useful,
;	but WITHOUT ANY WARRANTY; without even the implied warranty of
;	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;	Lesser General Public License for more details.
;
;	You should have received a copy of the GNU Lesser General Public
;	License along with this library; if not, write to the Free Software
;	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
;
;Contact information :
;						mail@makesystem.net
;						http://makesystem.net/?page_id=2
;*/
;
;#include "hd44780.h"
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
;/*!	\brief	Macro-definitions. */
;#define BIT(n)						(1u << (n))
;#define SET(x,n)           			((x) |= BIT(n))
;#define CLR(x,n)  		  			((x) &= ~BIT(n))
;#define GET(x,n)   		  			(((x) & BIT(n)) ? 1u : 0u)
;
;#define LCD_D7_MASK					0x80u
;#define LCD_D6_MASK					0x40u
;#define LCD_D5_MASK					0x20u
;#define LCD_D4_MASK					0x10u
;#define LCD_D3_MASK					0x08u
;#define LCD_D2_MASK					0x04u
;#define LCD_D1_MASK					0x02u
;#define LCD_D0_MASK					0x01u
;
;#define ENABLE_CYCLE_TIME			1u	/* Minimal value ~ 1us */
;#define AC_UPDATE_TIME				4u	/* Minimal value ~ 4us */
;
;#if (USE_PROGRESS_BAR)
;/*!	\brief	Progress bar definitions. */
;#define CGROM_PROGRESS_BAR_SIZE		6u
;#define FULL_LOAD					5u
;#define EMPTY_LOAD					0u
;#define EMPTY_ROW					0x00u /* xxx00000 */
;
;static const uint8_t progress_bar[CGROM_PROGRESS_BAR_SIZE] = {0x00u,0x10u,0x18u,0x1Cu,0x1Eu,0x1Fu};
;static uint8_t current_bar_pixel;
;static uint8_t current_cell_load;
;
;static void lcd_initbar(void);
;#endif
;
;/*!	\brief	Low-level functions. */
;static void lcd_config(uint8_t param);
;static void lcd_write(uint8_t data);
;static void lcd_strobe(void);
;static void lcd_high(uint8_t data);
;static void lcd_low(uint8_t data);
;static void lcd_10us_delay(volatile uint32_t us);
;static uint32_t lcd_pow10(uint8_t n);
;
;#if (USE_BUSY_FLAG)
;static void lcd_busy_delay(void);
;
;/*!	\brief	*/
;static void lcd_busy_delay(void)
;{
;	uint8_t BusyFlag;
;
;	Set_D7_as_Input(); /* Set D7 as input. */
;	/* When RS = 0 and R/W = 1, the busy flag is output to DB7. */
;	CLR(LCD_RS_OUT, LCD_RS);
;	SET(LCD_RW_OUT, LCD_RW);
;
;	do
;	{/* Note: two cycles are needed for the busy flag check. */
;		/* Read busy flag. */
;		lcd_strobe();
;		/* D7 is used as busy flag. */
;		BusyFlag = GET(LCD_D7_IN, LCD_D7);
;		/* Discard D3. */
;		lcd_strobe();
;		/* Verify the busy flag */
;	}while (BusyFlag);
;
;	CLR(LCD_RW_OUT, LCD_RW);
;	Set_D7_as_Outut(); /* Restore D7 as the output. */
;}
;#endif /* USE_BUSY_FLAG */
;
;/*!	\brief	Creates delay multiples of 10us. */
;static void lcd_10us_delay(volatile uint32_t us)
; 0001 0069 {

	.CSEG
_lcd_10us_delay_G001:
; .FSTART _lcd_10us_delay_G001
; 0001 006A 	/* Сonversion to us */
; 0001 006B 	us *= MCU_FREQ_VALUE;
	RCALL __PUTPARD2
;	us -> Y+0
	RCALL SUBOPT_0x1
	__GETD2N 0x8
	RCALL __MULD12U
	RCALL SUBOPT_0x2
; 0001 006C 	/* Wait */
; 0001 006D 	while (us > 0u)
_0x20003:
	RCALL SUBOPT_0x3
	RCALL __CPD02
	BRSH _0x20005
; 0001 006E 	{
; 0001 006F 		us--;
	RCALL SUBOPT_0x1
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RCALL SUBOPT_0x2
; 0001 0070 	}
	RJMP _0x20003
_0x20005:
; 0001 0071 }
	ADIW R28,4
	RET
; .FEND
;
;/*!	\brief	Initiate the transfer of data/commands to LCD. */
;static void lcd_strobe(void)
; 0001 0075 {/* Low level function. */
_lcd_strobe_G001:
; .FSTART _lcd_strobe_G001
; 0001 0076 	SET(LCD_E_OUT, LCD_E);
	SBI  0x15,1
; 0001 0077 	lcd_10us_delay(ENABLE_CYCLE_TIME);
	__GETD2N 0x1
	RCALL _lcd_10us_delay_G001
; 0001 0078 	CLR(LCD_E_OUT, LCD_E);	/* Enable strobe */
	CBI  0x15,1
; 0001 0079 }
	RET
; .FEND
;
;/*!	\brief	Send the msb nibble of the data / command to LCD. */
;static void lcd_high(uint8_t data)
; 0001 007D {/* Low level function. */
_lcd_high_G001:
; .FSTART _lcd_high_G001
; 0001 007E 	if(data & LCD_D7_MASK) SET(LCD_D7_OUT, LCD_D7); else CLR(LCD_D7_OUT, LCD_D7);
	ST   -Y,R26
;	data -> Y+0
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x80)
	BREQ _0x20006
	SBI  0x15,5
	RJMP _0x20007
_0x20006:
	CBI  0x15,5
; 0001 007F 	if(data & LCD_D6_MASK) SET(LCD_D6_OUT, LCD_D6); else CLR(LCD_D6_OUT, LCD_D6);
_0x20007:
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x40)
	BREQ _0x20008
	SBI  0x15,4
	RJMP _0x20009
_0x20008:
	CBI  0x15,4
; 0001 0080 	if(data & LCD_D5_MASK) SET(LCD_D5_OUT, LCD_D5); else CLR(LCD_D5_OUT, LCD_D5);
_0x20009:
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x20)
	BREQ _0x2000A
	SBI  0x15,3
	RJMP _0x2000B
_0x2000A:
	CBI  0x15,3
; 0001 0081 	if(data & LCD_D4_MASK) SET(LCD_D4_OUT, LCD_D4); else CLR(LCD_D4_OUT, LCD_D4);
_0x2000B:
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x10)
	BREQ _0x2000C
	SBI  0x15,2
	RJMP _0x2000D
_0x2000C:
	CBI  0x15,2
; 0001 0082 }
_0x2000D:
	RJMP _0x2080001
; .FEND
;
;/*!	\brief	Send the lsb nibble of the data / command to LCD. */
;static void lcd_low(uint8_t data)
; 0001 0086 {/* Low level function. */
_lcd_low_G001:
; .FSTART _lcd_low_G001
; 0001 0087 	if(data & LCD_D3_MASK) SET(LCD_D7_OUT, LCD_D7); else CLR(LCD_D7_OUT, LCD_D7);
	ST   -Y,R26
;	data -> Y+0
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x8)
	BREQ _0x2000E
	SBI  0x15,5
	RJMP _0x2000F
_0x2000E:
	CBI  0x15,5
; 0001 0088 	if(data & LCD_D2_MASK) SET(LCD_D6_OUT, LCD_D6); else CLR(LCD_D6_OUT, LCD_D6);
_0x2000F:
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x4)
	BREQ _0x20010
	SBI  0x15,4
	RJMP _0x20011
_0x20010:
	CBI  0x15,4
; 0001 0089 	if(data & LCD_D1_MASK) SET(LCD_D5_OUT, LCD_D5); else CLR(LCD_D5_OUT, LCD_D5);
_0x20011:
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x2)
	BREQ _0x20012
	SBI  0x15,3
	RJMP _0x20013
_0x20012:
	CBI  0x15,3
; 0001 008A 	if(data & LCD_D0_MASK) SET(LCD_D4_OUT, LCD_D4); else CLR(LCD_D4_OUT, LCD_D4);
_0x20013:
	RCALL SUBOPT_0x4
	ANDI R30,LOW(0x1)
	BREQ _0x20014
	SBI  0x15,2
	RJMP _0x20015
_0x20014:
	CBI  0x15,2
; 0001 008B }
_0x20015:
	RJMP _0x2080001
; .FEND
;
;/*!	\brief	Send data/commands to the display. */
;static void lcd_write(uint8_t data)
; 0001 008F {/* Low level function. */
_lcd_write_G001:
; .FSTART _lcd_write_G001
; 0001 0090 #if (USE_BUSY_FLAG)
; 0001 0091 	/* Write data/commands to LCD. */
; 0001 0092 	CLR(LCD_RW_OUT, LCD_RW);
; 0001 0093 #endif /* USE_BUSY_FLAG */
; 0001 0094 
; 0001 0095 	lcd_high(data);
	ST   -Y,R26
;	data -> Y+0
	LD   R26,Y
	RCALL _lcd_high_G001
; 0001 0096 	lcd_strobe();
	RCALL _lcd_strobe_G001
; 0001 0097 	lcd_low(data);
	RCALL SUBOPT_0x5
; 0001 0098 	lcd_strobe();
; 0001 0099 
; 0001 009A 	/* The busy flag must be checked after the 4-bit data has been transferred twice. */
; 0001 009B #if (USE_BUSY_FLAG)
; 0001 009C 	lcd_busy_delay();
; 0001 009D #else
; 0001 009E 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 009F #endif /* USE_BUSY_FLAG */
; 0001 00A0 }
	RJMP _0x2080001
; .FEND
;
;/*!	\brief	Initializing by instruction. 4-bit interface initialization. */
;static void lcd_config(uint8_t param)
; 0001 00A4 {/* Low level function. */
_lcd_config_G001:
; .FSTART _lcd_config_G001
; 0001 00A5 	/* Send commands to LCD. */
; 0001 00A6 	CLR(LCD_RS_OUT, LCD_RS);
	RCALL SUBOPT_0x6
;	param -> Y+0
; 0001 00A7 #if (USE_BUSY_FLAG)
; 0001 00A8 	/* Write data/commands to LCD. */
; 0001 00A9 	CLR(LCD_RW_OUT, LCD_RW);
; 0001 00AA #endif /* USE_BUSY_FLAG */
; 0001 00AB 
; 0001 00AC 	lcd_10us_delay(4000);
	__GETD2N 0xFA0
	RCALL _lcd_10us_delay_G001
; 0001 00AD 	lcd_high(param);
	LD   R26,Y
	RCALL _lcd_high_G001
; 0001 00AE 	lcd_strobe();		// Change 8-bit interface to 4-bit interface
	RCALL SUBOPT_0x7
; 0001 00AF 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 00B0 	lcd_strobe();		/* DB7 to DB4 of the "Function set" instruction is written twice. */
	RCALL SUBOPT_0x7
; 0001 00B1 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 00B2 	lcd_low(param);
	RCALL SUBOPT_0x5
; 0001 00B3 	lcd_strobe();		// 4-bit, two lines, 5x8 pixel
; 0001 00B4 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 00B5 	/* Note: The number of display lines and character font cannot be changed after this point. */
; 0001 00B6 }
	RJMP _0x2080001
; .FEND
;
;							//-----------------------------//
;							/*         LCDlib API          */
;							//-----------------------------//
;
;/*!	\details	Clear display writes space code 20H into all DDRAM addresses.
; * 				It then sets DDRAM address 0 into the address counter,
; * 				and returns the display to its original status if it was shifted.
; * 				In other words, the display disappears and the cursor
; * 				or blinking goes to the left edge of the display (in the first line if 2 lines are displayed).
; * 				It also sets I/D to 1 (increment mode) in entry mode (S of entry mode does not change). */
;void lcd_clrscr(void)
; 0001 00C3 {
_lcd_clrscr:
; .FSTART _lcd_clrscr
; 0001 00C4 	/* Send a command to LCD. */
; 0001 00C5 	CLR(LCD_RS_OUT, LCD_RS);
	CBI  0x15,0
; 0001 00C6 	/* Clear screen */
; 0001 00C7 	lcd_write(0x01u);
	LDI  R26,LOW(1)
	RJMP _0x2080003
; 0001 00C8 	/* Busy delay */
; 0001 00C9 #if (USE_BUSY_FLAG)
; 0001 00CA 	lcd_busy_delay();
; 0001 00CB #else
; 0001 00CC 	lcd_10us_delay(CLRSCR_CYCLE_TIME);
; 0001 00CD #endif /* USE_BUSY_FLAG */
; 0001 00CE }
; .FEND
;
;/*!	\details	"Return home" sets DDRAM address 0 into the address counter,
; * 				and returns the display to its original status if it was shifted.
; * 				The DDRAM contents do not change.
; * 				The cursor or blinking go to the left edge of the display
; * 				(in the first line if 2 lines are displayed). */
;void lcd_return(void)
; 0001 00D6 {
_lcd_return:
; .FSTART _lcd_return
; 0001 00D7 	/* Send a command to LCD. */
; 0001 00D8 	CLR(LCD_RS_OUT, LCD_RS);
	CBI  0x15,0
; 0001 00D9 	/* Return home */
; 0001 00DA 	lcd_write(0x02u);
	LDI  R26,LOW(2)
_0x2080003:
	RCALL _lcd_write_G001
; 0001 00DB 	/* Busy delay */
; 0001 00DC #if (USE_BUSY_FLAG)
; 0001 00DD 	lcd_busy_delay();
; 0001 00DE #else
; 0001 00DF 	lcd_10us_delay(RETHOME_CYCLE_TIME);
	__GETD2N 0xC8
	RCALL _lcd_10us_delay_G001
; 0001 00E0 #endif /* USE_BUSY_FLAG */
; 0001 00E1 }
	RET
; .FEND
;
;/*!	\details	lcd_scroll shifts the display to the right or left without writing or reading display data.
; * 				This function is used to correct or search the display.
; *	\note		The first and second line displays will shift at the same time. */
;void lcd_scroll(uint8_t direction)
; 0001 00E7 {
; 0001 00E8 	/* Send a command to LCD. */
; 0001 00E9 	CLR(LCD_RS_OUT, LCD_RS);
;	direction -> Y+0
; 0001 00EA 	/* Scroll display */
; 0001 00EB 	switch (direction)
; 0001 00EC 	{
; 0001 00ED 	/* To left */
; 0001 00EE 		case LEFT  :
; 0001 00EF 			lcd_write(0x18u);
; 0001 00F0 			break;
; 0001 00F1 
; 0001 00F2 		/* To right */
; 0001 00F3 		case RIGHT :
; 0001 00F4 			lcd_write(0x1Cu);
; 0001 00F5 			break;
; 0001 00F6 
; 0001 00F7 		default:
; 0001 00F8 			/* Ignore this command */
; 0001 00F9 			break;
; 0001 00FA 	}
; 0001 00FB }
;
;/*!	\details	"Cursor shift" shifts the cursor position to the right or left,
; * 				without writing or reading display data.
; * 				This function is used to correct or search the display.
; * 				In a 2-line display, the cursor moves to the second line
; * 				when it passes the 40th digit of the first line. */
;void cursor_shift(uint8_t direction)
; 0001 0103 {
_cursor_shift:
; .FSTART _cursor_shift
; 0001 0104 	/* Send a command to LCD. */
; 0001 0105 	CLR(LCD_RS_OUT, LCD_RS);
	RCALL SUBOPT_0x6
;	direction -> Y+0
; 0001 0106 	/* Shift cursor */
; 0001 0107 	switch (direction)
	RCALL SUBOPT_0x4
; 0001 0108 	{
; 0001 0109 		/* To left */
; 0001 010A 		case LEFT  :
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0x2001F
; 0001 010B 			lcd_write(0x10u);
	LDI  R26,LOW(16)
	RCALL _lcd_write_G001
; 0001 010C 			break;
	RJMP _0x2001E
; 0001 010D 
; 0001 010E 		/* To right */
; 0001 010F 		case RIGHT :
_0x2001F:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0x20021
; 0001 0110 			lcd_write(0x14u);
	LDI  R26,LOW(20)
	RCALL _lcd_write_G001
; 0001 0111 			break;
; 0001 0112 
; 0001 0113 		default:
_0x20021:
; 0001 0114 			/* Ignore this command */
; 0001 0115 			break;
; 0001 0116 	}
_0x2001E:
; 0001 0117 }
	RJMP _0x2080001
; .FEND
;
;/*!	\details	Go to the specified (DDRAM/CGRAM) memory address.*/
;void lcd_goto(uint8_t line, uint8_t address)
; 0001 011B {
_lcd_goto:
; .FSTART _lcd_goto
; 0001 011C 	/* Send a command to LCD. */
; 0001 011D 	CLR(LCD_RS_OUT, LCD_RS);
	RCALL SUBOPT_0x6
;	line -> Y+1
;	address -> Y+0
; 0001 011E 	/* Set DDRAM/CGRAM address. */
; 0001 011F 	switch (line)
	LDD  R30,Y+1
	LDI  R31,0
; 0001 0120 	{
; 0001 0121 		/* Set DDRAM address. */
; 0001 0122 		case LCD_1st_LINE: lcd_write(0x80u | START_ADDRESS_1st_LINE | address); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20025
	LD   R30,Y
	ORI  R30,0x80
	RCALL SUBOPT_0x8
	RJMP _0x20024
; 0001 0123 		case LCD_2nd_LINE: lcd_write(0x80u | START_ADDRESS_2nd_LINE | address); break;
_0x20025:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20026
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	RCALL SUBOPT_0x8
	RJMP _0x20024
; 0001 0124 		case LCD_3rd_LINE: lcd_write(0x80u | START_ADDRESS_3rd_LINE | address); break;
_0x20026:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20027
	LD   R30,Y
	ORI  R30,LOW(0x90)
	RCALL SUBOPT_0x8
	RJMP _0x20024
; 0001 0125 		case LCD_4th_LINE: lcd_write(0x80u | START_ADDRESS_4th_LINE | address); break;
_0x20027:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20028
	LD   R30,Y
	ORI  R30,LOW(0xD0)
	RCALL SUBOPT_0x8
	RJMP _0x20024
; 0001 0126 		/* Set CGRAM address. */
; 0001 0127 		case CGRAM : lcd_write(0x40u | address); break;
_0x20028:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2002A
	LD   R30,Y
	ORI  R30,0x40
	RCALL SUBOPT_0x8
; 0001 0128 
; 0001 0129 		default:
_0x2002A:
; 0001 012A 			/* Ignore this command */
; 0001 012B 			break;
; 0001 012C 	}
_0x20024:
; 0001 012D }
	RJMP _0x2080002
; .FEND
;
;/*!	\details	Change LCD settings. */
;void lcd_setmode(uint8_t param)
; 0001 0131 {
_lcd_setmode:
; .FSTART _lcd_setmode
; 0001 0132 	/* Send a command to LCD. */
; 0001 0133 	CLR(LCD_RS_OUT, LCD_RS);
	RCALL SUBOPT_0x6
;	param -> Y+0
; 0001 0134 	lcd_write(param);
	LD   R26,Y
	RCALL _lcd_write_G001
; 0001 0135 }
	RJMP _0x2080001
; .FEND
;
;/*!	\details	Write a single char to the current memory space (DDRAM/CGRAM). */
;void lcd_putc(uint8_t data)
; 0001 0139 {
_lcd_putc:
; .FSTART _lcd_putc
; 0001 013A 	/* Send data to LCD. */
; 0001 013B 	SET(LCD_RS_OUT, LCD_RS);
	ST   -Y,R26
;	data -> Y+0
	SBI  0x15,0
; 0001 013C 	lcd_write(data);
	LD   R26,Y
	RCALL _lcd_write_G001
; 0001 013D 	/* Note:
; 0001 013E 	 * After execution of the CGRAM/DDRAM data write/read instruction, the RAM address counter is incremented
; 0001 013F 	 * or decremented by 1. The RAM address counter is updated after the busy flag turns off.
; 0001 0140 	 * tADD is the time elapsed after the busy flag turns off until the address counter is updated. */
; 0001 0141 	lcd_10us_delay(AC_UPDATE_TIME);	/* Update RAM address counter delay. */
	__GETD2N 0x4
	RCALL _lcd_10us_delay_G001
; 0001 0142 }
	RJMP _0x2080001
; .FEND
;
;/*!	\details	Writes ANSI-C string to LCD (DDRAM memory space). */
;void lcd_puts(const uint8_t *str)
; 0001 0146 {
_lcd_puts:
; .FSTART _lcd_puts
; 0001 0147 	/* Send a ANSI-C string to LCD. */
; 0001 0148 	while ('\0' != *str)
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x2002B:
	RCALL SUBOPT_0x9
	CPI  R30,0
	BREQ _0x2002D
; 0001 0149 	{
; 0001 014A #if ( USE_FORMATTED_OUTPUT )
; 0001 014B 		if(('\n' == *str))
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0xA)
	BRNE _0x2002E
; 0001 014C 		{/*New line */
; 0001 014D 			lcd_goto(LCD_2nd_LINE, 0u);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xA
; 0001 014E 		}
; 0001 014F 		else if(('\r' == *str))
	RJMP _0x2002F
_0x2002E:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0xD)
	BRNE _0x20030
; 0001 0150 		{/* Return home */
; 0001 0151 			lcd_return();
	RCALL _lcd_return
; 0001 0152 		}
; 0001 0153 		else if(('\t' == *str))
	RJMP _0x20031
_0x20030:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0x9)
	BRNE _0x20032
; 0001 0154 		{/* Tab space */
; 0001 0155 			uint8_t i;
; 0001 0156 
; 0001 0157 			for(i=0u; i<TAB_SPACE; i++)
	SBIW R28,1
;	*str -> Y+1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x20034:
	LD   R26,Y
	CLR  R27
	SBIW R26,4
	BRGE _0x20035
; 0001 0158 			{/* Shift cursor to the right. */
; 0001 0159 				cursor_shift(RIGHT);
	LDI  R26,LOW(62)
	RCALL _cursor_shift
; 0001 015A 			}
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x20034
_0x20035:
; 0001 015B 		}
	ADIW R28,1
; 0001 015C 		else
	RJMP _0x20036
_0x20032:
; 0001 015D #endif
; 0001 015E 		{
; 0001 015F 			/* Display a symbol. */
; 0001 0160 			lcd_putc(*str);
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	RCALL _lcd_putc
; 0001 0161 		}
_0x20036:
_0x20031:
_0x2002F:
; 0001 0162 		/* Get the next symbol. */
; 0001 0163 		str++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0001 0164 	}
	RJMP _0x2002B
_0x2002D:
; 0001 0165 }
_0x2080002:
	ADIW R28,2
	RET
; .FEND
;
;/*!	\details	Load the user-defined symbol into the CGRAM memory. */
;void lcd_loadchar(uint8_t* vector, uint8_t position)
; 0001 0169 {
; 0001 016A 	uint8_t i;
; 0001 016B 	/* Go to the CGRAM memory space: 0 to 7 */
; 0001 016C 	lcd_goto(CGRAM, (position * FONT_HEIGHT));
;	*vector -> Y+2
;	position -> Y+1
;	i -> R17
; 0001 016D 
; 0001 016E 	for(i = 0u; i < FONT_HEIGHT; i++)
; 0001 016F 	{/* Load one row of pixels into the CGRAM register. */
; 0001 0170 		lcd_putc(vector[i]);
; 0001 0171 	}
; 0001 0172 
; 0001 0173 	/* Return to the DDRAM memory space. */
; 0001 0174 	lcd_goto(LCD_1st_LINE, 0u);
; 0001 0175 }
;
;/*!	\details	Load and display the user-defined symbol. */
;void lcd_drawchar( uint8_t* vector,
; 0001 0179 			   	   uint8_t position,
; 0001 017A 			   	   uint8_t line,
; 0001 017B 			   	   uint8_t address )
; 0001 017C {
; 0001 017D 	/* Load the user-defined symbol into the CGRAM memory. */
; 0001 017E 	lcd_loadchar(vector, position);
;	*vector -> Y+3
;	position -> Y+2
;	line -> Y+1
;	address -> Y+0
; 0001 017F 	/* Select LCD position. */
; 0001 0180 	lcd_goto(line, address);
; 0001 0181 	/* Display the user-defined symbol. */
; 0001 0182 	lcd_putc(position);
; 0001 0183 }
;
;/*!	\details	Erase a symbol from the left of the cursor. */
;void lcd_backspace(void)
; 0001 0187 {
; 0001 0188 	cursor_shift(LEFT);		// Сдвигаем курсор на одну позицию влево
; 0001 0189 	lcd_putc(' ');			// Очищаем, после чего происходит автоинкремент вправо
; 0001 018A 	cursor_shift(LEFT);		// Сдвигаем курсор на одну позицию влево
; 0001 018B }
;
;/*!	\brief	Returns 10^n value. */
;static uint32_t lcd_pow10(uint8_t n)
; 0001 018F {
; 0001 0190 	uint32_t retval = 1u;
; 0001 0191 
; 0001 0192 	while (n > 0u)
;	n -> Y+4
;	retval -> Y+0
; 0001 0193 	{
; 0001 0194 		retval *= 10u;
; 0001 0195 		n--;
; 0001 0196 	}
; 0001 0197 
; 0001 0198 	return retval;
; 0001 0199 }
;
;/*!	\brief	Display a integer number: +/- 2147483647. */
;void lcd_itos(int32_t value)
; 0001 019D {
_lcd_itos:
; .FSTART _lcd_itos
; 0001 019E 	int32_t i;
; 0001 019F 
; 0001 01A0 	if (value < 0)
	RCALL __PUTPARD2
	SBIW R28,4
;	value -> Y+4
;	i -> Y+0
	LDD  R26,Y+7
	TST  R26
	BRPL _0x2003D
; 0001 01A1 	{
; 0001 01A2 		lcd_putc('-');
	LDI  R26,LOW(45)
	RCALL _lcd_putc
; 0001 01A3 		value = -value;
	__GETD1S 4
	RCALL __ANEGD1
	__PUTD1S 4
; 0001 01A4 	}
; 0001 01A5 
; 0001 01A6 	i = 1;
_0x2003D:
	__GETD1N 0x1
	RCALL SUBOPT_0x2
; 0001 01A7 	while ((value / i) > 9)
_0x2003E:
	RCALL SUBOPT_0xB
	__CPD1N 0xA
	BRLT _0x20040
; 0001 01A8 	{
; 0001 01A9 		i *= 10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x2
; 0001 01AA 	}
	RJMP _0x2003E
_0x20040:
; 0001 01AB 
; 0001 01AC 	lcd_putc(value/i + '0');	/* Display at least one symbol */
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
; 0001 01AD 	i /= 10;
; 0001 01AE 
; 0001 01AF 	while (i > 0)
_0x20041:
	RCALL SUBOPT_0x3
	RCALL __CPD02
	BRGE _0x20043
; 0001 01B0 	{
; 0001 01B1 		lcd_putc('0' + ((value % (i*10)) / i));
	RCALL SUBOPT_0xC
	__GETD2S 4
	RCALL __MODD21
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x1
	RCALL __DIVD21
	RCALL SUBOPT_0xD
; 0001 01B2 		i /= 10;
; 0001 01B3 	}
	RJMP _0x20041
_0x20043:
; 0001 01B4 }
	ADIW R28,8
	RET
; .FEND
;
;/*!	\brief	Display a floating point number. */
;void lcd_ftos(float value, uint8_t n)
; 0001 01B8 {
; 0001 01B9 	if (value < 0.0)
;	value -> Y+1
;	n -> Y+0
; 0001 01BA 	{
; 0001 01BB 		lcd_putc('-');
; 0001 01BC 		value = -value;
; 0001 01BD 	}
; 0001 01BE 
; 0001 01BF 	lcd_itos((int32_t)value); // Вывод целой части
; 0001 01C0 
; 0001 01C1 	if (n > 0u)
; 0001 01C2 	{
; 0001 01C3 		lcd_putc('.'); // Точка
; 0001 01C4 
; 0001 01C5 		lcd_ntos((uint32_t)(value * (float)lcd_pow10(n)), n); // Вывод дробной части
; 0001 01C6 	}
; 0001 01C7 }
;
;/*!	\brief	Display "n" right digits of "value". */
;void lcd_ntos(uint32_t value, uint8_t n)
; 0001 01CB {
; 0001 01CC 	if (n > 0u)
;	value -> Y+1
;	n -> Y+0
; 0001 01CD 	{
; 0001 01CE 		uint32_t i = lcd_pow10(n - 1u);
; 0001 01CF 
; 0001 01D0 		while (i > 0u)	/* Display at least one symbol */
;	value -> Y+5
;	n -> Y+4
;	i -> Y+0
; 0001 01D1 		{
; 0001 01D2 			lcd_putc('0' + ((value/i) % 10u));
; 0001 01D3 
; 0001 01D4 			i /= 10u;
; 0001 01D5 		}
; 0001 01D6 	}
; 0001 01D7 }
;
;#if ( USE_PROGRESS_BAR )
;/*!	\brief	Initialize the progress bar
; * 			(i.e. preload elements of the progress bar into CGRAM and reset all variables). */
;static void lcd_initbar(void)
; 0001 01DD {
_lcd_initbar_G001:
; .FSTART _lcd_initbar_G001
; 0001 01DE 	uint8_t i, j;
; 0001 01DF 
; 0001 01E0 	for (i = 0u; i < CGROM_PROGRESS_BAR_SIZE; i++)
	RCALL __SAVELOCR2
;	i -> R17
;	j -> R16
	LDI  R17,LOW(0)
_0x2004B:
	MOV  R26,R17
	CLR  R27
	SBIW R26,6
	BRGE _0x2004C
; 0001 01E1 	{
; 0001 01E2 		lcd_goto(CGRAM, (i * FONT_HEIGHT));
	LDI  R30,LOW(5)
	ST   -Y,R30
	MOV  R30,R17
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R26,R30
	RCALL _lcd_goto
; 0001 01E3 
; 0001 01E4 		for (j = 0u; j < FONT_HEIGHT; j++)
	LDI  R16,LOW(0)
_0x2004E:
	MOV  R26,R16
	CLR  R27
	SBIW R26,8
	BRGE _0x2004F
; 0001 01E5 		{
; 0001 01E6 			if (j < PROGRESS_BAR_HEIGHT)
	MOV  R26,R16
	CLR  R27
	SBIW R26,6
	BRGE _0x20050
; 0001 01E7 			{
; 0001 01E8 				lcd_putc(progress_bar[i]);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_progress_bar_G001*2)
	SBCI R31,HIGH(-_progress_bar_G001*2)
	LPM  R26,Z
	RJMP _0x20063
; 0001 01E9 			}
; 0001 01EA 			else
_0x20050:
; 0001 01EB 			{/* Load an empty row of pixels in CGRAM. */
; 0001 01EC 				lcd_putc(EMPTY_ROW);
	LDI  R26,LOW(0)
_0x20063:
	RCALL _lcd_putc
; 0001 01ED 			}
; 0001 01EE 		}
	SUBI R16,-1
	RJMP _0x2004E
_0x2004F:
; 0001 01EF 	}
	SUBI R17,-1
	RJMP _0x2004B
_0x2004C:
; 0001 01F0 
; 0001 01F1 	/* Clear the entire bar and initialize all variables. */
; 0001 01F2 	lcd_clrbar();
	RCALL _lcd_clrbar
; 0001 01F3 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;/*!	\brief	Draw progress bar. */
;void lcd_drawbar(uint8_t next_bar_pixel)
; 0001 01F7 {
_lcd_drawbar:
; .FSTART _lcd_drawbar
; 0001 01F8 	/* Go to the current cell position in the progress bar. */
; 0001 01F9 	lcd_goto(PROGRESS_BAR_LINE, (current_bar_pixel / FONT_WIDTH));
	ST   -Y,R26
;	next_bar_pixel -> Y+0
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_current_bar_pixel_G001
	LDI  R27,0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL __DIVW21
	MOV  R26,R30
	RCALL _lcd_goto
; 0001 01FA 
; 0001 01FB 	if (next_bar_pixel > current_bar_pixel)
	RCALL SUBOPT_0xE
	LD   R26,Y
	CP   R30,R26
	BRSH _0x20052
; 0001 01FC 	{
; 0001 01FD 		/* Increment LCD cursor */
; 0001 01FE 		lcd_setmode(ENTRY_MODE_INC_NO_SHIFT);
	RCALL SUBOPT_0xF
; 0001 01FF 
; 0001 0200 		/* Prevent the progress bar overflow */
; 0001 0201 		if (next_bar_pixel > PROGRESS_BAR_MAX_LOAD)
	LD   R26,Y
	CPI  R26,LOW(0x33)
	BRLO _0x20053
; 0001 0202 		{
; 0001 0203 			next_bar_pixel = PROGRESS_BAR_MAX_LOAD;
	LDI  R30,LOW(50)
	ST   Y,R30
; 0001 0204 		}
; 0001 0205 
; 0001 0206 		while (current_bar_pixel != next_bar_pixel)
_0x20053:
_0x20054:
	RCALL SUBOPT_0x10
	BREQ _0x20056
; 0001 0207 		{
; 0001 0208 			/* Go to the next pixel. */
; 0001 0209 			current_bar_pixel++;
	RCALL SUBOPT_0xE
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x11
; 0001 020A 			current_cell_load++;
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x12
; 0001 020B 			/* Display the load of the current cell. */
; 0001 020C 			lcd_putc(current_cell_load);
	LDS  R26,_current_cell_load_G001
	RCALL _lcd_putc
; 0001 020D 
; 0001 020E 			if (current_cell_load < FULL_LOAD)
	LDS  R26,_current_cell_load_G001
	CLR  R27
	SBIW R26,5
	BRGE _0x20057
; 0001 020F 			{/* Return the cursor to the current cell. */
; 0001 0210 				cursor_shift(LEFT);
	LDI  R26,LOW(60)
	RCALL _cursor_shift
; 0001 0211 			}
; 0001 0212 			else
	RJMP _0x20058
_0x20057:
; 0001 0213 			{/* Go to the next cell. */
; 0001 0214 				current_cell_load = EMPTY_LOAD;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x12
; 0001 0215 			}
_0x20058:
; 0001 0216 		}
	RJMP _0x20054
_0x20056:
; 0001 0217 	 }
; 0001 0218 #if (USE_REGRESS_BAR)
; 0001 0219 	 else if (next_bar_pixel < current_bar_pixel)
	RJMP _0x20059
_0x20052:
	RCALL SUBOPT_0xE
	LD   R26,Y
	CP   R26,R30
	BRSH _0x2005A
; 0001 021A 	 {
; 0001 021B 		 /* Decrement LCD cursor */
; 0001 021C 		lcd_setmode(ENTRY_MODE_DEC_NO_SHIFT);
	LDI  R26,LOW(4)
	RCALL _lcd_setmode
; 0001 021D 
; 0001 021E 		do
_0x2005C:
; 0001 021F 		{
; 0001 0220 			if (EMPTY_LOAD == current_cell_load)
	LDS  R30,_current_cell_load_G001
	LDI  R31,0
	SBIW R30,0
	BRNE _0x2005E
; 0001 0221 			{/* Go to the next cell. */
; 0001 0222 				cursor_shift(LEFT);
	LDI  R26,LOW(60)
	RCALL _cursor_shift
; 0001 0223 				current_cell_load = FULL_LOAD;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x12
; 0001 0224 			}
; 0001 0225 			/* Go to the next pixel. */
; 0001 0226 			current_bar_pixel--;
_0x2005E:
	RCALL SUBOPT_0xE
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x11
; 0001 0227 			current_cell_load--;
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x12
; 0001 0228 			/* Display the load of the current cell. */
; 0001 0229 			lcd_putc(current_cell_load);
	LDS  R26,_current_cell_load_G001
	RCALL _lcd_putc
; 0001 022A 			/* Return the cursor to the current cell. */
; 0001 022B 			cursor_shift(RIGHT);
	LDI  R26,LOW(62)
	RCALL _cursor_shift
; 0001 022C 		}
; 0001 022D 		while (current_bar_pixel != next_bar_pixel);
	RCALL SUBOPT_0x10
	BRNE _0x2005C
; 0001 022E 	 }
; 0001 022F #endif /* USE_REGRESS_BAR */
; 0001 0230 	 else
_0x2005A:
; 0001 0231 	 {
; 0001 0232 		 /* Nothing to do. */
; 0001 0233 	 }
_0x20059:
; 0001 0234 
; 0001 0235 	/* Restore the default entry mode. */
; 0001 0236 	lcd_setmode(DEFAULT_ENTRY_MODE);
	RCALL SUBOPT_0xF
; 0001 0237 	/* Return home. */
; 0001 0238 	lcd_goto(LCD_1st_LINE, 0u);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
; 0001 0239 }
_0x2080001:
	ADIW R28,1
	RET
; .FEND
;
;/*!	\brief	Clear the entire progress bar. */
;void lcd_clrbar(void)
; 0001 023D {
_lcd_clrbar:
; .FSTART _lcd_clrbar
; 0001 023E 	uint8_t i;
; 0001 023F 	/* Go to the last cell in the progress bar. */
; 0001 0240 	lcd_goto(PROGRESS_BAR_LINE, (PROGRESS_BAR_WIDTH - 1u));
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL _lcd_goto
; 0001 0241 	/* Set the decrement mode. */
; 0001 0242 	lcd_setmode(ENTRY_MODE_DEC_NO_SHIFT);
	LDI  R26,LOW(4)
	RCALL _lcd_setmode
; 0001 0243 
; 0001 0244 	for(i = 0u; i < PROGRESS_BAR_WIDTH; i++)
	LDI  R17,LOW(0)
_0x20061:
	MOV  R26,R17
	CLR  R27
	SBIW R26,10
	BRGE _0x20062
; 0001 0245 	{/* Display the "empty cell" symbol (i.e. clear the LCD cell). */
; 0001 0246 		lcd_putc(EMPTY_LOAD);
	LDI  R26,LOW(0)
	RCALL _lcd_putc
; 0001 0247 	}
	SUBI R17,-1
	RJMP _0x20061
_0x20062:
; 0001 0248 
; 0001 0249 	/* Reset the progress bar variables. */
; 0001 024A 	current_bar_pixel = 0u;
	LDI  R30,LOW(0)
	STS  _current_bar_pixel_G001,R30
; 0001 024B 	current_cell_load = EMPTY_LOAD;
	RCALL SUBOPT_0x12
; 0001 024C 
; 0001 024D 	/* Restore the default entry mode. */
; 0001 024E 	lcd_setmode(DEFAULT_ENTRY_MODE);
	RCALL SUBOPT_0xF
; 0001 024F 	/* Return home. */
; 0001 0250 	lcd_goto(LCD_1st_LINE, 0u);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
; 0001 0251 }
	LD   R17,Y+
	RET
; .FEND
;#endif
;
;/*!	\brief	Initialize the LCD.
; * 	\note	This library use the 4-bit interface. */
;void lcd_init(void)
; 0001 0257 {
_lcd_init:
; .FSTART _lcd_init
; 0001 0258 	/* GPIO initialization. */
; 0001 0259 	//Set_All_pins_as_Outputs();
; 0001 025A 	/* LCD initialization. */
; 0001 025B 	lcd_config(DEFAULT_DISPLAY_CONFIG);
	LDI  R26,LOW(40)
	RCALL _lcd_config_G001
; 0001 025C 	lcd_setmode(DEFAULT_VIEW_MODE);
	LDI  R26,LOW(12)
	RCALL _lcd_setmode
; 0001 025D 	lcd_setmode(DEFAULT_ENTRY_MODE);
	RCALL SUBOPT_0xF
; 0001 025E 	lcd_clrscr();
	RCALL _lcd_clrscr
; 0001 025F 	lcd_return();
	RCALL _lcd_return
; 0001 0260 #if (USE_PROGRESS_BAR)
; 0001 0261 	lcd_initbar();
	RCALL _lcd_initbar_G001
; 0001 0262 #endif
; 0001 0263 }
	RET
; .FEND
;
;//-------------------------------
;/* END OF FILE */
;//-------------------------------

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_Mes0:
	.BYTE 0xB
_MinVol:
	.BYTE 0x2
_current_bar_pixel_G001:
	.BYTE 0x1
_current_cell_load_G001:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_Mes0)
	LDI  R27,HIGH(_Mes0)
	RCALL _lcd_puts
	RCALL _lcd_clrbar
	MOVW R30,R10
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	RCALL __MULW12
	MOVW R26,R30
	MOVW R30,R12
	RCALL __DIVW21
	MOV  R26,R30
	RCALL _lcd_drawbar
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(11)
	RCALL _lcd_goto
	MOVW R30,R10
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12
	MOVW R26,R30
	MOVW R30,R12
	RCALL __DIVW21
	RCALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _lcd_itos
	LDI  R26,LOW(37)
	RJMP _lcd_putc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LD   R26,Y
	RCALL _lcd_low_G001
	RCALL _lcd_strobe_G001
	__GETD2N 0xA
	RJMP _lcd_10us_delay_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R26
	CBI  0x15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL _lcd_strobe_G001
	__GETD2N 0xA
	RJMP _lcd_10us_delay_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	MOV  R26,R30
	RJMP _lcd_write_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_goto

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x1
	__GETD2S 4
	RCALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x1
	__GETD2N 0xA
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_putc
	RCALL SUBOPT_0x3
	__GETD1N 0xA
	RCALL __DIVD21
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDS  R30,_current_bar_pixel_G001
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(6)
	RJMP _lcd_setmode

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LD   R30,Y
	LDS  R26,_current_bar_pixel_G001
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	STS  _current_bar_pixel_G001,R30
	LDS  R30,_current_cell_load_G001
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	STS  _current_cell_load_G001,R30
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
