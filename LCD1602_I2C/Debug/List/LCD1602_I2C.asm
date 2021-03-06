
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
	.DEF _btn_flag=R5
	.DEF _click_flag=R4
	.DEF _count=R7

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
	RJMP _twi_int_handler
	RJMP 0x00

_progress_bar_G001:
	.DB  0x0,0x10,0x18,0x1C,0x1E,0x1F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x48,0x65,0x6C,0x6C,0x6F,0x20,0x57,0x6F
	.DB  0x72,0x6C,0x64,0x0,0x50,0x72,0x65,0x73
	.DB  0x73,0x20,0x42,0x75,0x74,0x74,0x6F,0x6E
	.DB  0x0
_0x2000003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0C
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x0D
	.DW  _0x6+12
	.DW  _0x0*2+12

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2000003*2

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
;Project :
;Version :
;Date    : 29.05.2021
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
;#include "hd44780.h"
;
;// Declare your global variables here
;
;unsigned char btn_flag = 0;
;unsigned char click_flag = 0;
;unsigned char count = 0;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0024 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0025 // Reinitialize Timer 0 value
; 0000 0026 TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 0027 // Place your code here
; 0000 0028 
; 0000 0029  if (count == 19)
	LDI  R30,LOW(19)
	CP   R30,R7
	BRNE _0x3
; 0000 002A         {
; 0000 002B            btn_flag = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 002C            count = 0;
	CLR  R7
; 0000 002D            if (click_flag)
	TST  R4
	BREQ _0x4
; 0000 002E             {
; 0000 002F                 click_flag=0;
	CLR  R4
; 0000 0030             }
; 0000 0031             else
	RJMP _0x5
_0x4:
; 0000 0032             {
; 0000 0033                 click_flag=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0034             }
_0x5:
; 0000 0035 
; 0000 0036         }
; 0000 0037     count++;
_0x3:
	INC  R7
