
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
	.DEF _FRT=R5
	.DEF _FOD=R4
	.DEF _rx_count=R7
	.DEF _tx_rd_index=R6
	.DEF _tx_counter=R9
	.DEF _tx_wr_index=R8

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
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_font5x7ru:
	.DB  0x5,0x7,0x20,0xE0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x34,0x1C,0x36,0x1C,0x16
	.DB  0x22,0x45,0x7F,0x51,0x22,0x22,0x15,0x2A
	.DB  0x54,0x22,0x36,0x49,0x55,0x23,0x50,0x0
	.DB  0x0,0x7,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x12,0xC
	.DB  0x1E,0xC,0x12,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x40,0x20,0x0,0x0,0x0,0x8,0x8
	.DB  0x8,0x0,0x0,0x0,0x40,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x41,0x41,0x41
	.DB  0x3E,0x0,0x2,0x41,0x7F,0x40,0x42,0x61
	.DB  0x51,0x49,0x66,0x22,0x41,0x49,0x49,0x36
	.DB  0x18,0x14,0x52,0x7F,0x40,0x27,0x45,0x45
	.DB  0x45,0x39,0x3E,0x49,0x49,0x49,0x32,0x61
	.DB  0x11,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x26,0x49,0x49,0x49,0x3E,0x0,0x0
	.DB  0x22,0x0,0x0,0x0,0x40,0x22,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x0,0x0,0x14,0x14
	.DB  0x14,0x0,0x0,0x22,0x14,0x8,0x0,0x0
	.DB  0x2,0x59,0x5,0x2,0x3E,0x49,0x55,0x59
	.DB  0x2E,0x7C,0x12,0x11,0x12,0x7C,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x41,0x3E,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x9,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x0,0x7F,0x0,0x0,0x20,0x40
	.DB  0x40,0x3F,0x0,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x2,0x4,0x8,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x41,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x22,0x45,0x49,0x51,0x22
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x3F
	.DB  0x40,0x3C,0x40,0x3F,0x63,0x14,0x8,0x14
	.DB  0x63,0x7,0x8,0x70,0x8,0x7,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x7F,0x41,0x41,0x0
	.DB  0x2,0x4,0x8,0x10,0x20,0x0,0x41,0x41
	.DB  0x7F,0x0,0x0,0x2,0x1,0x2,0x0,0x0
	.DB  0x40,0x40,0x40,0x0,0x0,0x1,0x2,0x0
	.DB  0x0,0x20,0x54,0x54,0x38,0x40,0x7E,0x48
	.DB  0x48,0x30,0x0,0x3C,0x42,0x42,0x24,0x0
	.DB  0x30,0x48,0x48,0x7E,0x0,0x3C,0x4A,0x4A
	.DB  0x2C,0x0,0x0,0x10,0x7C,0x12,0x4,0xC
	.DB  0x52,0x52,0x3C,0x0,0x7E,0x10,0x8,0x70
	.DB  0x0,0x0,0x0,0x7A,0x0,0x0,0x0,0x40
	.DB  0x3A,0x0,0x0,0x7E,0x10,0x28,0x44,0x0
	.DB  0x0,0x0,0x7E,0x0,0x0,0x7C,0x4,0x78
	.DB  0x4,0x78,0x7C,0x8,0x4,0x78,0x0,0x3C
	.DB  0x42,0x42,0x3C,0x0,0x7E,0x12,0x12,0xC
	.DB  0x0,0x0,0x1C,0x22,0x12,0x7E,0x7E,0x4
	.DB  0x2,0x4,0x0,0x24,0x4A,0x52,0x24,0x0
	.DB  0x0,0x8,0x3E,0x48,0x20,0x3E,0x40,0x40
	.DB  0x3E,0x0,0x1E,0x60,0x60,0x1E,0x0,0x3E
	.DB  0x40,0x38,0x40,0x3E,0x44,0x28,0x10,0x28
	.DB  0x44,0x46,0x28,0x10,0xE,0x0,0x62,0x52
	.DB  0x4A,0x46,0x0,0x8,0x36,0x41,0x0,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x0,0x41
	.DB  0x36,0x8,0x2,0x1,0x2,0x1,0x0,0x0
	.DB  0x3E,0x22,0x3E,0x0,0x0,0x2,0x7E,0x2A
	.DB  0x30,0x0,0x7E,0x2,0x3,0x2,0x0,0x40
	.DB  0x20,0x0,0x0,0x0,0x78,0xC,0x8,0x0
	.DB  0x40,0x20,0x40,0x20,0x0,0x0,0x40,0x40
	.DB  0x40,0x0,0x0,0x4,0x7E,0x4,0x0,0x0
	.DB  0x24,0x7E,0x24,0x0,0x14,0x3C,0x56,0x42
	.DB  0x24,0x26,0x16,0x68,0x64,0x62,0x7E,0x1
	.DB  0x7F,0x48,0x30,0x0,0x8,0x14,0x0,0x0
	.DB  0x7F,0x8,0x7F,0x48,0x30,0x7E,0x8,0x15
	.DB  0x22,0x40,0x2,0x7E,0xA,0xA,0x70,0x3F
	.DB  0x20,0x60,0x20,0x3F,0x2,0x1F,0x4A,0x4A
	.DB  0x30,0x0,0x1,0x2,0x0,0x0,0x0,0x2
	.DB  0x1,0x0,0x0,0x0,0x1,0x2,0x1,0x2
	.DB  0x0,0x2,0x1,0x2,0x1,0x4,0xE,0xE
	.DB  0x4,0x0,0x0,0x8,0x8,0x8,0x0,0x8
	.DB  0x8,0x8,0x8,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x2,0xE,0x2,0x4,0xE,0x78,0x4
	.DB  0x7C,0x50,0x20,0x0,0x14,0x8,0x0,0x0
	.DB  0x7C,0x10,0x7C,0x50,0x20,0x7C,0x10,0x2A
	.DB  0x40,0x0,0x7E,0x24,0x10,0x60,0x0,0x3C
	.DB  0x20,0x60,0x3C,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xE,0x50,0x51,0x50,0x3E,0xE,0x50
	.DB  0x51,0x3E,0x0,0x20,0x40,0x40,0x3E,0x0
	.DB  0x0,0x14,0x8,0x14,0x0,0x7E,0x2,0x2
	.DB  0x3,0x0,0x0,0x0,0x77,0x0,0x0,0x20
	.DB  0x4A,0x55,0x29,0x2,0x7E,0x4B,0x4A,0x43
	.DB  0x42,0x3C,0x5A,0x66,0x42,0x3C,0x3E,0x49
	.DB  0x49,0x41,0x22,0x8,0x14,0x0,0x8,0x14
	.DB  0x4,0x4,0x4,0xC,0x0,0x0,0x8,0x8
	.DB  0x8,0x0,0x3E,0x7D,0x55,0x69,0x3E,0x0
	.DB  0x2,0x7C,0x2,0x0,0x0,0x2,0x5,0x2
	.DB  0x0,0x0,0x24,0x2E,0x24,0x0,0x0,0x0
	.DB  0x7C,0x0,0x0,0x0,0x0,0x74,0x0,0x0
	.DB  0x0,0x78,0x8,0xC,0x0,0x7E,0x20,0x20
	.DB  0x1E,0x20,0xE,0x7E,0x2,0x7E,0x0,0x0
	.DB  0x0,0x2,0x0,0x0,0x3D,0x4A,0x4A,0x2D
	.DB  0x0,0x7E,0x4,0x8,0x7E,0x28,0x38,0x54
	.DB  0x44,0x0,0x0,0x14,0x8,0x0,0x14,0x8
	.DB  0x40,0x40,0x3A,0x0,0x0,0x22,0x45,0x49
	.DB  0x51,0x22,0x24,0x4A,0x52,0x24,0x0,0x0
	.DB  0x4,0x78,0x4,0x0,0x7C,0x12,0x11,0x12
	.DB  0x7C,0x7F,0x49,0x49,0x49,0x31,0x7F,0x49
	.DB  0x49,0x49,0x36,0x7F,0x1,0x1,0x1,0x1
	.DB  0x40,0x7E,0x41,0x41,0x7F,0x7F,0x49,0x49
	.DB  0x41,0x41,0x77,0x8,0x7F,0x8,0x77,0x22
	.DB  0x41,0x49,0x49,0x36,0x7F,0x10,0x8,0x4
	.DB  0x7F,0x7E,0x10,0x9,0x4,0x7E,0x7F,0x8
	.DB  0x14,0x22,0x41,0x40,0x3E,0x1,0x1,0x7F
	.DB  0x7F,0x2,0x4,0x2,0x7F,0x7F,0x8,0x8
	.DB  0x8,0x7F,0x3E,0x41,0x41,0x41,0x3E,0x7F
	.DB  0x1,0x1,0x1,0x7F,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x41,0x41,0x22,0x1,0x1
	.DB  0x7F,0x1,0x1,0x27,0x48,0x48,0x48,0x3F
	.DB  0xE,0x11,0x7F,0x11,0xE,0x63,0x14,0x8
	.DB  0x14,0x63,0x3F,0x20,0x20,0x20,0x7F,0xF
	.DB  0x10,0x10,0x10,0x7F,0x7F,0x40,0x7C,0x40
	.DB  0x7F,0x3F,0x20,0x3C,0x20,0x7F,0x1,0x7F
	.DB  0x48,0x48,0x30,0x7F,0x48,0x30,0x0,0x7F
	.DB  0x7F,0x48,0x48,0x48,0x30,0x22,0x41,0x49
	.DB  0x49,0x3E,0x7F,0x8,0x3E,0x41,0x3E,0x46
	.DB  0x29,0x19,0x9,0x7F,0x30,0x4A,0x4A,0x3C
	.DB  0x40,0x3C,0x4A,0x4A,0x30,0x0,0x7E,0x4A
	.DB  0x4A,0x34,0x0,0x7E,0x2,0x2,0x2,0x0
	.DB  0x40,0x7C,0x42,0x7E,0x40,0x3C,0x52,0x52
	.DB  0xC,0x0,0x76,0x8,0x7E,0x8,0x76,0x24
	.DB  0x42,0x4A,0x34,0x0,0x7E,0x10,0x8,0x7E
	.DB  0x0,0x7C,0x10,0xA,0x7C,0x0,0x7E,0x8
	.DB  0x14,0x62,0x0,0x7C,0x2,0x2,0x7E,0x0
	.DB  0x7E,0x4,0x8,0x4,0x7E,0x7E,0x8,0x8
	.DB  0x7E,0x0,0x3C,0x42,0x42,0x3C,0x0,0x7E
	.DB  0x2,0x2,0x7E,0x0,0x7E,0x12,0x12,0xC
	.DB  0x0,0x3C,0x42,0x42,0x24,0x0,0x2,0x2
	.DB  0x7E,0x2,0x2,0xE,0x50,0x50,0x3E,0x0
	.DB  0x1C,0x22,0x7E,0x22,0x1C,0x62,0x14,0x8
	.DB  0x14,0x62,0x3E,0x20,0x20,0x3E,0x60,0xE
	.DB  0x10,0x10,0x7E,0x0,0x7E,0x40,0x78,0x40
	.DB  0x7E,0x3E,0x20,0x38,0x20,0x7E,0x2,0x7E
	.DB  0x48,0x48,0x30,0x7E,0x48,0x30,0x0,0x7E
	.DB  0x7E,0x48,0x48,0x30,0x0,0x24,0x42,0x4A
	.DB  0x3C,0x0,0x7E,0x8,0x3C,0x42,0x3C,0x4C
	.DB  0x32,0x12,0x7E,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x20000:
	.DB  0xCF,0xF0,0xEE,0xE2,0xE5,0xF0,0xEA,0xE0
	.DB  0x20,0x55,0x53,0x41,0x52,0x54,0x0,0xCF
	.DB  0xF0,0xE8,0xED,0xFF,0xF2,0xEE,0x3A,0x20
	.DB  0x0,0x48,0x65,0x6C,0x6C,0x6F,0x2C,0x20
	.DB  0x57,0x6F,0x72,0x6C,0x64,0x21,0xA,0x0
