
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
	.DEF _FontID=R5

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

_f6x8_table:
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x0,0x6,0x8,0x48,0x48
	.DB  0x48,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x50,0x50,0xF8,0x50,0xF8,0x50,0x50,0x0
	.DB  0x6,0x8,0x20,0x78,0xA0,0x70,0x28,0xF0
	.DB  0x20,0x0,0x6,0x8,0xC0,0xC8,0x10,0x20
	.DB  0x40,0x98,0x18,0x0,0x6,0x8,0x60,0x90
	.DB  0xA0,0x40,0xA8,0x90,0x68,0x0,0x6,0x8
	.DB  0x60,0x20,0x40,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x10,0x20,0x40,0x40,0x40,0x20
	.DB  0x10,0x0,0x6,0x8,0x40,0x20,0x10,0x10
	.DB  0x10,0x20,0x40,0x0,0x6,0x8,0x0,0x50
	.DB  0x20,0xF8,0x20,0x50,0x0,0x0,0x6,0x8
	.DB  0x0,0x20,0x20,0xF8,0x20,0x20,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x60
	.DB  0x20,0x40,0x6,0x8,0x0,0x0,0x0,0xF8
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x60,0x60,0x0,0x6,0x8
	.DB  0x0,0x8,0x10,0x20,0x40,0x80,0x0,0x0
	.DB  0x6,0x8,0x70,0x88,0x98,0xA8,0xC8,0x88
	.DB  0x70,0x0,0x6,0x8,0x20,0x60,0x20,0x20
	.DB  0x20,0x20,0x70,0x0,0x6,0x8,0x70,0x88
	.DB  0x8,0x30,0x40,0x80,0xF8,0x0,0x6,0x8
	.DB  0x70,0x88,0x8,0x30,0x8,0x88,0x70,0x0
	.DB  0x6,0x8,0x10,0x30,0x50,0x90,0xF8,0x10
	.DB  0x10,0x0,0x6,0x8,0xF8,0x80,0xF0,0x8
	.DB  0x8,0x88,0x70,0x0,0x6,0x8,0x30,0x40
	.DB  0x80,0xF0,0x88,0x88,0x70,0x0,0x6,0x8
	.DB  0xF8,0x8,0x10,0x20,0x40,0x40,0x40,0x0
	.DB  0x6,0x8,0x70,0x88,0x88,0x70,0x88,0x88
	.DB  0x70,0x0,0x6,0x8,0x70,0x88,0x88,0x78
	.DB  0x8,0x10,0x60,0x0,0x6,0x8,0x0,0x60
	.DB  0x60,0x0,0x60,0x60,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x60,0x60,0x0,0x60,0x20,0x40
	.DB  0x6,0x8,0x10,0x20,0x40,0x80,0x40,0x20
	.DB  0x10,0x0,0x6,0x8,0x0,0x0,0xF8,0x0
	.DB  0xF8,0x0,0x0,0x0,0x6,0x8,0x80,0x40
	.DB  0x20,0x10,0x20,0x40,0x80,0x0,0x6,0x8
	.DB  0x70,0x88,0x8,0x10,0x20,0x0,0x20,0x0
	.DB  0x6,0x8,0x70,0x88,0x8,0x68,0xA8,0xA8
	.DB  0x70,0x0,0x6,0x8,0x70,0x88,0x88,0xF8
	.DB  0x88,0x88,0x88,0x0,0x6,0x8,0xF0,0x88
	.DB  0x88,0xF0,0x88,0x88,0xF0,0x0,0x6,0x8
	.DB  0x70,0x88,0x80,0x80,0x80,0x88,0x70,0x0
	.DB  0x6,0x8,0xE0,0x90,0x88,0x88,0x88,0x90
	.DB  0xE0,0x0,0x6,0x8,0xF8,0x80,0x80,0xF0
	.DB  0x80,0x80,0xF8,0x0,0x6,0x8,0xF8,0x80
	.DB  0x80,0xF0,0x80,0x80,0x80,0x0,0x6,0x8
	.DB  0x70,0x88,0x80,0x80,0x98,0x88,0x78,0x0
	.DB  0x6,0x8,0x88,0x88,0x88,0xF8,0x88,0x88
	.DB  0x88,0x0,0x6,0x8,0x70,0x20,0x20,0x20
	.DB  0x20,0x20,0x70,0x0,0x6,0x8,0x38,0x10
	.DB  0x10,0x10,0x10,0x90,0x60,0x0,0x6,0x8
	.DB  0x88,0x90,0xA0,0xC0,0xA0,0x90,0x88,0x0
	.DB  0x6,0x8,0x80,0x80,0x80,0x80,0x80,0x80
	.DB  0xF8,0x0,0x6,0x8,0x88,0xD8,0xA8,0xA8
	.DB  0x88,0x88,0x88,0x0,0x6,0x8,0x88,0x88
	.DB  0xC8,0xA8,0x98,0x88,0x88,0x0,0x6,0x8
	.DB  0x70,0x88,0x88,0x88,0x88,0x88,0x70,0x0
	.DB  0x6,0x8,0xF0,0x88,0x88,0xF0,0x80,0x80
	.DB  0x80,0x0,0x6,0x8,0x70,0x88,0x88,0x88
	.DB  0xA8,0x90,0x68,0x0,0x6,0x8,0xF0,0x88
	.DB  0x88,0xF0,0xA0,0x90,0x88,0x0,0x6,0x8
	.DB  0x70,0x88,0x80,0x70,0x8,0x88,0x70,0x0
	.DB  0x6,0x8,0xF8,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x6,0x8,0x88,0x88,0x88,0x88
	.DB  0x88,0x88,0x70,0x0,0x6,0x8,0x88,0x88
	.DB  0x88,0x88,0x88,0x50,0x20,0x0,0x6,0x8
	.DB  0x88,0x88,0x88,0xA8,0xA8,0xA8,0x50,0x0
	.DB  0x6,0x8,0x88,0x88,0x50,0x20,0x50,0x88
	.DB  0x88,0x0,0x6,0x8,0x88,0x88,0x88,0x50
	.DB  0x20,0x20,0x20,0x0,0x6,0x8,0xF8,0x8
	.DB  0x10,0x20,0x40,0x80,0xF8,0x0,0x6,0x8
	.DB  0x70,0x40,0x40,0x40,0x40,0x40,0x70,0x0
	.DB  0x6,0x8,0x0,0x80,0x40,0x20,0x10,0x8
	.DB  0x0,0x0,0x6,0x8,0x70,0x10,0x10,0x10
	.DB  0x10,0x10,0x70,0x0,0x6,0x8,0x20,0x50
	.DB  0x88,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0xF8
	.DB  0x6,0x8,0x40,0x20,0x10,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x70,0x8
	.DB  0x78,0x88,0x78,0x0,0x6,0x8,0x80,0x80
	.DB  0xB0,0xC8,0x88,0x88,0xF0,0x0,0x6,0x8
	.DB  0x0,0x0,0x70,0x80,0x80,0x88,0x70,0x0
	.DB  0x6,0x8,0x8,0x8,0x68,0x98,0x88,0x88
	.DB  0x78,0x0,0x6,0x8,0x0,0x0,0x70,0x88
	.DB  0xF8,0x80,0x70,0x0,0x6,0x8,0x30,0x48
	.DB  0x40,0xE0,0x40,0x40,0x40,0x0,0x6,0x8
	.DB  0x0,0x0,0x78,0x88,0x88,0x78,0x8,0x70
	.DB  0x6,0x8,0x80,0x80,0xB0,0xC8,0x88,0x88
	.DB  0x88,0x0,0x6,0x8,0x20,0x0,0x60,0x20
	.DB  0x20,0x20,0x70,0x0,0x6,0x8,0x10,0x0
	.DB  0x30,0x10,0x10,0x10,0x90,0x60,0x6,0x8
	.DB  0x80,0x80,0x90,0xA0,0xC0,0xA0,0x90,0x0
	.DB  0x6,0x8,0x60,0x20,0x20,0x20,0x20,0x20
	.DB  0x70,0x0,0x6,0x8,0x0,0x0,0xD0,0xA8
	.DB  0x88,0x88,0x88,0x0,0x6,0x8,0x0,0x0
	.DB  0xB0,0xC8,0x88,0x88,0x88,0x0,0x6,0x8
	.DB  0x0,0x0,0x70,0x88,0x88,0x88,0x70,0x0
	.DB  0x6,0x8,0x0,0x0,0xF0,0x88,0x88,0xF0
	.DB  0x80,0x80,0x6,0x8,0x0,0x0,0x78,0x88
	.DB  0x88,0x78,0x8,0x8,0x6,0x8,0x0,0x0
	.DB  0xB0,0xC8,0x80,0x80,0x80,0x0,0x6,0x8
	.DB  0x0,0x0,0x78,0x80,0x70,0x8,0xF0,0x0
	.DB  0x6,0x8,0x40,0x40,0xE0,0x40,0x40,0x48
	.DB  0x30,0x0,0x6,0x8,0x0,0x0,0x88,0x88
	.DB  0x88,0x98,0x68,0x0,0x6,0x8,0x0,0x0
	.DB  0x88,0x88,0x88,0x50,0x20,0x0,0x6,0x8
	.DB  0x0,0x0,0x88,0x88,0xA8,0xA8,0x50,0x0
	.DB  0x6,0x8,0x0,0x0,0x88,0x50,0x20,0x50
	.DB  0x88,0x0,0x6,0x8,0x0,0x0,0x88,0x88
	.DB  0x88,0x78,0x8,0x70,0x6,0x8,0x0,0x0
	.DB  0xF8,0x10,0x20,0x40,0xF8,0x0,0x6,0x8
	.DB  0x10,0x20,0x20,0x40,0x20,0x20,0x10,0x0
	.DB  0x6,0x8,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x6,0x8,0x40,0x20,0x20,0x10
	.DB  0x20,0x20,0x40,0x0,0x6,0x8,0x68,0x90
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x50,0x0,0xF8,0x80,0xF0,0x80
	.DB  0xF8,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x50,0x0,0x70,0x88,0xF8,0x80
	.DB  0x70,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x6,0x8
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x6,0x8,0x70,0x88,0x88,0xF8,0x88,0x88
	.DB  0x88,0x0,0x6,0x8,0xF8,0x80,0x80,0xF0
	.DB  0x88,0x88,0xF0,0x0,0x6,0x8,0xF0,0x88
	.DB  0x88,0xF0,0x88,0x88,0xF0,0x0,0x6,0x8
	.DB  0xF8,0x80,0x80,0x80,0x80,0x80,0x80,0x0
	.DB  0x6,0x8,0x30,0x50,0x50,0x50,0x50,0xF8
	.DB  0x88,0x0,0x6,0x8,0xF8,0x80,0x80,0xF0
	.DB  0x80,0x80,0xF8,0x0,0x6,0x8,0xA8,0xA8
	.DB  0xA8,0x70,0xA8,0xA8,0xA8,0x0,0x6,0x8
	.DB  0x70,0x88,0x8,0x10,0x8,0x88,0x70,0x0
	.DB  0x6,0x8,0x88,0x88,0x98,0xA8,0xC8,0x88
	.DB  0x88,0x0,0x6,0x8,0xA8,0x88,0x98,0xA8
	.DB  0xC8,0x88,0x88,0x0,0x6,0x8,0x88,0x88
	.DB  0x90,0xE0,0x90,0x88,0x88,0x0,0x6,0x8
	.DB  0x38,0x48,0x88,0x88,0x88,0x88,0x88,0x0
	.DB  0x6,0x8,0x88,0xD8,0xD8,0xA8,0xA8,0x88
	.DB  0x88,0x0,0x6,0x8,0x88,0x88,0x88,0xF8
	.DB  0x88,0x88,0x88,0x0,0x6,0x8,0x70,0x88
	.DB  0x88,0x88,0x88,0x88,0x70,0x0,0x6,0x8
	.DB  0xF8,0x88,0x88,0x88,0x88,0x88,0x88,0x0
	.DB  0x6,0x8,0xF0,0x88,0x88,0x88,0xF0,0x80
	.DB  0x80,0x0,0x6,0x8,0x70,0x88,0x80,0x80
	.DB  0x80,0x88,0x70,0x0,0x6,0x8,0xF8,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x6,0x8
	.DB  0x88,0x88,0x88,0x88,0x78,0x8,0xF0,0x0
	.DB  0x6,0x8,0x70,0xA8,0xA8,0xA8,0xA8,0x70
	.DB  0x20,0x0,0x6,0x8,0x88,0x88,0x50,0x20
	.DB  0x50,0x88,0x88,0x0,0x6,0x8,0x88,0x88
	.DB  0x88,0x88,0x88,0x88,0xF8,0x8,0x6,0x8
	.DB  0x88,0x88,0x88,0x88,0xF8,0x8,0x8,0x0
	.DB  0x6,0x8,0xA8,0xA8,0xA8,0xA8,0xA8,0xA8
	.DB  0xF8,0x0,0x6,0x8,0xA8,0xA8,0xA8,0xA8
	.DB  0xA8,0xA8,0xF8,0x8,0x6,0x8,0xC0,0x40
	.DB  0x40,0x70,0x48,0x48,0x70,0x0,0x6,0x8
	.DB  0x88,0x88,0x88,0xC8,0xA8,0xA8,0xC8,0x0
	.DB  0x6,0x8,0x40,0x40,0x40,0x70,0x48,0x48
	.DB  0x70,0x0,0x6,0x8,0x70,0x88,0x8,0x38
	.DB  0x8,0x88,0x70,0x0,0x6,0x8,0x90,0xA8
	.DB  0xA8,0xE8,0xA8,0xA8,0x90,0x0,0x6,0x8
	.DB  0x78,0x88,0x88,0x88,0x78,0x48,0x88,0x0
	.DB  0x6,0x8,0x0,0x0,0x70,0x8,0x78,0x88
	.DB  0x78,0x0,0x6,0x8,0x18,0x60,0x80,0xF0
	.DB  0x88,0x88,0x70,0x0,0x6,0x8,0x0,0x0
	.DB  0xF0,0x88,0xF0,0x88,0xF0,0x0,0x6,0x8
	.DB  0x0,0x0,0xF8,0x80,0x80,0x80,0x80,0x0
	.DB  0x6,0x8,0x0,0x0,0x30,0x50,0x50,0xF8
	.DB  0x88,0x0,0x6,0x8,0x0,0x0,0x70,0x88
	.DB  0xF8,0x80,0x70,0x0,0x6,0x8,0x0,0x0
	.DB  0xA8,0xA8,0x70,0xA8,0xA8,0x0,0x6,0x8
	.DB  0x0,0x0,0x70,0x88,0x10,0x88,0x70,0x0
	.DB  0x6,0x8,0x0,0x0,0x88,0x98,0xA8,0xC8
	.DB  0x88,0x0,0x6,0x8,0x70,0x0,0x88,0x98
	.DB  0xA8,0xC8,0x88,0x0,0x6,0x8,0x0,0x0
	.DB  0x88,0x90,0xE0,0x90,0x88,0x0,0x6,0x8
	.DB  0x0,0x0,0x38,0x48,0x88,0x88,0x88,0x0
	.DB  0x6,0x8,0x0,0x0,0x88,0xD8,0xA8,0x88
	.DB  0x88,0x0,0x6,0x8,0x0,0x0,0x88,0x88
	.DB  0xF8,0x88,0x88,0x0,0x6,0x8,0x0,0x0
	.DB  0x70,0x88,0x88,0x88,0x70,0x0,0x6,0x8
	.DB  0x0,0x0,0xF8,0x88,0x88,0x88,0x88,0x0
	.DB  0x6,0x8,0x0,0x0,0xF0,0x88,0xF0,0x80
	.DB  0x80,0x0,0x6,0x8,0x0,0x0,0x70,0x88
	.DB  0x80,0x88,0x70,0x0,0x6,0x8,0x0,0x0
	.DB  0xF8,0x20,0x20,0x20,0x20,0x0,0x6,0x8
	.DB  0x0,0x0,0x88,0x88,0x78,0x8,0xF0,0x0
	.DB  0x6,0x8,0x0,0x0,0x70,0xA8,0xA8,0x70
	.DB  0x20,0x0,0x6,0x8,0x0,0x0,0x88,0x50
	.DB  0x20,0x50,0x88,0x0,0x6,0x8,0x0,0x0
	.DB  0x88,0x88,0x88,0x88,0xF8,0x8,0x6,0x8
	.DB  0x0,0x0,0x88,0x88,0xF8,0x8,0x8,0x0
	.DB  0x6,0x8,0x0,0x0,0xA8,0xA8,0xA8,0xA8
	.DB  0xF8,0x0,0x6,0x8,0x0,0x0,0xA8,0xA8
	.DB  0xA8,0xA8,0xF8,0x8,0x6,0x8,0x0,0x0
	.DB  0xC0,0x40,0x70,0x48,0x70,0x0,0x6,0x8
	.DB  0x0,0x0,0x88,0x88,0xC8,0xA8,0xC8,0x0
	.DB  0x6,0x8,0x0,0x0,0x40,0x40,0x70,0x48
	.DB  0x70,0x0,0x6,0x8,0x0,0x0,0x70,0x88
	.DB  0x38,0x88,0x70,0x0,0x6,0x8,0x0,0x0
	.DB  0x90,0xA8,0xE8,0xA8,0x90,0x0,0x6,0x8
	.DB  0x0,0x0,0x78,0x88,0x78,0x48,0x88,0x0
