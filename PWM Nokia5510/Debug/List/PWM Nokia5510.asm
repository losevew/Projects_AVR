
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
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
	.DEF _NewState=R5
	.DEF _OldState=R4
	.DEF _OldVol=R7
	.DEF _upState=R6
	.DEF _downState=R9
	.DEF _Vol=R8

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x7F

_0x0:
	.DB  0xD1,0xEA,0xE2,0xE0,0xE6,0xED,0xEE,0xF1
	.DB  0xF2,0xFC,0x0,0x25,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;Date    : 19.12.2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
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
;// Graphic Display functions
;#include <glcd.h>
;#include <stdlib.h>
;
;// Font used for displaying text
;// on the graphic display
;#include "Font5x7ru.h"
;
;// Declare your global variables here
;unsigned char NewState, OldState, OldVol, upState, downState;
;unsigned char Vol = 0x7F;
;
;void EncoderScan(void);
;void LcdOut (unsigned char);
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002C {

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
; 0000 002D // Reinitialize Timer 0 value
; 0000 002E TCNT0=0x59;
	LDI  R30,LOW(89)
	OUT  0x32,R30
; 0000 002F // Place your code here
; 0000 0030 EncoderScan();
	RCALL _EncoderScan
; 0000 0031 
; 0000 0032 }
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
;void EncoderScan(void)
; 0000 0036 {
_EncoderScan:
; .FSTART _EncoderScan
; 0000 0037     NewState = PINB & 0x03;
	IN   R30,0x16
	ANDI R30,LOW(0x3)
	MOV  R5,R30
; 0000 0038     if (NewState != OldState) {
	CP   R4,R5
	BREQ _0x3
; 0000 0039         switch (OldState) {
	MOV  R30,R4
	LDI  R31,0
; 0000 003A             case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7
; 0000 003B                 {
; 0000 003C                 if (NewState == 3)upState++;
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x8
	INC  R6
; 0000 003D                 if (NewState == 0)downState++;
_0x8:
	TST  R5
	BRNE _0x9
	INC  R9
; 0000 003E                 break;
_0x9:
	RJMP _0x6
; 0000 003F                 }
; 0000 0040             case 0:
_0x7:
	SBIW R30,0
	BRNE _0xA
; 0000 0041                 {
; 0000 0042                 if (NewState == 2)upState++;
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0xB
	INC  R6
; 0000 0043                 if (NewState == 1)downState++;
_0xB:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xC
	INC  R9
; 0000 0044                 break;
_0xC:
	RJMP _0x6
; 0000 0045                 }
; 0000 0046             case 1:
_0xA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD
; 0000 0047                 {
; 0000 0048                 if (NewState == 0)upState++;
	TST  R5
	BRNE _0xE
	INC  R6
; 0000 0049                 if (NewState == 3)downState++;
_0xE:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0xF
	INC  R9
; 0000 004A                 break;
_0xF:
	RJMP _0x6
; 0000 004B                 }
; 0000 004C             case 3:
_0xD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6
; 0000 004D                 {
; 0000 004E                 if (NewState == 1)upState++;
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x11
	INC  R6
; 0000 004F                 if (NewState == 2)downState++;
_0x11:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x12
	INC  R9
; 0000 0050                 break;
_0x12:
; 0000 0051                 }
; 0000 0052         };
_0x6:
; 0000 0053         OldState = NewState;
	MOV  R4,R5
; 0000 0054         if (upState >= 4) {
	LDI  R30,LOW(4)
	CP   R6,R30
	BRLO _0x13
; 0000 0055             Vol++;
	INC  R8
; 0000 0056             upState = 0;
	CLR  R6
; 0000 0057         };
_0x13:
; 0000 0058         if (downState >= 4) {
	LDI  R30,LOW(4)
	CP   R9,R30
	BRLO _0x14
; 0000 0059             Vol--;
	DEC  R8
; 0000 005A             downState = 0;
	CLR  R9
; 0000 005B         };
_0x14:
; 0000 005C 
; 0000 005D     };
_0x3:
; 0000 005E 
; 0000 005F }
	RET
; .FEND
;
;void LcdOut (unsigned char pwVol )
; 0000 0062 {
_LcdOut:
; .FSTART _LcdOut
; 0000 0063      char Duty[];
; 0000 0064      int bar;
; 0000 0065      bar=pwVol*83/255;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	pwVol -> Y+2
;	Duty -> Y+2
;	bar -> R16,R17
	LDD  R26,Y+2
	LDI  R30,LOW(83)
	RCALL SUBOPT_0x0
	MOVW R16,R30
; 0000 0066      glcd_outtextxyf(12,5,"����������");
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2FN _0x0,0
	RCALL _glcd_outtextxyf
; 0000 0067      itoa(pwVol*100/255,Duty);
	LDD  R26,Y+2
	LDI  R30,LOW(100)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	MOVW R26,R28
	ADIW R26,4
	RCALL _itoa
; 0000 0068      glcd_outtextxy(35,15,Duty);
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL _glcd_outtextxy
; 0000 0069      glcd_outtextf("%");
	__POINTW2FN _0x0,11
	RCALL _glcd_outtextf
; 0000 006A      glcd_state.fill.color=0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
; 0000 006B      glcd_bar(0,30,83,40);
	LDI  R30,LOW(83)
	ST   -Y,R30
	LDI  R26,LOW(40)
	RCALL _glcd_bar
; 0000 006C      glcd_state.fill.color=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
; 0000 006D      glcd_bar(0,30,bar,40);
	ST   -Y,R16
	LDI  R26,LOW(40)
	RCALL _glcd_bar
; 0000 006E 
; 0000 006F }
	RCALL __LOADLOCR2
	RJMP _0x20E0002