; 0000 0038 
; 0000 0039 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// SPI functions
;#include <spi.h>
;
;// TWI functions
;#include <twi.h>
;
;void main(void)
; 0000 0042 {
_main:
; .FSTART _main
; 0000 0043 // Declare your local variables here
; 0000 0044 
; 0000 0045 // Input/Output Ports initialization
; 0000 0046 // Port B initialization
; 0000 0047 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 0048 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(46)
	OUT  0x17,R30
; 0000 0049 // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 004A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 004B 
; 0000 004C // Port C initialization
; 0000 004D // Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 004E DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(48)
	OUT  0x14,R30
; 0000 004F // State: Bit6=T Bit5=1 Bit4=1 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0050 PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0051 
; 0000 0052 // Port D initialization
; 0000 0053 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0054 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0055 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0056 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0057 
; 0000 0058 // Timer/Counter 0 initialization
; 0000 0059 // Clock source: System Clock
; 0000 005A // Clock value: 7,813 kHz
; 0000 005B TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 005C TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 005D 
; 0000 005E // Timer/Counter 1 initialization
; 0000 005F // Clock source: System Clock
; 0000 0060 // Clock value: 8000,000 kHz
; 0000 0061 // Mode: CTC top=OCR1A
; 0000 0062 // OC1A output: Disconnected
; 0000 0063 // OC1B output: Disconnected
; 0000 0064 // Noise Canceler: Off
; 0000 0065 // Input Capture on Falling Edge
; 0000 0066 // Timer Period: 1,1364 ms
; 0000 0067 // Timer1 Overflow Interrupt: Off
; 0000 0068 // Input Capture Interrupt: Off
; 0000 0069 // Compare A Match Interrupt: Off
; 0000 006A // Compare B Match Interrupt: Off
; 0000 006B TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(64)
	OUT  0x2F,R30
; 0000 006C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 006D TCNT1H=0xDC;
	LDI  R30,LOW(220)
	OUT  0x2D,R30
; 0000 006E TCNT1L=0x7D;
	LDI  R30,LOW(125)
	OUT  0x2C,R30
; 0000 006F ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0070 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0071 OCR1AH=0x23;
	LDI  R30,LOW(35)
	OUT  0x2B,R30
; 0000 0072 OCR1AL=0x82;
	LDI  R30,LOW(130)
	OUT  0x2A,R30
; 0000 0073 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0074 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0075 
; 0000 0076 // Timer/Counter 2 initialization
; 0000 0077 // Clock source: System Clock
; 0000 0078 // Clock value: Timer2 Stopped
; 0000 0079 // Mode: Normal top=0xFF
; 0000 007A // OC2 output: Disconnected
; 0000 007B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 007C TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 007D TCNT2=0x00;
	OUT  0x24,R30
; 0000 007E OCR2=0x00;
	OUT  0x23,R30
; 0000 007F 
; 0000 0080 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0081 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0082 
; 0000 0083 // External Interrupt(s) initialization
; 0000 0084 // INT0: Off
; 0000 0085 // INT1: Off
; 0000 0086 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0087 
; 0000 0088 // USART initialization
; 0000 0089 // USART disabled
; 0000 008A UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 008B 
; 0000 008C // Analog Comparator initialization
; 0000 008D // Analog Comparator: Off
; 0000 008E // The Analog Comparator's positive input is
; 0000 008F // connected to the AIN0 pin
; 0000 0090 // The Analog Comparator's negative input is
; 0000 0091 // connected to the AIN1 pin
; 0000 0092 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0093 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0094 
; 0000 0095 // ADC initialization
; 0000 0096 // ADC disabled
; 0000 0097 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0098 
; 0000 0099 // SPI initialization
; 0000 009A // SPI Type: Master
; 0000 009B // SPI Clock Rate: 500,000 kHz
; 0000 009C // SPI Clock Phase: Cycle Start
; 0000 009D // SPI Clock Polarity: Low
; 0000 009E // SPI Data Order: MSB First
; 0000 009F SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (1<<SPR0);
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 00A0 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 00A1 
; 0000 00A2 // TWI initialization
; 0000 00A3 // Mode: TWI Master
; 0000 00A4 // Bit Rate: 100 kHz
; 0000 00A5 twi_master_init(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _twi_master_init
; 0000 00A6 
; 0000 00A7 // Global enable interrupts
; 0000 00A8 #asm("sei")
	sei
; 0000 00A9 
; 0000 00AA lcd_init();
	RCALL _lcd_init
; 0000 00AB lcd_goto(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_goto
; 0000 00AC lcd_puts("Hello World");
	__POINTW2MN _0x6,0
	RCALL _lcd_puts
; 0000 00AD 
; 0000 00AE while (1)
_0x7:
; 0000 00AF       {
; 0000 00B0       // Place your code here
; 0000 00B1       if (!PIND.0 && btn_flag)
	SBIC 0x10,0
	RJMP _0xB
	TST  R5
	BRNE _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 00B2           {
; 0000 00B3             if (!click_flag)
	TST  R4
	BRNE _0xD
; 0000 00B4             {
; 0000 00B5                 btn_flag=0;
	CLR  R5
; 0000 00B6                 lcd_goto(2,2);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(2)
	RCALL _lcd_goto
; 0000 00B7                 lcd_puts("Press Button");
	__POINTW2MN _0x6,12
	RCALL _lcd_puts
; 0000 00B8             }
; 0000 00B9 
; 0000 00BA           }
_0xD:
; 0000 00BB 
; 0000 00BC       }
_0xA:
	RJMP _0x7
; 0000 00BD }
_0xE:
	RJMP _0xE
; .FEND

	.DSEG
_0x6:
	.BYTE 0x19
;//------------------------------------------------------
;/* File:       Library for HD44780 compatible displays  */
;/* Version:	   v2.01  						 			*/
;//------------------------------------------------------
;
;#include <delay.h>
;#include "hd44780.h"
;
;/*!	\brief	Macro-definitions. */
;#define BIT(n)						(1u << (n))
;#define SET(x,n)           			((x) |= BIT(n))
;#define CLR(x,n)  		  			((x) &= ~BIT(n))
;#define GET(x,n)   		  			(((x) & BIT(n)) ? 1u : 0u)
;
;
;
;#define ENABLE_CYCLE_TIME			1u	/* Minimal value ~ 1us */
;#define AC_UPDATE_TIME				1u	/* Minimal value ~ 4us */
;
;#define CMD 0u // command
;#define DTA 1u // data
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
;static void lcd_initbar(void);
;#endif
;
;/*!	\brief	Low-level functions. */
;static void lcd_config(uint8_t param);
;static void lcd_write(uint8_t data, uint8_t mode);
;static void lcd_10us_delay(volatile uint32_t us);
;static uint32_t lcd_pow10(uint8_t n);
;
;
;/*!	\brief	Creates delay multiples of 10us. */
;static void lcd_10us_delay(volatile uint32_t us)
; 0001 002D {

	.CSEG
_lcd_10us_delay_G001:
; .FSTART _lcd_10us_delay_G001
; 0001 002E 	/* �onversion to us */
; 0001 002F 	us *= MCU_FREQ_VALUE;
	RCALL __PUTPARD2
;	us -> Y+0
	RCALL SUBOPT_0x1
	__GETD2N 0x8
	RCALL __MULD12U
	RCALL SUBOPT_0x2
; 0001 0030 	/* Wait */
; 0001 0031 	while (us > 0u)
_0x20003:
	RCALL __GETD2S0
	RCALL __CPD02
	BRSH _0x20005
; 0001 0032 	{
; 0001 0033 		us--;
	RCALL SUBOPT_0x3
; 0001 0034 	}
	RJMP _0x20003
_0x20005:
; 0001 0035 }
	ADIW R28,4
	RET
; .FEND
;
;
;/*!	\brief	Send data/commands to the display. */
;static void lcd_write(uint8_t data, uint8_t mode)
; 0001 003A {/* Low level function. */
_lcd_write_G001:
; .FSTART _lcd_write_G001
; 0001 003B 
; 0001 003C 	uint8_t LCD_data[4];
; 0001 003D 
; 0001 003E 	LCD_data[0]=(data & 0xF0)|(mode<<LCD_RS)|(1<<LCD_E);
	ST   -Y,R26
	SBIW R28,4
;	data -> Y+5
;	mode -> Y+4
;	LCD_data -> Y+0
	LDD  R30,Y+5
	ANDI R30,LOW(0xF0)
	LDD  R26,Y+4
	OR   R30,R26
	RCALL SUBOPT_0x4
; 0001 003F     LCD_data[1]=LCD_data[0]&~(1<<LCD_E);
; 0001 0040 	LCD_data[2]=(data<<4)|(mode<<LCD_RS)|(1<<LCD_E);
	LDD  R30,Y+5
	SWAP R30
	ANDI R30,0xF0
	LDD  R26,Y+4
	OR   R30,R26
	ORI  R30,4
	STD  Y+2,R30
; 0001 0041     LCD_data[3]=LCD_data[02]&~(1<<LCD_E);;
	ANDI R30,0xFB
	STD  Y+3,R30
; 0001 0042     twi_master_trans(I2C_ADR_PCF8574,LCD_data,4,0,0);
	RCALL SUBOPT_0x5
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL SUBOPT_0x6
; 0001 0043 
; 0001 0044 
; 0001 0045 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 0046 }
	ADIW R28,6
	RET
; .FEND
;
;/*!	\brief	Initializing by instruction. 4-bit interface initialization. */
;static void lcd_config(uint8_t param)
; 0001 004A {/* Low level function. */
_lcd_config_G001:
; .FSTART _lcd_config_G001
; 0001 004B 	uint8_t LCD_data[2];
; 0001 004C 
; 0001 004D 	/* Send commands to LCD. */
; 0001 004E 
; 0001 004F 	LCD_data[0]=(param & 0xF0)|(CMD<<LCD_RS)|(1<<LCD_E);// Change 8-bit interface to 4-bit interface
	ST   -Y,R26
	SBIW R28,2
;	param -> Y+2
;	LCD_data -> Y+0
	LDD  R30,Y+2
	ANDI R30,LOW(0xF0)
	RCALL SUBOPT_0x4
; 0001 0050     LCD_data[1]=LCD_data[0] &~(1<<LCD_E);
; 0001 0051 	twi_master_trans(I2C_ADR_PCF8574,LCD_data,2,0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x6
; 0001 0052 
; 0001 0053 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 0054 
; 0001 0055 
; 0001 0056 	LCD_data[0]=(param & 0xF0)|(CMD<<LCD_RS)|(1<<LCD_E);/* DB7 to DB4 of the "Function set" instruction is written twice. * ...
	LDD  R30,Y+2
	ANDI R30,LOW(0xF0)
	RCALL SUBOPT_0x4
; 0001 0057     LCD_data[1]=LCD_data[0] &~(1<<LCD_E);
; 0001 0058 	twi_master_trans(I2C_ADR_PCF8574,LCD_data,2,0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x6
; 0001 0059 
; 0001 005A 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 005B 
; 0001 005C 
; 0001 005D 	LCD_data[0]=(param<<4)|(CMD<<LCD_RS)|(1<<LCD_E); // 4-bit, two lines, 5x8 pixel
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF0
	RCALL SUBOPT_0x4
; 0001 005E     LCD_data[1]=LCD_data[0] &~(1<<LCD_E);;
; 0001 005F     twi_master_trans(I2C_ADR_PCF8574,LCD_data,2,0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x6
; 0001 0060 
; 0001 0061 	lcd_10us_delay(BUSY_CYCLE_TIME);
; 0001 0062 	/* Note: The number of display lines and character font cannot be changed after this point. */
; 0001 0063 }
	RJMP _0x2060003
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
; 0001 0070 {
_lcd_clrscr:
; .FSTART _lcd_clrscr
; 0001 0071 
; 0001 0072 	/* Clear screen */
; 0001 0073 	lcd_write(0x01u, CMD);
	LDI  R30,LOW(1)
	RJMP _0x2060006
; 0001 0074 	lcd_10us_delay(CLRSCR_CYCLE_TIME);
; 0001 0075 
; 0001 0076 }
; .FEND
;
;/*!	\details	"Return home" sets DDRAM address 0 into the address counter,
; * 				and returns the display to its original status if it was shifted.
; * 				The DDRAM contents do not change.
; * 				The cursor or blinking go to the left edge of the display
; * 				(in the first line if 2 lines are displayed). */
;void lcd_return(void)
; 0001 007E {
_lcd_return:
; .FSTART _lcd_return
; 0001 007F 	/* Return home */
; 0001 0080 	lcd_write(0x02u, CMD);
	LDI  R30,LOW(2)
_0x2060006:
	ST   -Y,R30
	RCALL SUBOPT_0x7
; 0001 0081 	/* Busy delay */
; 0001 0082 	lcd_10us_delay(RETHOME_CYCLE_TIME);
	__GETD2N 0xC8
	RCALL _lcd_10us_delay_G001
; 0001 0083 
; 0001 0084 }
	RET
; .FEND
;
;/*!	\details	lcd_scroll shifts the display to the right or left without writing or reading display data.
; * 				This function is used to correct or search the display.
; *	\note		The first and second line displays will shift at the same time. */
;void lcd_scroll(uint8_t direction)
; 0001 008A {
; 0001 008B 
; 0001 008C 	/* Scroll display */
; 0001 008D 	switch (direction)
;	direction -> Y+0
; 0001 008E 	{
; 0001 008F 	/* To left */
; 0001 0090 		case LEFT  :
; 0001 0091 			lcd_write(0x18u,CMD);
; 0001 0092 			break;
; 0001 0093 
; 0001 0094 		/* To right */
; 0001 0095 		case RIGHT :
; 0001 0096 			lcd_write(0x1Cu, CMD);
; 0001 0097 			break;
; 0001 0098 
; 0001 0099 		default:
; 0001 009A 			/* Ignore this command */
; 0001 009B 			break;
; 0001 009C 	}
; 0001 009D }
;
;/*!	\details	"Cursor shift" shifts the cursor position to the right or left,
; * 				without writing or reading display data.
; * 				This function is used to correct or search the display.
; * 				In a 2-line display, the cursor moves to the second line
; * 				when it passes the 40th digit of the first line. */
;void cursor_shift(uint8_t direction)
; 0001 00A5 {
_cursor_shift:
; .FSTART _cursor_shift
; 0001 00A6 
; 0001 00A7 	/* Shift cursor */
; 0001 00A8 	switch (direction)
	ST   -Y,R26
;	direction -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0001 00A9 	{
; 0001 00AA 		/* To left */
; 0001 00AB 		case LEFT  :
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0x2000F
; 0001 00AC 			lcd_write(0x10u, CMD);
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x8
; 0001 00AD 			break;
	RJMP _0x2000E
; 0001 00AE 
; 0001 00AF 		/* To right */
; 0001 00B0 		case RIGHT :
_0x2000F:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0x20011
; 0001 00B1 			lcd_write(0x14u, CMD);
	LDI  R30,LOW(20)
	RCALL SUBOPT_0x8
; 0001 00B2 			break;
; 0001 00B3 
; 0001 00B4 		default:
_0x20011:
; 0001 00B5 			/* Ignore this command */
; 0001 00B6 			break;
; 0001 00B7 	}
_0x2000E:
; 0001 00B8 }
	RJMP _0x2060005
; .FEND
;
;/*!	\details	Go to the specified (DDRAM/CGRAM) memory address.*/
;void lcd_goto(uint8_t line, uint8_t address)
; 0001 00BC {
_lcd_goto:
; .FSTART _lcd_goto
; 0001 00BD 	/* Set DDRAM/CGRAM address. */
; 0001 00BE 	switch (line)
	ST   -Y,R26
;	line -> Y+1
;	address -> Y+0
	LDD  R30,Y+1
	LDI  R31,0
; 0001 00BF 	{
; 0001 00C0 		/* Set DDRAM address. */
; 0001 00C1 		case LCD_1st_LINE: lcd_write(0x80u | START_ADDRESS_1st_LINE | address, CMD); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20015
	LD   R30,Y
	ORI  R30,0x80
	RCALL SUBOPT_0x8
	RJMP _0x20014
; 0001 00C2 		case LCD_2nd_LINE: lcd_write(0x80u | START_ADDRESS_2nd_LINE | address, CMD); break;
_0x20015:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20016
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	RCALL SUBOPT_0x8
	RJMP _0x20014
; 0001 00C3 		case LCD_3rd_LINE: lcd_write(0x80u | START_ADDRESS_3rd_LINE | address, CMD); break;
_0x20016:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20017
	LD   R30,Y
	ORI  R30,LOW(0x90)
	RCALL SUBOPT_0x8
	RJMP _0x20014
; 0001 00C4 		case LCD_4th_LINE: lcd_write(0x80u | START_ADDRESS_4th_LINE | address, CMD); break;
_0x20017:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20018
	LD   R30,Y
	ORI  R30,LOW(0xD0)
	RCALL SUBOPT_0x8
	RJMP _0x20014
; 0001 00C5 		/* Set CGRAM address. */
; 0001 00C6 		case CGRAM : lcd_write(0x40u | address, CMD); break;
_0x20018:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2001A
	LD   R30,Y
	ORI  R30,0x40
	RCALL SUBOPT_0x8
; 0001 00C7 
; 0001 00C8 		default:
_0x2001A:
; 0001 00C9 			/* Ignore this command */
; 0001 00CA 			break;
; 0001 00CB 	}
_0x20014:
; 0001 00CC }
	RJMP _0x2060004
; .FEND
;
;/*!	\details	Change LCD settings. */
;void lcd_setmode(uint8_t param)
; 0001 00D0 {
_lcd_setmode:
; .FSTART _lcd_setmode
; 0001 00D1 	/* Send a command to LCD. */
; 0001 00D2 	lcd_write(param, CMD);
	ST   -Y,R26
;	param -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x8
; 0001 00D3 }
	RJMP _0x2060005
; .FEND
;
;/*!	\details	Write a single char to the current memory space (DDRAM/CGRAM). */
;void lcd_putc(uint8_t data)
; 0001 00D7 {
_lcd_putc:
; .FSTART _lcd_putc
; 0001 00D8 	/* Send data to LCD. */
; 0001 00D9 	lcd_write(data, DTA);
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_write_G001
; 0001 00DA 	/* Note:
; 0001 00DB 	 * After execution of the CGRAM/DDRAM data write/read instruction, the RAM address counter is incremented
; 0001 00DC 	 * or decremented by 1. The RAM address counter is updated after the busy flag turns off.
; 0001 00DD 	 * tADD is the time elapsed after the busy flag turns off until the address counter is updated. */
; 0001 00DE 	lcd_10us_delay(AC_UPDATE_TIME);	/* Update RAM address counter delay. */
	__GETD2N 0x1
	RCALL _lcd_10us_delay_G001
; 0001 00DF }
_0x2060005:
	ADIW R28,1
	RET
; .FEND
;
;/*!	\details	Writes ANSI-C string to LCD (DDRAM memory space). */
;void lcd_puts(const uint8_t *str)
; 0001 00E3 {
_lcd_puts:
; .FSTART _lcd_puts
; 0001 00E4 	/* Send a ANSI-C string to LCD. */
; 0001 00E5 	while ('\0' != *str)
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x2001B:
	RCALL SUBOPT_0x9
	CPI  R30,0
	BREQ _0x2001D
; 0001 00E6 	{
; 0001 00E7 #if ( USE_FORMATTED_OUTPUT )
; 0001 00E8 		if(('\n' == *str))
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0xA)
	BRNE _0x2001E
; 0001 00E9 		{/*New line */
; 0001 00EA 			lcd_goto(LCD_2nd_LINE, 0u);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	RCALL _lcd_goto
; 0001 00EB 		}
; 0001 00EC 		else if(('\r' == *str))
	RJMP _0x2001F
_0x2001E:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0xD)
	BRNE _0x20020
; 0001 00ED 		{/* Return home */
; 0001 00EE 			lcd_return();
	RCALL _lcd_return
; 0001 00EF 		}
; 0001 00F0 		else if(('\t' == *str))
	RJMP _0x20021
_0x20020:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0x9)
	BRNE _0x20022
; 0001 00F1 		{/* Tab space */
; 0001 00F2 			uint8_t i;
; 0001 00F3 
; 0001 00F4 			for(i=0u; i<TAB_SPACE; i++)
	SBIW R28,1
;	*str -> Y+1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x20024:
	LD   R26,Y
	CLR  R27
	SBIW R26,4
	BRGE _0x20025
; 0001 00F5 			{/* Shift cursor to the right. */
; 0001 00F6 				cursor_shift(RIGHT);
	LDI  R26,LOW(62)
	RCALL _cursor_shift
; 0001 00F7 			}
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x20024
_0x20025:
; 0001 00F8 		}
	ADIW R28,1
; 0001 00F9 		else
	RJMP _0x20026
_0x20022:
; 0001 00FA #endif
; 0001 00FB 		{
; 0001 00FC 			/* Display a symbol. */
; 0001 00FD 			lcd_putc(*str);
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	RCALL _lcd_putc
; 0001 00FE 		}
_0x20026:
_0x20021:
_0x2001F:
; 0001 00FF 		/* Get the next symbol. */
; 0001 0100 		str++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0001 0101 	}
	RJMP _0x2001B
_0x2001D:
; 0001 0102 }
_0x2060004:
	ADIW R28,2
	RET
