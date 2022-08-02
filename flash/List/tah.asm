
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny2313
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : No
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
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
	.EQU WDTCSR=0x21
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
	.DEF _led_l=R3
	.DEF _led_h=R2

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
	RJMP _int0
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_OVF
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

_0x3:
	.DB  0x6B,0x59,0xFB,0xF1
_0x4:
	.DB  0xBD,0xC,0xBA,0xAE,0xF,0xA7,0xB7,0x2C
	.DB  0xBF,0xAF,0x0,0x2,0xA7,0x93,0xBD,0x3B
_0x5:
	.DB  0x0,0x2,0x3,0x13,0x1B,0x1F,0x9F

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _ch
	.DW  _0x4*2

	.DW  0x07
	.DW  _leds
	.DW  _0x5*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
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
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define START_TIMER           TCCR1B=0x02
;#define STOP_TIMER            TCCR1B=0x00
;#define TIMER                 (TCNT1L+(TCNT1H<<8))
;#define CLR_TIMER_RPM         TCNT1H=0;TCNT1L=0
;#define NO_PULSE              60000
;
;#define CHR_PORT              PORTB
;#define NUM_PORT              PORTD
;#define ALL_NUM               0xCC
;#define LED_LOW               6
;#define LED_HI                3
;#define NUM_1                 5
;#define NUM_2                 1
;#define NUM_3                 0
;#define NUM_4                 4
;#define SBI(BYTE,BIT)         BYTE|=(1<<BIT)
;#define CBI(BYTE,BIT)         BYTE&=~(1<<BIT)
;#define LED_delay             200
;
;bit
;start,
;process,
;refresh;
;
;#pragma used+
;//__eeprom unsigned char
;unsigned char
;stop[4]={
;         0x6B,
;         0x59,
;         0xFB,
;         0xF1
;         },

	.DSEG
;ch[16] = {
;        0xBD,     //0
;        0x0C,     //1
;        0xBA,     //2
;        0xAE,     //3
;        0x0F,     //4
;        0xA7,     //5
;        0xB7,     //6
;        0x2C,     //7
;        0xBF,     //8
;        0xAF,     //9
;        0x00,     //blank
;        0x02,     //-
;        0xA7,     // S    12
;        0x93,     // T    13
;        0xBD,     // O    14
;        0x3B      // P    15
;                },
;leds[7]={
;         0x00,    //0 - leds
;         0x02,    //1 - led
;         0x03,    //2 - leds
;         0x13,    //3 - leds
;         0x1B,    //4 - leds
;         0x1F,    //5 - leds
;         0x9F,    //6 - leds
;         };
;#pragma used-
;
;unsigned char
;number[4],
;led_l,
;led_h;
;
;long
;data;
;
;void initdev()
; 0000 004B {

	.CSEG
_initdev:
; .FSTART _initdev
; 0000 004C  DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 004D  DDRD=0xFB;
	LDI  R30,LOW(251)
	OUT  0x11,R30
; 0000 004E 
; 0000 004F  PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0050  PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0051 
; 0000 0052  MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0053  GIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0054 
; 0000 0055  TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0056  TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0057  TCCR1B=0x02;
	OUT  0x2E,R30
; 0000 0058 }
	RET