; .FEND
;
;void main(void)
; 0000 0072 {
_main:
; .FSTART _main
; 0000 0073 // Declare your local variables here
; 0000 0074 // Variable used to store graphic display
; 0000 0075 // controller initialization data
; 0000 0076 GLCDINIT_t glcd_init_data;
; 0000 0077 
; 0000 0078 // Input/Output Ports initialization
; 0000 0079 // Port B initialization
; 0000 007A // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 007B DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(24)
	OUT  0x17,R30
; 0000 007C // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=P Bit0=P
; 0000 007D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(3)
	OUT  0x18,R30
; 0000 007E 
; 0000 007F // Port C initialization
; 0000 0080 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0081 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0082 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0083 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0084 
; 0000 0085 // Port D initialization
; 0000 0086 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0087 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0088 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0089 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 008A 
; 0000 008B // Timer/Counter 0 initialization
; 0000 008C // Clock source: System Clock
; 0000 008D // Clock value: 250,000 kHz
; 0000 008E TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 008F TCNT0=0x59;
	LDI  R30,LOW(89)
	OUT  0x32,R30
; 0000 0090 
; 0000 0091 // Timer/Counter 1 initialization
; 0000 0092 // Clock source: System Clock
; 0000 0093 // Clock value: Timer1 Stopped
; 0000 0094 // Mode: Normal top=0xFFFF
; 0000 0095 // OC1A output: Disconnected
; 0000 0096 // OC1B output: Disconnected
; 0000 0097 // Noise Canceler: Off
; 0000 0098 // Input Capture on Falling Edge
; 0000 0099 // Timer1 Overflow Interrupt: Off
; 0000 009A // Input Capture Interrupt: Off
; 0000 009B // Compare A Match Interrupt: Off
; 0000 009C // Compare B Match Interrupt: Off
; 0000 009D TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 009E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 009F TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00A0 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A1 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00A2 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A3 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A4 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A5 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A6 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A7 
; 0000 00A8 // Timer/Counter 2 initialization
; 0000 00A9 // Clock source: System Clock
; 0000 00AA // Clock value: 125,000 kHz
; 0000 00AB // Mode: Fast PWM top=0xFF
; 0000 00AC // OC2 output: Non-Inverted PWM
; 0000 00AD // Timer Period: 2,048 ms
; 0000 00AE // Output Pulse(s):
; 0000 00AF // OC2 Period: 2,048 ms Width: 1,02 ms
; 0000 00B0 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00B1 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(109)
	OUT  0x25,R30
; 0000 00B2 TCNT2=0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 00B3 OCR2=0x7F;
	LDI  R30,LOW(127)
	OUT  0x23,R30
; 0000 00B4 
; 0000 00B5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B6 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00B7 
; 0000 00B8 // External Interrupt(s) initialization
; 0000 00B9 // INT0: Off
; 0000 00BA // INT1: Off
; 0000 00BB MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00BC 
; 0000 00BD // USART initialization
; 0000 00BE // USART disabled
; 0000 00BF UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00C0 
; 0000 00C1 // Analog Comparator initialization
; 0000 00C2 // Analog Comparator: Off
; 0000 00C3 // The Analog Comparator's positive input is
; 0000 00C4 // connected to the AIN0 pin
; 0000 00C5 // The Analog Comparator's negative input is
; 0000 00C6 // connected to the AIN1 pin
; 0000 00C7 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C8 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00C9 
; 0000 00CA // ADC initialization
; 0000 00CB // ADC disabled
; 0000 00CC ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00CD 
; 0000 00CE // SPI initialization
; 0000 00CF // SPI disabled
; 0000 00D0 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00D1 
; 0000 00D2 // TWI initialization
; 0000 00D3 // TWI disabled
; 0000 00D4 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00D5 
; 0000 00D6 // Graphic Display Controller initialization
; 0000 00D7 // The PCD8544 connections are specified in the
; 0000 00D8 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00D9 // SDIN - PORTC Bit 0
; 0000 00DA // SCLK - PORTC Bit 1
; 0000 00DB // D /C - PORTC Bit 2
; 0000 00DC // /SCE - PORTC Bit 3
; 0000 00DD // /RES - PORTC Bit 4
; 0000 00DE 
; 0000 00DF // Specify the current font for displaying text
; 0000 00E0 glcd_init_data.font=font5x7ru;
	LDI  R30,LOW(_font5x7ru*2)
	LDI  R31,HIGH(_font5x7ru*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E1 // No function is used for reading
; 0000 00E2 // image data from external memory
; 0000 00E3 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00E4 // No function is used for writing
; 0000 00E5 // image data to external memory
; 0000 00E6 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00E7 // Set the LCD temperature coefficient
; 0000 00E8 glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 00E9 // Set the LCD bias
; 0000 00EA glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 00EB // Set the LCD contrast control voltage VLCD
; 0000 00EC glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,0x40
	STD  Y+7,R30
; 0000 00ED 
; 0000 00EE glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 00EF 
; 0000 00F0 // Global enable interrupts
; 0000 00F1 #asm("sei")
	sei
; 0000 00F2 
; 0000 00F3 while (1)
_0x15:
; 0000 00F4       {
; 0000 00F5       // Place your code here
; 0000 00F6       if (Vol != OldVol) {
	CP   R7,R8
	BREQ _0x18
; 0000 00F7           LcdOut(Vol);
	MOV  R26,R8
	RCALL _LcdOut
; 0000 00F8           OldVol = Vol;
	MOV  R7,R8
; 0000 00F9           OCR2=Vol;
	OUT  0x23,R8
; 0000 00FA       };
_0x18:
; 0000 00FB 
; 0000 00FC       }
	RJMP _0x15
; 0000 00FD }
_0x19:
	RJMP _0x19
; .FEND
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
;/* Code: 0x80, ASCII Character: '�' */
;0x00, 0x0E, 0x04, 0x0C, 0x14, 0x1C, 0x04,
;
;/* Code: 0x81, ASCII Character: '�' */
;0x08, 0x1E, 0x02, 0x02, 0x02, 0x02, 0x02,
;
;/* Code: 0x82, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x02,
;
;/* Code: 0x83, ASCII Character: '�' */
;0x00, 0x00, 0x04, 0x0E, 0x02, 0x02, 0x02,
;
;/* Code: 0x84, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x05,
;
;/* Code: 0x85, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E,
;
;/* Code: 0x86, ASCII Character: '�' */
;0x00, 0x04, 0x0E, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0x87, ASCII Character: '�' */
;0x00, 0x04, 0x0E, 0x04, 0x04, 0x0E, 0x04,
;
;/* Code: 0x88, ASCII Character: '�' */
;0x00, 0x0C, 0x17, 0x02, 0x07, 0x12, 0x0C,
;
;/* Code: 0x89, ASCII Character: '�' */
;0x00, 0x13, 0x0B, 0x04, 0x02, 0x1D, 0x1C,
;
;/* Code: 0x8A, ASCII Character: '�' */
;0x06, 0x05, 0x05, 0x0D, 0x15, 0x15, 0x0D,
;
;/* Code: 0x8B, ASCII Character: '�' */
;0x00, 0x00, 0x04, 0x02, 0x04, 0x00, 0x00,
;
;/* Code: 0x8C, ASCII Character: '�' */
;0x05, 0x05, 0x05, 0x0F, 0x15, 0x15, 0x0D,
;
;/* Code: 0x8D, ASCII Character: '�' */
;0x04, 0x09, 0x05, 0x03, 0x05, 0x09, 0x11,
;
;/* Code: 0x8E, ASCII Character: '�' */
;0x00, 0x0F, 0x02, 0x0E, 0x12, 0x12, 0x12,
;
;/* Code: 0x8F, ASCII Character: '�' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x1F, 0x04,
;
;/* Code: 0x90, ASCII Character: '�' */
;0x02, 0x0F, 0x02, 0x0E, 0x12, 0x10, 0x0C,
;
;/* Code: 0x91, ASCII Character: '�' */
;0x02, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x92, ASCII Character: '�' */
;0x04, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x93, ASCII Character: '�' */
;0x0A, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x94, ASCII Character: '�' */
;0x14, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x95, ASCII Character: '�' */
;0x00, 0x06, 0x0F, 0x06, 0x00, 0x00, 0x00,
;
;/* Code: 0x96, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00,
;
;/* Code: 0x97, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00,
;
;/* Code: 0x98, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x99, ASCII Character: '�' */
;0x00, 0x17, 0x1A, 0x12, 0x00, 0x00, 0x00,
;
;/* Code: 0x9A, ASCII Character: '�' */
;0x00, 0x00, 0x06, 0x05, 0x0D, 0x15, 0x0D,
;
;/* Code: 0x9B, ASCII Character: '�' */
;0x00, 0x00, 0x02, 0x04, 0x02, 0x00, 0x00,
;
;/* Code: 0x9C, ASCII Character: '�' */
;0x00, 0x00, 0x05, 0x05, 0x0F, 0x15, 0x0D,
;
;/* Code: 0x9D, ASCII Character: '�' */
;0x00, 0x04, 0x01, 0x05, 0x03, 0x05, 0x09,
;
;/* Code: 0x9E, ASCII Character: '�' */
;0x00, 0x01, 0x03, 0x01, 0x05, 0x0B, 0x09,
;
;/* Code: 0x9F, ASCII Character: '�' */
;0x00, 0x00, 0x09, 0x09, 0x09, 0x0F, 0x04,
;
;/* Code: 0xA0, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xA1, ASCII Character: '�' */
;0x04, 0x11, 0x11, 0x11, 0x1E, 0x10, 0x0E,
;
;/* Code: 0xA2, ASCII Character: '�' */
;0x04, 0x09, 0x09, 0x09, 0x0E, 0x08, 0x06,
;
;/* Code: 0xA3, ASCII Character: '�' */
;0x00, 0x08, 0x08, 0x08, 0x08, 0x09, 0x06,
;
;/* Code: 0xA4, ASCII Character: '�' */
;0x00, 0x00, 0x0A, 0x04, 0x0A, 0x00, 0x00,
;
;/* Code: 0xA5, ASCII Character: '�' */
;0x08, 0x0F, 0x01, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xA6, ASCII Character: '�' */
;0x04, 0x04, 0x04, 0x00, 0x04, 0x04, 0x04,
;
;/* Code: 0xA7, ASCII Character: '�' */
;0x0C, 0x12, 0x04, 0x0A, 0x04, 0x09, 0x06,
;
;/* Code: 0xA8, ASCII Character: '�' */
;0x0A, 0x1F, 0x01, 0x07, 0x01, 0x01, 0x1F,
;
;/* Code: 0xA9, ASCII Character: '�' */
;0x00, 0x0E, 0x15, 0x13, 0x13, 0x15, 0x0E,
;
;/* Code: 0xAA, ASCII Character: '�' */
;0x0E, 0x11, 0x01, 0x07, 0x01, 0x11, 0x0E,
;
;/* Code: 0xAB, ASCII Character: '�' */
;0x00, 0x00, 0x12, 0x09, 0x12, 0x00, 0x00,
;
;/* Code: 0xAC, ASCII Character: '�' */
;0x00, 0x00, 0x0F, 0x08, 0x00, 0x00, 0x00,
;
;/* Code: 0xAD, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00,
;
;/* Code: 0xAE, ASCII Character: '�' */
;0x0E, 0x11, 0x17, 0x1B, 0x17, 0x1B, 0x0E,
;
;/* Code: 0xAF, ASCII Character: '�' */
;0x00, 0x0A, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xB0, ASCII Character: '�' */
;0x04, 0x0A, 0x04, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xB1, ASCII Character: '�' */
;0x00, 0x04, 0x0E, 0x04, 0x00, 0x0E, 0x00,
;
;/* Code: 0xB2, ASCII Character: '�' */
;0x00, 0x00, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xB3, ASCII Character: '�' */
;0x00, 0x00, 0x04, 0x00, 0x04, 0x04, 0x04,
;
;/* Code: 0xB4, ASCII Character: '�' */
;0x00, 0x00, 0x08, 0x0E, 0x02, 0x02, 0x02,
;
;/* Code: 0xB5, ASCII Character: '�' */
;0x00, 0x09, 0x09, 0x09, 0x09, 0x17, 0x01,
;
;/* Code: 0xB6, ASCII Character: '�' */
;0x00, 0x0F, 0x0B, 0x0B, 0x0A, 0x0A, 0x0A,
;
;/* Code: 0xB7, ASCII Character: '�' */
;0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xB8, ASCII Character: '�' */
;0x09, 0x06, 0x09, 0x0F, 0x01, 0x09, 0x06,
;
;/* Code: 0xB9, ASCII Character: '�' */
;0x00, 0x09, 0x0B, 0x1D, 0x09, 0x19, 0x09,
;
;/* Code: 0xBA, ASCII Character: '�' */
;0x00, 0x00, 0x06, 0x01, 0x03, 0x01, 0x06,
;
;/* Code: 0xBB, ASCII Character: '�' */
;0x00, 0x00, 0x09, 0x12, 0x09, 0x00, 0x00,
;
;/* Code: 0xBC, ASCII Character: '�' */
;0x00, 0x04, 0x00, 0x04, 0x04, 0x04, 0x03,
;
;/* Code: 0xBD, ASCII Character: '�' */
;0x0E, 0x11, 0x02, 0x04, 0x08, 0x11, 0x0E,
;
;/* Code: 0xBE, ASCII Character: '�' */
;0x00, 0x06, 0x09, 0x02, 0x04, 0x09, 0x06,
;
;/* Code: 0xBF, ASCII Character: '�' */
;0x00, 0x00, 0x0A, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xC0, ASCII Character: '�' */
;0x04, 0x0A, 0x11, 0x11, 0x1F, 0x11, 0x11,
;
;/* Code: 0xC1, ASCII Character: '�' */
;0x1F, 0x01, 0x01, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0xC2, ASCII Character: '�' */
;0x0F, 0x11, 0x11, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0xC3, ASCII Character: '�' */
;0x1F, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xC4, ASCII Character: '�' */
;0x1C, 0x12, 0x12, 0x12, 0x12, 0x12, 0x1F,
;
;/* Code: 0xC5, ASCII Character: '�' */
;0x1F, 0x01, 0x01, 0x07, 0x01, 0x01, 0x1F,
;
;/* Code: 0xC6, ASCII Character: '�' */
;0x15, 0x15, 0x15, 0x0E, 0x15, 0x15, 0x15,
;
;/* Code: 0xC7, ASCII Character: '�' */
;0x0E, 0x11, 0x10, 0x0C, 0x10, 0x11, 0x0E,
;
;/* Code: 0xC8, ASCII Character: '�' */
;0x11, 0x11, 0x19, 0x15, 0x13, 0x11, 0x11,
;
;/* Code: 0xC9, ASCII Character: '�' */
;0x04, 0x11, 0x19, 0x15, 0x13, 0x11, 0x11,
;
;/* Code: 0xCA, ASCII Character: '�' */
;0x11, 0x09, 0x05, 0x03, 0x05, 0x09, 0x11,
;
;/* Code: 0xCB, ASCII Character: '�' */
;0x1C, 0x12, 0x12, 0x12, 0x12, 0x12, 0x11,
;
;/* Code: 0xCC, ASCII Character: '�' */
;0x11, 0x1B, 0x15, 0x11, 0x11, 0x11, 0x11,
;
;/* Code: 0xCD, ASCII Character: '�' */
;0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11,
;
;/* Code: 0xCE, ASCII Character: '�' */
;0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E,
;
;/* Code: 0xCF, ASCII Character: '�' */
;0x1F, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11,
;
;/* Code: 0xD0, ASCII Character: '�' */
;0x0F, 0x11, 0x11, 0x0F, 0x01, 0x01, 0x01,
;
;/* Code: 0xD1, ASCII Character: '�' */
;0x0E, 0x11, 0x01, 0x01, 0x01, 0x11, 0x0E,
;
;/* Code: 0xD2, ASCII Character: '�' */
;0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xD3, ASCII Character: '�' */
;0x11, 0x11, 0x11, 0x1E, 0x10, 0x11, 0x0E,
;
;/* Code: 0xD4, ASCII Character: '�' */
;0x0E, 0x15, 0x15, 0x15, 0x0E, 0x04, 0x04,
;
;/* Code: 0xD5, ASCII Character: '�' */
;0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11,
;
;/* Code: 0xD6, ASCII Character: '�' */
;0x11, 0x11, 0x11, 0x11, 0x11, 0x1F, 0x10,
;
;/* Code: 0xD7, ASCII Character: '�' */
;0x11, 0x11, 0x11, 0x11, 0x1E, 0x10, 0x10,
;
;/* Code: 0xD8, ASCII Character: '�' */
;0x11, 0x11, 0x15, 0x15, 0x15, 0x15, 0x1F,
;
;/* Code: 0xD9, ASCII Character: '�' */
;0x11, 0x11, 0x15, 0x15, 0x15, 0x1F, 0x10,
;
;/* Code: 0xDA, ASCII Character: '�' */
;0x03, 0x02, 0x02, 0x0E, 0x12, 0x12, 0x0E,
;
;/* Code: 0xDB, ASCII Character: '�' */
;0x11, 0x11, 0x11, 0x13, 0x15, 0x15, 0x13,
;
;/* Code: 0xDC, ASCII Character: '�' */
;0x01, 0x01, 0x01, 0x0F, 0x11, 0x11, 0x0F,
;
;/* Code: 0xDD, ASCII Character: '�' */
;0x0E, 0x11, 0x10, 0x1C, 0x10, 0x11, 0x0E,
;
;/* Code: 0xDE, ASCII Character: '�' */
;0x09, 0x15, 0x15, 0x17, 0x15, 0x15, 0x09,
;
;/* Code: 0xDF, ASCII Character: '�' */
;0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11,
;
;/* Code: 0xE0, ASCII Character: '�' */
;0x00, 0x06, 0x08, 0x0E, 0x09, 0x09, 0x16,
;
;/* Code: 0xE1, ASCII Character: '�' */
;0x00, 0x06, 0x01, 0x07, 0x09, 0x09, 0x06,
;
;/* Code: 0xE2, ASCII Character: '�' */
;0x00, 0x07, 0x09, 0x07, 0x09, 0x09, 0x07,
;
;/* Code: 0xE3, ASCII Character: '�' */
;0x00, 0x0F, 0x01, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xE4, ASCII Character: '�' */
;0x00, 0x0C, 0x0A, 0x0A, 0x0A, 0x0A, 0x1F,
;
;/* Code: 0xE5, ASCII Character: '�' */
;0x00, 0x06, 0x09, 0x09, 0x07, 0x01, 0x06,
;
;/* Code: 0xE6, ASCII Character: '�' */
;0x00, 0x15, 0x15, 0x0E, 0x15, 0x15, 0x15,
;
;/* Code: 0xE7, ASCII Character: '�' */
;0x00, 0x06, 0x09, 0x04, 0x08, 0x09, 0x06,
;
;/* Code: 0xE8, ASCII Character: '�' */
;0x00, 0x09, 0x09, 0x0D, 0x0B, 0x09, 0x09,
;
;/* Code: 0xE9, ASCII Character: '�' */
;0x00, 0x04, 0x09, 0x0D, 0x0B, 0x09, 0x09,
;
;/* Code: 0xEA, ASCII Character: '�' */
;0x00, 0x09, 0x05, 0x03, 0x05, 0x09, 0x09,
;
;/* Code: 0xEB, ASCII Character: '�' */
;0x00, 0x0E, 0x09, 0x09, 0x09, 0x09, 0x09,
;
;/* Code: 0xEC, ASCII Character: '�' */
;0x00, 0x11, 0x1B, 0x15, 0x11, 0x11, 0x11,
;
;/* Code: 0xED, ASCII Character: '�' */
;0x00, 0x09, 0x09, 0x0F, 0x09, 0x09, 0x09,
;
;/* Code: 0xEE, ASCII Character: '�' */
;0x00, 0x06, 0x09, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0xEF, ASCII Character: '�' */
;0x00, 0x0F, 0x09, 0x09, 0x09, 0x09, 0x09,
;
;/* Code: 0xF0, ASCII Character: '�' */
;0x00, 0x07, 0x09, 0x09, 0x07, 0x01, 0x01,
;
;/* Code: 0xF1, ASCII Character: '�' */
;0x00, 0x06, 0x09, 0x01, 0x01, 0x09, 0x06,
;
;/* Code: 0xF2, ASCII Character: '�' */
;0x00, 0x1F, 0x04, 0x04, 0x04, 0x04, 0x04,
;
;/* Code: 0xF3, ASCII Character: '�' */
;0x00, 0x09, 0x09, 0x09, 0x0E, 0x08, 0x06,
;
;/* Code: 0xF4, ASCII Character: '�' */
;0x00, 0x0E, 0x15, 0x15, 0x15, 0x0E, 0x04,
;
;/* Code: 0xF5, ASCII Character: '�' */
;0x00, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11,
;
;/* Code: 0xF6, ASCII Character: '�' */
;0x00, 0x09, 0x09, 0x09, 0x09, 0x1F, 0x10,
;
;/* Code: 0xF7, ASCII Character: '�' */
;0x00, 0x09, 0x09, 0x09, 0x0E, 0x08, 0x08,
;
;/* Code: 0xF8, ASCII Character: '�' */
;0x00, 0x11, 0x11, 0x15, 0x15, 0x15, 0x1F,
;
;/* Code: 0xF9, ASCII Character: '�' */
;0x00, 0x11, 0x11, 0x15, 0x15, 0x1F, 0x10,
;
;/* Code: 0xFA, ASCII Character: '�' */
;0x00, 0x03, 0x02, 0x0E, 0x12, 0x12, 0x0E,
;
;/* Code: 0xFB, ASCII Character: '�' */
;0x00, 0x11, 0x11, 0x13, 0x15, 0x15, 0x13,
;
;/* Code: 0xFC, ASCII Character: '�' */
;0x00, 0x01, 0x01, 0x07, 0x09, 0x09, 0x07,
;
;/* Code: 0xFD, ASCII Character: '�' */
;0x00, 0x06, 0x09, 0x0C, 0x08, 0x09, 0x06,
;
;/* Code: 0xFE, ASCII Character: '�' */
;0x00, 0x09, 0x15, 0x17, 0x15, 0x15, 0x09,
;
;/* Code: 0xFF, ASCII Character: '�' */
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
;/* Code: 0x80, ASCII Character: '�' */
;0x00, 0x02, 0x7E, 0x2A, 0x30,
;
;/* Code: 0x81, ASCII Character: '�' */
;0x00, 0x7E, 0x02, 0x03, 0x02,
;
;/* Code: 0x82, ASCII Character: '�' */
;0x00, 0x40, 0x20, 0x00, 0x00,
;
;/* Code: 0x83, ASCII Character: '�' */
;0x00, 0x78, 0x0C, 0x08, 0x00,
;
;/* Code: 0x84, ASCII Character: '�' */
;0x40, 0x20, 0x40, 0x20, 0x00,
;
;/* Code: 0x85, ASCII Character: '�' */
;0x00, 0x40, 0x40, 0x40, 0x00,
;
;/* Code: 0x86, ASCII Character: '�' */
;0x00, 0x04, 0x7E, 0x04, 0x00,
;
;/* Code: 0x87, ASCII Character: '�' */
;0x00, 0x24, 0x7E, 0x24, 0x00,
;
;/* Code: 0x88, ASCII Character: '�' */
;0x14, 0x3C, 0x56, 0x42, 0x24,
;
;/* Code: 0x89, ASCII Character: '�' */
;0x26, 0x16, 0x68, 0x64, 0x62,
;
;/* Code: 0x8A, ASCII Character: '�' */
;0x7E, 0x01, 0x7F, 0x48, 0x30,
;
;/* Code: 0x8B, ASCII Character: '�' */
;0x00, 0x08, 0x14, 0x00, 0x00,
;
;/* Code: 0x8C, ASCII Character: '�' */
;0x7F, 0x08, 0x7F, 0x48, 0x30,
;
;/* Code: 0x8D, ASCII Character: '�' */
;0x7E, 0x08, 0x15, 0x22, 0x40,
;
;/* Code: 0x8E, ASCII Character: '�' */
;0x02, 0x7E, 0x0A, 0x0A, 0x70,
;
;/* Code: 0x8F, ASCII Character: '�' */
;0x3F, 0x20, 0x60, 0x20, 0x3F,
;
;/* Code: 0x90, ASCII Character: '�' */
;0x02, 0x1F, 0x4A, 0x4A, 0x30,
;
;/* Code: 0x91, ASCII Character: '�' */
;0x00, 0x01, 0x02, 0x00, 0x00,
;
;/* Code: 0x92, ASCII Character: '�' */
;0x00, 0x02, 0x01, 0x00, 0x00,
;
;/* Code: 0x93, ASCII Character: '�' */
;0x00, 0x01, 0x02, 0x01, 0x02,
;
;/* Code: 0x94, ASCII Character: '�' */
;0x00, 0x02, 0x01, 0x02, 0x01,
;
;/* Code: 0x95, ASCII Character: '�' */
;0x04, 0x0E, 0x0E, 0x04, 0x00,
;
;/* Code: 0x96, ASCII Character: '�' */
;0x00, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0x97, ASCII Character: '�' */
;0x08, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0x98, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x99, ASCII Character: '�' */
;0x02, 0x0E, 0x02, 0x04, 0x0E,
;
;/* Code: 0x9A, ASCII Character: '�' */
;0x78, 0x04, 0x7C, 0x50, 0x20,
;
;/* Code: 0x9B, ASCII Character: '�' */
;0x00, 0x14, 0x08, 0x00, 0x00,
;
;/* Code: 0x9C, ASCII Character: '�' */
;0x7C, 0x10, 0x7C, 0x50, 0x20,
;
;/* Code: 0x9D, ASCII Character: '�' */
;0x7C, 0x10, 0x2A, 0x40, 0x00,
;
;/* Code: 0x9E, ASCII Character: '�' */
;0x7E, 0x24, 0x10, 0x60, 0x00,
;
;/* Code: 0x9F, ASCII Character: '�' */
;0x3C, 0x20, 0x60, 0x3C, 0x00,
;
;/* Code: 0xA0, ASCII Character: '�' */
;0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0xA1, ASCII Character: '�' */
;0x0E, 0x50, 0x51, 0x50, 0x3E,
;
;/* Code: 0xA2, ASCII Character: '�' */
;0x0E, 0x50, 0x51, 0x3E, 0x00,
;
;/* Code: 0xA3, ASCII Character: '�' */
;0x20, 0x40, 0x40, 0x3E, 0x00,
;
;/* Code: 0xA4, ASCII Character: '�' */
;0x00, 0x14, 0x08, 0x14, 0x00,
;
;/* Code: 0xA5, ASCII Character: '�' */
;0x7E, 0x02, 0x02, 0x03, 0x00,
;
;/* Code: 0xA6, ASCII Character: '�' */
;0x00, 0x00, 0x77, 0x00, 0x00,
;
;/* Code: 0xA7, ASCII Character: '�' */
;0x20, 0x4A, 0x55, 0x29, 0x02,
;
;/* Code: 0xA8, ASCII Character: '�' */
;0x7E, 0x4B, 0x4A, 0x43, 0x42,
;
;/* Code: 0xA9, ASCII Character: '�' */
;0x3C, 0x5A, 0x66, 0x42, 0x3C,
;
;/* Code: 0xAA, ASCII Character: '�' */
;0x3E, 0x49, 0x49, 0x41, 0x22,
;
;/* Code: 0xAB, ASCII Character: '�' */
;0x08, 0x14, 0x00, 0x08, 0x14,
;
;/* Code: 0xAC, ASCII Character: '�' */
;0x04, 0x04, 0x04, 0x0C, 0x00,
;
;/* Code: 0xAD, ASCII Character: '�' */
;0x00, 0x08, 0x08, 0x08, 0x00,
;
;/* Code: 0xAE, ASCII Character: '�' */
;0x3E, 0x7D, 0x55, 0x69, 0x3E,
;
;/* Code: 0xAF, ASCII Character: '�' */
;0x00, 0x02, 0x7C, 0x02, 0x00,
;
;/* Code: 0xB0, ASCII Character: '�' */
;0x00, 0x02, 0x05, 0x02, 0x00,
;
;/* Code: 0xB1, ASCII Character: '�' */
;0x00, 0x24, 0x2E, 0x24, 0x00,
;
;/* Code: 0xB2, ASCII Character: '�' */
;0x00, 0x00, 0x7C, 0x00, 0x00,
;
;/* Code: 0xB3, ASCII Character: '�' */
;0x00, 0x00, 0x74, 0x00, 0x00,
;
;/* Code: 0xB4, ASCII Character: '�' */
;0x00, 0x78, 0x08, 0x0C, 0x00,
;
;/* Code: 0xB5, ASCII Character: '�' */
;0x7E, 0x20, 0x20, 0x1E, 0x20,
;
;/* Code: 0xB6, ASCII Character: '�' */
;0x0E, 0x7E, 0x02, 0x7E, 0x00,
;
;/* Code: 0xB7, ASCII Character: '�' */
;0x00, 0x00, 0x02, 0x00, 0x00,
;
;/* Code: 0xB8, ASCII Character: '�' */
;0x3D, 0x4A, 0x4A, 0x2D, 0x00,
;
;/* Code: 0xB9, ASCII Character: '�' */
;0x7E, 0x04, 0x08, 0x7E, 0x28,
;
;/* Code: 0xBA, ASCII Character: '�' */
;0x38, 0x54, 0x44, 0x00, 0x00,
;
;/* Code: 0xBB, ASCII Character: '�' */
;0x14, 0x08, 0x00, 0x14, 0x08,
;
;/* Code: 0xBC, ASCII Character: '�' */
;0x40, 0x40, 0x3A, 0x00, 0x00,
;
;/* Code: 0xBD, ASCII Character: '�' */
;0x22, 0x45, 0x49, 0x51, 0x22,
;
;/* Code: 0xBE, ASCII Character: '�' */
;0x24, 0x4A, 0x52, 0x24, 0x00,
;
;/* Code: 0xBF, ASCII Character: '�' */
;0x00, 0x04, 0x78, 0x04, 0x00,
;
;/* Code: 0xC0, ASCII Character: '�' */
;0x7C, 0x12, 0x11, 0x12, 0x7C,
;
;/* Code: 0xC1, ASCII Character: '�' */
;0x7F, 0x49, 0x49, 0x49, 0x31,
;
;/* Code: 0xC2, ASCII Character: '�' */
;0x7F, 0x49, 0x49, 0x49, 0x36,
;
;/* Code: 0xC3, ASCII Character: '�' */
;0x7F, 0x01, 0x01, 0x01, 0x01,
;
;/* Code: 0xC4, ASCII Character: '�' */
;0x40, 0x7E, 0x41, 0x41, 0x7F,
;
;/* Code: 0xC5, ASCII Character: '�' */
;0x7F, 0x49, 0x49, 0x41, 0x41,
;
;/* Code: 0xC6, ASCII Character: '�' */
;0x77, 0x08, 0x7F, 0x08, 0x77,
;
;/* Code: 0xC7, ASCII Character: '�' */
;0x22, 0x41, 0x49, 0x49, 0x36,
;
;/* Code: 0xC8, ASCII Character: '�' */
;0x7F, 0x10, 0x08, 0x04, 0x7F,
;
;/* Code: 0xC9, ASCII Character: '�' */
;0x7E, 0x10, 0x09, 0x04, 0x7E,
;
;/* Code: 0xCA, ASCII Character: '�' */
;0x7F, 0x08, 0x14, 0x22, 0x41,
;
;/* Code: 0xCB, ASCII Character: '�' */
;0x40, 0x3E, 0x01, 0x01, 0x7F,
;
;/* Code: 0xCC, ASCII Character: '�' */
;0x7F, 0x02, 0x04, 0x02, 0x7F,
;
;/* Code: 0xCD, ASCII Character: '�' */
;0x7F, 0x08, 0x08, 0x08, 0x7F,
;
;/* Code: 0xCE, ASCII Character: '�' */
;0x3E, 0x41, 0x41, 0x41, 0x3E,
;
;/* Code: 0xCF, ASCII Character: '�' */
;0x7F, 0x01, 0x01, 0x01, 0x7F,
;
;/* Code: 0xD0, ASCII Character: '�' */
;0x7F, 0x09, 0x09, 0x09, 0x06,
;
;/* Code: 0xD1, ASCII Character: '�' */
;0x3E, 0x41, 0x41, 0x41, 0x22,
;
;/* Code: 0xD2, ASCII Character: '�' */
;0x01, 0x01, 0x7F, 0x01, 0x01,
;
;/* Code: 0xD3, ASCII Character: '�' */
;0x27, 0x48, 0x48, 0x48, 0x3F,
;
;/* Code: 0xD4, ASCII Character: '�' */
;0x0E, 0x11, 0x7F, 0x11, 0x0E,
;
;/* Code: 0xD5, ASCII Character: '�' */
;0x63, 0x14, 0x08, 0x14, 0x63,
;
;/* Code: 0xD6, ASCII Character: '�' */
;0x3F, 0x20, 0x20, 0x20, 0x7F,
;
;/* Code: 0xD7, ASCII Character: '�' */
;0x0F, 0x10, 0x10, 0x10, 0x7F,
;
;/* Code: 0xD8, ASCII Character: '�' */
;0x7F, 0x40, 0x7C, 0x40, 0x7F,
;
;/* Code: 0xD9, ASCII Character: '�' */
;0x3F, 0x20, 0x3C, 0x20, 0x7F,
;
;/* Code: 0xDA, ASCII Character: '�' */
;0x01, 0x7F, 0x48, 0x48, 0x30,
;
;/* Code: 0xDB, ASCII Character: '�' */
;0x7F, 0x48, 0x30, 0x00, 0x7F,
;
;/* Code: 0xDC, ASCII Character: '�' */
;0x7F, 0x48, 0x48, 0x48, 0x30,
;
;/* Code: 0xDD, ASCII Character: '�' */
;0x22, 0x41, 0x49, 0x49, 0x3E,
;
;/* Code: 0xDE, ASCII Character: '�' */
;0x7F, 0x08, 0x3E, 0x41, 0x3E,
;
;/* Code: 0xDF, ASCII Character: '�' */
;0x46, 0x29, 0x19, 0x09, 0x7F,
;
;/* Code: 0xE0, ASCII Character: '�' */
;0x30, 0x4A, 0x4A, 0x3C, 0x40,
;
;/* Code: 0xE1, ASCII Character: '�' */
;0x3C, 0x4A, 0x4A, 0x30, 0x00,
;
;/* Code: 0xE2, ASCII Character: '�' */
;0x7E, 0x4A, 0x4A, 0x34, 0x00,
;
;/* Code: 0xE3, ASCII Character: '�' */
;0x7E, 0x02, 0x02, 0x02, 0x00,
;
;/* Code: 0xE4, ASCII Character: '�' */
;0x40, 0x7C, 0x42, 0x7E, 0x40,
;
;/* Code: 0xE5, ASCII Character: '�' */
;0x3C, 0x52, 0x52, 0x0C, 0x00,
;
;/* Code: 0xE6, ASCII Character: '�' */
;0x76, 0x08, 0x7E, 0x08, 0x76,
;
;/* Code: 0xE7, ASCII Character: '�' */
;0x24, 0x42, 0x4A, 0x34, 0x00,
;
;/* Code: 0xE8, ASCII Character: '�' */
;0x7E, 0x10, 0x08, 0x7E, 0x00,
;
;/* Code: 0xE9, ASCII Character: '�' */
;0x7C, 0x10, 0x0A, 0x7C, 0x00,
;
;/* Code: 0xEA, ASCII Character: '�' */
;0x7E, 0x08, 0x14, 0x62, 0x00,
;
;/* Code: 0xEB, ASCII Character: '�' */
;0x7C, 0x02, 0x02, 0x7E, 0x00,
;
;/* Code: 0xEC, ASCII Character: '�' */
;0x7E, 0x04, 0x08, 0x04, 0x7E,
;
;/* Code: 0xED, ASCII Character: '�' */
;0x7E, 0x08, 0x08, 0x7E, 0x00,
;
;/* Code: 0xEE, ASCII Character: '�' */
;0x3C, 0x42, 0x42, 0x3C, 0x00,
;
;/* Code: 0xEF, ASCII Character: '�' */
;0x7E, 0x02, 0x02, 0x7E, 0x00,
;
;/* Code: 0xF0, ASCII Character: '�' */
;0x7E, 0x12, 0x12, 0x0C, 0x00,
;
;/* Code: 0xF1, ASCII Character: '�' */
;0x3C, 0x42, 0x42, 0x24, 0x00,
;
;/* Code: 0xF2, ASCII Character: '�' */
;0x02, 0x02, 0x7E, 0x02, 0x02,
;
;/* Code: 0xF3, ASCII Character: '�' */
;0x0E, 0x50, 0x50, 0x3E, 0x00,
;
;/* Code: 0xF4, ASCII Character: '�' */
;0x1C, 0x22, 0x7E, 0x22, 0x1C,
;
;/* Code: 0xF5, ASCII Character: '�' */
;0x62, 0x14, 0x08, 0x14, 0x62,
;
;/* Code: 0xF6, ASCII Character: '�' */
;0x3E, 0x20, 0x20, 0x3E, 0x60,
;
;/* Code: 0xF7, ASCII Character: '�' */
;0x0E, 0x10, 0x10, 0x7E, 0x00,
;
;/* Code: 0xF8, ASCII Character: '�' */
;0x7E, 0x40, 0x78, 0x40, 0x7E,
;
;/* Code: 0xF9, ASCII Character: '�' */
;0x3E, 0x20, 0x38, 0x20, 0x7E,
;
;/* Code: 0xFA, ASCII Character: '�' */
;0x02, 0x7E, 0x48, 0x48, 0x30,
;
;/* Code: 0xFB, ASCII Character: '�' */
;0x7E, 0x48, 0x30, 0x00, 0x7E,
;
;/* Code: 0xFC, ASCII Character: '�' */
;0x7E, 0x48, 0x48, 0x30, 0x00,
;
;/* Code: 0xFD, ASCII Character: '�' */
;0x24, 0x42, 0x4A, 0x3C, 0x00,
;
;/* Code: 0xFE, ASCII Character: '�' */
;0x7E, 0x08, 0x3C, 0x42, 0x3C,
;
;/* Code: 0xFF, ASCII Character: '�' */
;0x4C, 0x32, 0x12, 0x7E, 0x00,
;
;#endif
;};
;
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
	RJMP _0x20E0003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x20E000A
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	SBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x20E000A
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
	RJMP _0x20E0002
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
	RJMP _0x20E0003
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
	RJMP _0x20E0003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	RCALL SUBOPT_0x8
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x20E000A
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0x9
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
	RCALL SUBOPT_0xA
	SBIW R30,0
	BREQ _0x2000008
	RCALL SUBOPT_0xA
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0xA
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	RCALL SUBOPT_0xA
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	RCALL SUBOPT_0xB
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0xC
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	RCALL __GETW1P
	RJMP _0x20000A0
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(192)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
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
	RCALL SUBOPT_0x1
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x20E0009
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
_0x20E000A:
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
	RCALL SUBOPT_0xE
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x20E0001
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
_0x20E0009:
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
	RJMP _0x20E0008