; .FEND
;
;/*!	\details	Load the user-defined symbol into the CGRAM memory. */
;void lcd_loadchar(uint8_t* vector, uint8_t position)
; 0001 0106 {
; 0001 0107 	uint8_t i;
; 0001 0108 	/* Go to the CGRAM memory space: 0 to 7 */
; 0001 0109 	lcd_goto(CGRAM, (position * FONT_HEIGHT));
;	*vector -> Y+2
;	position -> Y+1
;	i -> R17
; 0001 010A 
; 0001 010B 	for(i = 0u; i < FONT_HEIGHT; i++)
; 0001 010C 	{/* Load one row of pixels into the CGRAM register. */
; 0001 010D 		lcd_putc(vector[i]);
; 0001 010E 	}
; 0001 010F 
; 0001 0110 	/* Return to the DDRAM memory space. */
; 0001 0111 	lcd_goto(LCD_1st_LINE, 0u);
; 0001 0112 }
;
;/*!	\details	Load and display the user-defined symbol. */
;void lcd_drawchar( uint8_t* vector,
; 0001 0116 			   	   uint8_t position,
; 0001 0117 			   	   uint8_t line,
; 0001 0118 			   	   uint8_t address )
; 0001 0119 {
; 0001 011A 	/* Load the user-defined symbol into the CGRAM memory. */
; 0001 011B 	lcd_loadchar(vector, position);
;	*vector -> Y+3
;	position -> Y+2
;	line -> Y+1
;	address -> Y+0
; 0001 011C 	/* Select LCD position. */
; 0001 011D 	lcd_goto(line, address);
; 0001 011E 	/* Display the user-defined symbol. */
; 0001 011F 	lcd_putc(position);
; 0001 0120 }
;
;/*!	\details	Erase a symbol from the left of the cursor. */
;void lcd_backspace(void)
; 0001 0124 {
; 0001 0125 	cursor_shift(LEFT);		// �������� ������ �� ���� ������� �����
; 0001 0126 	lcd_putc(' ');			// �������, ����� ���� ���������� ������������� ������
; 0001 0127 	cursor_shift(LEFT);		// �������� ������ �� ���� ������� �����
; 0001 0128 }
;
;/*!	\brief	Returns 10^n value. */
;static uint32_t lcd_pow10(uint8_t n)
; 0001 012C {
; 0001 012D 	uint32_t retval = 1u;
; 0001 012E 
; 0001 012F 	while (n > 0u)
;	n -> Y+4
;	retval -> Y+0
; 0001 0130 	{
; 0001 0131 		retval *= 10u;
; 0001 0132 		n--;
; 0001 0133 	}
; 0001 0134 
; 0001 0135 	return retval;
; 0001 0136 }
;
;/*!	\brief	Display a integer number: +/- 2147483647. */
;void lcd_itos(int32_t value)
; 0001 013A {
; 0001 013B 	int32_t i;
; 0001 013C 
; 0001 013D 	if (value < 0)
;	value -> Y+4
;	i -> Y+0
; 0001 013E 	{
; 0001 013F 		lcd_putc('-');
; 0001 0140 		value = -value;
; 0001 0141 	}
; 0001 0142 
; 0001 0143 	i = 1;
; 0001 0144 	while ((value / i) > 9)
; 0001 0145 	{
; 0001 0146 		i *= 10;
; 0001 0147 	}
; 0001 0148 
; 0001 0149 	lcd_putc(value/i + '0');	/* Display at least one symbol */
; 0001 014A 	i /= 10;
; 0001 014B 
; 0001 014C 	while (i > 0)
; 0001 014D 	{
; 0001 014E 		lcd_putc('0' + ((value % (i*10)) / i));
; 0001 014F 		i /= 10;
; 0001 0150 	}
; 0001 0151 }
;
;/*!	\brief	Display a floating point number. */
;void lcd_ftos(float value, uint8_t n)
; 0001 0155 {
; 0001 0156 	if (value < 0.0)
;	value -> Y+1
;	n -> Y+0
; 0001 0157 	{
; 0001 0158 		lcd_putc('-');
; 0001 0159 		value = -value;
; 0001 015A 	}
; 0001 015B 
; 0001 015C 	lcd_itos((int32_t)value); // ����� ����� �����
; 0001 015D 
; 0001 015E 	if (n > 0u)
; 0001 015F 	{
; 0001 0160 		lcd_putc('.'); // �����
; 0001 0161 
; 0001 0162 		lcd_ntos((uint32_t)(value * (float)lcd_pow10(n)), n); // ����� ������� �����
; 0001 0163 	}
; 0001 0164 }
;
;/*!	\brief	Display "n" right digits of "value". */
;void lcd_ntos(uint32_t value, uint8_t n)
; 0001 0168 {
; 0001 0169 	if (n > 0u)
;	value -> Y+1
;	n -> Y+0
; 0001 016A 	{
; 0001 016B 		uint32_t i = lcd_pow10(n - 1u);
; 0001 016C 
; 0001 016D 		while (i > 0u)	/* Display at least one symbol */
;	value -> Y+5
;	n -> Y+4
;	i -> Y+0
; 0001 016E 		{
; 0001 016F 			lcd_putc('0' + ((value/i) % 10u));
; 0001 0170 
; 0001 0171 			i /= 10u;
; 0001 0172 		}
; 0001 0173 	}
; 0001 0174 }
;
;#if ( USE_PROGRESS_BAR )
;/*!	\brief	Initialize the progress bar
; * 			(i.e. preload elements of the progress bar into CGRAM and reset all variables). */
;static void lcd_initbar(void)
; 0001 017A {
_lcd_initbar_G001:
; .FSTART _lcd_initbar_G001
; 0001 017B 	uint8_t i, j;
; 0001 017C 
; 0001 017D 	for (i = 0u; i < CGROM_PROGRESS_BAR_SIZE; i++)
	RCALL __SAVELOCR2
;	i -> R17
;	j -> R16
	LDI  R17,LOW(0)
_0x2003B:
	MOV  R26,R17
	CLR  R27
	SBIW R26,6
	BRGE _0x2003C
; 0001 017E 	{
; 0001 017F 		lcd_goto(CGRAM, (i * FONT_HEIGHT));
	LDI  R30,LOW(5)
	ST   -Y,R30
	MOV  R30,R17
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R26,R30
	RCALL _lcd_goto
; 0001 0180 
; 0001 0181 		for (j = 0u; j < FONT_HEIGHT; j++)
	LDI  R16,LOW(0)
_0x2003E:
	MOV  R26,R16
	CLR  R27
	SBIW R26,8
	BRGE _0x2003F
; 0001 0182 		{
; 0001 0183 			if (j < PROGRESS_BAR_HEIGHT)
	MOV  R26,R16
	CLR  R27
	SBIW R26,3
	BRGE _0x20040
; 0001 0184 			{
; 0001 0185 				lcd_putc(progress_bar[i]);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_progress_bar_G001*2)
	SBCI R31,HIGH(-_progress_bar_G001*2)
	LPM  R26,Z
	RJMP _0x20053
; 0001 0186 			}
; 0001 0187 			else
_0x20040:
; 0001 0188 			{/* Load an empty row of pixels in CGRAM. */
; 0001 0189 				lcd_putc(EMPTY_ROW);
	LDI  R26,LOW(0)
_0x20053:
	RCALL _lcd_putc
; 0001 018A 			}
; 0001 018B 		}
	SUBI R16,-1
	RJMP _0x2003E
_0x2003F:
; 0001 018C 	}
	SUBI R17,-1
	RJMP _0x2003B