_0x20E0060:
	.DB  0x1
_0x20E0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0F
	.DW  _0x20020
	.DW  _0x20000*2+25

	.DW  0x01
	.DW  __seed_G107
	.DW  _0x20E0060*2

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
;/****************************************************************************
;Font created by the LCD Vision V1.05 font & image editor/converter
;(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Font name: font5x7ru
;Fixed font width: 5 pixels
;Font height: 7 pixels
;First character: 0x20
;Last character: 0xFF
;
;Exported font data size:
;1572 bytes for displays organized as horizontal rows of bytes
;1124 bytes for displays organized as rows of vertical bytes.
;****************************************************************************/
;
;flash unsigned char font5x7ru[]=
;{
;0x05, /* Fixed font width */
;0x07, /* Font height */
;0x20, /* First character */
;0xE0, /* Number of characters in font */
;
;#ifndef _GLCD_DATA_BYTEY_
;/* Font data for displays organized as
;   horizontal rows of bytes */
;
;/* Code: 0x20, ASCII Character: ' ' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x21, ASCII Character: '!' */
;0x04, 0x04, 0x04, 0x04, 0x04, 0x00, 0x04,
;
;/* Code: 0x22, ASCII Character: '"' */
;0x0A, 0x0A, 0x0A, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x23, ASCII Character: '#' */
;0x00, 0x14, 0x1F, 0x0A, 0x1F, 0x05, 0x00,
;
;/* Code: 0x24, ASCII Character: '$' */
;0x0E, 0x15, 0x06, 0x04, 0x0C, 0x15, 0x0E,
;
;/* Code: 0x25, ASCII Character: '%' */
;0x02, 0x15, 0x0A, 0x04, 0x0A, 0x15, 0x08,
;
;/* Code: 0x26, ASCII Character: '&' */
;0x0E, 0x09, 0x05, 0x02, 0x15, 0x09, 0x16,
;
;/* Code: 0x27, ASCII Character: ''' */
;0x04, 0x04, 0x04, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x28, ASCII Character: '(' */
;0x08, 0x04, 0x02, 0x02, 0x02, 0x04, 0x08,
;
;/* Code: 0x29, ASCII Character: ')' */
;0x02, 0x04, 0x08, 0x08, 0x08, 0x04, 0x02,
;
;/* Code: 0x2A, ASCII Character: '*' */
;0x00, 0x15, 0x0E, 0x0E, 0x15, 0x00, 0x00,
;
;/* Code: 0x2B, ASCII Character: '+' */
;0x00, 0x04, 0x04, 0x1F, 0x04, 0x04, 0x00,
;
;/* Code: 0x2C, ASCII Character: ',' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x02,
;
;/* Code: 0x2D, ASCII Character: '-' */
;0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00,
;
;/* Code: 0x2E, ASCII Character: '.' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04,
;
;/* Code: 0x2F, ASCII Character: '/' */
;0x00, 0x10, 0x08, 0x04, 0x02, 0x01, 0x00,
;
;/* Code: 0x30, ASCII Character: '0' */
;0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0x31, ASCII Character: '1' */
;0x0C, 0x0A, 0x08, 0x08, 0x08, 0x08, 0x1C,
;
;/* Code: 0x32, ASCII Character: '2' */
;0x0E, 0x11, 0x10, 0x08, 0x04, 0x12, 0x1F,
;
;/* Code: 0x33, ASCII Character: '3' */
;0x0E, 0x11, 0x10, 0x0C, 0x10, 0x11, 0x0E,
;
;/* Code: 0x34, ASCII Character: '4' */
;0x08, 0x0C, 0x0A, 0x09, 0x0F, 0x08, 0x1C,
;
;/* Code: 0x35, ASCII Character: '5' */
;0x1F, 0x01, 0x0F, 0x10, 0x10, 0x11, 0x0E,
;
;/* Code: 0x36, ASCII Character: '6' */
;0x0E, 0x11, 0x01, 0x0F, 0x11, 0x11, 0x0E,
;
;/* Code: 0x37, ASCII Character: '7' */
;0x1F, 0x10, 0x08, 0x04, 0x02, 0x01, 0x01,
;
;/* Code: 0x38, ASCII Character: '8' */
;0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E,
;
;/* Code: 0x39, ASCII Character: '9' */
;0x0E, 0x11, 0x11, 0x1E, 0x10, 0x11, 0x0E,
;
;/* Code: 0x3A, ASCII Character: ':' */
;0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00,
;
;/* Code: 0x3B, ASCII Character: ';' */
;0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x02,
;
;/* Code: 0x3C, ASCII Character: '<' */
;0x00, 0x08, 0x04, 0x02, 0x04, 0x08, 0x00,
;
;/* Code: 0x3D, ASCII Character: '=' */
;0x00, 0x00, 0x0E, 0x00, 0x0E, 0x00, 0x00,
;
;/* Code: 0x3E, ASCII Character: '>' */
;0x00, 0x02, 0x04, 0x08, 0x04, 0x02, 0x00,
;
;/* Code: 0x3F, ASCII Character: '?' */
;0x0C, 0x12, 0x08, 0x04, 0x04, 0x00, 0x04,
;
;/* Code: 0x40, ASCII Character: '@' */
;0x0E, 0x11, 0x15, 0x1B, 0x0D, 0x11, 0x0E,
;
;/* Code: 0x41, ASCII Character: 'A' */
;0x04, 0x0A, 0x11, 0x11, 0x1F, 0x11, 0x11,
;
;/* Code: 0x42, ASCII Character: 'B' */
;0x0F, 0x11, 0x11, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0x43, ASCII Character: 'C' */
;0x0E, 0x11, 0x01, 0x01, 0x01, 0x11, 0x0E,
;
;/* Code: 0x44, ASCII Character: 'D' */
;0x0F, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0F,
;
;/* Code: 0x45, ASCII Character: 'E' */
;0x1F, 0x01, 0x01, 0x0F, 0x01, 0x01, 0x1F,
;
;/* Code: 0x46, ASCII Character: 'F' */
;0x1F, 0x01, 0x01, 0x0F, 0x01, 0x01, 0x01,
;
;/* Code: 0x47, ASCII Character: 'G' */
;0x0E, 0x11, 0x01, 0x01, 0x19, 0x11, 0x0E,
;
;/* Code: 0x48, ASCII Character: 'H' */
;0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11,
;
;/* Code: 0x49, ASCII Character: 'I' */
;0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x4A, ASCII Character: 'J' */
;0x08, 0x08, 0x08, 0x08, 0x08, 0x09, 0x06,
;
;/* Code: 0x4B, ASCII Character: 'K' */
;0x11, 0x09, 0x05, 0x03, 0x05, 0x09, 0x11,
;
;/* Code: 0x4C, ASCII Character: 'L' */
;0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1F,
;
;/* Code: 0x4D, ASCII Character: 'M' */
;0x11, 0x1B, 0x15, 0x11, 0x11, 0x11, 0x11,
;
;/* Code: 0x4E, ASCII Character: 'N' */
;0x11, 0x13, 0x15, 0x19, 0x11, 0x11, 0x11,
;
;/* Code: 0x4F, ASCII Character: 'O' */
;0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0x50, ASCII Character: 'P' */
;0x0F, 0x11, 0x11, 0x0F, 0x01, 0x01, 0x01,
;
;/* Code: 0x51, ASCII Character: 'Q' */
;0x0E, 0x11, 0x11, 0x11, 0x11, 0x09, 0x16,
;
;/* Code: 0x52, ASCII Character: 'R' */
;0x0F, 0x11, 0x11, 0x0F, 0x05, 0x09, 0x11,
;
;/* Code: 0x53, ASCII Character: 'S' */
;0x0E, 0x11, 0x02, 0x04, 0x08, 0x11, 0x0E,
;
;/* Code: 0x54, ASCII Character: 'T' */
;0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x55, ASCII Character: 'U' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0x56, ASCII Character: 'V' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04,
;
;/* Code: 0x57, ASCII Character: 'W' */
;0x11, 0x11, 0x15, 0x15, 0x15, 0x15, 0x0A,
;
;/* Code: 0x58, ASCII Character: 'X' */
;0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11,
;
;/* Code: 0x59, ASCII Character: 'Y' */
;0x11, 0x11, 0x11, 0x0A, 0x04, 0x04, 0x04,
;
;/* Code: 0x5A, ASCII Character: 'Z' */
;0x1F, 0x10, 0x08, 0x04, 0x02, 0x01, 0x1F,
;
;/* Code: 0x5B, ASCII Character: '[' */
;0x0E, 0x02, 0x02, 0x02, 0x02, 0x02, 0x0E,
;
;/* Code: 0x5C, ASCII Character: '\' */
;0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x00,
;
;/* Code: 0x5D, ASCII Character: ']' */
;0x0E, 0x08, 0x08, 0x08, 0x08, 0x08, 0x0E,
;
;/* Code: 0x5E, ASCII Character: '^' */
;0x04, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5F, ASCII Character: '_' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E,
;
;/* Code: 0x60, ASCII Character: '`' */
;0x02, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x61, ASCII Character: 'a' */
;0x00, 0x00, 0x06, 0x08, 0x0E, 0x09, 0x16,
;
;/* Code: 0x62, ASCII Character: 'b' */
;0x00, 0x01, 0x01, 0x07, 0x09, 0x09, 0x07,
;
;/* Code: 0x63, ASCII Character: 'c' */
;0x00, 0x06, 0x09, 0x01, 0x01, 0x09, 0x06,
;
;/* Code: 0x64, ASCII Character: 'd' */
;0x00, 0x08, 0x08, 0x0E, 0x09, 0x09, 0x0E,
;
;/* Code: 0x65, ASCII Character: 'e' */
;0x00, 0x06, 0x09, 0x0F, 0x01, 0x09, 0x06,
;
;/* Code: 0x66, ASCII Character: 'f' */
;0x00, 0x08, 0x14, 0x04, 0x0E, 0x04, 0x04,
;
;/* Code: 0x67, ASCII Character: 'g' */
;0x00, 0x06, 0x09, 0x09, 0x0E, 0x08, 0x06,
;
;/* Code: 0x68, ASCII Character: 'h' */
;0x00, 0x01, 0x01, 0x05, 0x0B, 0x09, 0x09,
;
;/* Code: 0x69, ASCII Character: 'i' */
;0x00, 0x04, 0x00, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x6A, ASCII Character: 'j' */
;0x00, 0x04, 0x00, 0x04, 0x04, 0x04, 0x02,
;
;/* Code: 0x6B, ASCII Character: 'k' */
;0x00, 0x01, 0x09, 0x05, 0x03, 0x05, 0x09,
;
;/* Code: 0x6C, ASCII Character: 'l' */
;0x00, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x6D, ASCII Character: 'm' */
;0x00, 0x00, 0x0B, 0x15, 0x15, 0x15, 0x15,
;
;/* Code: 0x6E, ASCII Character: 'n' */
;0x00, 0x00, 0x05, 0x0B, 0x09, 0x09, 0x09,
;
;/* Code: 0x6F, ASCII Character: 'o' */
;0x00, 0x06, 0x09, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0x70, ASCII Character: 'p' */
;0x00, 0x07, 0x09, 0x09, 0x07, 0x01, 0x01,
;
;/* Code: 0x71, ASCII Character: 'q' */
;0x00, 0x1C, 0x12, 0x12, 0x1A, 0x14, 0x10,
;
;/* Code: 0x72, ASCII Character: 'r' */
;0x00, 0x05, 0x0B, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0x73, ASCII Character: 's' */
;0x00, 0x06, 0x09, 0x02, 0x04, 0x09, 0x06,
;
;/* Code: 0x74, ASCII Character: 't' */
;0x00, 0x04, 0x04, 0x0E, 0x04, 0x14, 0x08,
;
;/* Code: 0x75, ASCII Character: 'u' */
;0x00, 0x09, 0x09, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0x76, ASCII Character: 'v' */
;0x00, 0x09, 0x09, 0x09, 0x09, 0x06, 0x06,
;
;/* Code: 0x77, ASCII Character: 'w' */
;0x00, 0x11, 0x11, 0x15, 0x15, 0x15, 0x0A,
;
;/* Code: 0x78, ASCII Character: 'x' */
;0x00, 0x00, 0x11, 0x0A, 0x04, 0x0A, 0x11,
;
;/* Code: 0x79, ASCII Character: 'y' */
;0x00, 0x09, 0x09, 0x0A, 0x04, 0x02, 0x01,
;
;/* Code: 0x7A, ASCII Character: 'z' */
;0x00, 0x0F, 0x08, 0x04, 0x02, 0x01, 0x0F,
;
;/* Code: 0x7B, ASCII Character: '{' */
;0x04, 0x02, 0x02, 0x01, 0x02, 0x02, 0x04,
;
;/* Code: 0x7C, ASCII Character: '|' */
;0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x7D, ASCII Character: '}' */
;0x04, 0x08, 0x08, 0x10, 0x08, 0x08, 0x04,
;
;/* Code: 0x7E, ASCII Character: '~' */
;0x0A, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7F, ASCII Character: '' */
;0x00, 0x0E, 0x0A, 0x0A, 0x0A, 0x0E, 0x00,
;
;/* Code: 0x80, ASCII Character: 'Ä' */
;0x00, 0x0E, 0x04, 0x0C, 0x14, 0x1C, 0x04,
;
;/* Code: 0x81, ASCII Character: 'Å' */
;0x08, 0x1E, 0x02, 0x02, 0x02, 0x02, 0x02,
;
;/* Code: 0x82, ASCII Character: 'Ç' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x02,
;
;/* Code: 0x83, ASCII Character: 'É' */
;0x00, 0x00, 0x04, 0x0E, 0x02, 0x02, 0x02,
;
;/* Code: 0x84, ASCII Character: 'Ñ' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x05,
;
;/* Code: 0x85, ASCII Character: 'Ö' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E,
;
;/* Code: 0x86, ASCII Character: 'Ü' */
;0x00, 0x04, 0x0E, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x87, ASCII Character: 'á' */
;0x00, 0x04, 0x0E, 0x04, 0x04, 0x0E, 0x04,
;
;/* Code: 0x88, ASCII Character: 'à' */
;0x00, 0x0C, 0x17, 0x02, 0x07, 0x12, 0x0C,
;
;/* Code: 0x89, ASCII Character: 'â' */
;0x00, 0x13, 0x0B, 0x04, 0x02, 0x1D, 0x1C,
;
;/* Code: 0x8A, ASCII Character: 'ä' */
;0x06, 0x05, 0x05, 0x0D, 0x15, 0x15, 0x0D,
;
;/* Code: 0x8B, ASCII Character: 'ã' */
;0x00, 0x00, 0x04, 0x02, 0x04, 0x00, 0x00,
;
;/* Code: 0x8C, ASCII Character: 'å' */
;0x05, 0x05, 0x05, 0x0F, 0x15, 0x15, 0x0D,
;
;/* Code: 0x8D, ASCII Character: 'ç' */
;0x04, 0x09, 0x05, 0x03, 0x05, 0x09, 0x11,
;
;/* Code: 0x8E, ASCII Character: 'é' */
;0x00, 0x0F, 0x02, 0x0E, 0x12, 0x12, 0x12,
;
;/* Code: 0x8F, ASCII Character: 'è' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x1F, 0x04,
;
;/* Code: 0x90, ASCII Character: 'ê' */
;0x02, 0x0F, 0x02, 0x0E, 0x12, 0x10, 0x0C,
;
;/* Code: 0x91, ASCII Character: 'ë' */
;0x02, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x92, ASCII Character: 'í' */
;0x04, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x93, ASCII Character: 'ì' */
;0x0A, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x94, ASCII Character: 'î' */
;0x14, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x95, ASCII Character: 'ï' */
;0x00, 0x06, 0x0F, 0x06, 0x00, 0x00, 0x00,
;
;/* Code: 0x96, ASCII Character: 'ñ' */
;0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00,
;
;/* Code: 0x97, ASCII Character: 'ó' */
;0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00,
;
;/* Code: 0x98, ASCII Character: 'ò' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x99, ASCII Character: 'ô' */
;0x00, 0x17, 0x1A, 0x12, 0x00, 0x00, 0x00,
;
;/* Code: 0x9A, ASCII Character: 'ö' */
;0x00, 0x00, 0x06, 0x05, 0x0D, 0x15, 0x0D,
;
;/* Code: 0x9B, ASCII Character: 'õ' */
;0x00, 0x00, 0x02, 0x04, 0x02, 0x00, 0x00,
;
;/* Code: 0x9C, ASCII Character: 'ú' */
;0x00, 0x00, 0x05, 0x05, 0x0F, 0x15, 0x0D,
;
;/* Code: 0x9D, ASCII Character: 'ù' */
;0x00, 0x04, 0x01, 0x05, 0x03, 0x05, 0x09,
;
;/* Code: 0x9E, ASCII Character: 'û' */
;0x00, 0x01, 0x03, 0x01, 0x05, 0x0B, 0x09,
;
;/* Code: 0x9F, ASCII Character: 'ü' */
;0x00, 0x00, 0x09, 0x09, 0x09, 0x0F, 0x04,
;
;/* Code: 0xA0, ASCII Character: '†' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xA1, ASCII Character: '°' */
;0x04, 0x11, 0x11, 0x11, 0x1E, 0x10, 0x0E,
;
;/* Code: 0xA2, ASCII Character: '¢' */
;0x04, 0x09, 0x09, 0x09, 0x0E, 0x08, 0x06,
;
;/* Code: 0xA3, ASCII Character: '£' */
;0x00, 0x08, 0x08, 0x08, 0x08, 0x09, 0x06,
;
;/* Code: 0xA4, ASCII Character: '§' */
;0x00, 0x00, 0x0A, 0x04, 0x0A, 0x00, 0x00,
;
;/* Code: 0xA5, ASCII Character: '•' */
;0x08, 0x0F, 0x01, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xA6, ASCII Character: '¶' */
;0x04, 0x04, 0x04, 0x00, 0x04, 0x04, 0x04,
;
;/* Code: 0xA7, ASCII Character: 'ß' */
;0x0C, 0x12, 0x04, 0x0A, 0x04, 0x09, 0x06,
;
;/* Code: 0xA8, ASCII Character: '®' */
;0x0A, 0x1F, 0x01, 0x07, 0x01, 0x01, 0x1F,
;
;/* Code: 0xA9, ASCII Character: '©' */
;0x00, 0x0E, 0x15, 0x13, 0x13, 0x15, 0x0E,
;
;/* Code: 0xAA, ASCII Character: '™' */
;0x0E, 0x11, 0x01, 0x07, 0x01, 0x11, 0x0E,
;
;/* Code: 0xAB, ASCII Character: '´' */
;0x00, 0x00, 0x12, 0x09, 0x12, 0x00, 0x00,
;
;/* Code: 0xAC, ASCII Character: '¨' */
;0x00, 0x00, 0x0F, 0x08, 0x00, 0x00, 0x00,
;
;/* Code: 0xAD, ASCII Character: '≠' */
;0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00,
;
;/* Code: 0xAE, ASCII Character: 'Æ' */
;0x0E, 0x11, 0x17, 0x1B, 0x17, 0x1B, 0x0E,
;
;/* Code: 0xAF, ASCII Character: 'Ø' */
;0x00, 0x0A, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xB0, ASCII Character: '∞' */
;0x04, 0x0A, 0x04, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xB1, ASCII Character: '±' */
;0x00, 0x04, 0x0E, 0x04, 0x00, 0x0E, 0x00,
;
;/* Code: 0xB2, ASCII Character: '≤' */
;0x00, 0x00, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xB3, ASCII Character: '≥' */
;0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x04,
;
;/* Code: 0xB4, ASCII Character: '¥' */
;0x00, 0x00, 0x08, 0x0E, 0x02, 0x02, 0x02,
;
;/* Code: 0xB5, ASCII Character: 'µ' */
;0x00, 0x09, 0x09, 0x09, 0x09, 0x17, 0x01,
;
;/* Code: 0xB6, ASCII Character: '∂' */
;0x00, 0x0F, 0x0B, 0x0B, 0x0A, 0x0A, 0x0A,
;
;/* Code: 0xB7, ASCII Character: '∑' */
;0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xB8, ASCII Character: '∏' */
;0x09, 0x06, 0x09, 0x0F, 0x01, 0x09, 0x06,
;
;/* Code: 0xB9, ASCII Character: 'π' */
;0x00, 0x09, 0x0B, 0x1D, 0x09, 0x19, 0x09,
;
;/* Code: 0xBA, ASCII Character: '∫' */
;0x00, 0x00, 0x06, 0x01, 0x03, 0x01, 0x06,
;
;/* Code: 0xBB, ASCII Character: 'ª' */
;0x00, 0x00, 0x09, 0x12, 0x09, 0x00, 0x00,
;
;/* Code: 0xBC, ASCII Character: 'º' */
;0x00, 0x04, 0x00, 0x04, 0x04, 0x04, 0x03,
;
;/* Code: 0xBD, ASCII Character: 'Ω' */
;0x0E, 0x11, 0x02, 0x04, 0x08, 0x11, 0x0E,
;
;/* Code: 0xBE, ASCII Character: 'æ' */
;0x00, 0x06, 0x09, 0x02, 0x04, 0x09, 0x06,
;
;/* Code: 0xBF, ASCII Character: 'ø' */
;0x00, 0x00, 0x0A, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xC0, ASCII Character: '¿' */
;0x04, 0x0A, 0x11, 0x11, 0x1F, 0x11, 0x11,
;
;/* Code: 0xC1, ASCII Character: '¡' */
;0x1F, 0x01, 0x01, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0xC2, ASCII Character: '¬' */
;0x0F, 0x11, 0x11, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0xC3, ASCII Character: '√' */
;0x1F, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xC4, ASCII Character: 'ƒ' */
;0x1C, 0x12, 0x12, 0x12, 0x12, 0x12, 0x1F,
;
;/* Code: 0xC5, ASCII Character: '≈' */
;0x1F, 0x01, 0x01, 0x07, 0x01, 0x01, 0x1F,
;
;/* Code: 0xC6, ASCII Character: '∆' */
;0x15, 0x15, 0x15, 0x0E, 0x15, 0x15, 0x15,
;
;/* Code: 0xC7, ASCII Character: '«' */
;0x0E, 0x11, 0x10, 0x0C, 0x10, 0x11, 0x0E,
;
;/* Code: 0xC8, ASCII Character: '»' */
;0x11, 0x11, 0x19, 0x15, 0x13, 0x11, 0x11,
;
;/* Code: 0xC9, ASCII Character: '…' */
;0x04, 0x11, 0x19, 0x15, 0x13, 0x11, 0x11,
;
;/* Code: 0xCA, ASCII Character: ' ' */
;0x11, 0x09, 0x05, 0x03, 0x05, 0x09, 0x11,
;
;/* Code: 0xCB, ASCII Character: 'À' */
;0x1C, 0x12, 0x12, 0x12, 0x12, 0x12, 0x11,
;
;/* Code: 0xCC, ASCII Character: 'Ã' */
;0x11, 0x1B, 0x15, 0x11, 0x11, 0x11, 0x11,
;
;/* Code: 0xCD, ASCII Character: 'Õ' */
;0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11,
;
;/* Code: 0xCE, ASCII Character: 'Œ' */
;0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0xCF, ASCII Character: 'œ' */
;0x1F, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11,
;
;/* Code: 0xD0, ASCII Character: '–' */
;0x0F, 0x11, 0x11, 0x0F, 0x01, 0x01, 0x01,
;
;/* Code: 0xD1, ASCII Character: '—' */
;0x0E, 0x11, 0x01, 0x01, 0x01, 0x11, 0x0E,
;
;/* Code: 0xD2, ASCII Character: '“' */
;0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xD3, ASCII Character: '”' */
;0x11, 0x11, 0x11, 0x1E, 0x10, 0x11, 0x0E,
;
;/* Code: 0xD4, ASCII Character: '‘' */
;0x0E, 0x15, 0x15, 0x15, 0x0E, 0x04, 0x04,
;
;/* Code: 0xD5, ASCII Character: '’' */
;0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11,
;
;/* Code: 0xD6, ASCII Character: '÷' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x1F, 0x10,
;
;/* Code: 0xD7, ASCII Character: '◊' */
;0x11, 0x11, 0x11, 0x11, 0x1E, 0x10, 0x10,
;
;/* Code: 0xD8, ASCII Character: 'ÿ' */
;0x11, 0x11, 0x15, 0x15, 0x15, 0x15, 0x1F,
;
;/* Code: 0xD9, ASCII Character: 'Ÿ' */
;0x11, 0x11, 0x15, 0x15, 0x15, 0x1F, 0x10,
;
;/* Code: 0xDA, ASCII Character: '⁄' */
;0x03, 0x02, 0x02, 0x0E, 0x12, 0x12, 0x0E,
;
;/* Code: 0xDB, ASCII Character: '€' */
;0x11, 0x11, 0x11, 0x13, 0x15, 0x15, 0x13,
;
;/* Code: 0xDC, ASCII Character: '‹' */
;0x01, 0x01, 0x01, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0xDD, ASCII Character: '›' */
;0x0E, 0x11, 0x10, 0x1C, 0x10, 0x11, 0x0E,
;
;/* Code: 0xDE, ASCII Character: 'ﬁ' */
;0x09, 0x15, 0x15, 0x17, 0x15, 0x15, 0x09,
;
;/* Code: 0xDF, ASCII Character: 'ﬂ' */
;0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11,
;
;/* Code: 0xE0, ASCII Character: '‡' */
;0x00, 0x06, 0x08, 0x0E, 0x09, 0x09, 0x16,
;
;/* Code: 0xE1, ASCII Character: '·' */
;0x00, 0x06, 0x01, 0x07, 0x09, 0x09, 0x06,
;
;/* Code: 0xE2, ASCII Character: '‚' */
;0x00, 0x07, 0x09, 0x07, 0x09, 0x09, 0x07,
;
;/* Code: 0xE3, ASCII Character: '„' */
;0x00, 0x0F, 0x01, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xE4, ASCII Character: '‰' */
;0x00, 0x0C, 0x0A, 0x0A, 0x0A, 0x0A, 0x1F,
;
;/* Code: 0xE5, ASCII Character: 'Â' */
;0x00, 0x06, 0x09, 0x09, 0x07, 0x01, 0x06,
;
;/* Code: 0xE6, ASCII Character: 'Ê' */
;0x00, 0x15, 0x15, 0x0E, 0x15, 0x15, 0x15,
;
;/* Code: 0xE7, ASCII Character: 'Á' */
;0x00, 0x06, 0x09, 0x04, 0x08, 0x09, 0x06,
;
;/* Code: 0xE8, ASCII Character: 'Ë' */
;0x00, 0x09, 0x09, 0x0D, 0x0B, 0x09, 0x09,
;
;/* Code: 0xE9, ASCII Character: 'È' */
;0x00, 0x04, 0x09, 0x0D, 0x0B, 0x09, 0x09,
;
;/* Code: 0xEA, ASCII Character: 'Í' */
;0x00, 0x09, 0x05, 0x03, 0x05, 0x09, 0x09,
;
;/* Code: 0xEB, ASCII Character: 'Î' */
;0x00, 0x0E, 0x09, 0x09, 0x09, 0x09, 0x09,
;
;/* Code: 0xEC, ASCII Character: 'Ï' */
;0x00, 0x11, 0x1B, 0x15, 0x11, 0x11, 0x11,
;
;/* Code: 0xED, ASCII Character: 'Ì' */
;0x00, 0x09, 0x09, 0x0F, 0x09, 0x09, 0x09,
;
;/* Code: 0xEE, ASCII Character: 'Ó' */
;0x00, 0x06, 0x09, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0xEF, ASCII Character: 'Ô' */
;0x00, 0x0F, 0x09, 0x09, 0x09, 0x09, 0x09,
;
;/* Code: 0xF0, ASCII Character: '' */
;0x00, 0x07, 0x09, 0x09, 0x07, 0x01, 0x01,
;
;/* Code: 0xF1, ASCII Character: 'Ò' */
;0x00, 0x06, 0x09, 0x01, 0x01, 0x09, 0x06,
;
;/* Code: 0xF2, ASCII Character: 'Ú' */
;0x00, 0x1F, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xF3, ASCII Character: 'Û' */
;0x00, 0x09, 0x09, 0x09, 0x0E, 0x08, 0x06,
;
;/* Code: 0xF4, ASCII Character: 'Ù' */
;0x00, 0x0E, 0x15, 0x15, 0x15, 0x0E, 0x04,
;
;/* Code: 0xF5, ASCII Character: 'ı' */
;0x00, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11,
;
;/* Code: 0xF6, ASCII Character: 'ˆ' */
;0x00, 0x09, 0x09, 0x09, 0x09, 0x1F, 0x10,
;
;/* Code: 0xF7, ASCII Character: '˜' */
;0x00, 0x09, 0x09, 0x09, 0x0E, 0x08, 0x08,
;
;/* Code: 0xF8, ASCII Character: '¯' */
;0x00, 0x11, 0x11, 0x15, 0x15, 0x15, 0x1F,
;
;/* Code: 0xF9, ASCII Character: '˘' */
;0x00, 0x11, 0x11, 0x15, 0x15, 0x1F, 0x10,
;
;/* Code: 0xFA, ASCII Character: '˙' */
;0x00, 0x03, 0x02, 0x0E, 0x12, 0x12, 0x0E,
;
;/* Code: 0xFB, ASCII Character: '˚' */
;0x00, 0x11, 0x11, 0x13, 0x15, 0x15, 0x13,
;
;/* Code: 0xFC, ASCII Character: '¸' */
;0x00, 0x01, 0x01, 0x07, 0x09, 0x09, 0x07,
;
;/* Code: 0xFD, ASCII Character: '˝' */
;0x00, 0x06, 0x09, 0x0C, 0x08, 0x09, 0x06,
;
;/* Code: 0xFE, ASCII Character: '˛' */
;0x00, 0x09, 0x15, 0x17, 0x15, 0x15, 0x09,
;
;/* Code: 0xFF, ASCII Character: 'ˇ' */
;0x00, 0x0E, 0x09, 0x09, 0x0E, 0x0A, 0x09,
;
;#else
;/* Font data for displays organized as
;   rows of vertical bytes */
;
;/* Code: 0x20, ASCII Character: ' ' */
;0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x21, ASCII Character: '!' */
;0x00, 0x00, 0x5F, 0x00, 0x00,
;
;/* Code: 0x22, ASCII Character: '"' */
;0x00, 0x07, 0x00, 0x07, 0x00,
;
;/* Code: 0x23, ASCII Character: '#' */
;0x34, 0x1C, 0x36, 0x1C, 0x16,
;
;/* Code: 0x24, ASCII Character: '$' */
;0x22, 0x45, 0x7F, 0x51, 0x22,
;
;/* Code: 0x25, ASCII Character: '%' */
;0x22, 0x15, 0x2A, 0x54, 0x22,
;
;/* Code: 0x26, ASCII Character: '&' */
;0x36, 0x49, 0x55, 0x23, 0x50,
;
;/* Code: 0x27, ASCII Character: ''' */
;0x00, 0x00, 0x07, 0x00, 0x00,
;
;/* Code: 0x28, ASCII Character: '(' */
;0x00, 0x1C, 0x22, 0x41, 0x00,
;
;/* Code: 0x29, ASCII Character: ')' */
;0x00, 0x41, 0x22, 0x1C, 0x00,
;
;/* Code: 0x2A, ASCII Character: '*' */
;0x12, 0x0C, 0x1E, 0x0C, 0x12,
;
;/* Code: 0x2B, ASCII Character: '+' */
;0x08, 0x08, 0x3E, 0x08, 0x08,
;
;/* Code: 0x2C, ASCII Character: ',' */
;0x00, 0x40, 0x20, 0x00, 0x00,
;
;/* Code: 0x2D, ASCII Character: '-' */
;0x00, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0x2E, ASCII Character: '.' */
;0x00, 0x00, 0x40, 0x00, 0x00,
;
;/* Code: 0x2F, ASCII Character: '/' */
;0x20, 0x10, 0x08, 0x04, 0x02,
;
;/* Code: 0x30, ASCII Character: '0' */
;0x3E, 0x41, 0x41, 0x41, 0x3E,
;
;/* Code: 0x31, ASCII Character: '1' */
;0x00, 0x02, 0x41, 0x7F, 0x40,
;
;/* Code: 0x32, ASCII Character: '2' */
;0x42, 0x61, 0x51, 0x49, 0x66,
;
;/* Code: 0x33, ASCII Character: '3' */
;0x22, 0x41, 0x49, 0x49, 0x36,
;
;/* Code: 0x34, ASCII Character: '4' */
;0x18, 0x14, 0x52, 0x7F, 0x40,
;
;/* Code: 0x35, ASCII Character: '5' */
;0x27, 0x45, 0x45, 0x45, 0x39,
;
;/* Code: 0x36, ASCII Character: '6' */
;0x3E, 0x49, 0x49, 0x49, 0x32,
;
;/* Code: 0x37, ASCII Character: '7' */
;0x61, 0x11, 0x09, 0x05, 0x03,
;
;/* Code: 0x38, ASCII Character: '8' */
;0x36, 0x49, 0x49, 0x49, 0x36,
;
;/* Code: 0x39, ASCII Character: '9' */
;0x26, 0x49, 0x49, 0x49, 0x3E,
;
;/* Code: 0x3A, ASCII Character: ':' */
;0x00, 0x00, 0x22, 0x00, 0x00,
;
;/* Code: 0x3B, ASCII Character: ';' */
;0x00, 0x40, 0x22, 0x00, 0x00,
;
;/* Code: 0x3C, ASCII Character: '<' */
;0x00, 0x08, 0x14, 0x22, 0x00,
;
;/* Code: 0x3D, ASCII Character: '=' */
;0x00, 0x14, 0x14, 0x14, 0x00,
;
;/* Code: 0x3E, ASCII Character: '>' */
;0x00, 0x22, 0x14, 0x08, 0x00,
;
;/* Code: 0x3F, ASCII Character: '?' */
;0x00, 0x02, 0x59, 0x05, 0x02,
;
;/* Code: 0x40, ASCII Character: '@' */
;0x3E, 0x49, 0x55, 0x59, 0x2E,
;
;/* Code: 0x41, ASCII Character: 'A' */
;0x7C, 0x12, 0x11, 0x12, 0x7C,
;
;/* Code: 0x42, ASCII Character: 'B' */
;0x7F, 0x49, 0x49, 0x49, 0x36,
;
;/* Code: 0x43, ASCII Character: 'C' */
;0x3E, 0x41, 0x41, 0x41, 0x22,
;
;/* Code: 0x44, ASCII Character: 'D' */
;0x7F, 0x41, 0x41, 0x41, 0x3E,
;
;/* Code: 0x45, ASCII Character: 'E' */
;0x7F, 0x49, 0x49, 0x49, 0x41,
;
;/* Code: 0x46, ASCII Character: 'F' */
;0x7F, 0x09, 0x09, 0x09, 0x01,
;
;/* Code: 0x47, ASCII Character: 'G' */
;0x3E, 0x41, 0x41, 0x51, 0x32,
;
;/* Code: 0x48, ASCII Character: 'H' */
;0x7F, 0x08, 0x08, 0x08, 0x7F,
;
;/* Code: 0x49, ASCII Character: 'I' */
;0x00, 0x00, 0x7F, 0x00, 0x00,
;
;/* Code: 0x4A, ASCII Character: 'J' */
;0x20, 0x40, 0x40, 0x3F, 0x00,
;
;/* Code: 0x4B, ASCII Character: 'K' */
;0x7F, 0x08, 0x14, 0x22, 0x41,
;
;/* Code: 0x4C, ASCII Character: 'L' */
;0x7F, 0x40, 0x40, 0x40, 0x40,
;
;/* Code: 0x4D, ASCII Character: 'M' */
;0x7F, 0x02, 0x04, 0x02, 0x7F,
;
;/* Code: 0x4E, ASCII Character: 'N' */
;0x7F, 0x02, 0x04, 0x08, 0x7F,
;
;/* Code: 0x4F, ASCII Character: 'O' */
;0x3E, 0x41, 0x41, 0x41, 0x3E,
;
;/* Code: 0x50, ASCII Character: 'P' */
;0x7F, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0x51, ASCII Character: 'Q' */
;0x3E, 0x41, 0x41, 0x21, 0x5E,
;
;/* Code: 0x52, ASCII Character: 'R' */
;0x7F, 0x09, 0x19, 0x29, 0x46,
;
;/* Code: 0x53, ASCII Character: 'S' */
;0x22, 0x45, 0x49, 0x51, 0x22,
;
;/* Code: 0x54, ASCII Character: 'T' */
;0x01, 0x01, 0x7F, 0x01, 0x01,
;
;/* Code: 0x55, ASCII Character: 'U' */
;0x3F, 0x40, 0x40, 0x40, 0x3F,
;
;/* Code: 0x56, ASCII Character: 'V' */
;0x1F, 0x20, 0x40, 0x20, 0x1F,
;
;/* Code: 0x57, ASCII Character: 'W' */
;0x3F, 0x40, 0x3C, 0x40, 0x3F,
;
;/* Code: 0x58, ASCII Character: 'X' */
;0x63, 0x14, 0x08, 0x14, 0x63,
;
;/* Code: 0x59, ASCII Character: 'Y' */
;0x07, 0x08, 0x70, 0x08, 0x07,
;
;/* Code: 0x5A, ASCII Character: 'Z' */
;0x61, 0x51, 0x49, 0x45, 0x43,
;
;/* Code: 0x5B, ASCII Character: '[' */
;0x00, 0x7F, 0x41, 0x41, 0x00,
;
;/* Code: 0x5C, ASCII Character: '\' */
;0x02, 0x04, 0x08, 0x10, 0x20,
;
;/* Code: 0x5D, ASCII Character: ']' */
;0x00, 0x41, 0x41, 0x7F, 0x00,
;
;/* Code: 0x5E, ASCII Character: '^' */
;0x00, 0x02, 0x01, 0x02, 0x00,
;
;/* Code: 0x5F, ASCII Character: '_' */
;0x00, 0x40, 0x40, 0x40, 0x00,
;
;/* Code: 0x60, ASCII Character: '`' */
;0x00, 0x01, 0x02, 0x00, 0x00,
;
;/* Code: 0x61, ASCII Character: 'a' */
;0x20, 0x54, 0x54, 0x38, 0x40,
;
;/* Code: 0x62, ASCII Character: 'b' */
;0x7E, 0x48, 0x48, 0x30, 0x00,
;
;/* Code: 0x63, ASCII Character: 'c' */
;0x3C, 0x42, 0x42, 0x24, 0x00,
;
;/* Code: 0x64, ASCII Character: 'd' */
;0x30, 0x48, 0x48, 0x7E, 0x00,
;
;/* Code: 0x65, ASCII Character: 'e' */
;0x3C, 0x4A, 0x4A, 0x2C, 0x00,
;
;/* Code: 0x66, ASCII Character: 'f' */
;0x00, 0x10, 0x7C, 0x12, 0x04,
;
;/* Code: 0x67, ASCII Character: 'g' */
;0x0C, 0x52, 0x52, 0x3C, 0x00,
;
;/* Code: 0x68, ASCII Character: 'h' */
;0x7E, 0x10, 0x08, 0x70, 0x00,
;
;/* Code: 0x69, ASCII Character: 'i' */
;0x00, 0x00, 0x7A, 0x00, 0x00,
;
;/* Code: 0x6A, ASCII Character: 'j' */
;0x00, 0x40, 0x3A, 0x00, 0x00,
;
;/* Code: 0x6B, ASCII Character: 'k' */
;0x7E, 0x10, 0x28, 0x44, 0x00,
;
;/* Code: 0x6C, ASCII Character: 'l' */
;0x00, 0x00, 0x7E, 0x00, 0x00,
;
;/* Code: 0x6D, ASCII Character: 'm' */
;0x7C, 0x04, 0x78, 0x04, 0x78,
;
;/* Code: 0x6E, ASCII Character: 'n' */
;0x7C, 0x08, 0x04, 0x78, 0x00,
;
;/* Code: 0x6F, ASCII Character: 'o' */
;0x3C, 0x42, 0x42, 0x3C, 0x00,
;
;/* Code: 0x70, ASCII Character: 'p' */
;0x7E, 0x12, 0x12, 0x0C, 0x00,
;
;/* Code: 0x71, ASCII Character: 'q' */
;0x00, 0x1C, 0x22, 0x12, 0x7E,
;
;/* Code: 0x72, ASCII Character: 'r' */
;0x7E, 0x04, 0x02, 0x04, 0x00,
;
;/* Code: 0x73, ASCII Character: 's' */
;0x24, 0x4A, 0x52, 0x24, 0x00,
;
;/* Code: 0x74, ASCII Character: 't' */
;0x00, 0x08, 0x3E, 0x48, 0x20,
;
;/* Code: 0x75, ASCII Character: 'u' */
;0x3E, 0x40, 0x40, 0x3E, 0x00,
;
;/* Code: 0x76, ASCII Character: 'v' */
;0x1E, 0x60, 0x60, 0x1E, 0x00,
;
;/* Code: 0x77, ASCII Character: 'w' */
;0x3E, 0x40, 0x38, 0x40, 0x3E,
;
;/* Code: 0x78, ASCII Character: 'x' */
;0x44, 0x28, 0x10, 0x28, 0x44,
;
;/* Code: 0x79, ASCII Character: 'y' */
;0x46, 0x28, 0x10, 0x0E, 0x00,
;
;/* Code: 0x7A, ASCII Character: 'z' */
;0x62, 0x52, 0x4A, 0x46, 0x00,
;
;/* Code: 0x7B, ASCII Character: '{' */
;0x08, 0x36, 0x41, 0x00, 0x00,
;
;/* Code: 0x7C, ASCII Character: '|' */
;0x00, 0x00, 0x7F, 0x00, 0x00,
;
;/* Code: 0x7D, ASCII Character: '}' */
;0x00, 0x00, 0x41, 0x36, 0x08,
;
;/* Code: 0x7E, ASCII Character: '~' */
;0x02, 0x01, 0x02, 0x01, 0x00,
;
;/* Code: 0x7F, ASCII Character: '' */
;0x00, 0x3E, 0x22, 0x3E, 0x00,
;
;/* Code: 0x80, ASCII Character: 'Ä' */
;0x00, 0x02, 0x7E, 0x2A, 0x30,
;
;/* Code: 0x81, ASCII Character: 'Å' */
;0x00, 0x7E, 0x02, 0x03, 0x02,
;
;/* Code: 0x82, ASCII Character: 'Ç' */
;0x00, 0x40, 0x20, 0x00, 0x00,
;
;/* Code: 0x83, ASCII Character: 'É' */
;0x00, 0x78, 0x0C, 0x08, 0x00,
;
;/* Code: 0x84, ASCII Character: 'Ñ' */
;0x40, 0x20, 0x40, 0x20, 0x00,
;
;/* Code: 0x85, ASCII Character: 'Ö' */
;0x00, 0x40, 0x40, 0x40, 0x00,
;
;/* Code: 0x86, ASCII Character: 'Ü' */
;0x00, 0x04, 0x7E, 0x04, 0x00,
;
;/* Code: 0x87, ASCII Character: 'á' */
;0x00, 0x24, 0x7E, 0x24, 0x00,
;
;/* Code: 0x88, ASCII Character: 'à' */
;0x14, 0x3C, 0x56, 0x42, 0x24,
;
;/* Code: 0x89, ASCII Character: 'â' */
;0x26, 0x16, 0x68, 0x64, 0x62,
;
;/* Code: 0x8A, ASCII Character: 'ä' */
;0x7E, 0x01, 0x7F, 0x48, 0x30,
;
;/* Code: 0x8B, ASCII Character: 'ã' */
;0x00, 0x08, 0x14, 0x00, 0x00,
;
;/* Code: 0x8C, ASCII Character: 'å' */
;0x7F, 0x08, 0x7F, 0x48, 0x30,
;
;/* Code: 0x8D, ASCII Character: 'ç' */
;0x7E, 0x08, 0x15, 0x22, 0x40,
;
;/* Code: 0x8E, ASCII Character: 'é' */
;0x02, 0x7E, 0x0A, 0x0A, 0x70,
;
;/* Code: 0x8F, ASCII Character: 'è' */
;0x3F, 0x20, 0x60, 0x20, 0x3F,
;
;/* Code: 0x90, ASCII Character: 'ê' */
;0x02, 0x1F, 0x4A, 0x4A, 0x30,
;
;/* Code: 0x91, ASCII Character: 'ë' */
;0x00, 0x01, 0x02, 0x00, 0x00,
;
;/* Code: 0x92, ASCII Character: 'í' */
;0x00, 0x02, 0x01, 0x00, 0x00,
;
;/* Code: 0x93, ASCII Character: 'ì' */
;0x00, 0x01, 0x02, 0x01, 0x02,
;
;/* Code: 0x94, ASCII Character: 'î' */
;0x00, 0x02, 0x01, 0x02, 0x01,
;
;/* Code: 0x95, ASCII Character: 'ï' */
;0x04, 0x0E, 0x0E, 0x04, 0x00,
;
;/* Code: 0x96, ASCII Character: 'ñ' */
;0x00, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0x97, ASCII Character: 'ó' */
;0x08, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0x98, ASCII Character: 'ò' */
;0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x99, ASCII Character: 'ô' */
;0x02, 0x0E, 0x02, 0x04, 0x0E,
;
;/* Code: 0x9A, ASCII Character: 'ö' */
;0x78, 0x04, 0x7C, 0x50, 0x20,
;
;/* Code: 0x9B, ASCII Character: 'õ' */
;0x00, 0x14, 0x08, 0x00, 0x00,
;
;/* Code: 0x9C, ASCII Character: 'ú' */
;0x7C, 0x10, 0x7C, 0x50, 0x20,
;
;/* Code: 0x9D, ASCII Character: 'ù' */
;0x7C, 0x10, 0x2A, 0x40, 0x00,
;
;/* Code: 0x9E, ASCII Character: 'û' */
;0x7E, 0x24, 0x10, 0x60, 0x00,
;
;/* Code: 0x9F, ASCII Character: 'ü' */
;0x3C, 0x20, 0x60, 0x3C, 0x00,
;
;/* Code: 0xA0, ASCII Character: '†' */
;0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xA1, ASCII Character: '°' */
;0x0E, 0x50, 0x51, 0x50, 0x3E,
;
;/* Code: 0xA2, ASCII Character: '¢' */
;0x0E, 0x50, 0x51, 0x3E, 0x00,
;
;/* Code: 0xA3, ASCII Character: '£' */
;0x20, 0x40, 0x40, 0x3E, 0x00,
;
;/* Code: 0xA4, ASCII Character: '§' */
;0x00, 0x14, 0x08, 0x14, 0x00,
;
;/* Code: 0xA5, ASCII Character: '•' */
;0x7E, 0x02, 0x02, 0x03, 0x00,
;
;/* Code: 0xA6, ASCII Character: '¶' */
;0x00, 0x00, 0x77, 0x00, 0x00,
;
;/* Code: 0xA7, ASCII Character: 'ß' */
;0x20, 0x4A, 0x55, 0x29, 0x02,
;
;/* Code: 0xA8, ASCII Character: '®' */
;0x7E, 0x4B, 0x4A, 0x43, 0x42,
;
;/* Code: 0xA9, ASCII Character: '©' */
;0x3C, 0x5A, 0x66, 0x42, 0x3C,
;
;/* Code: 0xAA, ASCII Character: '™' */
;0x3E, 0x49, 0x49, 0x41, 0x22,
;
;/* Code: 0xAB, ASCII Character: '´' */
;0x08, 0x14, 0x00, 0x08, 0x14,
;
;/* Code: 0xAC, ASCII Character: '¨' */
;0x04, 0x04, 0x04, 0x0C, 0x00,
;
;/* Code: 0xAD, ASCII Character: '≠' */
;0x00, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0xAE, ASCII Character: 'Æ' */
;0x3E, 0x7D, 0x55, 0x69, 0x3E,
;
;/* Code: 0xAF, ASCII Character: 'Ø' */
;0x00, 0x02, 0x7C, 0x02, 0x00,
;
;/* Code: 0xB0, ASCII Character: '∞' */
;0x00, 0x02, 0x05, 0x02, 0x00,
;
;/* Code: 0xB1, ASCII Character: '±' */
;0x00, 0x24, 0x2E, 0x24, 0x00,
;
;/* Code: 0xB2, ASCII Character: '≤' */
;0x00, 0x00, 0x7C, 0x00, 0x00,
;
;/* Code: 0xB3, ASCII Character: '≥' */
;0x00, 0x00, 0x74, 0x00, 0x00,
;
;/* Code: 0xB4, ASCII Character: '¥' */
;0x00, 0x78, 0x08, 0x0C, 0x00,
;
;/* Code: 0xB5, ASCII Character: 'µ' */
;0x7E, 0x20, 0x20, 0x1E, 0x20,
;
;/* Code: 0xB6, ASCII Character: '∂' */
;0x0E, 0x7E, 0x02, 0x7E, 0x00,
;
;/* Code: 0xB7, ASCII Character: '∑' */
;0x00, 0x00, 0x02, 0x00, 0x00,
;
;/* Code: 0xB8, ASCII Character: '∏' */
;0x3D, 0x4A, 0x4A, 0x2D, 0x00,
;
;/* Code: 0xB9, ASCII Character: 'π' */
;0x7E, 0x04, 0x08, 0x7E, 0x28,
;
;/* Code: 0xBA, ASCII Character: '∫' */
;0x38, 0x54, 0x44, 0x00, 0x00,
;
;/* Code: 0xBB, ASCII Character: 'ª' */
;0x14, 0x08, 0x00, 0x14, 0x08,
;
;/* Code: 0xBC, ASCII Character: 'º' */
;0x40, 0x40, 0x3A, 0x00, 0x00,
;
;/* Code: 0xBD, ASCII Character: 'Ω' */
;0x22, 0x45, 0x49, 0x51, 0x22,
;
;/* Code: 0xBE, ASCII Character: 'æ' */
;0x24, 0x4A, 0x52, 0x24, 0x00,
;
;/* Code: 0xBF, ASCII Character: 'ø' */
;0x00, 0x04, 0x78, 0x04, 0x00,
;
;/* Code: 0xC0, ASCII Character: '¿' */
;0x7C, 0x12, 0x11, 0x12, 0x7C,
;
;/* Code: 0xC1, ASCII Character: '¡' */
;0x7F, 0x49, 0x49, 0x49, 0x31,
;
;/* Code: 0xC2, ASCII Character: '¬' */
;0x7F, 0x49, 0x49, 0x49, 0x36,
;
;/* Code: 0xC3, ASCII Character: '√' */
;0x7F, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xC4, ASCII Character: 'ƒ' */
;0x40, 0x7E, 0x41, 0x41, 0x7F,
;
;/* Code: 0xC5, ASCII Character: '≈' */
;0x7F, 0x49, 0x49, 0x41, 0x41,
;
;/* Code: 0xC6, ASCII Character: '∆' */
;0x77, 0x08, 0x7F, 0x08, 0x77,
;
;/* Code: 0xC7, ASCII Character: '«' */
;0x22, 0x41, 0x49, 0x49, 0x36,
;
;/* Code: 0xC8, ASCII Character: '»' */
;0x7F, 0x10, 0x08, 0x04, 0x7F,
;
;/* Code: 0xC9, ASCII Character: '…' */
;0x7E, 0x10, 0x09, 0x04, 0x7E,
;
;/* Code: 0xCA, ASCII Character: ' ' */
;0x7F, 0x08, 0x14, 0x22, 0x41,
;
;/* Code: 0xCB, ASCII Character: 'À' */
;0x40, 0x3E, 0x01, 0x01, 0x7F,
;
;/* Code: 0xCC, ASCII Character: 'Ã' */
;0x7F, 0x02, 0x04, 0x02, 0x7F,
;
;/* Code: 0xCD, ASCII Character: 'Õ' */
;0x7F, 0x08, 0x08, 0x08, 0x7F,
;
;/* Code: 0xCE, ASCII Character: 'Œ' */
;0x3E, 0x41, 0x41, 0x41, 0x3E,
;
;/* Code: 0xCF, ASCII Character: 'œ' */
;0x7F, 0x01, 0x01, 0x01, 0x7F,
;
;/* Code: 0xD0, ASCII Character: '–' */
;0x7F, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0xD1, ASCII Character: '—' */
;0x3E, 0x41, 0x41, 0x41, 0x22,
;
;/* Code: 0xD2, ASCII Character: '“' */
;0x01, 0x01, 0x7F, 0x01, 0x01,
;
;/* Code: 0xD3, ASCII Character: '”' */
;0x27, 0x48, 0x48, 0x48, 0x3F,
;
;/* Code: 0xD4, ASCII Character: '‘' */
;0x0E, 0x11, 0x7F, 0x11, 0x0E,
;
;/* Code: 0xD5, ASCII Character: '’' */
;0x63, 0x14, 0x08, 0x14, 0x63,
;
;/* Code: 0xD6, ASCII Character: '÷' */
;0x3F, 0x20, 0x20, 0x20, 0x7F,
;
;/* Code: 0xD7, ASCII Character: '◊' */
;0x0F, 0x10, 0x10, 0x10, 0x7F,
;
;/* Code: 0xD8, ASCII Character: 'ÿ' */
;0x7F, 0x40, 0x7C, 0x40, 0x7F,
;
;/* Code: 0xD9, ASCII Character: 'Ÿ' */
;0x3F, 0x20, 0x3C, 0x20, 0x7F,
;
;/* Code: 0xDA, ASCII Character: '⁄' */
;0x01, 0x7F, 0x48, 0x48, 0x30,
;
;/* Code: 0xDB, ASCII Character: '€' */
;0x7F, 0x48, 0x30, 0x00, 0x7F,
;
;/* Code: 0xDC, ASCII Character: '‹' */
;0x7F, 0x48, 0x48, 0x48, 0x30,
;
;/* Code: 0xDD, ASCII Character: '›' */
;0x22, 0x41, 0x49, 0x49, 0x3E,
;
;/* Code: 0xDE, ASCII Character: 'ﬁ' */
;0x7F, 0x08, 0x3E, 0x41, 0x3E,
;
;/* Code: 0xDF, ASCII Character: 'ﬂ' */
;0x46, 0x29, 0x19, 0x09, 0x7F,
;
;/* Code: 0xE0, ASCII Character: '‡' */
;0x30, 0x4A, 0x4A, 0x3C, 0x40,
;
;/* Code: 0xE1, ASCII Character: '·' */
;0x3C, 0x4A, 0x4A, 0x30, 0x00,
;
;/* Code: 0xE2, ASCII Character: '‚' */
;0x7E, 0x4A, 0x4A, 0x34, 0x00,
;
;/* Code: 0xE3, ASCII Character: '„' */
;0x7E, 0x02, 0x02, 0x02, 0x00,
;
;/* Code: 0xE4, ASCII Character: '‰' */
;0x40, 0x7C, 0x42, 0x7E, 0x40,
;
;/* Code: 0xE5, ASCII Character: 'Â' */
;0x3C, 0x52, 0x52, 0x0C, 0x00,
;
;/* Code: 0xE6, ASCII Character: 'Ê' */
;0x76, 0x08, 0x7E, 0x08, 0x76,
;
;/* Code: 0xE7, ASCII Character: 'Á' */
;0x24, 0x42, 0x4A, 0x34, 0x00,
;
;/* Code: 0xE8, ASCII Character: 'Ë' */
;0x7E, 0x10, 0x08, 0x7E, 0x00,
;
;/* Code: 0xE9, ASCII Character: 'È' */
;0x7C, 0x10, 0x0A, 0x7C, 0x00,
;
;/* Code: 0xEA, ASCII Character: 'Í' */
;0x7E, 0x08, 0x14, 0x62, 0x00,
;
;/* Code: 0xEB, ASCII Character: 'Î' */
;0x7C, 0x02, 0x02, 0x7E, 0x00,
;
;/* Code: 0xEC, ASCII Character: 'Ï' */
;0x7E, 0x04, 0x08, 0x04, 0x7E,
;
;/* Code: 0xED, ASCII Character: 'Ì' */
;0x7E, 0x08, 0x08, 0x7E, 0x00,
;
;/* Code: 0xEE, ASCII Character: 'Ó' */
;0x3C, 0x42, 0x42, 0x3C, 0x00,
;
;/* Code: 0xEF, ASCII Character: 'Ô' */
;0x7E, 0x02, 0x02, 0x7E, 0x00,
;
;/* Code: 0xF0, ASCII Character: '' */
;0x7E, 0x12, 0x12, 0x0C, 0x00,
;
;/* Code: 0xF1, ASCII Character: 'Ò' */
;0x3C, 0x42, 0x42, 0x24, 0x00,
;
;/* Code: 0xF2, ASCII Character: 'Ú' */
;0x02, 0x02, 0x7E, 0x02, 0x02,
;
;/* Code: 0xF3, ASCII Character: 'Û' */
;0x0E, 0x50, 0x50, 0x3E, 0x00,
;
;/* Code: 0xF4, ASCII Character: 'Ù' */
;0x1C, 0x22, 0x7E, 0x22, 0x1C,
;
;/* Code: 0xF5, ASCII Character: 'ı' */
;0x62, 0x14, 0x08, 0x14, 0x62,
;
;/* Code: 0xF6, ASCII Character: 'ˆ' */
;0x3E, 0x20, 0x20, 0x3E, 0x60,
;
;/* Code: 0xF7, ASCII Character: '˜' */
;0x0E, 0x10, 0x10, 0x7E, 0x00,
;
;/* Code: 0xF8, ASCII Character: '¯' */
;0x7E, 0x40, 0x78, 0x40, 0x7E,
;
;/* Code: 0xF9, ASCII Character: '˘' */
;0x3E, 0x20, 0x38, 0x20, 0x7E,
;
;/* Code: 0xFA, ASCII Character: '˙' */
;0x02, 0x7E, 0x48, 0x48, 0x30,
;
;/* Code: 0xFB, ASCII Character: '˚' */
;0x7E, 0x48, 0x30, 0x00, 0x7E,
;
;/* Code: 0xFC, ASCII Character: '¸' */
;0x7E, 0x48, 0x48, 0x30, 0x00,
;
;/* Code: 0xFD, ASCII Character: '˝' */
;0x24, 0x42, 0x4A, 0x3C, 0x00,
;
;/* Code: 0xFE, ASCII Character: '˛' */
;0x7E, 0x08, 0x3C, 0x42, 0x3C,
;
;/* Code: 0xFF, ASCII Character: 'ˇ' */
;0x4C, 0x32, 0x12, 0x7E, 0x00,
;
;#endif
;};
;
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12.09.2017
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
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include "font5x7ru.h"
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;unsigned char FRT = 0;                //ÙÎ‡„ ÔÓ‚ÚÓ‡ ÔÂÂ‰‡˜Ë
;unsigned char FOD = 0;                //ÙÎ‡„ ÓÚÓ·‡ÊÂÌËˇ ËÌÙÓÏ‡ˆËË
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;unsigned char rx_data[RX_BUFFER_SIZE];
;unsigned char rx_count=0;
;//unsigned char rx_wr_index=0,rx_rd_index=0;
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;unsigned char tx_rd_index=0;
;unsigned char tx_counter=0;
;unsigned char tx_wr_index=0;
;
;// This flag is set on USART Receiver buffer overflow
;//bit rx_buffer_overflow;
;
;
;void LCD_Out (void)
; 0001 003E {

	.CSEG
_LCD_Out:
; .FSTART _LCD_Out
; 0001 003F      unsigned char i;
; 0001 0040      glcd_clear();
	ST   -Y,R17
;	i -> R17
	RCALL SUBOPT_0x0
; 0001 0041      glcd_outtextf("œÓ‚ÂÍ‡ USART");
; 0001 0042      glcd_outtextf("œËÌˇÚÓ: ");
	__POINTW2FN _0x20000,15
	RCALL _glcd_outtextf
; 0001 0043      //glcd_outtext(str);
; 0001 0044      for (i = 0; i < RX_BUFFER_SIZE; i++)
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRSH _0x20005
; 0001 0045             {
; 0001 0046                 glcd_putchar (rx_data[i]);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_data)
	SBCI R31,HIGH(-_rx_data)
	LD   R26,Z
	RCALL _glcd_putchar
; 0001 0047             }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0048      FOD = 0;
	CLR  R4
