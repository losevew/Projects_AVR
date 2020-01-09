
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
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

	#pragma AVRPART ADMIN PART_NAME ATmega8A
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
	.DEF _start=R5
	.DEF _start_stop=R4
	.DEF _start_pwm=R7
	.DEF _direction=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
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
	RJMP _ana_comp_isr
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x1

_0x3:
	.DB  0x64

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _motor_pwm
	.DW  _0x3*2

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
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : ����������� ���������������� ��������� � AVR(��� ��������)
;Version :
;Date    : 28.07.2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;
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
;#include <delay.h>
;
;// ���� U(������� �����)
;#define UH_ON    TCCR1A |= (1 << COM1A1);
;#define UH_OFF    TCCR1A &= ~(1 << COM1A1);
;
;// ���� U(������ �����)
;#define UL_ON    PORTB |= (1 << PORTB5);
;#define UL_OFF    PORTB &= ~(1 << PORTB5);
;
;// ���� V(������� �����)
;#define VH_ON    TCCR2 |= (1 << COM21);
;#define VH_OFF    TCCR2 &= ~(1 << COM21);
;
;// ���� V(������ �����)
;#define VL_ON    PORTB |= (1 << PORTB0);
;#define VL_OFF    PORTB &= ~(1 << PORTB0);
;
;// ���� W(������� �����)
;#define WH_ON    TCCR1A |= (1 << COM1B1);
;#define WH_OFF    TCCR1A &= ~(1 << COM1B1);
;
;// ���� W(������ �����)
;#define WL_ON    PORTB |= (1 << PORTB4);
;#define WL_OFF    PORTB &= ~(1 << PORTB4);
;
;#define PHASE_ALL_OFF	UH_OFF;UL_OFF;VH_OFF;VL_OFF;WH_OFF;WL_OFF;
;
;#define SENSE_U		ADMUX = 0; // ���� �������� ��� ���� U
;#define SENSE_V		ADMUX = 1; // ���� �������� ��� ���� V
;#define SENSE_W		ADMUX = 2; // ���� �������� ��� ���� W
;
;#define SENSE_UVW	(ACSR&(1 << ACO)) // ����� �����������
;
;#define START_PWM   10 // ����������� ��� ��� �������
;#define WORK_PWM   100 // ������������ ������� ��� ��� �������
;
;
;// Declare your global variables here
;
;unsigned char start = 0, start_stop = 0, start_pwm;
;unsigned char direction = 1; // 0 - ������ �������, 1 - �� �������
;volatile unsigned char motor_pwm = WORK_PWM;

	.DSEG
