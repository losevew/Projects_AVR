
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

_NUMBER_FONT:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71

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
;/**************************************************************************************
;* tm1638.c
;*
;* TM1638 LED controller with key-scan interface driver for Atmel AVR
;* micro controllers.
;*
;*   Copyright (C) 2015 Michael Williamson. All rights reserved.
;*   Authors: Michael Williamson <mikesmodz@gmail.com>
;*
;* Redistribution and use in source and binary forms, with or without
;* modification, are permitted provided that the following conditions
;* are met:
;*
;* 1. Redistributions of source code must retain the above copyright
;*    notice, this list of conditions and the following disclaimer.
;* 2. Redistributions in binary form must reproduce the above copyright
;*    notice, this list of conditions and the following disclaimer in
;*    the documentation and/or other materials provided with the
;*    distribution.
;*
;* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
;* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;* COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
;* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
;* OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
;* AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;* ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;* POSSIBILITY OF SUCH DAMAGE.
;*
;****************************************************************************/
;
;/****************************************************************************
;* Included Files
;****************************************************************************/
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
;#include <delay.h>
;#include "tm1638.h"
;#include "tm1638_fonts.h"
;
;/****************************************************************************
;* Private Function Prototypes
;****************************************************************************/
;static void TM1638_SendCommand(const unsigned char cmd);
;//static void TM1638_SendData(const unsigned char adr, const unsigned char data);
;static void TM1638_SendByte(unsigned char data);
;static unsigned char TM1638_ReceiveByte(void);
;
;/****************************************************************************
;* Private Functions
;****************************************************************************/
;
;//*****************************************************************************
;// Function:     TM1638_SendCommand
;// Called with:  cmd = command to send.
;// Returns:      Nothing.
;// Purpose:      Sends a command to the TM1638.
;//*****************************************************************************
;static void TM1638_SendCommand(const unsigned char cmd)
; 0000 0040 {

	.CSEG
_TM1638_SendCommand_G000:
; .FSTART _TM1638_SendCommand_G000
; 0000 0041 	TM1638_STROBE_LOW;
	ST   -Y,R26
;	cmd -> Y+0
	CBI  0x15,1
; 0000 0042 	TM1638_SendByte(cmd);
	LD   R26,Y
	RCALL _TM1638_SendByte_G000
; 0000 0043 	TM1638_STROBE_HIGH;
	SBI  0x15,1
; 0000 0044 }
	ADIW R28,1
	RET
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_SendData
;// Called with:  adr = register address.
;//				 data = data to write.
;// Returns:      Nothing.
;// Purpose:      Sends a data to the TM1638.
;//*****************************************************************************
;void TM1638_SendData(const unsigned char adr, const unsigned char data)
; 0000 004E {
_TM1638_SendData:
; .FSTART _TM1638_SendData
; 0000 004F 	TM1638_SendCommand(TM1638_DATA_WRITE_FIX_ADDR);
	ST   -Y,R26
;	adr -> Y+1
;	data -> Y+0
	LDI  R26,LOW(68)
	RCALL _TM1638_SendCommand_G000
; 0000 0050 	TM1638_STROBE_LOW;
	CBI  0x15,1
; 0000 0051 	TM1638_SendByte(TM1638_ADDR_INSTRUCTION_SET|(adr&0x0F));
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	MOV  R26,R30
	RCALL _TM1638_SendByte_G000
; 0000 0052 	TM1638_SendByte(data);
	LD   R26,Y
	RCALL _TM1638_SendByte_G000
; 0000 0053 	TM1638_STROBE_HIGH;
	SBI  0x15,1
; 0000 0054 }
	RJMP _0x2000002
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_SendByte
;// Called with:  data = data to write.
;// Returns:      Nothing.
;// Purpose:      Sends a byte to the TM1638.
;//*****************************************************************************
;static void TM1638_SendByte(unsigned char data)
; 0000 005D {
_TM1638_SendByte_G000:
; .FSTART _TM1638_SendByte_G000
; 0000 005E 	unsigned char i = 0;
; 0000 005F 	for (i=0; i<8; i++)
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+1
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x4:
	CPI  R17,8
	BRSH _0x5
; 0000 0060 	{
; 0000 0061 		TM1638_CLOCK_LOW;
	CBI  0x15,0
; 0000 0062 		if (data & 0x01)
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	BREQ _0x6
; 0000 0063 		{
; 0000 0064 			TM1638_DATA_HIGH;
	SBI  0x15,2
; 0000 0065 		}
; 0000 0066 		else
	RJMP _0x7
_0x6:
; 0000 0067 		{
; 0000 0068 			TM1638_DATA_LOW;
	CBI  0x15,2
; 0000 0069 		}
_0x7:
; 0000 006A 		data >>= 1;
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
; 0000 006B 		TM1638_CLOCK_HIGH;
	SBI  0x15,0
; 0000 006C 	}
	SUBI R17,-1
	RJMP _0x4
_0x5:
; 0000 006D }
	LDD  R17,Y+0
	RJMP _0x2000002
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_ReceiveByte
;// Called with:  Nothing.
;// Returns:      Byte received.
;// Purpose:      Reads a byte of data from the TM1638.
;//*****************************************************************************
;static unsigned char TM1638_ReceiveByte(void)
; 0000 0076 {
_TM1638_ReceiveByte_G000:
; .FSTART _TM1638_ReceiveByte_G000
; 0000 0077 	unsigned char res = 0;
; 0000 0078 	unsigned char i = 0;
; 0000 0079 
; 0000 007A 	/* Change data pin to input */
; 0000 007B 	TM1638_DIR	&= ~(1 << TM1638_DATA_PIN);
	RCALL __SAVELOCR2
;	res -> R17
;	i -> R16
	LDI  R17,0
	LDI  R16,0
	CBI  0x14,2
; 0000 007C 
; 0000 007D 	for (i=0; i<8; i++)
	LDI  R16,LOW(0)
_0x9:
	CPI  R16,8
	BRSH _0xA
; 0000 007E 	{
; 0000 007F 		TM1638_CLOCK_LOW;
	CBI  0x15,0
; 0000 0080 		if (TM1638_PINS & (1 << TM1638_DATA_PIN)) res |= 0x80;
	SBIC 0x13,2
	ORI  R17,LOW(128)
; 0000 0081 		TM1638_CLOCK_HIGH;
	SBI  0x15,0
; 0000 0082 		res >>= 1;
	LSR  R17
; 0000 0083 	}
	SUBI R16,-1
	RJMP _0x9
_0xA:
; 0000 0084 
; 0000 0085 	/* Change data pin back to output */
; 0000 0086 	TM1638_DIR	|= 1 << TM1638_DATA_PIN;
	SBI  0x14,2
; 0000 0087 
; 0000 0088 	/* Return result */
; 0000 0089 	return res;
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 008A }
; .FEND
;
;/****************************************************************************
;* Public Functions
;****************************************************************************/
;
;//*****************************************************************************
;// Function:     TM1638_Init
;// Called with:  intensity = display intensity 0-7.
;// Returns:      Nothing.
;// Purpose:      Initialises the hardware used by the TM1638.
;//*****************************************************************************
;void TM1638_Init(const unsigned char intensity)
; 0000 0097 {
_TM1638_Init:
; .FSTART _TM1638_Init
; 0000 0098 	unsigned char i = 0;
; 0000 0099 
; 0000 009A 	/* Initialise clock pin as output */
; 0000 009B 	TM1638_DIR|= 1 << TM1638_CLOCK_PIN;
	ST   -Y,R26
	ST   -Y,R17
;	intensity -> Y+1
;	i -> R17
	LDI  R17,0
	SBI  0x14,0
; 0000 009C 
; 0000 009D 	/* Initialise strobe pin as output */
; 0000 009E 	TM1638_DIR|= 1 << TM1638_STROBE_PIN;
	SBI  0x14,1
; 0000 009F 
; 0000 00A0 	/* Initialise data pin as output */
; 0000 00A1 	TM1638_DIR	|= 1 << TM1638_DATA_PIN;
	SBI  0x14,2
; 0000 00A2 
; 0000 00A3 	/* Initialise the display */
; 0000 00A4 	TM1638_SendCommand(TM1638_DATA_WRITE_AUTO_ADDR);
	LDI  R26,LOW(64)
	RCALL _TM1638_SendCommand_G000
; 0000 00A5 	TM1638_SendCommand(TM1638_DISPLAY_CONTROL_SET|0x08|(intensity&0x07));
	LDD  R30,Y+1
	ANDI R30,LOW(0x7)
	ORI  R30,LOW(0x88)
	MOV  R26,R30
	RCALL _TM1638_SendCommand_G000
; 0000 00A6 
; 0000 00A7 	/* Set strobe low */
; 0000 00A8 	TM1638_STROBE_LOW;
	CBI  0x15,1
; 0000 00A9 
; 0000 00AA 	/* Send first register address */
; 0000 00AB 	TM1638_SendByte(TM1638_ADDR_INSTRUCTION_SET);
	LDI  R26,LOW(192)
	RCALL _TM1638_SendByte_G000
; 0000 00AC 
; 0000 00AD 	/* Clear all of the registers */
; 0000 00AE 	for (i=0; i<16; i++)
	LDI  R17,LOW(0)
_0xD:
	CPI  R17,16
	BRSH _0xE
; 0000 00AF 	{
; 0000 00B0 		TM1638_SendByte(0x00);
	LDI  R26,LOW(0)
	RCALL _TM1638_SendByte_G000
; 0000 00B1 	}
	SUBI R17,-1
	RJMP _0xD
_0xE:
; 0000 00B2 
; 0000 00B3 	/* Set strobe high */
; 0000 00B4 	TM1638_STROBE_HIGH;
	SBI  0x15,1
; 0000 00B5 }
	LDD  R17,Y+0
	RJMP _0x2000002
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_ClearDigits
;// Called with:  Nothing.
;// Returns:      Nothing.
;// Purpose:      Clears all of the digits.
;//*****************************************************************************
;void TM1638_ClearDigits(void)
; 0000 00BE {
; 0000 00BF 	unsigned char i = 0;
; 0000 00C0 	for (i=0; i<8; i++)
;	i -> R17
; 0000 00C1 	{
; 0000 00C2 		TM1638_SendData(i<<1, 0x00);
; 0000 00C3 	}
; 0000 00C4 }
;
;//*****************************************************************************
;// Function:     TM1638_SetLED
;// Called with:  pos = LED position 0-7.
;//				 colour = LED colour 0x00 (off), 0x01 (red) or
;//				 0x02 (green).
;// Returns:      Nothing.
;// Purpose:      Sets an LED state.
;//*****************************************************************************
;void TM1638_SetLED(const unsigned char pos, const unsigned char colour)
; 0000 00CF {
_TM1638_SetLED:
; .FSTART _TM1638_SetLED
; 0000 00D0 	TM1638_SendData(((pos&0x07)<<1)+1, colour);
	ST   -Y,R26
;	pos -> Y+1
;	colour -> Y+0
	LDD  R30,Y+1
	ANDI R30,LOW(0x7)
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _TM1638_SendData
; 0000 00D1 }
	RJMP _0x2000002
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_SetDigit
;// Called with:  pos = digit position 0-7.
;//				 segments = segment data.
;//				 dot = include dot segment.
;// Returns:      Nothing.
;// Purpose:      Sets a digits segments.
;//*****************************************************************************
;void TM1638_SetDigit(const unsigned char pos, const unsigned char segments, unsigned char dot)
; 0000 00DC {
_TM1638_SetDigit:
; .FSTART _TM1638_SetDigit
; 0000 00DD 	TM1638_SendData((pos&0x07)<<1, segments|(dot?0x80:0));
	ST   -Y,R26
;	pos -> Y+2
;	segments -> Y+1
;	dot -> Y+0
	LDD  R30,Y+2
	ANDI R30,LOW(0x7)
	LSL  R30
	ST   -Y,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x12
	LDI  R30,LOW(128)
	RJMP _0x13
_0x12:
	LDI  R30,LOW(0)
_0x13:
	LDD  R26,Y+2
	OR   R30,R26
	MOV  R26,R30
	RCALL _TM1638_SendData
; 0000 00DE }
	RJMP _0x2000003
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_SetDisplayDigit
;// Called with:  digit = value to display 0x00-0x0F.
;//				 pos = digit position 0-7.
;//				 dot = include dot segment.
;// Returns:      Nothing.
;// Purpose:      Sets a digits segments.
;//*****************************************************************************
;void TM1638_SetDisplayDigit(const unsigned char digit, const unsigned char pos, unsigned char dot)
; 0000 00E9 {
_TM1638_SetDisplayDigit:
; .FSTART _TM1638_SetDisplayDigit
; 0000 00EA 	TM1638_SetDigit(pos, NUMBER_FONT[digit & 0x0F], dot);
	ST   -Y,R26
;	digit -> Y+2
;	pos -> Y+1
;	dot -> Y+0
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+3
	LDI  R31,0
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	SUBI R30,LOW(-_NUMBER_FONT*2)
	SBCI R31,HIGH(-_NUMBER_FONT*2)
	LPM  R30,Z
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _TM1638_SetDigit
; 0000 00EB }
_0x2000003:
	ADIW R28,3
	RET
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_ClearDisplayDigit
;// Called with:  pos = digit position 0-7.
;//				 dot = include dot segment.
;// Returns:      Nothing.
;// Purpose:      Sets a digits segments.
;//*****************************************************************************
;void TM1638_ClearDisplayDigit(const unsigned char pos, unsigned char dot)
; 0000 00F5 {
_TM1638_ClearDisplayDigit:
; .FSTART _TM1638_ClearDisplayDigit
; 0000 00F6 	TM1638_SetDigit(pos, 0, dot);
	ST   -Y,R26
;	pos -> Y+1
;	dot -> Y+0
	LDD  R30,Y+1
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _TM1638_SetDigit
; 0000 00F7 }
_0x2000002:
	ADIW R28,2
	RET