; 0001 0049 }
	LD   R17,Y+
	RET
; .FEND
;
;
;
;void USART_Transmit(char c)
; 0001 004E {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0001 004F while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x20006:
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ _0x20006
; 0001 0050 #asm("cli")
	cli
; 0001 0051 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R9
	BRNE _0x2000A
	SBIC 0xB,5
	RJMP _0x20009
_0x2000A:
; 0001 0052    {
; 0001 0053    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0001 0054 #if TX_BUFFER_SIZE != 256
; 0001 0055    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x2000C
	CLR  R8
; 0001 0056 #endif
; 0001 0057    ++tx_counter;
_0x2000C:
	INC  R9
; 0001 0058    }
; 0001 0059 else
	RJMP _0x2000D
_0x20009:
; 0001 005A    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0001 005B #asm("sei")
_0x2000D:
	sei
; 0001 005C }
	RJMP _0x2100008
; .FEND
;
;void UART_send_st (const unsigned char *st)
; 0001 005F {
_UART_send_st:
; .FSTART _UART_send_st
; 0001 0060    while(*st)
	RCALL SUBOPT_0x1
;	*st -> Y+0
_0x2000E:
	RCALL SUBOPT_0x2
	LD   R30,X
	CPI  R30,0
	BREQ _0x20010
; 0001 0061       USART_Transmit(*st++);
	RCALL SUBOPT_0x2
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _USART_Transmit
	RJMP _0x2000E
_0x20010:
; 0001 0062 }
	RJMP _0x2100003