_font_table_funcs:
	.DB  LOW(_f6x8_GetCharTable),HIGH(_f6x8_GetCharTable)
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0xCB,0xE0,0xE4,0xE8,0xEA,0x20,0xFF,0x20
	.DB  0xF2,0xE5,0xE1,0xFF,0x20,0xEB,0xFE,0xE1
	.DB  0xEB,0xFE,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x13
	.DW  _0x6
	.DW  _0x0*2

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
;Date    : 21.02.2018
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
;#include "scroll_demo.h"
;#include "max7219\ledmatrix.h"
;#include "max7219\fonts\font.h"
;
;// Declare your global variables here
;
;// Ѕуфер дл¤ скролла по индикатору
;uint8_t ScrollBuff[140];
;
;void main(void)
; 0000 0024 {

	.CSEG
_main:
; .FSTART _main
; 0000 0025 // Declare your local variables here
; 0000 0026 
; 0000 0027 // Input/Output Ports initialization
; 0000 0028 // Port B initialization
; 0000 0029 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 002A DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 002B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 002D 
; 0000 002E // Port C initialization
; 0000 002F // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0030 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0031 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0032 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0033 
; 0000 0034 // Port D initialization
; 0000 0035 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0036 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0037 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0038 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0039 
; 0000 003A // Timer/Counter 0 initialization
; 0000 003B // Clock source: System Clock
; 0000 003C // Clock value: Timer 0 Stopped
; 0000 003D TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 003E TCNT0=0x00;
	OUT  0x32,R30
; 0000 003F 
; 0000 0040 // Timer/Counter 1 initialization
; 0000 0041 // Clock source: System Clock
; 0000 0042 // Clock value: Timer1 Stopped
; 0000 0043 // Mode: Normal top=0xFFFF
; 0000 0044 // OC1A output: Disconnected
; 0000 0045 // OC1B output: Disconnected
; 0000 0046 // Noise Canceler: Off
; 0000 0047 // Input Capture on Falling Edge
; 0000 0048 // Timer1 Overflow Interrupt: Off
; 0000 0049 // Input Capture Interrupt: Off
; 0000 004A // Compare A Match Interrupt: Off
; 0000 004B // Compare B Match Interrupt: Off
; 0000 004C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 004D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 004E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 004F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0050 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0051 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0052 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0053 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0054 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0055 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0056 
; 0000 0057 // Timer/Counter 2 initialization
; 0000 0058 // Clock source: System Clock
; 0000 0059 // Clock value: Timer2 Stopped
; 0000 005A // Mode: Normal top=0xFF
; 0000 005B // OC2 output: Disconnected
; 0000 005C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 005D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 005E TCNT2=0x00;
	OUT  0x24,R30
; 0000 005F OCR2=0x00;
	OUT  0x23,R30
; 0000 0060 
; 0000 0061 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0062 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0063 
; 0000 0064 // External Interrupt(s) initialization
; 0000 0065 // INT0: Off
; 0000 0066 // INT1: Off
; 0000 0067 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0068 
; 0000 0069 // USART initialization
; 0000 006A // USART disabled
; 0000 006B UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 006C 
; 0000 006D // Analog Comparator initialization
; 0000 006E // Analog Comparator: Off
; 0000 006F // The Analog Comparator's positive input is
; 0000 0070 // connected to the AIN0 pin
; 0000 0071 // The Analog Comparator's negative input is
; 0000 0072 // connected to the AIN1 pin
; 0000 0073 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0074 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0075 
; 0000 0076 // ADC initialization
; 0000 0077 // ADC disabled
; 0000 0078 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0079 
; 0000 007A // SPI initialization
; 0000 007B // SPI disabled
; 0000 007C SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 007D 
; 0000 007E // TWI initialization
; 0000 007F // TWI disabled
; 0000 0080 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0081 
; 0000 0082 // »нициализируем светодиодную матрицу
; 0000 0083   ledmatrix_init();
	RCALL _ledmatrix_init
; 0000 0084 
; 0000 0085   // ћигнЄм всеми матрицами (типа тест индикаторов)
; 0000 0086   ledmatrix_testmatrix(1);
	LDI  R26,LOW(1)
	RCALL _ledmatrix_testmatrix
; 0000 0087   delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0088   ledmatrix_testmatrix(0);
	LDI  R26,LOW(0)
	RCALL _ledmatrix_testmatrix
; 0000 0089 
; 0000 008A while (1)
_0x3:
; 0000 008B       {
; 0000 008C       // Place your code here
; 0000 008D       // ‘ормируем буфер дл¤ скролла на матрице с желаемым текстом
; 0000 008E         // ?л¤ форматированного вывода можно также использовать функцию font_printf
; 0000 008F         uint16_t ScrollLines = font_DrawString("Ладик я тебя люблю", ScrollBuff, 140);
; 0000 0090         // —кроллим текст по матрице справа налево
; 0000 0091         demo_ScrollBuff(ScrollBuff, ScrollLines, 1);
	SBIW R28,2
;	ScrollLines -> Y+0
	__POINTW1MN _0x6,0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	LDI  R26,LOW(140)
	LDI  R27,0
	RCALL _font_DrawString
	ST   Y,R30
	STD  Y+1,R31
	RCALL SUBOPT_0x1
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x0
	LDI  R26,LOW(1)
	RCALL _demo_ScrollBuff
; 0000 0092         // —кроллим текст по матрице слева направо
; 0000 0093         demo_ScrollBuff(ScrollBuff, ScrollLines, 0);
	RCALL SUBOPT_0x1
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	RCALL _demo_ScrollBuff
; 0000 0094 
; 0000 0095       }
	ADIW R28,2
	RJMP _0x3
; 0000 0096 }
_0x7:
	RJMP _0x7