_0x200002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0xF
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
	RJMP _0x20E0008
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x20E0008
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
	RCALL SUBOPT_0x10
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x11
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
	RCALL SUBOPT_0x12
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
	RCALL SUBOPT_0x11
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
	RCALL SUBOPT_0x12
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x11
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
	RCALL SUBOPT_0x11
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
	RCALL SUBOPT_0x13
	RCALL _pcd8544_gotoxy
	RJMP _0x2000050
_0x200005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2000050
	RCALL SUBOPT_0x13
	RCALL _pcd8544_setaddr_G100
_0x2000050:
_0x200005D:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x200005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2000060
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x1
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
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x13
	RCALL _pcd8544_setaddr_G100
_0x200007D:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	RCALL SUBOPT_0x8
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	RCALL SUBOPT_0x19
	MOV  R30,R19
	MOV  R26,R20
	RCALL __LSRB12
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1
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
	RCALL SUBOPT_0x17
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	MOV  R21,R30
_0x2000084:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x2000086
	RCALL SUBOPT_0x18
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000084
_0x2000086:
	RJMP _0x200007B
_0x2000087:
_0x2000088:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x200008A
	RCALL SUBOPT_0x1B
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	RCALL SUBOPT_0x1C
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
	RCALL SUBOPT_0x11