_0x2003C:
; 0001 018D 
; 0001 018E 	/* Clear the entire bar and initialize all variables. */
; 0001 018F 	lcd_clrbar();
	RCALL _lcd_clrbar
; 0001 0190 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;/*!	\brief	Draw progress bar. */
;void lcd_drawbar(uint8_t next_bar_pixel)
; 0001 0194 {
; 0001 0195 	/* Go to the current cell position in the progress bar. */
; 0001 0196 	lcd_goto(PROGRESS_BAR_LINE, (current_bar_pixel / FONT_WIDTH));
;	next_bar_pixel -> Y+0
; 0001 0197 
; 0001 0198 	if (next_bar_pixel > current_bar_pixel)
; 0001 0199 	{
; 0001 019A 		/* Increment LCD cursor */
; 0001 019B 		lcd_setmode(ENTRY_MODE_INC_NO_SHIFT);
; 0001 019C 
; 0001 019D 		/* Prevent the progress bar overflow */
; 0001 019E 		if (next_bar_pixel > PROGRESS_BAR_MAX_LOAD)
; 0001 019F 		{
; 0001 01A0 			next_bar_pixel = PROGRESS_BAR_MAX_LOAD;
; 0001 01A1 		}
; 0001 01A2 
; 0001 01A3 		while (current_bar_pixel != next_bar_pixel)
; 0001 01A4 		{
; 0001 01A5 			/* Go to the next pixel. */
; 0001 01A6 			current_bar_pixel++;
; 0001 01A7 			current_cell_load++;
; 0001 01A8 			/* Display the load of the current cell. */
; 0001 01A9 			lcd_putc(current_cell_load);
; 0001 01AA 
; 0001 01AB 			if (current_cell_load < FULL_LOAD)
; 0001 01AC 			{/* Return the cursor to the current cell. */
; 0001 01AD 				cursor_shift(LEFT);
; 0001 01AE 			}
; 0001 01AF 			else
; 0001 01B0 			{/* Go to the next cell. */
; 0001 01B1 				current_cell_load = EMPTY_LOAD;
; 0001 01B2 			}
; 0001 01B3 		}
; 0001 01B4 	 }
; 0001 01B5 #if (USE_REGRESS_BAR)
; 0001 01B6 	 else if (next_bar_pixel < current_bar_pixel)
; 0001 01B7 	 {
; 0001 01B8 		 /* Decrement LCD cursor */
; 0001 01B9 		lcd_setmode(ENTRY_MODE_DEC_NO_SHIFT);
; 0001 01BA 
; 0001 01BB 		do
; 0001 01BC 		{
; 0001 01BD 			if (EMPTY_LOAD == current_cell_load)
; 0001 01BE 			{/* Go to the next cell. */
; 0001 01BF 				cursor_shift(LEFT);
; 0001 01C0 				current_cell_load = FULL_LOAD;
; 0001 01C1 			}
; 0001 01C2 			/* Go to the next pixel. */
; 0001 01C3 			current_bar_pixel--;
; 0001 01C4 			current_cell_load--;
; 0001 01C5 			/* Display the load of the current cell. */
; 0001 01C6 			lcd_putc(current_cell_load);
; 0001 01C7 			/* Return the cursor to the current cell. */
; 0001 01C8 			cursor_shift(RIGHT);
; 0001 01C9 		}
; 0001 01CA 		while (current_bar_pixel != next_bar_pixel);
; 0001 01CB 	 }
; 0001 01CC #endif /* USE_REGRESS_BAR */
; 0001 01CD 	 else
; 0001 01CE 	 {
; 0001 01CF 		 /* Nothing to do. */
; 0001 01D0 	 }
; 0001 01D1 
; 0001 01D2 	/* Restore the default entry mode. */
; 0001 01D3 	lcd_setmode(DEFAULT_ENTRY_MODE);
; 0001 01D4 	/* Return home. */
; 0001 01D5 	lcd_goto(LCD_1st_LINE, 0u);
; 0001 01D6 }
;
;/*!	\brief	Clear the entire progress bar. */
;void lcd_clrbar(void)
; 0001 01DA {
_lcd_clrbar:
; .FSTART _lcd_clrbar
; 0001 01DB 	uint8_t i;
; 0001 01DC 	/* Go to the last cell in the progress bar. */
; 0001 01DD 	lcd_goto(PROGRESS_BAR_LINE, (PROGRESS_BAR_WIDTH - 1u));
	ST   -Y,R17
;	i -> R17
	RCALL SUBOPT_0x0
	LDI  R26,LOW(9)
	RCALL _lcd_goto
; 0001 01DE 	/* Set the decrement mode. */
; 0001 01DF 	lcd_setmode(ENTRY_MODE_DEC_NO_SHIFT);
	LDI  R26,LOW(4)
	RCALL _lcd_setmode
; 0001 01E0 
; 0001 01E1 	for(i = 0u; i < PROGRESS_BAR_WIDTH; i++)
	LDI  R17,LOW(0)
_0x20051:
	MOV  R26,R17
	CLR  R27
	SBIW R26,10
	BRGE _0x20052
; 0001 01E2 	{/* Display the "empty cell" symbol (i.e. clear the LCD cell). */
; 0001 01E3 		lcd_putc(EMPTY_LOAD);
	LDI  R26,LOW(0)
	RCALL _lcd_putc
; 0001 01E4 	}
	SUBI R17,-1
	RJMP _0x20051
_0x20052:
; 0001 01E5 
; 0001 01E6 	/* Reset the progress bar variables. */
; 0001 01E7 	current_bar_pixel = 0u;
	LDI  R30,LOW(0)
	STS  _current_bar_pixel_G001,R30
; 0001 01E8 	current_cell_load = EMPTY_LOAD;
	STS  _current_cell_load_G001,R30
; 0001 01E9 
; 0001 01EA 	/* Restore the default entry mode. */
; 0001 01EB 	lcd_setmode(DEFAULT_ENTRY_MODE);
	LDI  R26,LOW(6)
	RCALL _lcd_setmode
; 0001 01EC 	/* Return home. */
; 0001 01ED 	lcd_goto(LCD_1st_LINE, 0u);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_goto
; 0001 01EE }
	LD   R17,Y+
	RET