; .FEND
;
;void RefreshDisplay()
; 0000 005B {
_RefreshDisplay:
; .FSTART _RefreshDisplay
; 0000 005C  CHR_PORT=leds[led_l];
	LDI  R26,LOW(_leds)
	ADD  R26,R3
	LD   R30,X
	OUT  0x18,R30
; 0000 005D  CBI(NUM_PORT,LED_LOW);
	CBI  0x12,6
; 0000 005E  delay_us(LED_delay);
	RCALL SUBOPT_0x0
; 0000 005F  SBI(NUM_PORT,LED_LOW);
	SBI  0x12,6
; 0000 0060 
; 0000 0061  CHR_PORT=leds[led_h];
	LDI  R26,LOW(_leds)
	ADD  R26,R2
	LD   R30,X
	OUT  0x18,R30
; 0000 0062  CBI(NUM_PORT,LED_HI);
	CBI  0x12,3
; 0000 0063  delay_us(LED_delay);
	RCALL SUBOPT_0x0
; 0000 0064  SBI(NUM_PORT,LED_HI);
	SBI  0x12,3
; 0000 0065 
; 0000 0066 
; 0000 0067  CHR_PORT=ch[number[0]];
	LDS  R30,_number
	RCALL SUBOPT_0x1
; 0000 0068  CBI(NUM_PORT,NUM_1);
	CBI  0x12,5
; 0000 0069  delay_us(LED_delay);
	RCALL SUBOPT_0x0
; 0000 006A  SBI(NUM_PORT,NUM_1);
	SBI  0x12,5
; 0000 006B 
; 0000 006C  CHR_PORT=ch[number[1]];
	__GETB1MN _number,1
	RCALL SUBOPT_0x1
; 0000 006D  CBI(NUM_PORT,NUM_2);
	CBI  0x12,1
; 0000 006E  delay_us(LED_delay);
	RCALL SUBOPT_0x0
; 0000 006F  SBI(NUM_PORT,NUM_2);
	SBI  0x12,1
; 0000 0070 
; 0000 0071  CHR_PORT=ch[number[2]];
	__GETB1MN _number,2
	RCALL SUBOPT_0x1
; 0000 0072  CBI(NUM_PORT,NUM_3);
	CBI  0x12,0
; 0000 0073  delay_us(LED_delay);
	RCALL SUBOPT_0x0
; 0000 0074  SBI(NUM_PORT,NUM_3);
	SBI  0x12,0
; 0000 0075 
; 0000 0076  CHR_PORT=ch[number[3]];
	__GETB1MN _number,3
	RCALL SUBOPT_0x1
; 0000 0077  CBI(NUM_PORT,NUM_4);
	CBI  0x12,4
; 0000 0078  delay_us(LED_delay);
	RCALL SUBOPT_0x0
; 0000 0079  SBI(NUM_PORT,NUM_4);
	SBI  0x12,4
; 0000 007A }
	RET
; .FEND
;
;int  conv(unsigned int len_imp)
; 0000 007D {
_conv:
; .FSTART _conv
; 0000 007E  float f;
; 0000 007F  int tmp;
; 0000 0080 
; 0000 0081  if(len_imp==0) return 0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	RCALL __SAVELOCR2
;	len_imp -> Y+6
;	f -> Y+2
;	tmp -> R16,R17
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2000001
; 0000 0082  f=((float)1000000)/len_imp;
_0x6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x49742400
	RCALL SUBOPT_0x2
; 0000 0083  f/=2;
	__GETD1N 0x40000000
	RCALL SUBOPT_0x2
; 0000 0084  f*=60;
	__GETD1N 0x42700000
	RCALL __MULF12
	__PUTD1S 2
; 0000 0085  tmp=f;
	RCALL __CFD1
	MOVW R16,R30
; 0000 0086  tmp/=50;
	MOVW R26,R16
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL __DIVW21
	MOVW R16,R30
; 0000 0087  tmp*=50;
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	RCALL __MULW12
	MOVW R16,R30
; 0000 0088  return tmp;
_0x2000001:
	RCALL __LOADLOCR2
	ADIW R28,8
	RET
; 0000 0089 }
; .FEND
;
;void PrepareData(unsigned int rpm)
; 0000 008C {
_PrepareData:
; .FSTART _PrepareData
; 0000 008D  unsigned int r=0;
; 0000 008E  unsigned char i=0;
; 0000 008F 
; 0000 0090       if(rpm>6000)
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR4
;	rpm -> Y+4
;	r -> R16,R17
;	i -> R19
	__GETWRN 16,17,0
	LDI  R19,0
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x1771)
	LDI  R30,HIGH(0x1771)
	CPC  R27,R30
	BRLO _0x7
; 0000 0091         {
; 0000 0092          rpm=5999;
	LDI  R30,LOW(5999)
	LDI  R31,HIGH(5999)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0093          }
; 0000 0094  r=rpm;
_0x7:
	__GETWRS 16,17,4
; 0000 0095 
; 0000 0096       if(rpm>3000)
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLO _0x8
; 0000 0097          {
; 0000 0098           led_l=6;
	LDI  R30,LOW(6)
	MOV  R3,R30
; 0000 0099           led_h=(rpm/500)-6;
	RCALL SUBOPT_0x4
	SUBI R30,LOW(6)
	MOV  R2,R30
; 0000 009A             }
; 0000 009B       else
	RJMP _0x9