; .FEND
;
;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0001 0068 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0001 0069 
; 0001 006A if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	IN   R30,0xB
	ANDI R30,LOW(0x1C)
	BRNE _0x20011
; 0001 006B    {
; 0001 006C         rx_count=0;
	CLR  R7
; 0001 006D //        rx_data[rx_count]=UDR;//Get first byte
; 0001 006E //        rx_count++;
; 0001 006F         do {			//Receive  packet
_0x20013:
; 0001 0070 
; 0001 0071             while ( !(UCSRA & RX_COMPLETE) );
_0x20015:
	SBIS 0xB,7
	RJMP _0x20015
; 0001 0072             rx_data[rx_count]=UDR;
	MOV  R26,R7
	LDI  R27,0
	SUBI R26,LOW(-_rx_data)
	SBCI R27,HIGH(-_rx_data)
	IN   R30,0xC
	ST   X,R30
; 0001 0073 	        rx_count++;
	INC  R7
; 0001 0074 
; 0001 0075         } while (rx_count<RX_BUFFER_SIZE);
	LDI  R30,LOW(8)
	CP   R7,R30
	BRLO _0x20013
; 0001 0076 
; 0001 0077    if (rx_count == RX_BUFFER_SIZE) rx_count=0;
	CP   R30,R7
	BRNE _0x20018
	CLR  R7
; 0001 0078    }
_0x20018:
; 0001 0079 
; 0001 007A    FOD=1;
_0x20011:
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0001 007B    return;
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; 0001 007C }
; .FEND
;
;
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0001 0082 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 0083 if (tx_counter)
	TST  R9
	BREQ _0x20019