_0x2000076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000091
	RCALL SUBOPT_0x13
	RCALL _pcd8544_setaddr_G100
_0x2000092:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	RCALL SUBOPT_0x8
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSLB12
	RCALL SUBOPT_0x19
	MOV  R30,R18
	MOV  R26,R20
	RCALL __LSLB12
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1
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
	RCALL SUBOPT_0x17
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	MOV  R21,R30
_0x2000099:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x200009B
	RCALL SUBOPT_0x18
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000099
_0x200009B:
	RJMP _0x2000090
_0x200009C:
_0x200009D:
	PUSH R17
	RCALL SUBOPT_0x14
	POP  R26
	CP   R26,R30
	BRSH _0x200009F
	RCALL SUBOPT_0x1B
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	RCALL SUBOPT_0x1C
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
_0x20E0008:
	RCALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x1D
	BRLT _0x2020003
	RCALL SUBOPT_0xD
	RJMP _0x20E0003
_0x2020003:
	RCALL SUBOPT_0x1E
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x20E0003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x20E0003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x1D
	BRLT _0x2020005
	RCALL SUBOPT_0xD
	RJMP _0x20E0003
_0x2020005:
	RCALL SUBOPT_0x1E
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x20E0003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x20E0003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	RCALL SUBOPT_0x9
	SBIW R28,3
	RCALL SUBOPT_0x1F
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	RCALL SUBOPT_0xD
	RJMP _0x20E0007