; .FEND

	.DSEG
_0x6:
	.BYTE 0x13
;//------------------------------------------------------------------------------
;// This is Open source software. You can place this code on your site, but don't
;// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Это программное обеспечение распространяется свободно. Вы можете размещать
;// его на вашем сайте, но не забудьте указать ссылку на мой YouTube-канал
;// "Электроника в объектике" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Автор: Надыршин Руслан / Nadyrshin Ruslan
;//------------------------------------------------------------------------------
;#include "scroll_demo.h"
;#include <delay.h>
;#include "max7219\max7219.h"
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
;#include "max7219\ledmatrix.h"
;
;
;//==============================================================================
;// Процедура прокручивает на матрице буфер pBuff (ВЛЕВО/ВПРАВО)
;//==============================================================================
;void demo_ScrollBuff(uint8_t *pBuff, uint16_t ScrollLines, uint8_t RightToLeft)
; 0001 0013 {

	.CSEG
_demo_ScrollBuff:
; .FSTART _demo_ScrollBuff
; 0001 0014   uint16_t i;
; 0001 0015   uint16_t ScrollIdx = (RightToLeft) ? 0 : ScrollLines - 1;
; 0001 0016 
; 0001 0017   ledmatrix_fill_screenbuff(0x00);  // Очистка буфера кадра
	ST   -Y,R26
	RCALL __SAVELOCR4
;	*pBuff -> Y+7
;	ScrollLines -> Y+5
;	RightToLeft -> Y+4
;	i -> R16,R17
;	ScrollIdx -> R18,R19
	LDD  R30,Y+4
	LDI  R31,0
	SBIW R30,0
	BREQ _0x20003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20004
_0x20003:
	RCALL SUBOPT_0x2
	SBIW R30,1
_0x20004:
	MOVW R18,R30
	LDI  R26,LOW(0)
	RCALL _ledmatrix_fill_screenbuff
; 0001 0018 
; 0001 0019   for (i = 0; i < ScrollLines + (MAX7219_NUM * 8); i++)
	RCALL SUBOPT_0x3
_0x20007:
	RCALL SUBOPT_0x2
	ADIW R30,32
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x20008
; 0001 001A   {
; 0001 001B     if (RightToLeft)    // Прокрутка справа налево
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x20009
; 0001 001C     {
; 0001 001D       ledmatrix_ScrollLeft();
	RCALL _ledmatrix_ScrollLeft
; 0001 001E 
; 0001 001F       if (i < ScrollLines)
	RCALL SUBOPT_0x2
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2000A
; 0001 0020         ledmatrix_screenbuff[(MAX7219_NUM * 8) - 1] = pBuff[ScrollIdx++];
	MOVW R30,R18
	__ADDWRN 18,19,1
	RCALL SUBOPT_0x4
	RJMP _0x2000F
; 0001 0021       else
_0x2000A:
; 0001 0022         ledmatrix_screenbuff[(MAX7219_NUM * 8) - 1] = 0;
	LDI  R30,LOW(0)
_0x2000F:
	__PUTB1MN _ledmatrix_screenbuff,31
; 0001 0023     }
; 0001 0024     else                // Прокрутка слева направо
	RJMP _0x2000C
_0x20009:
; 0001 0025     {
; 0001 0026       ledmatrix_ScrollRight();
	RCALL _ledmatrix_ScrollRight
; 0001 0027 
; 0001 0028       if (i < ScrollLines)
	RCALL SUBOPT_0x2
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2000D
; 0001 0029         ledmatrix_screenbuff[0] = pBuff[ScrollIdx--];
	MOVW R30,R18
	__SUBWRN 18,19,1
	RCALL SUBOPT_0x4
	RJMP _0x20010
; 0001 002A       else
_0x2000D:
; 0001 002B         ledmatrix_screenbuff[0] = 0;
	LDI  R30,LOW(0)
_0x20010:
	STS  _ledmatrix_screenbuff,R30
; 0001 002C     }
_0x2000C:
; 0001 002D 
; 0001 002E     ledmatrix_update_from_buff();
	RCALL _ledmatrix_update_from_buff
; 0001 002F 
; 0001 0030     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0001 0031   }
	RCALL SUBOPT_0x5
	RJMP _0x20007
_0x20008:
; 0001 0032 }
	RCALL __LOADLOCR4
	ADIW R28,9
	RET