; .FEND
;
;//*****************************************************************************
;// Function:     TM1638_GetKeys
;// Called with:  Nothing.
;// Returns:      Key states.
;// Purpose:      Reads all of the button states.
;//*****************************************************************************
;unsigned char TM1638_GetKeys(void)
; 0000 0100 {
_TM1638_GetKeys:
; .FSTART _TM1638_GetKeys
; 0000 0101 	unsigned char i = 0;
; 0000 0102 	unsigned char res = 0;
; 0000 0103 	unsigned char keys = 0;
; 0000 0104 
; 0000 0105 	/* Set strobe low */
; 0000 0106 	TM1638_STROBE_LOW;
	RCALL __SAVELOCR4
;	i -> R17
;	res -> R16
;	keys -> R19
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	CBI  0x15,1
; 0000 0107 
; 0000 0108 	/* Send read scan keys command */
; 0000 0109 	TM1638_SendByte(TM1638_READ_KEY_SCAN_MODE);
	LDI  R26,LOW(66)
	RCALL _TM1638_SendByte_G000
; 0000 010A 
; 0000 010B 	/* Read four bytes containing the key states */
; 0000 010C 	for (i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x16:
	CPI  R17,4
	BRSH _0x17
; 0000 010D 	{
; 0000 010E 		/* Get key states byte */
; 0000 010F 		res = TM1638_ReceiveByte();
	RCALL _TM1638_ReceiveByte_G000
	MOV  R16,R30
; 0000 0110 
; 0000 0111 		/* All keys are on key scan data input K3 which are bits
; 0000 0112 		   B0 and B4 of the result. See data sheet page 4.
; 0000 0113 		   Read these bits and ignore the rest. */
; 0000 0114 		if (res&0x01) keys |= (0x01<<i);
	SBRS R16,0
	RJMP _0x18
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R19,R30
; 0000 0115 		if (res&0x10) keys |= (0x01<<(i+4));
_0x18:
	SBRS R16,4
	RJMP _0x19
	MOV  R30,R17
	SUBI R30,-LOW(4)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R19,R30
; 0000 0116 	}
_0x19:
	SUBI R17,-1
	RJMP _0x16
_0x17:
; 0000 0117 
; 0000 0118 	/* Set strobe high */
; 0000 0119 	TM1638_STROBE_HIGH;
	SBI  0x15,1
; 0000 011A 
; 0000 011B 	/* Return key states */
; 0000 011C 	return keys;
	MOV  R30,R19
	RCALL __LOADLOCR4
	RJMP _0x2000001
; 0000 011D }
; .FEND
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 23.02.2018
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
;#include <delay.h>
;#include "tm1638.h"
;
;// Declare your global variables here
;
;static void custom_delay(unsigned int delay);
;
;void main(void)
; 0001 0023 {

	.CSEG
_main:
; .FSTART _main
; 0001 0024 // Declare your local variables here
; 0001 0025     unsigned char i = 0;
; 0001 0026 	unsigned char keys = 0;
; 0001 0027 	unsigned char flag = 0;
; 0001 0028 
; 0001 0029 // Input/Output Ports initialization
; 0001 002A // Port B initialization
; 0001 002B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 002C DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
;	i -> R17
;	keys -> R16
;	flag -> R19
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0001 002D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 002E PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0001 002F 
; 0001 0030 // Port C initialization
; 0001 0031 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0032 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0001 0033 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0034 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0001 0035 
; 0001 0036 // Port D initialization
; 0001 0037 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0038 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0001 0039 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 003A PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0001 003B 
; 0001 003C // Timer/Counter 0 initialization
; 0001 003D // Clock source: System Clock
; 0001 003E // Clock value: Timer 0 Stopped
; 0001 003F TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0001 0040 TCNT0=0x00;
	OUT  0x32,R30
; 0001 0041 
; 0001 0042 // Timer/Counter 1 initialization
; 0001 0043 // Clock source: System Clock
; 0001 0044 // Clock value: Timer1 Stopped
; 0001 0045 // Mode: Normal top=0xFFFF
; 0001 0046 // OC1A output: Disconnected
; 0001 0047 // OC1B output: Disconnected
; 0001 0048 // Noise Canceler: Off
; 0001 0049 // Input Capture on Falling Edge
; 0001 004A // Timer1 Overflow Interrupt: Off
; 0001 004B // Input Capture Interrupt: Off
; 0001 004C // Compare A Match Interrupt: Off
; 0001 004D // Compare B Match Interrupt: Off
; 0001 004E TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0001 004F TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0001 0050 TCNT1H=0x00;
	OUT  0x2D,R30
; 0001 0051 TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0052 ICR1H=0x00;
	OUT  0x27,R30
; 0001 0053 ICR1L=0x00;
	OUT  0x26,R30
; 0001 0054 OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 0055 OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 0056 OCR1BH=0x00;
	OUT  0x29,R30
; 0001 0057 OCR1BL=0x00;
	OUT  0x28,R30
; 0001 0058 
; 0001 0059 // Timer/Counter 2 initialization
; 0001 005A // Clock source: System Clock
; 0001 005B // Clock value: Timer2 Stopped
; 0001 005C // Mode: Normal top=0xFF
; 0001 005D // OC2 output: Disconnected
; 0001 005E ASSR=0<<AS2;
	OUT  0x22,R30
; 0001 005F TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0001 0060 TCNT2=0x00;
	OUT  0x24,R30
; 0001 0061 OCR2=0x00;
	OUT  0x23,R30
; 0001 0062 
; 0001 0063 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0064 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0001 0065 
; 0001 0066 // External Interrupt(s) initialization
; 0001 0067 // INT0: Off
; 0001 0068 // INT1: Off
; 0001 0069 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0001 006A 
; 0001 006B // USART initialization
; 0001 006C // USART disabled
; 0001 006D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0001 006E 
; 0001 006F // Analog Comparator initialization
; 0001 0070 // Analog Comparator: Off
; 0001 0071 // The Analog Comparator's positive input is
; 0001 0072 // connected to the AIN0 pin
; 0001 0073 // The Analog Comparator's negative input is
; 0001 0074 // connected to the AIN1 pin
; 0001 0075 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 0076 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 0077 
; 0001 0078 // ADC initialization
; 0001 0079 // ADC disabled
; 0001 007A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0001 007B 
; 0001 007C // SPI initialization
; 0001 007D // SPI disabled
; 0001 007E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0001 007F 
; 0001 0080 // TWI initialization
; 0001 0081 // TWI disabled
; 0001 0082 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0001 0083 
; 0001 0084 
; 0001 0085 
; 0001 0086 
; 0001 0087 	/* Initialise the display */
; 0001 0088 	TM1638_Init(0x07);
	LDI  R26,LOW(7)
	RCALL _TM1638_Init
; 0001 0089 
; 0001 008A 	/* Main loop */
; 0001 008B 
; 0001 008C while (1)
_0x20003:
; 0001 008D       {
; 0001 008E       // Place your code here
; 0001 008F       keys = TM1638_GetKeys();
	RCALL _TM1638_GetKeys
	MOV  R16,R30
; 0001 0090 		for (i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x20007:
	CPI  R17,8
	BRSH _0x20008
; 0001 0091 		{
; 0001 0092 			if (keys & (1<<i))
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	MOV  R26,R16
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x20009
; 0001 0093             {
; 0001 0094                 TM1638_ClearDisplayDigit(i, 0);
	ST   -Y,R17
	LDI  R26,LOW(0)
	RCALL _TM1638_ClearDisplayDigit
; 0001 0095             }
; 0001 0096 			else
	RJMP _0x2000A
_0x20009:
; 0001 0097             {
; 0001 0098                 TM1638_SetDisplayDigit(i+1, i, 0);
	MOV  R30,R17
	SUBI R30,-LOW(1)
	ST   -Y,R30
	ST   -Y,R17
	LDI  R26,LOW(0)
	RCALL _TM1638_SetDisplayDigit
; 0001 0099             }
_0x2000A:
; 0001 009A 		}
	SUBI R17,-1
	RJMP _0x20007
_0x20008:
; 0001 009B 		for (i=0;i<8;i++) TM1638_SetLED(i,flag);
	LDI  R17,LOW(0)
_0x2000C:
	CPI  R17,8
	BRSH _0x2000D
	ST   -Y,R17
	MOV  R26,R19
	RCALL _TM1638_SetLED
	SUBI R17,-1
	RJMP _0x2000C
_0x2000D:
; 0001 009C custom_delay(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _custom_delay_G001
; 0001 009D 		flag = !flag;
	MOV  R30,R19
	RCALL __LNEGB1
	MOV  R19,R30
; 0001 009E 
; 0001 009F       }
	RJMP _0x20003
; 0001 00A0 }
_0x2000E:
	RJMP _0x2000E
; .FEND
;
;//*****************************************************************************
;// Function:     	custom_delay
;// Called with:  	delay = delay length.
;// Returns:			nothing.
;// Purpose:      	Peforms a delay * 10 ms delay.
;//*****************************************************************************
;static void custom_delay(unsigned int delay)
; 0001 00A9 {
_custom_delay_G001:
; .FSTART _custom_delay_G001
; 0001 00AA 	unsigned int i;
; 0001 00AB 	for(i=0; i<delay; i++) delay_ms(10);
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR2
;	delay -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x20010:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x20011
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
	__ADDWRN 16,17,1
	RJMP _0x20010
_0x20011:
; 0001 00AC }
	RCALL __LOADLOCR2
_0x2000001:
	ADIW R28,4
	RET
; .FEND
;

	.CSEG

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

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