_0x202000B:
	RCALL SUBOPT_0x20
	STD  Y+7,R0
	RCALL SUBOPT_0x20
	STD  Y+6,R0
	RCALL SUBOPT_0x20
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	RCALL SUBOPT_0xD
	RJMP _0x20E0007
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
	RCALL SUBOPT_0xD
	RJMP _0x20E0007
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
	RCALL SUBOPT_0x10
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x10
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x20E0007
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
	RCALL SUBOPT_0x10
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x20E0007:
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
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0xF
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0xF
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x1F
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
	BRNE _0x2020022
	RCALL __LOADLOCR6
	RJMP _0x20E0006
_0x2020022:
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
	RCALL SUBOPT_0x22
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x21
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
	RCALL SUBOPT_0x22
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x21
	ST   -Y,R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x23
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x21
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x23
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RCALL __LOADLOCR6
	RJMP _0x20E0006
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
	RCALL __LOADLOCR6
	RJMP _0x20E0006
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	RCALL SUBOPT_0x24
_0x2020025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
	RJMP _0x20E0004
; .FEND
_glcd_outtextxyf:
; .FSTART _glcd_outtextxyf
	RCALL SUBOPT_0x24
_0x2020028:
	RCALL SUBOPT_0x25
	BREQ _0x202002A
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020028
_0x202002A:
	LDD  R17,Y+0
	RJMP _0x20E0004