;volatile unsigned char commutation_step = 0;
;volatile unsigned char rotor_run = 0; // ������� ��������� �������� ���
;
;// ������� ������������ ������� ���������
;void commutation(unsigned char startup)
; 0000 004B {

	.CSEG
_commutation:
; .FSTART _commutation
; 0000 004C 	switch (commutation_step)
	ST   -Y,R26
;	startup -> Y+0
	LDS  R30,_commutation_step
	LDI  R31,0
; 0000 004D 	{
; 0000 004E 		case (0):
	SBIW R30,0
	BRNE _0x7
; 0000 004F 			if(!SENSE_UVW || startup)
	SBIS 0x8,5
	RJMP _0x9
	RCALL SUBOPT_0x0
	BREQ _0x8
_0x9:
; 0000 0050 			{
; 0000 0051 				if(direction)
	TST  R6
	BREQ _0xB
; 0000 0052 				{
; 0000 0053 				UH_ON; WH_OFF; SENSE_W;
	IN   R30,0x2F
	ORI  R30,0x80
	OUT  0x2F,R30
	RCALL SUBOPT_0x1
	RJMP _0x45
; 0000 0054 				}
; 0000 0055 				else
_0xB:
; 0000 0056 				{
; 0000 0057 				UH_OFF; WH_ON; SENSE_U;
	RCALL SUBOPT_0x2
	IN   R30,0x2F
	ORI  R30,0x20
	OUT  0x2F,R30
	LDI  R30,LOW(0)
_0x45:
	OUT  0x7,R30
; 0000 0058 				}
; 0000 0059 				commutation_step = 1; // ��������� ���
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
; 0000 005A 				TCNT0 = 0; // �������� ������� T0
; 0000 005B 			}
; 0000 005C 			break;
_0x8:
	RJMP _0x6
; 0000 005D 
; 0000 005E 		case (1):
_0x7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD
; 0000 005F 			if(SENSE_UVW || startup)
	SBIC 0x8,5
	RJMP _0xF
	RCALL SUBOPT_0x0
	BREQ _0xE
_0xF:
; 0000 0060 			{
; 0000 0061 				if(direction)
	TST  R6
	BREQ _0x11
; 0000 0062 				{
; 0000 0063 				VL_OFF;	WL_ON; SENSE_V;
	CBI  0x18,0
	SBI  0x18,4
	RJMP _0x46
; 0000 0064 				}
; 0000 0065 				else
_0x11:
; 0000 0066 				{
; 0000 0067 				VL_OFF;	UL_ON; SENSE_V;
	CBI  0x18,0
	SBI  0x18,5
_0x46:
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 0068 				}
; 0000 0069 				commutation_step = 2;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3
; 0000 006A 				TCNT0 = 0; // �������� ������� T0
; 0000 006B 			}
; 0000 006C 			break;
_0xE:
	RJMP _0x6
; 0000 006D 
; 0000 006E 		case (2):
_0xD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 006F 			if(!SENSE_UVW || startup)
	SBIS 0x8,5
	RJMP _0x15
	RCALL SUBOPT_0x0
	BREQ _0x14
_0x15:
; 0000 0070 			{
; 0000 0071 				if(direction)
	TST  R6
	BREQ _0x17
; 0000 0072 				{
; 0000 0073 				UH_OFF; VH_ON; SENSE_U;
	RCALL SUBOPT_0x2
	IN   R30,0x25
	ORI  R30,0x20
	OUT  0x25,R30
	LDI  R30,LOW(0)
	RJMP _0x47
; 0000 0074 				}
; 0000 0075 				else
_0x17:
; 0000 0076 				{
; 0000 0077 				VH_ON; WH_OFF; SENSE_W;
	IN   R30,0x25
	ORI  R30,0x20
	OUT  0x25,R30
	RCALL SUBOPT_0x1
_0x47:
	OUT  0x7,R30
; 0000 0078 				}
; 0000 0079 				commutation_step = 3;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3
; 0000 007A 				TCNT0 = 0; // �������� ������� T0
; 0000 007B 			}
; 0000 007C 			break;
_0x14:
	RJMP _0x6
; 0000 007D 
; 0000 007E 		case (3):
_0x13:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x19
; 0000 007F 			if(SENSE_UVW || startup)
	SBIC 0x8,5
	RJMP _0x1B
	RCALL SUBOPT_0x0
	BREQ _0x1A
_0x1B:
; 0000 0080 			{
; 0000 0081 				if(direction)
	TST  R6
	BREQ _0x1D
; 0000 0082 				{
; 0000 0083 				UL_ON; WL_OFF; SENSE_W;
	SBI  0x18,5
	CBI  0x18,4
	LDI  R30,LOW(2)
	RJMP _0x48
; 0000 0084 				}
; 0000 0085 				else
_0x1D:
; 0000 0086 				{
; 0000 0087 				UL_OFF; WL_ON; SENSE_U;
	CBI  0x18,5
	SBI  0x18,4
	LDI  R30,LOW(0)
_0x48:
	OUT  0x7,R30
; 0000 0088 				}
; 0000 0089 				commutation_step = 4;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3
; 0000 008A 				TCNT0 = 0; // �������� ������� T0
; 0000 008B 			}
; 0000 008C 			break;
_0x1A:
	RJMP _0x6
; 0000 008D 
; 0000 008E 		case (4):
_0x19:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1F
; 0000 008F 			if(!SENSE_UVW || startup)
	SBIS 0x8,5
	RJMP _0x21
	RCALL SUBOPT_0x0
	BREQ _0x20
_0x21:
; 0000 0090 			{
; 0000 0091 				if(direction)
	TST  R6
	BREQ _0x23
; 0000 0092 				{
; 0000 0093 				VH_OFF; WH_ON; SENSE_V;
	RCALL SUBOPT_0x4
	ORI  R30,0x20
	RJMP _0x49
; 0000 0094 				}
; 0000 0095 				else
_0x23:
; 0000 0096 				{
; 0000 0097 				VH_OFF;	UH_ON; SENSE_V;
	RCALL SUBOPT_0x4
	ORI  R30,0x80
_0x49:
	OUT  0x2F,R30
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 0098 				}
; 0000 0099 				commutation_step = 5;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3
; 0000 009A 				TCNT0 = 0; // �������� ������� T0
; 0000 009B 			}
; 0000 009C 			break;
_0x20:
	RJMP _0x6
; 0000 009D 
; 0000 009E 		case (5):
_0x1F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6
; 0000 009F 			if(SENSE_UVW || startup)
	SBIC 0x8,5
	RJMP _0x27
	RCALL SUBOPT_0x0
	BREQ _0x26
_0x27:
; 0000 00A0 			{
; 0000 00A1 				if(direction)
	TST  R6
	BREQ _0x29
; 0000 00A2 				{
; 0000 00A3 				UL_OFF;	VL_ON; SENSE_U;
	CBI  0x18,5
	SBI  0x18,0
	LDI  R30,LOW(0)
	RJMP _0x4A
; 0000 00A4 				}
; 0000 00A5 				else
_0x29:
; 0000 00A6 				{
; 0000 00A7 				VL_ON; WL_OFF; SENSE_W;
	SBI  0x18,0
	CBI  0x18,4
	LDI  R30,LOW(2)
_0x4A:
	OUT  0x7,R30
; 0000 00A8 				}
; 0000 00A9 				commutation_step = 0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x3
; 0000 00AA 				TCNT0 = 0; // �������� ������� T0
; 0000 00AB 			}
; 0000 00AC 			break;
_0x26:
; 0000 00AD 	}
_0x6:
; 0000 00AE }
	ADIW R28,1
	RET