_0x8:
; 0000 009C           {
; 0000 009D            led_l=rpm/500;
	RCALL SUBOPT_0x4
	MOV  R3,R30
; 0000 009E            led_h=0;
	CLR  R2
; 0000 009F             }
_0x9:
; 0000 00A0 
; 0000 00A1 
; 0000 00A2       for(i=0; i<4; i++)
	LDI  R19,LOW(0)
_0xB:
	CPI  R19,4
	BRSH _0xC
; 0000 00A3       {
; 0000 00A4        number[3-i]=rpm%10;
	LDI  R30,LOW(3)
	SUB  R30,R19
	SUBI R30,-LOW(_number)
	MOV  R18,R30
	RCALL SUBOPT_0x3
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R26,R18
	ST   X,R30
; 0000 00A5        rpm/=10;
	RCALL SUBOPT_0x3
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00A6       }
	SUBI R19,-1
	RJMP _0xB
_0xC:
; 0000 00A7 
; 0000 00A8       //Пустые символы
; 0000 00A9       if(r<10)
	__CPWRN 16,17,10
	BRSH _0xD
; 0000 00AA       {
; 0000 00AB        number[0]=10;
	RCALL SUBOPT_0x5
; 0000 00AC        number[1]=10;
; 0000 00AD        number[2]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _number,2
; 0000 00AE        goto exit;
	RJMP _0xE
; 0000 00AF       }
; 0000 00B0 
; 0000 00B1       if((r>=10)&(r<100))
_0xD:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __GEW12U
	MOV  R0,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __LTW12U
	AND  R30,R0
	BREQ _0xF
; 0000 00B2       {
; 0000 00B3        number[0]=10;
	RCALL SUBOPT_0x5
; 0000 00B4        number[1]=10;
; 0000 00B5        goto exit;
	RJMP _0xE
; 0000 00B6       }
; 0000 00B7 
; 0000 00B8       if((r>=100)&(r<1000))
_0xF:
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __GEW12U
	MOV  R0,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __LTW12U
	AND  R30,R0
	BREQ _0x10
; 0000 00B9       {
; 0000 00BA        number[0]=10;
	LDI  R30,LOW(10)
	STS  _number,R30
; 0000 00BB        goto exit;
; 0000 00BC       }
; 0000 00BD       exit:
_0x10:
_0xE:
; 0000 00BE }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;void chk_OVF_T1()
; 0000 00C1 {
_chk_OVF_T1:
; .FSTART _chk_OVF_T1
; 0000 00C2      if(TIFR&0x80)
	IN   R30,0x38
	SBRS R30,7
	RJMP _0x11
; 0000 00C3         {
; 0000 00C4          start=0;
	CBI  0x13,0
; 0000 00C5          process=0;
	CBI  0x13,1
; 0000 00C6          SBI(TIFR,TOV1);
	IN   R30,0x38
	ORI  R30,0x80
	OUT  0x38,R30
; 0000 00C7            }
; 0000 00C8 }
_0x11:
	RET
; .FEND
;
;void WD()
; 0000 00CB {
_WD:
; .FSTART _WD
; 0000 00CC  #asm("cli")
	cli
; 0000 00CD  #asm("wdr")
	wdr
; 0000 00CE  WDTCSR |= (1<<WDCE) | (1<<WDE);
	IN   R30,0x21
	ORI  R30,LOW(0x18)
	OUT  0x21,R30
; 0000 00CF  WDTCSR = (1<<WDE) | (1<<WDP2) | (1<<WDP0);
	LDI  R30,LOW(13)
	OUT  0x21,R30
; 0000 00D0  #asm("sei")
	sei
; 0000 00D1 }
	RET