; .FEND
_glcd_outtextf:
; .FSTART _glcd_outtextf
	RCALL SUBOPT_0x9
	ST   -Y,R17
_0x2020031:
	RCALL SUBOPT_0x25
	BREQ _0x2020033
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020031
_0x2020033:
	LDD  R17,Y+0
	RJMP _0x20E0002
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
	RJMP _0x20E0003
; .FEND
_glcd_corners_G101:
; .FSTART _glcd_corners_G101
	RCALL SUBOPT_0x9
	RCALL __SAVELOCR6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R17,Z+3
	LDD  R16,Z+1
	LDD  R19,Z+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X
	CP   R16,R17
	BRSH _0x2020066
	MOV  R21,R16
	MOV  R16,R17
	MOV  R17,R21
_0x2020066:
	CP   R18,R19
	BRSH _0x2020067
	MOV  R21,R18
	MOV  R18,R19
	MOV  R19,R21
_0x2020067:
	MOV  R30,R17
	__PUTB1SNS 6,3
	MOV  R30,R19
	__PUTB1SNS 6,2
	MOV  R30,R16
	__PUTB1SNS 6,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R18
	RCALL __LOADLOCR6
	RJMP _0x20E0006
; .FEND
_glcd_barrel:
; .FSTART _glcd_barrel
	ST   -Y,R26
	RCALL __SAVELOCR4
	LDD  R26,Y+7
	CPI  R26,LOW(0x54)
	BRSH _0x20200ED
	LDD  R26,Y+6
	CPI  R26,LOW(0x30)
	BRLO _0x20200EC