; .FEND
;
;
;
;// Analog Comparator interrupt service routine
;// ���������� ���������� �� �����������. �������� �������� ���
;interrupt [ANA_COMP] void ana_comp_isr(void)
; 0000 00B5 {
_ana_comp_isr:
; .FSTART _ana_comp_isr
	RCALL SUBOPT_0x5
; 0000 00B6 // Place your code here
; 0000 00B7     rotor_run++; // �������������� ��������
	LDS  R30,_rotor_run
	SUBI R30,-LOW(1)
	STS  _rotor_run,R30
; 0000 00B8     if(rotor_run > 200) rotor_run = 200;
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0xC9)
	BRLO _0x2B
	LDI  R30,LOW(200)
	STS  _rotor_run,R30
; 0000 00B9     if(rotor_run == 200) // ���� �������� �������� ��� ������������, ������ ��������
_0x2B:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0xC8)
	BRNE _0x2C
; 0000 00BA     commutation(0); // ����������� ������� �� ������� �����������
	LDI  R26,LOW(0)
	RCALL _commutation
; 0000 00BB 
; 0000 00BC }
_0x2C:
	RJMP _0x4B
; .FEND
;
;// Timer 0 overflow interrupt service routine
;// ���������� ���������� �� ������������ �0. ������ ��������� ��� �������� �������� ���
;// ���� ��������� ����������, ���� �������� ��������� �������� ���
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00C2 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x5
; 0000 00C3 // Place your code here
; 0000 00C4     rotor_run = 0; // ���������� ������� ���������
	LDI  R30,LOW(0)
	STS  _rotor_run,R30