; 0001 0084    {
; 0001 0085    --tx_counter;
	DEC  R9
; 0001 0086    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0001 0087 #if TX_BUFFER_SIZE != 256
; 0001 0088    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x2001A
	CLR  R6
; 0001 0089 #endif
; 0001 008A    }
_0x2001A:
; 0001 008B }
_0x20019:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void main(void)
; 0001 0093 {
_main:
; .FSTART _main
; 0001 0094 // Declare your local variables here
; 0001 0095 // Variable used to store graphic display
; 0001 0096 // controller initialization data
; 0001 0097 GLCDINIT_t glcd_init_data;
; 0001 0098 
; 0001 0099 // Input/Output Ports initialization
; 0001 009A // Port B initialization
; 0001 009B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 009C DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0001 009D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 009E PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0001 009F 
; 0001 00A0 // Port C initialization
; 0001 00A1 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 00A2 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0001 00A3 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 00A4 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0001 00A5 
; 0001 00A6 // Port D initialization
; 0001 00A7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 00A8 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0001 00A9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 00AA PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0001 00AB 
; 0001 00AC // Timer/Counter 0 initialization
; 0001 00AD // Clock source: System Clock
; 0001 00AE // Clock value: Timer 0 Stopped
; 0001 00AF TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0001 00B0 TCNT0=0x00;
	OUT  0x32,R30
; 0001 00B1 
; 0001 00B2 // Timer/Counter 1 initialization
; 0001 00B3 // Clock source: System Clock
; 0001 00B4 // Clock value: Timer1 Stopped
; 0001 00B5 // Mode: Normal top=0xFFFF
; 0001 00B6 // OC1A output: Disconnected
; 0001 00B7 // OC1B output: Disconnected
; 0001 00B8 // Noise Canceler: Off
; 0001 00B9 // Input Capture on Falling Edge
; 0001 00BA // Timer1 Overflow Interrupt: Off
; 0001 00BB // Input Capture Interrupt: Off
; 0001 00BC // Compare A Match Interrupt: Off
; 0001 00BD // Compare B Match Interrupt: Off
; 0001 00BE TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0001 00BF TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0001 00C0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0001 00C1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 00C2 ICR1H=0x00;
	OUT  0x27,R30
; 0001 00C3 ICR1L=0x00;
	OUT  0x26,R30
; 0001 00C4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 00C5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 00C6 OCR1BH=0x00;
	OUT  0x29,R30
; 0001 00C7 OCR1BL=0x00;
	OUT  0x28,R30
; 0001 00C8 
; 0001 00C9 // Timer/Counter 2 initialization
; 0001 00CA // Clock source: System Clock
; 0001 00CB // Clock value: Timer2 Stopped
; 0001 00CC // Mode: Normal top=0xFF
; 0001 00CD // OC2 output: Disconnected
; 0001 00CE ASSR=0<<AS2;
	OUT  0x22,R30
; 0001 00CF TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0001 00D0 TCNT2=0x00;
	OUT  0x24,R30
; 0001 00D1 OCR2=0x00;
	OUT  0x23,R30
; 0001 00D2 
; 0001 00D3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 00D4 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0001 00D5 
; 0001 00D6 // External Interrupt(s) initialization
; 0001 00D7 // INT0: Off
; 0001 00D8 // INT1: Off
; 0001 00D9 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0001 00DA 
; 0001 00DB // USART initialization
; 0001 00DC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 00DD // USART Receiver: On
; 0001 00DE // USART Transmitter: On
; 0001 00DF // USART Mode: Asynchronous
; 0001 00E0 // USART Baud Rate: 9600
; 0001 00E1 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0001 00E2 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 00E3 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0001 00E4 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 00E5 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0001 00E6 
; 0001 00E7 // Analog Comparator initialization
; 0001 00E8 // Analog Comparator: Off
; 0001 00E9 // The Analog Comparator's positive input is
; 0001 00EA // connected to the AIN0 pin
; 0001 00EB // The Analog Comparator's negative input is
; 0001 00EC // connected to the AIN1 pin
; 0001 00ED ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 00EE SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 00EF 
; 0001 00F0 // ADC initialization
; 0001 00F1 // ADC disabled
; 0001 00F2 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0001 00F3 
; 0001 00F4 // SPI initialization
; 0001 00F5 // SPI disabled
; 0001 00F6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0001 00F7 
; 0001 00F8 // TWI initialization
; 0001 00F9 // TWI disabled
; 0001 00FA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0001 00FB 
; 0001 00FC // Graphic Display Controller initialization
; 0001 00FD // The PCD8544 connections are specified in the
; 0001 00FE // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0001 00FF // SDIN - PORTC Bit 0
; 0001 0100 // SCLK - PORTC Bit 1
; 0001 0101 // D /C - PORTC Bit 2
; 0001 0102 // /SCE - PORTC Bit 3
; 0001 0103 // /RES - PORTC Bit 4
; 0001 0104 
; 0001 0105 // Specify the current font for displaying text
; 0001 0106 glcd_init_data.font=font5x7ru;
	LDI  R30,LOW(_font5x7ru*2)
	LDI  R31,HIGH(_font5x7ru*2)
	ST   Y,R30
	STD  Y+1,R31
; 0001 0107 // No function is used for reading
; 0001 0108 // image data from external memory
; 0001 0109 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0001 010A // No function is used for writing
; 0001 010B // image data to external memory
; 0001 010C glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0001 010D // Set the LCD temperature coefficient
; 0001 010E glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0001 010F // Set the LCD bias
; 0001 0110 glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0001 0111 // Set the LCD contrast control voltage VLCD
; 0001 0112 glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,0x40
	STD  Y+7,R30
; 0001 0113 
; 0001 0114 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0001 0115 
; 0001 0116 glcd_clear();
	RCALL SUBOPT_0x0
; 0001 0117 glcd_outtextf("œÓ‚ÂÍ‡ USART");
; 0001 0118 
; 0001 0119 // Global enable interrupts
; 0001 011A #asm("sei")
	sei
; 0001 011B 
; 0001 011C while (1)
_0x2001B:
; 0001 011D       {
; 0001 011E       // Place your code here
; 0001 011F       if(PINB.0!=1)
	SBIC 0x16,0
	RJMP _0x2001E
; 0001 0120         {
; 0001 0121             if (FRT == 0)
	TST  R5
	BRNE _0x2001F
; 0001 0122             {
; 0001 0123                 USART_Transmit('U');
	LDI  R26,LOW(85)
	RCALL _USART_Transmit
; 0001 0124                 USART_Transmit('S');
	LDI  R26,LOW(83)
	RCALL _USART_Transmit
; 0001 0125                 USART_Transmit('A');
	LDI  R26,LOW(65)
	RCALL _USART_Transmit
; 0001 0126                 USART_Transmit('R');
	LDI  R26,LOW(82)
	RCALL _USART_Transmit
; 0001 0127                 USART_Transmit('T');
	LDI  R26,LOW(84)
	RCALL _USART_Transmit
; 0001 0128                 USART_Transmit(13);
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0001 0129                 UART_send_st("Hello, World!\n");
	__POINTW2MN _0x20020,0
	RCALL _UART_send_st
; 0001 012A                 USART_Transmit(13);
	LDI  R26,LOW(13)
	RCALL _USART_Transmit
; 0001 012B                 FRT = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0001 012C             }
; 0001 012D         }
_0x2001F:
; 0001 012E         else
	RJMP _0x20021
_0x2001E:
; 0001 012F         {
; 0001 0130             FRT = 0;
	CLR  R5
; 0001 0131         }
_0x20021:
; 0001 0132         if (FOD==1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x20022
; 0001 0133         {
; 0001 0134             LCD_Out();
	RCALL _LCD_Out
; 0001 0135         }
; 0001 0136 
; 0001 0137 
; 0001 0138       }
_0x20022:
	RJMP _0x2001B
; 0001 0139 }
_0x20023:
	RJMP _0x20023
; .FEND

	.DSEG
_0x20020:
	.BYTE 0xF
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
_pcd8544_delay_G100:
; .FSTART _pcd8544_delay_G100
	RET
; .FEND
_pcd8544_wrbus_G100:
; .FSTART _pcd8544_wrbus_G100
	RCALL SUBOPT_0x3
	CBI  0x15,3
	LDI  R17,LOW(8)
_0x2000004:
	RCALL _pcd8544_delay_G100
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000006
	SBI  0x15,0
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,0
_0x2000007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G100
	SBI  0x15,1
	RCALL _pcd8544_delay_G100
	CBI  0x15,1
	SUBI R17,LOW(1)
	BRNE _0x2000004
	SBI  0x15,3
	LDD  R17,Y+0
	RJMP _0x2100003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x2100008
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	SBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x2100008
; .FEND
_pcd8544_setaddr_G100:
; .FSTART _pcd8544_setaddr_G100
	RCALL SUBOPT_0x3
	LDD  R30,Y+1
	RCALL SUBOPT_0x4
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	RCALL SUBOPT_0x5
	STS  _gfx_addr_G100,R30
	STS  _gfx_addr_G100+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	RCALL SUBOPT_0x6
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G100
	ORI  R30,0x40
	RCALL SUBOPT_0x6
	RJMP _0x2100003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G100
	LDS  R31,_gfx_addr_G100+1
	RCALL SUBOPT_0x7
	LD   R30,Z
	RJMP _0x2100003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	RCALL SUBOPT_0x8
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x2100008
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0x1
	RCALL __SAVELOCR4
	SBI  0x14,3
	SBI  0x15,3
	SBI  0x14,1
	CBI  0x15,1
	SBI  0x14,0
	SBI  0x14,2
	SBI  0x14,4
	CBI  0x15,4
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
	SBI  0x15,4
	RCALL SUBOPT_0x9
	SBIW R30,0
	BREQ _0x2000008
	RCALL SUBOPT_0x9
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0x9
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	RCALL SUBOPT_0x9
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	RCALL SUBOPT_0xA
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0xB
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	RCALL __GETW1P
	RJMP _0x20000A0
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(192)
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
_0x20000A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	RCALL SUBOPT_0x6
	MOV  R30,R16
	ORI  R30,0x10
	RCALL SUBOPT_0x6
	MOV  R30,R19
	ORI  R30,0x80
	RCALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0xD
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x2100007
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(12)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(8)
_0x200000B:
	RCALL SUBOPT_0x6
_0x2100008:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	RCALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x200000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x200000E
_0x2000010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x2100001
; .FEND
_pcd8544_wrmasked_G100:
; .FSTART _pcd8544_wrmasked_G100
	RCALL SUBOPT_0x3
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2000020
	CPI  R30,LOW(0x8)
	BRNE _0x2000021
_0x2000020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2000022
_0x2000021:
	CPI  R30,LOW(0x3)
	BRNE _0x2000024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000025
_0x2000024:
	CPI  R30,0
	BRNE _0x2000026
_0x2000025:
_0x2000022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000027
_0x2000026:
	CPI  R30,LOW(0x2)
	BRNE _0x2000028
_0x2000027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x200001E
_0x2000028:
	CPI  R30,LOW(0x1)
	BRNE _0x2000029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x200001E
_0x2000029:
	CPI  R30,LOW(0x4)
	BRNE _0x200001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x200001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x2100007:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	RCALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x200002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x200002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x200002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x200002B
_0x200002C:
	RJMP _0x2100006
_0x200002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	RCALL SUBOPT_0xE
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x200002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x200002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	RCALL SUBOPT_0xE
	SBIW R26,49
	BRLO _0x200002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x200002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	RJMP _0x2100006
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x2100006
_0x2000036:
_0x2000037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	RCALL SUBOPT_0x4
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000038
_0x2000039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	RCALL SUBOPT_0xF
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x10
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x200003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x200003D
	MOV  R17,R16
_0x200003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000040
	RCALL SUBOPT_0x11
	RJMP _0x200003E
_0x2000040:
	RJMP _0x200003B
_0x200003D:
_0x2000038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2000041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x10
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2000042
	SUBI R19,-LOW(1)
_0x2000042:
	LDI  R18,LOW(0)
_0x2000043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000045
	LDD  R17,Y+14
_0x2000046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000048
	RCALL SUBOPT_0x11
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x10
	RJMP _0x2000043
_0x2000045:
_0x2000041:
_0x2000030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x10
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x200004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x200004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2000052
	CPI  R30,LOW(0x3)
	BRNE _0x2000053
_0x2000052:
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x7)
	BRNE _0x2000055