; .FEND
;//==============================================================================
;//------------------------------------------------------------------------------
;// This is Open source software. You can place this code on your site, but don't
;// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Это программное обеспечение распространяется свободно. Вы можете размещать
;// его на вашем сайте, но не забудьте указать ссылку на мой YouTube-канал
;// "Электроника в объектике" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Автор: Надыршин Руслан / Nadyrshin Ruslan
;//------------------------------------------------------------------------------
;
;#include <delay.h>
;#include "ledmatrix.h"
;#include "max7219.h"
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
;uint8_t ledmatrix_screenbuff[MAX7219_NUM * 8];
;
;
;//==============================================================================
;// Процедура инициализирует матрицу
;//==============================================================================
;void ledmatrix_init(void)
; 0002 0016 {

	.CSEG
_ledmatrix_init:
; .FSTART _ledmatrix_init
; 0002 0017   max7219_init();
	RCALL _max7219_init
; 0002 0018 
; 0002 0019   // Выводим все max7219 из спящего режима
; 0002 001A   max7219_set_run_onoff(MAX7219_ALL_IDX, 1);
	RCALL SUBOPT_0x6
	LDI  R26,LOW(1)
	RCALL _max7219_set_run_onoff
; 0002 001B   // Устанавливаем кол-во символов (или строк), подключенных к max7219
; 0002 001C   max7219_set_scan_limit(MAX7219_ALL_IDX, 0x07);
	RCALL SUBOPT_0x6
	LDI  R26,LOW(7)
	RCALL _max7219_set_scan_limit
; 0002 001D   // Устанавливаем режим перекодирования кодов цифр перед выводом на индикатор (для матриц =0)
; 0002 001E   max7219_set_decodemode(MAX7219_ALL_IDX, MAX7219_NO_DECODE);
	RCALL SUBOPT_0x6
	LDI  R26,LOW(0)
	RCALL _max7219_set_decodemode
; 0002 001F   // Устанавливаем яркость индикаторов (от 0 до 15)
; 0002 0020   max7219_set_intensity(MAX7219_ALL_IDX, 0xF);
	RCALL SUBOPT_0x6
	LDI  R26,LOW(15)
	RCALL _max7219_set_intensity
; 0002 0021 
; 0002 0022   // Очищаем ОЗУ микросхем max7219, потому что сейчас в них может быть мусор
; 0002 0023   ledmatrix_fill_screenbuff(0);
	LDI  R26,LOW(0)
	RCALL _ledmatrix_fill_screenbuff
; 0002 0024   ledmatrix_update_from_buff();
	RCALL _ledmatrix_update_from_buff
; 0002 0025 }
	RET
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура управляет режимом Test матрицы
;//==============================================================================
;void ledmatrix_testmatrix(uint8_t TestOn)
; 0002 002D {
_ledmatrix_testmatrix:
; .FSTART _ledmatrix_testmatrix
; 0002 002E   max7219_set_testmode_onoff(MAX7219_ALL_IDX, TestOn);
	ST   -Y,R26
;	TestOn -> Y+0
	RCALL SUBOPT_0x6
	LDD  R26,Y+1
	RCALL _max7219_set_testmode_onoff
; 0002 002F }
	ADIW R28,1
	RET
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура устанавливает яркость матрицы. Диапазон 0-15
;//==============================================================================
;void ledmatrix_set_brightness(uint8_t Value)
; 0002 0037 {
; 0002 0038   max7219_set_intensity(MAX7219_ALL_IDX, Value);
;	Value -> Y+0
; 0002 0039 }
;//==============================================================================
;
;
;//==============================================================================
;// Процедура заполняет буфер кадра значением FillValue
;//==============================================================================
;void ledmatrix_fill_screenbuff(uint8_t FillValue)
; 0002 0041 {
_ledmatrix_fill_screenbuff:
; .FSTART _ledmatrix_fill_screenbuff
; 0002 0042     uint16_t i;
; 0002 0043     for (i = 0; i < (8 * MAX7219_NUM); i++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	FillValue -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x3
_0x40004:
	__CPWRN 16,17,32
	BRSH _0x40005
; 0002 0044         ledmatrix_screenbuff[i] = FillValue;
	MOVW R30,R16
	RCALL SUBOPT_0x7
	LDD  R26,Y+2
	STD  Z+0,R26
	RCALL SUBOPT_0x5
	RJMP _0x40004
_0x40005:
; 0002 0045 }
	RJMP _0x20A0004
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура сдвигает содержимое буфера кадра ВЛЕВО
;// Самый правый столбец сохраняет при этом своё старое значение
;//==============================================================================
;void ledmatrix_ScrollLeft(void)
; 0002 004E {
_ledmatrix_ScrollLeft:
; .FSTART _ledmatrix_ScrollLeft
; 0002 004F     uint16_t col;
; 0002 0050     for (col = 1; col < (MAX7219_NUM * 8); col++)
	RCALL __SAVELOCR2
;	col -> R16,R17
	__GETWRN 16,17,1
_0x40007:
	__CPWRN 16,17,32
	BRSH _0x40008
; 0002 0051      ledmatrix_screenbuff[col - 1] = ledmatrix_screenbuff[col];
	MOVW R30,R16
	SBIW R30,1
	RCALL SUBOPT_0x7
	MOVW R0,R30
	LDI  R26,LOW(_ledmatrix_screenbuff)
	LDI  R27,HIGH(_ledmatrix_screenbuff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RCALL SUBOPT_0x5
	RJMP _0x40007
_0x40008:
; 0002 0052 }
	RJMP _0x20A0006
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура сдвигает содержимое буфера кадра ВПРАВО
;// Самый левый столбец сохраняет при этом своё старое значение
;//==============================================================================
;void ledmatrix_ScrollRight(void)
; 0002 005B {
_ledmatrix_ScrollRight:
; .FSTART _ledmatrix_ScrollRight
; 0002 005C     uint16_t col;
; 0002 005D     for (col = (MAX7219_NUM * 8) - 1; col; col--)
	RCALL __SAVELOCR2
;	col -> R16,R17
	__GETWRN 16,17,31
_0x4000A:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x4000B
; 0002 005E         ledmatrix_screenbuff[col] = ledmatrix_screenbuff[col - 1];
	MOVW R26,R16
	SUBI R26,LOW(-_ledmatrix_screenbuff)
	SBCI R27,HIGH(-_ledmatrix_screenbuff)
	MOVW R30,R16
	SBIW R30,1
	RCALL SUBOPT_0x7
	LD   R30,Z
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0x4000A
_0x4000B:
; 0002 005F }
_0x20A0006:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура обновляет состояние индикаторов в соответствии с буфером кадра ledmatrix_screenbuff
;//==============================================================================
;void ledmatrix_update_from_buff(void)
; 0002 0067 {
_ledmatrix_update_from_buff:
; .FSTART _ledmatrix_update_from_buff
; 0002 0068   uint16_t max7219_SpiBuff[MAX7219_NUM];
; 0002 0069   uint8_t Digit;
; 0002 006A   uint8_t i;
; 0002 006B   uint8_t Col;
; 0002 006C   uint8_t bite;
; 0002 006D   for (Digit = 0; Digit < 8; Digit++)
	SBIW R28,8
	RCALL __SAVELOCR4
;	max7219_SpiBuff -> Y+4
;	Digit -> R17
;	i -> R16
;	Col -> R19
;	bite -> R18
	LDI  R17,LOW(0)
_0x4000D:
	CPI  R17,8
	BRSH _0x4000E
; 0002 006E   {
; 0002 006F     for (i = 0; i < MAX7219_NUM; i++)
	LDI  R16,LOW(0)
_0x40010:
	CPI  R16,4
	BRSH _0x40011
; 0002 0070     {
; 0002 0071       // Формирование слова для записи в max7219[i] в строку Digit
; 0002 0072       uint8_t Data = 0;
; 0002 0073       for (Col = 0; Col < 8; Col++)
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	max7219_SpiBuff -> Y+5
;	Data -> Y+0
	LDI  R19,LOW(0)
_0x40013:
	CPI  R19,8
	BRSH _0x40014
; 0002 0074       {
; 0002 0075         bite = (ledmatrix_screenbuff[(i << 3) + Col] & (1 << Digit)) ? 1 : 0;
	MOV  R30,R16
	LDI  R31,0
	RCALL __LSLW3
	MOVW R26,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x7
	LD   R1,Z
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	MOV  R26,R1
	RCALL SUBOPT_0xA
	BREQ _0x40015
	LDI  R30,LOW(1)
	RJMP _0x40016
_0x40015:
	LDI  R30,LOW(0)
_0x40016:
	MOV  R18,R30
; 0002 0076         Data |= (bite << (7 - Col));
	LDI  R30,LOW(7)
	SUB  R30,R19
	MOV  R26,R18
	RCALL SUBOPT_0xB
; 0002 0077       }
	SUBI R19,-1
	RJMP _0x40013
_0x40014:
; 0002 0078       max7219_SpiBuff[i] = Data | ((uint16_t) (Digit + 1) << 8);
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	RCALL SUBOPT_0xC
	MOVW R0,R30
	LD   R26,Y
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,1
	MOV  R31,R30
	LDI  R30,0
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0002 0079     }
	ADIW R28,1
	SUBI R16,-1
	RJMP _0x40010
_0x40011:
; 0002 007A 
; 0002 007B     // Записываем одну строку во все max7219
; 0002 007C     max7219_sendarray(max7219_SpiBuff);
	RCALL SUBOPT_0xD
	RCALL _max7219_sendarray
; 0002 007D   }
	SUBI R17,-1
	RJMP _0x4000D
_0x4000E:
; 0002 007E }
	RCALL __LOADLOCR4
	ADIW R28,12
	RET
; .FEND
;//==============================================================================
;//------------------------------------------------------------------------------
;// This is Open source software. You can place this code on your site, but don't
;// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Это программное обеспечение распространяется свободно. Вы можете размещать
;// его на вашем сайте, но не забудьте указать ссылку на мой YouTube-канал
;// "Электроника в объектике" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Автор: Надыршин Руслан / Nadyrshin Ruslan
;//------------------------------------------------------------------------------
;
;#include <delay.h>
;#include "max7219.h"
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
;
;
;
;//==============================================================================
;// Процедура инициализирует интерфейс обмена с цепочкой max7219
;//==============================================================================
;void max7219_init(void)
; 0003 0015 {

	.CSEG
_max7219_init:
; .FSTART _max7219_init
; 0003 0016     MAX7219_DIN_DDR |= (1 << MAX7219_DIN_PIN);
	SBI  0x14,0
; 0003 0017 	MAX7219_CS_DDR |= (1 << MAX7219_CS_PIN);
	SBI  0x14,1
; 0003 0018 	MAX7219_CLK_DDR |= (1 << MAX7219_CLK_PIN);
	SBI  0x14,2
; 0003 0019 
; 0003 001A 	MAX7219_DIN_PORT &= ~(1 << MAX7219_DIN_PIN);
	CBI  0x15,0
; 0003 001B 	MAX7219_CS_PORT |= (1 << MAX7219_CS_PIN);
	SBI  0x15,1
; 0003 001C 	MAX7219_CLK_PORT &= ~(1 << MAX7219_CLK_PIN);
	CBI  0x15,2
; 0003 001D }
	RET
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура отправляет команду с данным в один или во все max7219 в цепочке
;//==============================================================================
;void max7219_send(uint8_t MAX_Idx, uint8_t Cmd, uint8_t Data)
; 0003 0025 {
_max7219_send:
; .FSTART _max7219_send
; 0003 0026   uint16_t max7219_SpiBuff[MAX7219_NUM];
; 0003 0027   uint16_t Word = Data | ((uint16_t) Cmd << 8);
; 0003 0028   uint8_t i;
; 0003 0029 
; 0003 002A   for (i = 0; i < MAX7219_NUM; i++)
	ST   -Y,R26
	SBIW R28,8
	RCALL __SAVELOCR4
;	MAX_Idx -> Y+14
;	Cmd -> Y+13
;	Data -> Y+12
;	max7219_SpiBuff -> Y+4
;	Word -> R16,R17
;	i -> R19
	LDD  R26,Y+12
	LDI  R27,0
	LDI  R30,0
	LDD  R31,Y+13
	OR   R30,R26
	OR   R31,R27
	MOVW R16,R30
	LDI  R19,LOW(0)
_0x60004:
	CPI  R19,4
	BRSH _0x60005
; 0003 002B   {
; 0003 002C     if (MAX_Idx == 0xFF)  // Нужно записать во все max7219 в цепочке
	LDD  R26,Y+14
	CPI  R26,LOW(0xFF)
	BRNE _0x60006
; 0003 002D       max7219_SpiBuff[i] = Word;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	ST   Z,R16
	STD  Z+1,R17
; 0003 002E     else                  // Нужно записать только в один max7219
	RJMP _0x60007
_0x60006:
; 0003 002F     {
; 0003 0030       if (i == MAX_Idx)         // Та микросхема max7219, в которую нужно записать команду/данные
	LDD  R30,Y+14
	CP   R30,R19
	BRNE _0x60008
; 0003 0031         max7219_SpiBuff[i] = Word;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	ST   Z,R16
	STD  Z+1,R17
; 0003 0032       else                      // max7219, которому нет данных на запись
	RJMP _0x60009
_0x60008:
; 0003 0033         max7219_SpiBuff[i] = 0x00 | ((uint16_t) MAX7219_CMD_NO_OP << 8);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0003 0034     }
_0x60009:
_0x60007:
; 0003 0035   }
	SUBI R19,-1
	RJMP _0x60004
_0x60005:
; 0003 0036 
; 0003 0037   // Пишем пачку слов во все подключенные max7219
; 0003 0038   max7219_sendarray(max7219_SpiBuff);
	RCALL SUBOPT_0xD
	RCALL _max7219_sendarray
; 0003 0039 }
	RCALL __LOADLOCR4
	ADIW R28,15
	RET
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура отправляет массив команд в max7219
;//==============================================================================
;void max7219_sendarray(uint16_t *pArray)
; 0003 0041 {
_max7219_sendarray:
; .FSTART _max7219_sendarray
; 0003 0042   uint8_t i;
; 0003 0043   MAX7219_CS_LOW();
	RCALL SUBOPT_0xE
	ST   -Y,R17
;	*pArray -> Y+1
;	i -> R17
	CBI  0x15,1
; 0003 0044   delay_us(2);
	RCALL SUBOPT_0xF
; 0003 0045 
; 0003 0046   for (i = 0; i < MAX7219_NUM; i++)
	LDI  R17,LOW(0)
_0x6000B:
	CPI  R17,4
	BRSH _0x6000C
; 0003 0047     max7219_send16bit(*(pArray++));
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	LD   R31,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOVW R26,R30
	RCALL _max7219_send16bit
	SUBI R17,-1
	RJMP _0x6000B
_0x6000C:
; 0003 0049 delay_us(2);
	RCALL SUBOPT_0xF
; 0003 004A   MAX7219_CS_HIGHT();
	SBI  0x15,1
; 0003 004B }
	LDD  R17,Y+0
	RJMP _0x20A0003
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура отправляет 16-битное слово по SPI
;//==============================================================================
;void max7219_send16bit(uint16_t Word)
; 0003 0053 {
_max7219_send16bit:
; .FSTART _max7219_send16bit
; 0003 0054     uint8_t i = 0;
; 0003 0055 	uint16_t temp = 0;
; 0003 0056 
; 0003 0057 
; 0003 0058 	while(i<16)
	RCALL SUBOPT_0xE
	RCALL __SAVELOCR4
;	Word -> Y+4
;	i -> R17
;	temp -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x6000D:
	CPI  R17,16
	BRSH _0x6000F
; 0003 0059 	{
; 0003 005A 		temp = Word;
	__GETWRS 18,19,4
; 0003 005B 
; 0003 005C 		if((temp << i) & 0x8000)
	MOV  R30,R17
	MOVW R26,R18
	RCALL __LSLW12
	ANDI R31,HIGH(0x8000)
	BREQ _0x60010
; 0003 005D 		{
; 0003 005E 			MAX7219_DIN_PORT |= (1 << MAX7219_DIN_PIN);
	SBI  0x15,0
; 0003 005F 		}
; 0003 0060 		else
	RJMP _0x60011
_0x60010:
; 0003 0061 		{
; 0003 0062 			MAX7219_DIN_PORT &= ~(1 << MAX7219_DIN_PIN);
	CBI  0x15,0
; 0003 0063 		}
_0x60011:
; 0003 0064 
; 0003 0065         delay_us(2);
	RCALL SUBOPT_0xF
; 0003 0066 		MAX7219_CLK_PORT |= (1 << MAX7219_CLK_PIN);
	SBI  0x15,2
; 0003 0067         delay_us(2);
	RCALL SUBOPT_0xF
; 0003 0068 		MAX7219_CLK_PORT &= ~(1 << MAX7219_CLK_PIN);
	CBI  0x15,2
; 0003 0069 
; 0003 006A 		i++;
	SUBI R17,-1
; 0003 006B 	}
	RJMP _0x6000D
_0x6000F:
; 0003 006C 
; 0003 006D }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура устанавливает режим декодирования символов в 1 или во всех max7219
;//==============================================================================
;void max7219_set_decodemode(uint8_t MAX_Idx, uint8_t DecodeMode)
; 0003 0075 {
_max7219_set_decodemode:
; .FSTART _max7219_set_decodemode
; 0003 0076   max7219_send(MAX_Idx, MAX7219_CMD_DECODE_MODE, DecodeMode);
	ST   -Y,R26
;	MAX_Idx -> Y+1
;	DecodeMode -> Y+0
	RCALL SUBOPT_0x10
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x11
; 0003 0077 }
	RJMP _0x20A0005
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура устанавливает яркость в 1 или во всех max7219
;//==============================================================================
;void max7219_set_intensity(uint8_t MAX_Idx, uint8_t Intensity)
; 0003 007F {
_max7219_set_intensity:
; .FSTART _max7219_set_intensity
; 0003 0080   if (Intensity > 15)
	ST   -Y,R26
;	MAX_Idx -> Y+1
;	Intensity -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x10)
	BRLO _0x60012
; 0003 0081     Intensity = 15;
	LDI  R30,LOW(15)
	ST   Y,R30
; 0003 0082 
; 0003 0083   max7219_send(MAX_Idx, MAX7219_CMD_INTENSITY, Intensity);
_0x60012:
	RCALL SUBOPT_0x10
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x11
; 0003 0084 }
	RJMP _0x20A0005
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура устанавливает кол-во знаков/строк в 1 или во всех max7219
;//==============================================================================
;void max7219_set_scan_limit(uint8_t MAX_Idx, uint8_t Limit)
; 0003 008C {
_max7219_set_scan_limit:
; .FSTART _max7219_set_scan_limit
; 0003 008D   if (Limit > 7)
	ST   -Y,R26
;	MAX_Idx -> Y+1
;	Limit -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRLO _0x60013
; 0003 008E     Limit = 7;
	LDI  R30,LOW(7)
	ST   Y,R30
; 0003 008F 
; 0003 0090   max7219_send(MAX_Idx, MAX7219_CMD_SCAN_LIMIT, Limit);
_0x60013:
	RCALL SUBOPT_0x10
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x11
; 0003 0091 }
	RJMP _0x20A0005
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура включает/выключает max7219. После подачи питания он выключен
;//==============================================================================
;void max7219_set_run_onoff(uint8_t MAX_Idx, uint8_t On)
; 0003 0099 {
_max7219_set_run_onoff:
; .FSTART _max7219_set_run_onoff
; 0003 009A   if (On)
	ST   -Y,R26
;	MAX_Idx -> Y+1
;	On -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x60014
; 0003 009B     On = 1;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0003 009C 
; 0003 009D   max7219_send(MAX_Idx, MAX7219_CMD_SHUTDOWN, On);
_0x60014:
	RCALL SUBOPT_0x10
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x11
; 0003 009E }
	RJMP _0x20A0005
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Процедура включает/выключает тестовый режим max7219 (горят все индикаторы)
;//==============================================================================
;void max7219_set_testmode_onoff(uint8_t MAX_Idx, uint8_t On)
; 0003 00A6 {
_max7219_set_testmode_onoff:
; .FSTART _max7219_set_testmode_onoff
; 0003 00A7   if (On)
	ST   -Y,R26
;	MAX_Idx -> Y+1
;	On -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x60015
; 0003 00A8     On = 1;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0003 00A9 
; 0003 00AA   max7219_send(MAX_Idx, MAX7219_CMD_DISP_TEST, On);
_0x60015:
	RCALL SUBOPT_0x10
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x11
; 0003 00AB }
	RJMP _0x20A0005
; .FEND
;//==============================================================================
;//------------------------------------------------------------------------------
;// This is Open source software. You can place this code on your site, but don't
;// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Это программное обеспечение распространяется свободно. Вы можете размещать
;// его на вашем сайте, но не забудьте указать ссылку на мой YouTube-канал
;// "Электроника в объектике" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Автор: Надыршин Руслан / Nadyrshin Ruslan
;//------------------------------------------------------------------------------
;#include "font.h"
;#include "f6x8m.h"
;
;
;// Таблица содержит латинские и русские символы (cp1251) и большинство спец. символов
;// Первые 2 байта символа - ширина и высота (для моноширинных шрифтов - константы)
;__flash const uint8_t f6x8_table[f6x8_NOFCHARS][f6x8_MONO_HEIGHT + 2] = {
;// 0x00
;  {
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x01
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x02
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x03
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x04
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x05
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x06
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x07
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x08
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x09
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x0A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x0B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x0C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x0D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x0E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x0F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x10
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x11
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x12
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x13
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x14
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x15
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x16
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x17
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x18
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x19
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x1A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x1B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x1C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x1D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x1E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x1F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x20
;  ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x21
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   ________,
;   __X_____,
;   ________}
;// 0x22
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X__X___,
;   _X__X___,
;   _X__X___,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;
;// 0x23
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X_X____,
;   _X_X____,
;   XXXXX___,
;   _X_X____,
;   XXXXX___,
;   _X_X____,
;   _X_X____,
;   ________}
;
;// 0x24
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __X_____,
;   _XXXX___,
;   X_X_____,
;   _XXX____,
;   __X_X___,
;   XXXX____,
;   __X_____}
;
;// 0x25
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XX______,
;   XX__X___,
;   ___X____,
;   __X_____,
;   _X______,
;   X__XX___,
;   ___XX___,
;   ________}
;
;// 0x26
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XX_____,
;   X__X____,
;   X_X_____,
;   _X______,
;   X_X_X___,
;   X__X____,
;   _XX_X___,
;   ________}
;
;// 0x27
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XX_____,
;   __X_____,
;   _X______,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;
;// 0x28
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ___X____,
;   __X_____,
;   _X______,
;   _X______,
;   _X______,
;   __X_____,
;   ___X____,
;   ________}
;// 0x29
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X______,
;   __X_____,
;   ___X____,
;   ___X____,
;   ___X____,
;   __X_____,
;   _X______,
;   ________}
;// 0x2A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   _X_X____,
;   __X_____,
;   XXXXX___,
;   __X_____,
;   _X_X____,
;   ________,
;   ________}
;// 0x2B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   __X_____,
;   __X_____,
;   XXXXX___,
;   __X_____,
;   __X_____,
;   ________,
;   ________}
;// 0x2C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   _XX_____,
;   __X_____,
;   _X______}
;// 0x2D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   XXXXX___,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x2E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   _XX_____,
;   _XX_____,
;   ________}
;// 0x2F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ____X___,
;   ___X____,
;   __X_____,
;   _X______,
;   X_______,
;   ________,
;   ________}
;
;// 0x30
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X__XX___,
;   X_X_X___,
;   XX__X___,
;   X___X___,
;   _XXX____,
;   ________}
;
;// 0x31
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __X_____,
;   _XX_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   _XXX____,
;   ________}
;
;// 0x32
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   ____X___,
;   __XX____,
;   _X______,
;   X_______,
;   XXXXX___,
;   ________}
;
;// 0x33
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   ____X___,
;   __XX____,
;   ____X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x34
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ___X____,
;   __XX____,
;   _X_X____,
;   X__X____,
;   XXXXX___,
;   ___X____,
;   ___X____,
;   ________}
;// 0x35
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X_______,
;   XXXX____,
;   ____X___,
;   ____X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x36
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __XX____,
;   _X______,
;   X_______,
;   XXXX____,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x37
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   ____X___,
;   ___X____,
;   __X_____,
;   _X______,
;   _X______,
;   _X______,
;   ________}
;// 0x38
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   _XXX____,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x39
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ____X___,
;   ___X____,
;   _XX_____,
;   ________}
;// 0x3A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   _XX_____,
;   _XX_____,
;   ________,
;   _XX_____,
;   _XX_____,
;   ________,
;   ________}
;// 0x3B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XX_____,
;   _XX_____,
;   ________,
;   _XX_____,
;   __X_____,
;   _X______}
;// 0x3C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ___X____,
;   __X_____,
;   _X______,
;   X_______,
;   _X______,
;   __X_____,
;   ___X____,
;   ________}
;// 0x3D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXXX___,
;   ________,
;   XXXXX___,
;   ________,
;   ________,
;   ________}
;// 0x3E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_______,
;   _X______,
;   __X_____,
;   ___X____,
;   __X_____,
;   _X______,
;   X_______,
;   ________}
;// 0x3F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   ____X___,
;   ___X____,
;   __X_____,
;   ________,
;   __X_____,
;   ________}
;// 0x40
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   ____X___,
;   _XX_X___,
;   X_X_X___,
;   X_X_X___,
;   _XXX____,
;   ________}
;// 0x41
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x42
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   ________}
;// 0x43
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X_______,
;   X_______,
;   X_______,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x44
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXX_____,
;   X__X____,
;   X___X___,
;   X___X___,
;   X___X___,
;   X__X____,
;   XXX_____,
;   ________}
;// 0x45
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X_______,
;   X_______,
;   XXXX____,
;   X_______,
;   X_______,
;   XXXXX___,
;   ________}
;// 0x46
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X_______,
;   X_______,
;   XXXX____,
;   X_______,
;   X_______,
;   X_______,
;   ________}
;// 0x47
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X_______,
;   X_______,
;   X__XX___,
;   X___X___,
;   _XXXX___,
;   ________}
;// 0x48
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x49
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   _XXX____,
;   ________}
;// 0x4A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __XXX___,
;   ___X____,
;   ___X____,
;   ___X____,
;   ___X____,
;   X__X____,
;   _XX_____,
;   ________}
;// 0x4B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X__X____,
;   X_X_____,
;   XX______,
;   X_X_____,
;   X__X____,
;   X___X___,
;   ________}
;// 0x4C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   XXXXX___,
;   ________}
;// 0x4D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   XX_XX___,
;   X_X_X___,
;   X_X_X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x4E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   XX__X___,
;   X_X_X___,
;   X__XX___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x4F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x50
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   X_______,
;   X_______,
;   X_______,
;   ________}
;// 0x51
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   X___X___,
;   X_X_X___,
;   X__X____,
;   _XX_X___,
;   ________}
;// 0x52
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   X_X_____,
;   X__X____,
;   X___X___,
;   ________}
;// 0x53
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X_______,
;   _XXX____,
;   ____X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x54
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   ________}
;// 0x55
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x56
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   _X_X____,
;   __X_____,
;   ________}
;// 0x57
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   _X_X____,
;   ________}
;// 0x58
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   _X_X____,
;   __X_____,
;   _X_X____,
;   X___X___,
;   X___X___,
;   ________}
;// 0x59
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   _X_X____,
;   __X_____,
;   __X_____,
;   __X_____,
;   ________}
;// 0x5A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   ____X___,
;   ___X____,
;   __X_____,
;   _X______,
;   X_______,
;   XXXXX___,
;   ________}
;// 0x5B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   _X______,
;   _X______,
;   _X______,
;   _X______,
;   _X______,
;   _XXX____,
;   ________}
;// 0x5C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   X_______,
;   _X______,
;   __X_____,
;   ___X____,
;   ____X___,
;   ________,
;   ________}
;// 0x5D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   ___X____,
;   ___X____,
;   ___X____,
;   ___X____,
;   ___X____,
;   _XXX____,
;   ________}
;// 0x5E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __X_____,
;   _X_X____,
;   X___X___,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x5F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   XXXXX___}
;// 0x60
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X______,
;   __X_____,
;   ___X____,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x61
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   ____X___,
;   _XXXX___,
;   X___X___,
;   _XXXX___,
;   ________}
;// 0x62
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_______,
;   X_______,
;   X_XX____,
;   XX__X___,
;   X___X___,
;   X___X___,
;   XXXX____,
;   ________}
;// 0x63
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X_______,
;   X_______,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x64
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ____X___,
;   ____X___,
;   _XX_X___,
;   X__XX___,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ________}
;// 0x65
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   XXXXX___,
;   X_______,
;   _XXX____,
;   ________}
;// 0x66
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __XX____,
;   _X__X___,
;   _X______,
;   XXX_____,
;   _X______,
;   _X______,
;   _X______,
;   ________}
;// 0x67
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXXX___,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ____X___,
;   _XXX____}
;// 0x68
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_______,
;   X_______,
;   X_XX____,
;   XX__X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x69
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __X_____,
;   ________,
;   _XX_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   _XXX____,
;   ________}
;// 0x6A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ___X____,
;   ________,
;   __XX____,
;   ___X____,
;   ___X____,
;   ___X____,
;   X__X____,
;   _XX_____}
;// 0x6B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_______,
;   X_______,
;   X__X____,
;   X_X_____,
;   XX______,
;   X_X_____,
;   X__X____,
;   ________}
;// 0x6C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XX_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   _XXX____,
;   ________}
;// 0x6D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XX_X____,
;   X_X_X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x6E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X_XX____,
;   XX__X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0x6F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0x70
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   X_______,
;   X_______}
;// 0x71
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXXX___,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ____X___,
;   ____X___}
;// 0x72
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X_XX____,
;   XX__X___,
;   X_______,
;   X_______,
;   X_______,
;   ________}
;// 0x73
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXXX___,
;   X_______,
;   _XXX____,
;   ____X___,
;   XXXX____,
;   ________}
;// 0x74
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X______,
;   _X______,
;   XXX_____,
;   _X______,
;   _X______,
;   _X__X___,
;   __XX____,
;   ________}
;// 0x75
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   X___X___,
;   X__XX___,
;   _XX_X___,
;   ________}
;// 0x76
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   X___X___,
;   _X_X____,
;   __X_____,
;   ________}
;// 0x77
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   X_X_X___,
;   X_X_X___,
;   _X_X____,
;   ________}
;// 0x78
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   _X_X____,
;   __X_____,
;   _X_X____,
;   X___X___,
;   ________}
;// 0x79
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ____X___,
;   _XXX____}
;// 0x7A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXXX___,
;   ___X____,
;   __X_____,
;   _X______,
;   XXXXX___,
;   ________}
;// 0x7B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ___X____,
;   __X_____,
;   __X_____,
;   _X______,
;   __X_____,
;   __X_____,
;   ___X____,
;   ________}
;// 0x7C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   ________}
;// 0x7D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X______,
;   __X_____,
;   __X_____,
;   ___X____,
;   __X_____,
;   __X_____,
;   _X______,
;   ________}
;// 0x7E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XX_X___,
;   X__X____,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x7F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x80
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x81
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x82
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x83
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x84
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x85
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x86
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x87
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x88
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x89
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x8A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x8B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x8C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x8D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x8E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x8F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x90
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x91
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x92
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x93
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x94
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x95
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x96
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x97
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x98
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x99
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x9A
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x9B
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x9C
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x9D
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x9E
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0x9F
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA0
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA1
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA2
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA3
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA4
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA5
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA6
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA7
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xA8
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X_X____,
;   ________,
;   XXXXX___,
;   X_______,
;   XXXX____,
;   X_______,
;   XXXXX___,
;   ________}
;// 0xA9
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xAA
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xAB
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xAC
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xAD
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xAE
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xAF
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB0
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB1
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB2
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB3
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB4
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB5
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB6
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB7
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xB8
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X_X____,
;   ________,
;   _XXX____,
;   X___X___,
;   XXXXX___,
;   X_______,
;   _XXX____,
;   ________}
;// 0xB9
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xBA
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xBB
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xBC
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xBD
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xBE
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xBF
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________,
;   ________}
;// 0xC0
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xC1
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X_______,
;   X_______,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   ________}
;// 0xC2
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   X___X___,
;   X___X___,
;   XXXX____,
;   ________}
;// 0xC3
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   ________}
;// 0xC4
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __XX____,
;   _X_X____,
;   _X_X____,
;   _X_X____,
;   _X_X____,
;   XXXXX___,
;   X___X___,
;   ________}
;// 0xC5
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X_______,
;   X_______,
;   XXXX____,
;   X_______,
;   X_______,
;   XXXXX___,
;   ________}
;// 0xC6
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   _XXX____,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   ________}
;// 0xC7
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   ____X___,
;   ___X____,
;   ____X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xC8
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X__XX___,
;   X_X_X___,
;   XX__X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xC9
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_X_X___,
;   X___X___,
;   X__XX___,
;   X_X_X___,
;   XX__X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xCA
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X__X____,
;   XXX_____,
;   X__X____,
;   X___X___,
;   X___X___,
;   ________}
;// 0xCB
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   __XXX___,
;   _X__X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xCC
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   XX_XX___,
;   XX_XX___,
;   X_X_X___,
;   X_X_X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xCD
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xCE
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xCF
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xD0
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXX____,
;   X___X___,
;   X___X___,
;   X___X___,
;   XXXX____,
;   X_______,
;   X_______,
;   ________}
;// 0xD1
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   X_______,
;   X_______,
;   X_______,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xD2
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XXXXX___,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   ________}
;// 0xD3
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ____X___,
;   XXXX____,
;   ________}
;// 0xD4
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   _XXX____,
;   __X_____,
;   ________}
;// 0xD5
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   _X_X____,
;   __X_____,
;   _X_X____,
;   X___X___,
;   X___X___,
;   ________}
;// 0xD6
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   ____X___}
;// 0xD7
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   ____X___,
;   ____X___,
;   ________}
;// 0xD8
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   XXXXX___,
;   ________}
;// 0xD9
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   XXXXX___,
;   ____X___}
;// 0xDA
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   XX______,
;   _X______,
;   _X______,
;   _XXX____,
;   _X__X___,
;   _X__X___,
;   _XXX____,
;   ________}
;// 0xDB
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X___X___,
;   X___X___,
;   X___X___,
;   XX__X___,
;   X_X_X___,
;   X_X_X___,
;   XX__X___,
;   ________}
;// 0xDC
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _X______,
;   _X______,
;   _X______,
;   _XXX____,
;   _X__X___,
;   _X__X___,
;   _XXX____,
;   ________}
;// 0xDD
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   X___X___,
;   ____X___,
;   __XXX___,
;   ____X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xDE
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   X__X____,
;   X_X_X___,
;   X_X_X___,
;   XXX_X___,
;   X_X_X___,
;   X_X_X___,
;   X__X____,
;   ________}
;// 0xDF
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   _X__X___,
;   X___X___,
;   ________}
;// 0xE0
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   ____X___,
;   _XXXX___,
;   X___X___,
;   _XXXX___,
;   ________}
;// 0xE1
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ___XX___,
;   _XX_____,
;   X_______,
;   XXXX____,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xE2
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXX____,
;   X___X___,
;   XXXX____,
;   X___X___,
;   XXXX____,
;   ________}
;// 0xE3
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXXX___,
;   X_______,
;   X_______,
;   X_______,
;   X_______,
;   ________}
;// 0xE4
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   __XX____,
;   _X_X____,
;   _X_X____,
;   XXXXX___,
;   X___X___,
;   ________}
;// 0xE5
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   XXXXX___,
;   X_______,
;   _XXX____,
;   ________}
;// 0xE6
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X_X_X___,
;   X_X_X___,
;   _XXX____,
;   X_X_X___,
;   X_X_X___,
;   ________}
;// 0xE7
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   ___X____,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xE8
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X__XX___,
;   X_X_X___,
;   XX__X___,
;   X___X___,
;   ________}
;// 0xE9
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   _XXX____,
;   ________,
;   X___X___,
;   X__XX___,
;   X_X_X___,
;   XX__X___,
;   X___X___,
;   ________}
;// 0xEA
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X__X____,
;   XXX_____,
;   X__X____,
;   X___X___,
;   ________}
;// 0xEB
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   __XXX___,
;   _X__X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xEC
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   XX_XX___,
;   X_X_X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xED
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xEE
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   X___X___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xEF
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXXX___,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   ________}
;// 0xF0
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXX____,
;   X___X___,
;   XXXX____,
;   X_______,
;   X_______,
;   ________}
;// 0xF1
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   X_______,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xF2
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XXXXX___,
;   __X_____,
;   __X_____,
;   __X_____,
;   __X_____,
;   ________}
;// 0xF3
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   _XXXX___,
;   ____X___,
;   XXXX____,
;   ________}
;// 0xF4
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X_X_X___,
;   X_X_X___,
;   _XXX____,
;   __X_____,
;   ________}
;// 0xF5
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   _X_X____,
;   __X_____,
;   _X_X____,
;   X___X___,
;   ________}
;// 0xF6
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   ____X___}
;// 0xF7
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   XXXXX___,
;   ____X___,
;   ____X___,
;   ________}
;// 0xF8
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   XXXXX___,
;   ________}
;// 0xF9
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   X_X_X___,
;   XXXXX___,
;   ____X___}
;// 0xFA
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   XX______,
;   _X______,
;   _XXX____,
;   _X__X___,
;   _XXX____,
;   ________}
;// 0xFB
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X___X___,
;   X___X___,
;   XX__X___,
;   X_X_X___,
;   XX__X___,
;   ________}
;// 0xFC
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _X______,
;   _X______,
;   _XXX____,
;   _X__X___,
;   _XXX____,
;   ________}
;// 0xFD
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXX____,
;   X___X___,
;   __XXX___,
;   X___X___,
;   _XXX____,
;   ________}
;// 0xFE
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X__X____,
;   X_X_X___,
;   XXX_X___,
;   X_X_X___,
;   X__X____,
;   ________}
;// 0xFF
; ,{
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   _XXXX___,
;   X___X___,
;   _XXXX___,
;   _X__X___,
;   X___X___,
;   ________}
;};
;
;uint8_t f6x8_charbuff[f6x8_MONO_HEIGHT + 2];
;
;//==============================================================================
;// Функция возвращает указатель на подтаблицу символа Char
;//==============================================================================
;uint8_t *f6x8_GetCharTable(uint8_t Char)
; 0004 0C21 {

	.CSEG
_f6x8_GetCharTable:
; .FSTART _f6x8_GetCharTable
; 0004 0C22     uint8_t i;
; 0004 0C23   for (i = 0; i < f6x8_MONO_HEIGHT + 2; i++)
	ST   -Y,R26
	ST   -Y,R17
;	Char -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x80004:
	CPI  R17,10
	BRSH _0x80005
; 0004 0C24     f6x8_charbuff[i] = f6x8_table[Char][i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_f6x8_charbuff)
	SBCI R31,HIGH(-_f6x8_charbuff)
	MOVW R22,R30
	LDD  R30,Y+1
	LDI  R26,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_f6x8_table*2)
	SBCI R31,HIGH(-_f6x8_table*2)
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	RCALL SUBOPT_0x9
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	SUBI R17,-1
	RJMP _0x80004