; .FEND
;#endif
;
;/*!	\brief	Initialize the LCD.
; * 	\note	This library use the 4-bit interface. */
;void lcd_init(void)
; 0001 01F4 {
_lcd_init:
; .FSTART _lcd_init
; 0001 01F5 	/* LCD initialization. */
; 0001 01F6 	lcd_config(DEFAULT_DISPLAY_CONFIG);
	LDI  R26,LOW(40)
	RCALL _lcd_config_G001
; 0001 01F7 	lcd_setmode(DEFAULT_VIEW_MODE);
	LDI  R26,LOW(12)
	RCALL _lcd_setmode
; 0001 01F8 	lcd_setmode(DEFAULT_ENTRY_MODE);
	LDI  R26,LOW(6)
	RCALL _lcd_setmode
; 0001 01F9 	lcd_clrscr();
	RCALL _lcd_clrscr
; 0001 01FA 	lcd_return();
	RCALL _lcd_return
; 0001 01FB #if (USE_PROGRESS_BAR)
; 0001 01FC 	lcd_initbar();
	RCALL _lcd_initbar_G001
; 0001 01FD #endif
; 0001 01FE }
	RET
; .FEND
;
;//-------------------------------
;/* END OF FILE */
;//-------------------------------
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
_twi_master_init:
; .FSTART _twi_master_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SET
	BLD  R2,1
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDI  R30,LOW(0)
	STS  _twi_slave_rx_handler_G100,R30
	STS  _twi_slave_rx_handler_G100+1,R30
	STS  _twi_slave_tx_handler_G100,R30
	STS  _twi_slave_tx_handler_G100+1,R30
	SBI  0x15,4
	SBI  0x15,5
	OUT  0x36,R30
	IN   R30,0x1
	ANDI R30,LOW(0xFC)
	OUT  0x1,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(4000)
	LDI  R27,HIGH(4000)
	RCALL __DIVW21U
	MOV  R17,R30
	CPI  R17,8
	BRLO _0x2000004
	SUBI R17,LOW(8)