_0x2000054:
	RJMP _0x2000056
_0x2000055:
	CPI  R30,LOW(0x8)
	BRNE _0x2000057
_0x2000056:
	RJMP _0x2000058
_0x2000057:
	CPI  R30,LOW(0x9)
	BRNE _0x2000059
_0x2000058:
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x200005A:
	RCALL SUBOPT_0x12
	RCALL _pcd8544_gotoxy
	RJMP _0x2000050
_0x200005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2000050
	RCALL SUBOPT_0x12
	RCALL _pcd8544_setaddr_G100
_0x2000050:
_0x200005D:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x200005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2000060
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x8
	LD   R26,Z
	RCALL _glcd_writemem
	RJMP _0x2000061
_0x2000060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000065
	LDI  R21,LOW(0)
	RJMP _0x2000066
_0x2000065:
	CPI  R30,LOW(0xA)
	BRNE _0x2000064
	LDI  R21,LOW(255)
	RJMP _0x2000066
_0x2000064:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	RCALL SUBOPT_0x16
	MOV  R21,R30
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2000071
	COM  R21
	RJMP _0x2000072
_0x2000071:
	CPI  R30,0
	BRNE _0x2000074
_0x2000072:
_0x200006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G100
	RJMP _0x200006B
_0x2000074:
	RCALL SUBOPT_0x17
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
_0x200006B:
_0x2000061:
	RJMP _0x200005D