; .FEND
;
;void main()
; 0000 00D4 {
_main:
; .FSTART _main
; 0000 00D5  static unsigned int
; 0000 00D6  dat;
; 0000 00D7 
; 0000 00D8  initdev();
	RCALL _initdev
; 0000 00D9  WD();
	RCALL _WD
; 0000 00DA   #asm ("sei")
	sei
; 0000 00DB 
; 0000 00DC    while (1)
_0x16:
; 0000 00DD   {
; 0000 00DE     chk_OVF_T1();
	RCALL _chk_OVF_T1
; 0000 00DF     #asm("wdr")
	wdr
; 0000 00E0 
; 0000 00E1       if(start)
	SBIS 0x13,0
	RJMP _0x19
; 0000 00E2         {
; 0000 00E3             if(refresh)
	SBIS 0x13,2
	RJMP _0x1A
; 0000 00E4               {
; 0000 00E5                dat=conv(data);
	LDS  R26,_data
	LDS  R27,_data+1
	RCALL _conv
	STS  _dat_S0000006000,R30
	STS  _dat_S0000006000+1,R31
; 0000 00E6                PrepareData(dat);
	LDS  R26,_dat_S0000006000
	LDS  R27,_dat_S0000006000+1
	RCALL _PrepareData
; 0000 00E7                refresh=0;
	CBI  0x13,2
; 0000 00E8                GIMSK|=(1<<INT0);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00E9                START_TIMER;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 00EA                }
; 0000 00EB 
; 0000 00EC          RefreshDisplay();
_0x1A:
	RJMP _0x3D
; 0000 00ED           }
; 0000 00EE       else
_0x19:
; 0000 00EF         {
; 0000 00F0            if(refresh)
	SBIS 0x13,2
	RJMP _0x1E
; 0000 00F1             {
; 0000 00F2               led_l++;
	INC  R3
; 0000 00F3 
; 0000 00F4                  if(led_l>6)
	LDI  R30,LOW(6)
	CP   R30,R3
	BRSH _0x1F
; 0000 00F5                    {
; 0000 00F6                     led_h++;
	INC  R2
; 0000 00F7                     led_l=6;
	MOV  R3,R30
; 0000 00F8 
; 0000 00F9                       if(led_h>6)
	CP   R30,R2
	BRSH _0x20
; 0000 00FA                       {
; 0000 00FB                        led_l=0;
	CLR  R3
; 0000 00FC                        led_h=0;
	CLR  R2
; 0000 00FD                       }
; 0000 00FE 
; 0000 00FF                    }
_0x20:
; 0000 0100               refresh=0;
_0x1F:
	CBI  0x13,2
; 0000 0101                       }
; 0000 0102          number[0]=12;
_0x1E:
	LDI  R30,LOW(12)
	STS  _number,R30
; 0000 0103          number[1]=13;
	LDI  R30,LOW(13)
	__PUTB1MN _number,1
; 0000 0104          number[2]=14;
	LDI  R30,LOW(14)
	__PUTB1MN _number,2
; 0000 0105          number[3]=15;
	LDI  R30,LOW(15)
	__PUTB1MN _number,3
; 0000 0106          RefreshDisplay();
_0x3D:
	RCALL _RefreshDisplay
; 0000 0107            }
; 0000 0108              }
	RJMP _0x16
; 0000 0109                }
_0x23:
	RJMP _0x23