_0x20200ED:
	RJMP _0x20E0005
_0x20200EC:
	LDD  R30,Y+5
	CPI  R30,0
	BREQ _0x20200F0
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x20200F1
_0x20200F0:
	RJMP _0x20200EF
_0x20200F1:
	LDD  R19,Y+6
	MOV  R30,R19
	LDD  R26,Y+4
	ADD  R30,R26
	STD  Y+4,R30
	LDD  R30,Y+7
	LDD  R26,Y+5
	ADD  R30,R26
	STD  Y+5,R30
_0x20200F2:
	LDD  R30,Y+4
	CP   R19,R30
	BRSH _0x20200F4
	SUB  R30,R19
	MOV  R18,R30
	CPI  R18,9
	BRLO _0x20200F5
	LDI  R18,LOW(8)
_0x20200F5:
	LDD  R17,Y+7
_0x20200F6:
	LDD  R30,Y+5
	CP   R17,R30
	BRSH _0x20200F8
	SUB  R30,R17
	MOV  R16,R30
	CPI  R16,9
	BRLO _0x20200F9
	LDI  R16,LOW(8)
_0x20200F9:
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	ST   -Y,R18
	RCALL SUBOPT_0xE
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0x1
	LDI  R26,LOW(8)
	RCALL _glcd_block
	ADD  R17,R16
	RJMP _0x20200F6