_0x2000004:
	OUT  0x0,R17
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	OUT  0x36,R30
	LDD  R17,Y+0
_0x2060003:
	ADIW R28,3
	RET
; .FEND
_twi_master_trans:
; .FSTART _twi_master_trans
	ST   -Y,R26
	SBIW R28,4
	SBRS R2,1
	RJMP _0x2000005
	LDD  R30,Y+10
	LSL  R30
	STS  _slave_address_G100,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STS  _twi_tx_buffer_G100,R30
	STS  _twi_tx_buffer_G100+1,R31
	LDI  R30,LOW(0)
	STS  _twi_tx_index,R30
	LDD  R30,Y+7
	STS  _bytes_to_tx_G100,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _twi_rx_buffer_G100,R30
	STS  _twi_rx_buffer_G100+1,R31
	LDI  R30,LOW(0)
	STS  _twi_rx_index,R30
	LDD  R30,Y+4
	STS  _bytes_to_rx_G100,R30
	LDI  R30,LOW(6)
	STS  _twi_result,R30
	sei
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2000006
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x2060002
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x2000009
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BREQ _0x200000A
_0x2000009:
	RJMP _0x2000008
_0x200000A:
	RJMP _0x2060002
_0x2000008:
	SET
	RJMP _0x2000065
_0x2000006:
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x200000C
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,0
	BREQ _0x2060002
	LDS  R30,_slave_address_G100
	ORI  R30,1
	STS  _slave_address_G100,R30
	CLT