_0x80005:
; 0004 0C26 return f6x8_charbuff;
	LDI  R30,LOW(_f6x8_charbuff)
	LDI  R31,HIGH(_f6x8_charbuff)
	LDD  R17,Y+0
_0x20A0005:
	ADIW R28,2
	RET
; 0004 0C27 //  return (uint8_t *)(&f6x8_table[Char][0]);
; 0004 0C28 }
; .FEND
;//==============================================================================
;//------------------------------------------------------------------------------
;// This is Open source software. You can place this code on your site, but don't
;// forget a link to my YouTube-channel: https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Это программное обеспечение распространяется свободно. Вы можете размещать
;// его на вашем сайте, но не забудьте указать ссылку на мой YouTube-канал
;// "Электроника в объектике" https://www.youtube.com/channel/UChButpZaL5kUUl_zTyIDFkQ
;// Автор: Надыршин Руслан / Nadyrshin Ruslan
;//------------------------------------------------------------------------------
;#include "font.h"
;#include "f6x8m.h"
;#include <stdio.h>
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
;#include <stdlib.h>
;#include <stdarg.h>
;#include <string.h>
;
;
;// Текущий шрифт для вывода текста
;uint8_t FontID = FONTID_6X8M;
;
;// Таблица с указателями на функции извлечения таблицы символа шрифта. Шрифт пока один
;const t_font_getchar font_table_funcs[] =
;{
;  f6x8_GetCharTable
;};
;
;
;//==============================================================================
;// Процедура меняет шрифт
;//==============================================================================
;void font_ChangeFont(uint8_t NewFont)
; 0005 001F {

	.CSEG
; 0005 0020   FontID = NewFont;
;	NewFont -> Y+0
; 0005 0021 }
;//==============================================================================
;
;
;//==============================================================================
;// Функция возвращает ширину символа Char в пикселях
;//==============================================================================
;uint8_t font_GetCharWidth(uint8_t Char)
; 0005 0029 {
_font_GetCharWidth:
; .FSTART _font_GetCharWidth
; 0005 002A   uint8_t *pCharTable = font_table_funcs[FontID](Char);
; 0005 002B   return *pCharTable;  // Ширина символа
	ST   -Y,R26
	RCALL __SAVELOCR2
;	Char -> Y+2
;	*pCharTable -> R16,R17
	RCALL SUBOPT_0x12
	RCALL __GETW1PF
	PUSH R31
	PUSH R30
	LDD  R26,Y+2
	POP  R30
	POP  R31
	ICALL
	MOVW R16,R30
	MOVW R26,R16
	LD   R30,X
_0x20A0004:
	RCALL __LOADLOCR2
_0x20A0003:
	ADIW R28,3
	RET
; 0005 002C }
; .FEND
;//==============================================================================
;
;const uint8_t Table[] = {
;   f6x8_MONO_WIDTH,
;   f6x8_MONO_HEIGHT,
;   ________,
;   ________,
;   X__X____,
;   X_X_X___,
;   XXX_X___,
;   X_X_X___,
;   X__X____,
;   ________};
;
;//==============================================================================
;// Функция вывода символа Char в буфер из набора байт
;// 1 байт буфера = 1 столбец монохромного индикатора
;// Возвращает кол-во использованных столбцов, 0 - если не хватило длины буфера (BuffLen)
;//==============================================================================
;uint8_t font_DrawChar(uint8_t Char, uint8_t *pColumnBuff, uint16_t BuffLen)
; 0005 0041 {
_font_DrawChar:
; .FSTART _font_DrawChar
; 0005 0042   // Указатель на подтабличку конкретного символа шрифта
; 0005 0043   uint8_t *pCharTable = font_table_funcs[FontID](Char);
; 0005 0044   uint8_t CharWidth = *(pCharTable++);  // Ширина символа
; 0005 0045   uint8_t CharHeight = *(pCharTable++); // Высота символа
; 0005 0046   uint8_t col;
; 0005 0047   uint8_t row;
; 0005 0048 
; 0005 0049   if (CharWidth > BuffLen)
	RCALL SUBOPT_0xE
	RCALL __SAVELOCR6
;	Char -> Y+10
;	*pColumnBuff -> Y+8
;	BuffLen -> Y+6
;	*pCharTable -> R16,R17
;	CharWidth -> R19
;	CharHeight -> R18
;	col -> R21
;	row -> R20
	RCALL SUBOPT_0x12
	RCALL __GETW1PF
	PUSH R31
	PUSH R30
	LDD  R26,Y+10
	POP  R30
	POP  R31
	ICALL
	MOVW R16,R30
	MOVW R26,R16
	RCALL SUBOPT_0x5
	LD   R30,X
	MOV  R19,R30
	MOVW R26,R16
	RCALL SUBOPT_0x5
	LD   R30,X
	MOV  R18,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOV  R26,R19
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xA0003
; 0005 004A     return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A0002
; 0005 004B   for (col = 0; col < CharWidth; col++)
_0xA0003:
	LDI  R21,LOW(0)
_0xA0005:
	CP   R21,R19
	BRSH _0xA0006
; 0005 004C   {
; 0005 004D     uint8_t ColBuff = 0;
; 0005 004E 
; 0005 004F     for (row = 0; row < CharHeight; row++)
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	Char -> Y+11
;	*pColumnBuff -> Y+9
;	BuffLen -> Y+7
;	ColBuff -> Y+0
	LDI  R20,LOW(0)
_0xA0008:
	CP   R20,R18
	BRSH _0xA0009
; 0005 0050     {
; 0005 0051       if (pCharTable[row] & (1 << (7 - col)))
	MOVW R26,R16
	CLR  R30
	ADD  R26,R20
	ADC  R27,R30
	LD   R22,X
	MOV  R30,R21
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	MOV  R26,R22
	RCALL SUBOPT_0xA
	BREQ _0xA000A
; 0005 0052         ColBuff |= (1 << row);
	MOV  R30,R20
	LDI  R26,LOW(1)
	RCALL SUBOPT_0xB
; 0005 0053     }
_0xA000A:
	SUBI R20,-1
	RJMP _0xA0008
_0xA0009:
; 0005 0054 
; 0005 0055     *pColumnBuff = ColBuff;
	LD   R30,Y
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
; 0005 0056     pColumnBuff++;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0005 0057   }
	ADIW R28,1
	SUBI R21,-1
	RJMP _0xA0005
_0xA0006:
; 0005 0058 
; 0005 0059   return CharWidth;
	MOV  R30,R19
_0x20A0002:
	RCALL __LOADLOCR6
	ADIW R28,11
	RET
; 0005 005A }
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Функция вывода текста из строки Str в буфер из набора байт
;// 1 байт буфера = 1 столбец монохромного индикатора
;// Возвращает кол-во использованных столбцов, 0 - если не хватило длины буфера (BuffLen)
;//==============================================================================
;uint16_t font_DrawString(uint8_t *Str, uint8_t *pColumnBuff, uint16_t BuffLen)
; 0005 0064 {
_font_DrawString:
; .FSTART _font_DrawString
; 0005 0065   uint16_t BuffOffset = 0;
; 0005 0066   uint8_t *StrTemp = Str;
; 0005 0067 
; 0005 0068   // Считаем длину необходимого буфера для размещения всех символов строки
; 0005 0069   while (*StrTemp != '\0')
	RCALL SUBOPT_0xE
	RCALL __SAVELOCR4
;	*Str -> Y+8
;	*pColumnBuff -> Y+6
;	BuffLen -> Y+4
;	BuffOffset -> R16,R17
;	*StrTemp -> R18,R19
	RCALL SUBOPT_0x3
	__GETWRS 18,19,8
_0xA000B:
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BREQ _0xA000D
; 0005 006A   {
; 0005 006B     BuffOffset += font_GetCharWidth(*StrTemp);
	LD   R26,X
	RCALL _font_GetCharWidth
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0005 006C     StrTemp++;
	__ADDWRN 18,19,1
; 0005 006D 
; 0005 006E     if (BuffOffset > BuffLen)     // Сформированная строка не уместится в буфере
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R16
	CPC  R31,R17
	BRSH _0xA000E
; 0005 006F       return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0001
; 0005 0070   }
_0xA000E:
	RJMP _0xA000B
_0xA000D:
; 0005 0071 
; 0005 0072   BuffOffset = 0;
	RCALL SUBOPT_0x3
; 0005 0073   StrTemp = Str;
	__GETWRS 18,19,8
; 0005 0074 
; 0005 0075   // Считаем длину необходимого буфера для размещения всех символов строки
; 0005 0076   while (*StrTemp != '\0')
_0xA000F:
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BREQ _0xA0011
; 0005 0077   {
; 0005 0078     // Выводим очередной символ
; 0005 0079     uint8_t Width = font_DrawChar(*StrTemp, pColumnBuff, BuffLen - BuffOffset);
; 0005 007A     BuffOffset += Width;
	SBIW R28,1
;	*Str -> Y+9
;	*pColumnBuff -> Y+7
;	BuffLen -> Y+5
;	Width -> Y+0
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SUB  R26,R16
	SBC  R27,R17
	RCALL _font_DrawChar
	ST   Y,R30
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0005 007B     pColumnBuff += Width;
	LD   R30,Y
	LDI  R31,0
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RCALL SUBOPT_0x9
	STD  Y+7,R30
	STD  Y+7+1,R31
; 0005 007C     StrTemp++;
	__ADDWRN 18,19,1
; 0005 007D   }
	ADIW R28,1
	RJMP _0xA000F
_0xA0011:
; 0005 007E 
; 0005 007F   return BuffOffset;
	MOVW R30,R16
_0x20A0001:
	RCALL __LOADLOCR4
	ADIW R28,10
	RET
; 0005 0080 }
; .FEND
;//==============================================================================
;
;
;//==============================================================================
;// Функция форматированного вывода в буфер из набора байт
;// 1 байт буфера = 1 столбец монохромного индикатора
;// Возвращает кол-во использованных столбцов, 0 - если не хватило длины буфера (BuffLen)
;//==============================================================================
;uint16_t font_printf(uint8_t *pColumnBuff, uint16_t BuffLen, flash char *args, ...)
; 0005 008A {
; 0005 008B   char font_Buff[40];
; 0005 008C   char len;
; 0005 008D 
; 0005 008E   va_list ap;
; 0005 008F   va_start(ap, args);
;	*pColumnBuff -> Y+48
;	BuffLen -> Y+46
;	*args -> Y+44
;	font_Buff -> Y+4
;	len -> R17
;	*ap -> R18,R19
; 0005 0090   len = vsnprintf(font_Buff, sizeof(font_Buff), args, ap);
; 0005 0091   va_end(ap);
; 0005 0092 
; 0005 0093   return font_DrawString((uint8_t *)font_Buff, pColumnBuff, BuffLen);
; 0005 0094 }
;//==============================================================================
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

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_ledmatrix_screenbuff:
	.BYTE 0x20
_ScrollBuff:
	.BYTE 0x8C
_f6x8_charbuff:
	.BYTE 0xA
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_ScrollBuff)
	LDI  R31,HIGH(_ScrollBuff)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(255)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	SUBI R30,LOW(-_ledmatrix_screenbuff)
	SBCI R31,HIGH(-_ledmatrix_screenbuff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOV  R30,R19
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL __LSLB12
	LD   R26,Y
	OR   R30,R26
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	__DELAY_USB 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	LDD  R26,Y+2
	RJMP _max7219_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOV  R30,R5
	LDI  R26,LOW(_font_table_funcs*2)
	LDI  R27,HIGH(_font_table_funcs*2)
	LDI  R31,0
	RJMP SUBOPT_0xC


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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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