_0x200005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000075
_0x200004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000076
_0x200004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000078
_0x2000077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000078:
	ST   -Y,R19
	MOV  R26,R18
	RCALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200007C
	RCALL SUBOPT_0x12
	RCALL _pcd8544_setaddr_G100
_0x200007D:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	RCALL SUBOPT_0x8
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	RCALL SUBOPT_0x18
	MOV  R30,R19
	MOV  R26,R20
	RCALL __LSRB12
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0xD
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x200007D
_0x200007F:
	RJMP _0x200007B
_0x200007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2000080
	LDI  R21,LOW(0)
	RJMP _0x2000081
_0x2000080:
	CPI  R30,LOW(0xA)
	BRNE _0x2000087
	LDI  R21,LOW(255)
_0x2000081:
	RCALL SUBOPT_0x16
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	MOV  R21,R30
_0x2000084:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x2000086
	RCALL SUBOPT_0x17
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000084
_0x2000086:
	RJMP _0x200007B
_0x2000087:
_0x2000088:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x200008A
	RCALL SUBOPT_0x1A
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	RCALL SUBOPT_0x1B
	RJMP _0x2000088
_0x200008A:
_0x200007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x200008B
	RJMP _0x200004B
_0x200008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x200008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000A1
_0x200008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x10
_0x2000076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000091
	RCALL SUBOPT_0x12
	RCALL _pcd8544_setaddr_G100