_0x2000065:
	BLD  R2,0
	CLT
	BLD  R2,1
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	OUT  0x36,R30
	__GETD1N 0x7A120
	RCALL SUBOPT_0x2
_0x200000E:
	SBRC R2,1
	RJMP _0x2000010
	RCALL SUBOPT_0x3
	BRNE _0x2000011
	LDI  R30,LOW(5)
	STS  _twi_result,R30
	SET
	BLD  R2,1
	RJMP _0x2060002
_0x2000011:
	RJMP _0x200000E
_0x2000010:
_0x200000C:
	LDS  R26,_twi_result
	LDI  R30,LOW(0)
	RCALL __EQB12
	RJMP _0x2060001
_0x2000005:
_0x2060002:
	LDI  R30,LOW(0)
_0x2060001:
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
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
	RCALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G100
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G100
	LDS  R27,_twi_rx_buffer_G100+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2000017
	LDI  R18,LOW(0)
	RJMP _0x2000018
_0x2000017:
	CPI  R30,LOW(0x10)
	BRNE _0x2000019
_0x2000018:
	LDS  R30,_slave_address_G100
	RJMP _0x2000067
_0x2000019:
	CPI  R30,LOW(0x18)
	BREQ _0x200001D
	CPI  R30,LOW(0x28)
	BRNE _0x200001E
_0x200001D:
	CP   R16,R19
	BRSH _0x200001F
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2000067:
	OUT  0x3,R30
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2000020
_0x200001F:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x2000021
	LDS  R30,_slave_address_G100
	ORI  R30,1
	STS  _slave_address_G100,R30
	CLT
	BLD  R2,0
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	OUT  0x36,R30
	RJMP _0x2000016