_0x20200F8:
	ADD  R19,R18
	RJMP _0x20200F2
_0x20200F4:
_0x20200EF:
_0x20E0005:
	RCALL __LOADLOCR4
_0x20E0006:
	ADIW R28,8
	RET
; .FEND
_glcd_bar:
; .FSTART _glcd_bar
	ST   -Y,R26
	MOVW R26,R28
	RCALL _glcd_corners_G101
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+3
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x26
	MOV  R26,R30
	RCALL _glcd_barrel
	RJMP _0x20E0001
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	RCALL SUBOPT_0x9
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
_memset:
; .FSTART _memset
	RCALL SUBOPT_0x9
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
_0x20E0004:
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
_0x20E0003:
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
	RJMP _0x20E0002
_0x208000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x208000E:
	CPI  R17,0
	BRNE _0x2080011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x20E0002
_0x2080011:
_0x2080005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x20E0002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0x9
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2080015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x20E0002
_0x2080015:
	CPI  R30,LOW(0x2)
	BRNE _0x2080016
	RCALL SUBOPT_0x1E
	RCALL __EEPROMRDB
	RJMP _0x20E0002
_0x2080016:
	CPI  R30,LOW(0x3)
	BRNE _0x2080018
	RCALL SUBOPT_0x1E
	__CALL1MN _glcd_state,25
	RJMP _0x20E0002
_0x2080018:
	RCALL SUBOPT_0x1E
	LD   R30,X
_0x20E0002:
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
	RCALL SUBOPT_0x1
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x208001B:
_0x20E0001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	__PUTB1MN _glcd_state,16
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x1
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R16
	LDD  R26,Y+16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	SUBI R17,-1
	LDD  R30,Y+14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x15:
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
SUBOPT_0x16:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ST   -Y,R21
	LDD  R26,Y+10
	RJMP _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
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
SUBOPT_0x1A:
	COM  R30
	AND  R30,R1
	OR   R21,R30
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1B:
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
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RJMP _pcd8544_wrmasked_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x9
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x21:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1
	LDI  R26,LOW(9)
	RJMP _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x9
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RJMP _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R30,Y+3
	SUB  R30,R26
	SUBI R30,-LOW(1)
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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

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