_0x2000092:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	RCALL SUBOPT_0x8
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSLB12
	RCALL SUBOPT_0x18
	MOV  R30,R18
	MOV  R26,R20
	RCALL __LSLB12
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0xD
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x2000092
_0x2000094:
	RJMP _0x2000090
_0x2000091:
	CPI  R30,LOW(0x9)
	BRNE _0x2000095
	LDI  R21,LOW(0)
	RJMP _0x2000096
_0x2000095:
	CPI  R30,LOW(0xA)
	BRNE _0x200009C
	LDI  R21,LOW(255)
_0x2000096:
	RCALL SUBOPT_0x16
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	MOV  R21,R30
_0x2000099:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x200009B
	RCALL SUBOPT_0x17
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000099
_0x200009B:
	RJMP _0x2000090
_0x200009C:
_0x200009D:
	PUSH R17
	RCALL SUBOPT_0x13
	POP  R26
	CP   R26,R30
	BRSH _0x200009F
	RCALL SUBOPT_0x1A
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	RCALL SUBOPT_0x1B
	RJMP _0x200009D
_0x200009F:
_0x2000090:
_0x2000075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x5
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000049
_0x200004B:
_0x2100006:
	RCALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL __CPW02
	BRLT _0x2020003
	RCALL SUBOPT_0xC
	RJMP _0x2100003
_0x2020003:
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x2100003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2100003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL __CPW02
	BRLT _0x2020005
	RCALL SUBOPT_0xC
	RJMP _0x2100003
_0x2020005:
	RCALL SUBOPT_0x2
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x2100003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2100003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	RCALL SUBOPT_0x1
	SBIW R28,3
	RCALL SUBOPT_0x1C
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	RCALL SUBOPT_0xC
	RJMP _0x2100005
_0x202000B:
	RCALL SUBOPT_0x1D
	STD  Y+7,R0
	RCALL SUBOPT_0x1D
	STD  Y+6,R0
	RCALL SUBOPT_0x1D
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	RCALL SUBOPT_0xC
	RJMP _0x2100005
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	RCALL SUBOPT_0xC
	RJMP _0x2100005
_0x202000D:
	LDD  R30,Y+6
	RCALL SUBOPT_0x4
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	RCALL SUBOPT_0xF
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0xF
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2100005
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	RCALL SUBOPT_0xF
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2100005:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0xE
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0xE
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x1C
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x2100004
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	RCALL SUBOPT_0x5
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	RCALL SUBOPT_0x1F
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x1E
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x1F
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x20
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x1E
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x20
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2100004
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2100004:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextf:
; .FSTART _glcd_outtextf
	RCALL SUBOPT_0x1
	ST   -Y,R17
_0x2020031:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020033
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020031
_0x2020033:
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2100003
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
_memset:
; .FSTART _memset
	RCALL SUBOPT_0x1
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x2100003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	RCALL SUBOPT_0x3
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2080007
	CPI  R30,LOW(0xA)
	BRNE _0x2080008
_0x2080007:
	LDS  R17,_glcd_state
	RJMP _0x2080009
_0x2080008:
	CPI  R30,LOW(0x9)
	BRNE _0x208000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2080009
_0x208000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2080005
	__GETBRMN 17,_glcd_state,16
_0x2080009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x208000E
	CPI  R17,0
	BREQ _0x208000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000E:
	CPI  R17,0
	BRNE _0x2080011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x2080011:
_0x2080005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0x1
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2080015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2100002
_0x2080015:
	CPI  R30,LOW(0x2)
	BRNE _0x2080016
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	RJMP _0x2100002
_0x2080016:
	CPI  R30,LOW(0x3)
	BRNE _0x2080018
	RCALL SUBOPT_0x2
	__CALL1MN _glcd_state,25
	RJMP _0x2100002
_0x2080018:
	RCALL SUBOPT_0x2
	LD   R30,X
_0x2100002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x208001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x2)
	BRNE _0x208001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL __EEPROMWRB
	RJMP _0x208001B
_0x208001D:
	CPI  R30,LOW(0x3)
	BRNE _0x208001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0xD
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x208001B:
_0x2100001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_rx_data:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G107:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	RCALL _glcd_clear
	__POINTW2FN _0x20000,0
	RJMP _glcd_outtextf

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOV  R26,R30
	RJMP _pcd8544_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_gfx_addr_G100)
	LDI  R27,HIGH(_gfx_addr_G100)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0xD
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R16
	LDD  R26,Y+16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	SUBI R17,-1
	LDD  R30,Y+14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	ST   -Y,R21
	LDD  R26,Y+10
	RJMP _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RCALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	COM  R30
	AND  R30,R1
	OR   R21,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1A:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RJMP _pcd8544_wrmasked_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	LDI  R26,LOW(9)
	RJMP _glcd_block


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

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