_0x2000021:
	RJMP _0x2000022
_0x2000020:
	RJMP _0x2000016
_0x200001E:
	CPI  R30,LOW(0x50)
	BRNE _0x2000023
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000024
_0x2000023:
	CPI  R30,LOW(0x40)
	BRNE _0x2000025
_0x2000024:
	LDS  R30,_bytes_to_rx_G100
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2000026
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000068
_0x2000026:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2000068:
	OUT  0x36,R30
	RJMP _0x2000016
_0x2000025:
	CPI  R30,LOW(0x58)
	BRNE _0x2000028
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000029
_0x2000028:
	CPI  R30,LOW(0x20)
	BRNE _0x200002A
_0x2000029:
	RJMP _0x200002B
_0x200002A:
	CPI  R30,LOW(0x30)
	BRNE _0x200002C
_0x200002B:
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x48)
	BRNE _0x200002E
_0x200002D:
	CPI  R18,0
	BRNE _0x200002F
	SBRS R2,0
	RJMP _0x2000030
	CP   R16,R19
	BRLO _0x2000032
	RJMP _0x2000033
_0x2000030:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x2000034
_0x2000032:
	LDI  R18,LOW(4)
_0x2000034:
_0x2000033:
_0x200002F:
_0x2000022:
	RJMP _0x2000069
_0x200002E:
	CPI  R30,LOW(0x38)
	BRNE _0x2000037
	LDI  R18,LOW(2)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x200006A
_0x2000037:
	CPI  R30,LOW(0x68)
	BREQ _0x200003A
	CPI  R30,LOW(0x78)
	BRNE _0x200003B
_0x200003A:
	LDI  R18,LOW(2)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x60)
	BREQ _0x200003F
	CPI  R30,LOW(0x70)
	BRNE _0x2000040
_0x200003F:
	LDI  R18,LOW(0)
_0x200003C:
	LDI  R17,LOW(0)
	CLT
	BLD  R2,0
	LDS  R30,_twi_rx_buffer_size_G100
	CPI  R30,0
	BRNE _0x2000041
	LDI  R18,LOW(1)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x200006B
_0x2000041:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x200006B:
	OUT  0x36,R30
	RJMP _0x2000016
_0x2000040:
	CPI  R30,LOW(0x80)
	BREQ _0x2000044
	CPI  R30,LOW(0x90)
	BRNE _0x2000045
_0x2000044:
	SBRS R2,0
	RJMP _0x2000046
	LDI  R18,LOW(1)
	RJMP _0x2000047
_0x2000046:
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G100
	CP   R17,R30
	BRSH _0x2000048
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BRNE _0x2000049
	LDI  R18,LOW(6)
	RJMP _0x2000047
_0x2000049:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G100,0
	CPI  R30,0
	BREQ _0x200004A
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	RJMP _0x2000016
_0x200004A:
	RJMP _0x200004B
_0x2000048:
	SET
	BLD  R2,0
_0x200004B:
	RJMP _0x200004C
_0x2000045:
	CPI  R30,LOW(0x88)
	BRNE _0x200004D
_0x200004C:
	RJMP _0x200004E
_0x200004D:
	CPI  R30,LOW(0x98)
	BRNE _0x200004F
_0x200004E:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2000016
_0x200004F:
	CPI  R30,LOW(0xA0)
	BRNE _0x2000050
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	SET
	BLD  R2,1
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000051
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G100,0
	RJMP _0x2000052
_0x2000051:
	LDI  R18,LOW(6)
_0x2000052:
	RJMP _0x2000016
_0x2000050:
	CPI  R30,LOW(0xB0)
	BRNE _0x2000053
	LDI  R18,LOW(2)
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0xA8)
	BRNE _0x2000055
_0x2000054:
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000056
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G100,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000058
	LDI  R18,LOW(0)
	RJMP _0x2000059
_0x2000056:
_0x2000058:
	LDI  R18,LOW(6)
	RJMP _0x2000047
_0x2000059:
	LDI  R16,LOW(0)
	CLT
	BLD  R2,0
	RJMP _0x200005A
_0x2000055:
	CPI  R30,LOW(0xB8)
	BRNE _0x200005B
_0x200005A:
	SBRS R2,0
	RJMP _0x200005C
	LDI  R18,LOW(1)
	RJMP _0x2000047
_0x200005C:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x3,R30
	CP   R16,R19
	BRSH _0x200005D
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x200006C
_0x200005D:
	SET
	BLD  R2,0
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x200006C:
	OUT  0x36,R30
	RJMP _0x2000016
_0x200005B:
	CPI  R30,LOW(0xC0)
	BREQ _0x2000060
	CPI  R30,LOW(0xC8)
	BRNE _0x2000061
_0x2000060:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000062
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G100,0
_0x2000062:
	RJMP _0x2000035
_0x2000061:
	CPI  R30,0
	BRNE _0x2000016
	LDI  R18,LOW(3)
_0x2000047:
_0x2000069:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x200006A:
	OUT  0x36,R30
_0x2000035:
	SET
	BLD  R2,1
_0x2000016:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G100,R19
	RCALL __LOADLOCR6
	ADIW R28,6
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

	.CSEG

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_current_bar_pixel_G001:
	.BYTE 0x1
_current_cell_load_G001:
	.BYTE 0x1
_slave_address_G100:
	.BYTE 0x1
_twi_tx_buffer_G100:
	.BYTE 0x2
_bytes_to_tx_G100:
	.BYTE 0x1
_twi_rx_buffer_G100:
	.BYTE 0x2
_bytes_to_rx_G100:
	.BYTE 0x1
_twi_rx_buffer_size_G100:
	.BYTE 0x1
_twi_slave_rx_handler_G100:
	.BYTE 0x2
_twi_slave_tx_handler_G100:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x1
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	ORI  R30,4
	ST   Y,R30
	ANDI R30,0xFB
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(39)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _twi_master_trans
	__GETD2N 0x5
	RJMP _lcd_10us_delay_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(0)
	RJMP _lcd_write_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	RET


	.CSEG
__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
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

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