; 0000 00C5     OCR1A = START_PWM; // ��� �������
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00C6     OCR1B = START_PWM;
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00C7     OCR2 = START_PWM;
	OUT  0x23,R30
; 0000 00C8     commutation(1); // ����������� ������� ����������
	LDI  R26,LOW(1)
	RCALL _commutation
; 0000 00C9 
; 0000 00CA }
_0x4B:
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
;// External Interrupt 0 service routine
;// ���������� �������� ���������� INT0. �������
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00CF {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D0 // Place your code here
; 0000 00D1     delay_us(100);
	RCALL SUBOPT_0x7
; 0000 00D2         if ((PIND & ( 1 << PIND2)) == 0){
	SBIC 0x10,2
	RJMP _0x2D
; 0000 00D3             delay_us(100);
	RCALL SUBOPT_0x7
; 0000 00D4     // ������ ������ ������� �������
; 0000 00D5             if ((PIND & ( 1 << PIND1)) == 0)
	SBIC 0x10,1
	RJMP _0x2E
; 0000 00D6             {
; 0000 00D7               if(motor_pwm != START_PWM) motor_pwm -= 5; // ��������� ���
	LDS  R26,_motor_pwm
	CPI  R26,LOW(0xA)
	BREQ _0x2F
	RCALL SUBOPT_0x8
	SUBI R30,LOW(5)
	STS  _motor_pwm,R30
; 0000 00D8             }
_0x2F:
; 0000 00D9     // ������ �� ������� �������
; 0000 00DA             else
	RJMP _0x30
_0x2E:
; 0000 00DB             {
; 0000 00DC               if(motor_pwm != 255) motor_pwm += 5; // ����������� ���
	LDS  R26,_motor_pwm
	CPI  R26,LOW(0xFF)
	BREQ _0x31
	RCALL SUBOPT_0x8
	SUBI R30,-LOW(5)
	STS  _motor_pwm,R30
; 0000 00DD             }
_0x31:
_0x30:
; 0000 00DE         }
; 0000 00DF         GIFR = (1 << INTF0); // ���������� ���� �������� ����������
_0x2D:
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00E0         return;
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	RETI
; 0000 00E1 
; 0000 00E2 }
; .FEND
;
;
;
;
;
;void main(void)
; 0000 00E9 {
_main:
; .FSTART _main
; 0000 00EA // Declare your local variables here
; 0000 00EB 
; 0000 00EC // Input/Output Ports initialization
; 0000 00ED // Port B initialization
; 0000 00EE // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00EF DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00F0 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00F1 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00F2 
; 0000 00F3 // Port C initialization
; 0000 00F4 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00F5 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00F6 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00F7 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00F8 
; 0000 00F9 // Port D initialization
; 0000 00FA // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00FB DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 00FC // State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 00FD PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 00FE 
; 0000 00FF // Timer/Counter 0 initialization
; 0000 0100 // Clock source: System Clock
; 0000 0101 // Clock value: 15,625 kHz
; 0000 0102 TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0103 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0104 
; 0000 0105 // Timer/Counter 1 initialization
; 0000 0106 // Clock source: System Clock
; 0000 0107 // Clock value: 16000,000 kHz
; 0000 0108 // Mode: Fast PWM top=0x00FF
; 0000 0109 // OC1A output: Disconnected
; 0000 010A // OC1B output: Disconnected
; 0000 010B // Noise Canceler: Off
; 0000 010C // Input Capture on Falling Edge
; 0000 010D // Timer Period: 0,016 ms
; 0000 010E // Timer1 Overflow Interrupt: Off
; 0000 010F // Input Capture Interrupt: Off
; 0000 0110 // Compare A Match Interrupt: Off
; 0000 0111 // Compare B Match Interrupt: Off
; 0000 0112 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0113 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 0114 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0115 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0116 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0117 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0118 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0119 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 011A //OCR1AH=(START_PWM)>>8;
; 0000 011B //OCR1AL=(START_PWM) & 0xFF;
; 0000 011C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 011D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 011E 
; 0000 011F 
; 0000 0120 // Timer/Counter 2 initialization
; 0000 0121 // Clock source: System Clock
; 0000 0122 // Clock value: 16000,000 kHz
; 0000 0123 // Mode: Fast PWM top=0xFF
; 0000 0124 // OC2 output: Non-Inverted PWM
; 0000 0125 // Timer Period: 0,016 ms
; 0000 0126 // Output Pulse(s):
; 0000 0127 // OC2 Period: 0,016 ms Width: 0 us
; 0000 0128 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0129 TCCR2= (1<<COM21) | (0<<COM20) | (1<<WGM21) | (1<<WGM20) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(105)
	OUT  0x25,R30
; 0000 012A TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 012B OCR2=0x00;;
	OUT  0x23,R30
; 0000 012C 
; 0000 012D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 012E TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 012F 
; 0000 0130 // External Interrupt(s) initialization
; 0000 0131 // INT0: On
; 0000 0132 // INT0 Mode: Falling Edge
; 0000 0133 // INT1: Off
; 0000 0134 GICR|=(0<<INT1) | (1<<INT0);
; 0000 0135 MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0136 GIFR=(0<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0137 
; 0000 0138 // USART initialization
; 0000 0139 // USART disabled
; 0000 013A UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 013B 
; 0000 013C // ADC initialization
; 0000 013D // ADC disabled
; 0000 013E ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 013F 
; 0000 0140 // Analog Comparator initialization
; 0000 0141 // Analog Comparator: On
; 0000 0142 // The Analog Comparator's positive input is
; 0000 0143 // connected to the AIN0 pin
; 0000 0144 // The Analog Comparator's negative input is
; 0000 0145 // connected to the ADC multiplexer
; 0000 0146 // Interrupt on Output Toggle
; 0000 0147 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0148 ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(8)
	OUT  0x8,R30
; 0000 0149 SFIOR=(1<<ACME);
	OUT  0x30,R30
; 0000 014A 
; 0000 014B 
; 0000 014C // SPI initialization
; 0000 014D // SPI disabled
; 0000 014E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 014F 
; 0000 0150 // TWI initialization
; 0000 0151 // TWI disabled
; 0000 0152 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0153 
; 0000 0154 PHASE_ALL_OFF; // ��������� ��� ����
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xA
; 0000 0155 
; 0000 0156 // Global enable interrupts
; 0000 0157 #asm("sei")
	sei
; 0000 0158 
; 0000 0159 while (1)
_0x32:
; 0000 015A     {
; 0000 015B       // Place your code here
; 0000 015C       if((PIND&(1 << PIND0)) == 0) // �����/����
	SBIC 0x10,0
	RJMP _0x35
; 0000 015D         {
; 0000 015E             delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
; 0000 015F             start_stop ^= 1; // ����������� ���������
	LDI  R30,LOW(1)
	EOR  R4,R30
; 0000 0160             while((PIND&(1 << PIND0)) == 0){} // ���� ���������� ������
_0x36:
	SBIS 0x10,0
	RJMP _0x36
; 0000 0161            // while((PIND.0) == 0){}
; 0000 0162         }
; 0000 0163 
; 0000 0164         if(start_stop)
_0x35:
	TST  R4
	BREQ _0x39
; 0000 0165         {
; 0000 0166             ACSR |= (1 << ACIE); // ��������� ���������� �� �����������
	SBI  0x8,3
; 0000 0167             TIMSK |= (1 << TOIE0); // ��������� ���������� �� ������������ T0
	IN   R30,0x39
	ORI  R30,1
	RCALL SUBOPT_0x9
; 0000 0168             GICR |= (1 << INT0); // ��������� ������� ���������� INT0
; 0000 0169             // ������� �����
; 0000 016A               if(rotor_run == 200 && start == 0) // ���� �������� �������� ��� ������������ � ��������� �� ��� �������
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0xC8)
	BRNE _0x3B
	TST  R5
	BREQ _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 016B               {
; 0000 016C                 for(start_pwm = START_PWM; start_pwm < motor_pwm; start_pwm++)
	LDI  R30,LOW(10)
	MOV  R7,R30
_0x3E:
	RCALL SUBOPT_0x8
	CP   R7,R30
	BRSH _0x3F
; 0000 016D                     {
; 0000 016E                       delay_ms(10); // ��������
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 016F                       OCR1A = start_pwm;
	MOV  R30,R7
	LDI  R31,0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0170                       OCR1B = start_pwm;
	MOV  R30,R7
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0171                       OCR2 = start_pwm;
	OUT  0x23,R7
; 0000 0172                     }
	INC  R7
	RJMP _0x3E
_0x3F:
; 0000 0173                   start = 1; // ������ ���������
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0174                   PORTD |= (1 << PORTD7); // �������� ���������
	SBI  0x12,7
; 0000 0175               }
; 0000 0176 
; 0000 0177               if(rotor_run == 200) // ���� �������� �������� ��� ������������, ����� ������ ���
_0x3A:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0xC8)
	BRNE _0x40
; 0000 0178               {
; 0000 0179                   OCR1A = motor_pwm;
	RCALL SUBOPT_0x8
	LDI  R31,0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 017A                   OCR1B = motor_pwm;
	RCALL SUBOPT_0x8
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 017B                   OCR2 = motor_pwm;
	RCALL SUBOPT_0x8
	OUT  0x23,R30
; 0000 017C               }
; 0000 017D         }
_0x40:
; 0000 017E         else
	RJMP _0x41
_0x39:
; 0000 017F         {
; 0000 0180 
; 0000 0181             if(PIND&(1 << PIND3)) direction = 1; // ����� ����������� �������� ����
	SBIS 0x10,3
	RJMP _0x42
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0182             else direction = 0;
	RJMP _0x43
_0x42:
	CLR  R6
; 0000 0183 
; 0000 0184             start = 0; // ��������� ����������
_0x43:
	CLR  R5
; 0000 0185             PORTD &= ~(1 << PORTD7); // ��������� ���������
	CBI  0x12,7
; 0000 0186             PHASE_ALL_OFF; // ��� ���� ���������
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xA
; 0000 0187             ACSR &= ~(1 << ACIE); // ��������� ���������� �� �����������
	CBI  0x8,3
; 0000 0188             TIMSK &= ~(1 << TOIE0); // ��������� ���������� �� ������������ T0
	IN   R30,0x39
	ANDI R30,0xFE
	OUT  0x39,R30
; 0000 0189             GICR &= ~(1 << INT0); // ��������� ������� ���������� INT0
	IN   R30,0x3B
	ANDI R30,0xBF
	OUT  0x3B,R30
; 0000 018A         }
_0x41:
; 0000 018B 
; 0000 018C 
; 0000 018D       }
	RJMP _0x32
; 0000 018E }
_0x44:
	RJMP _0x44
; .FEND

	.DSEG
_motor_pwm:
	.BYTE 0x1
_commutation_step:
	.BYTE 0x1
_rotor_run:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	IN   R30,0x2F
	ANDI R30,0xDF
	OUT  0x2F,R30
	LDI  R30,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	IN   R30,0x2F
	ANDI R30,0x7F
	OUT  0x2F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	STS  _commutation_step,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	IN   R30,0x25
	ANDI R30,0xDF
	OUT  0x25,R30
	IN   R30,0x2F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_rotor_run
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R30,_motor_pwm
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	OUT  0x39,R30
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	CBI  0x18,5
	IN   R30,0x25
	ANDI R30,0xDF
	OUT  0x25,R30
	CBI  0x18,0
	IN   R30,0x2F
	ANDI R30,0xDF
	OUT  0x2F,R30
	CBI  0x18,4
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