; .FEND
;
;
;interrupt [EXT_INT0] void int0(void)
; 0000 010D {
_int0:
; .FSTART _int0
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
; 0000 010E  static unsigned char
; 0000 010F  cnt=0;
; 0000 0110 
; 0000 0111  static unsigned int
; 0000 0112  len[2]={0};
; 0000 0113 
; 0000 0114  chk_OVF_T1();
	RCALL _chk_OVF_T1
; 0000 0115 
; 0000 0116   if(!process)
	SBIC 0x13,1
	RJMP _0x24
; 0000 0117     {
; 0000 0118     START_TIMER;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0119     CLR_TIMER_RPM;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
; 0000 011A     process=1;
	SBI  0x13,1
; 0000 011B        }
; 0000 011C  else
	RJMP _0x27
_0x24:
; 0000 011D     {
; 0000 011E      switch(cnt)
	LDS  R30,_cnt_S0000007000
	LDI  R31,0
; 0000 011F            {
; 0000 0120             case 0:
	SBIW R30,0
	BRNE _0x2B
; 0000 0121             STOP_TIMER;
	RCALL SUBOPT_0x6
; 0000 0122             len[0]=TIMER;
	STS  _len_S0000007000,R30
	STS  _len_S0000007000+1,R31
; 0000 0123             process=0;
	CBI  0x13,1
; 0000 0124             cnt++;
	LDS  R30,_cnt_S0000007000
	SUBI R30,-LOW(1)
	STS  _cnt_S0000007000,R30
; 0000 0125             break;
	RJMP _0x2A
; 0000 0126 
; 0000 0127             case 1:
_0x2B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x35
; 0000 0128             STOP_TIMER;
	RCALL SUBOPT_0x6
; 0000 0129             len[1]=TIMER;
	__PUTW1MN _len_S0000007000,2
; 0000 012A             if((len[1] < (len[0]+300)) && (len[1] > (len[0]-300)))
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-300)
	SBCI R31,HIGH(-300)
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(300)
	SBCI R31,HIGH(300)
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x31
_0x30:
	RJMP _0x2F
_0x31:
; 0000 012B               {
; 0000 012C                cnt=10;
	LDI  R30,LOW(10)
	RJMP _0x3E
; 0000 012D                 }
; 0000 012E             else
_0x2F:
; 0000 012F               {
; 0000 0130                cnt=0;
	LDI  R30,LOW(0)
_0x3E:
	STS  _cnt_S0000007000,R30
; 0000 0131                 }
; 0000 0132             process=0;
	CBI  0x13,1
; 0000 0133             break;
; 0000 0134 
; 0000 0135             default:break;
_0x35:
; 0000 0136                 }
_0x2A:
; 0000 0137 
; 0000 0138      if(cnt==10)
	LDS  R26,_cnt_S0000007000
	CPI  R26,LOW(0xA)
	BRNE _0x36
; 0000 0139        {
; 0000 013A         data=((long)len[0]+(long)len[1])/2;
	LDS  R26,_len_S0000007000
	LDS  R27,_len_S0000007000+1
	CLR  R24
	CLR  R25
	__GETW1MN _len_S0000007000,2
	CLR  R22
	CLR  R23
	RCALL __ADDD21
	__GETD1N 0x2
	RCALL __DIVD21
	STS  _data,R30
	STS  _data+1,R31
	STS  _data+2,R22
	STS  _data+3,R23
; 0000 013B         cnt=0;
	LDI  R30,LOW(0)
	STS  _cnt_S0000007000,R30
; 0000 013C         start=1;
	SBI  0x13,0
; 0000 013D         GIMSK=0x00;
	OUT  0x3B,R30
; 0000 013E           }
; 0000 013F         }
_0x36:
_0x27:
; 0000 0140 }
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
;interrupt [TIM0_OVF] void timer0_OVF(void)
; 0000 0143 {
_timer0_OVF:
; .FSTART _timer0_OVF
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0144  static unsigned char
; 0000 0145  time,t;
; 0000 0146 
; 0000 0147  time++;
	LDS  R30,_time_S0000008000
	SUBI R30,-LOW(1)
	STS  _time_S0000008000,R30
; 0000 0148    //Задержка в полсекунды
; 0000 0149    if(time>250)
	LDS  R26,_time_S0000008000
	CPI  R26,LOW(0xFB)
	BRLO _0x39
; 0000 014A      {
; 0000 014B       time=0;
	LDI  R30,LOW(0)
	STS  _time_S0000008000,R30
; 0000 014C       t++;
	LDS  R30,_t_S0000008000
	SUBI R30,-LOW(1)
	STS  _t_S0000008000,R30
; 0000 014D          if(t==16)
	LDS  R26,_t_S0000008000
	CPI  R26,LOW(0x10)
	BRNE _0x3A
; 0000 014E            {
; 0000 014F             refresh=1;
	SBI  0x13,2
; 0000 0150             t=0;
	LDI  R30,LOW(0)
	STS  _t_S0000008000,R30
; 0000 0151            }
; 0000 0152        }
_0x3A:
; 0000 0153 }
_0x39:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND

	.DSEG
_ch:
	.BYTE 0x10
_leds:
	.BYTE 0x7
_number:
	.BYTE 0x4
_data:
	.BYTE 0x4
_dat_S0000006000:
	.BYTE 0x2
_cnt_S0000007000:
	.BYTE 0x1
_len_S0000007000:
	.BYTE 0x4
_time_S0000008000:
	.BYTE 0x1
_t_S0000008000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	SUBI R30,-LOW(_ch)
	LD   R30,Z
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	RCALL __DIVF21
	__PUTD1S 2
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x3
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	STS  _number,R30
	__PUTB1MN _number,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	OUT  0x2E,R30
	IN   R30,0x2C
	LDI  R31,0
	MOVW R26,R30
	IN   R30,0x2D
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	__GETW2MN _len_S0000007000,2
	LDS  R30,_len_S0000007000
	LDS  R31,_len_S0000007000+1
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

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

__GEW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRSH __GEW12UT
	CLR  R30
__GEW12UT:
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__MULW12U:
	MOV  R0,R26
	MOV  R1,R27
	LDI  R24,17
	CLR  R26
	SUB  R27,R27
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R26,R0
	ADC  R27,R1
__MULW12U2:
	LSR  R27
	ROR  R26
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
