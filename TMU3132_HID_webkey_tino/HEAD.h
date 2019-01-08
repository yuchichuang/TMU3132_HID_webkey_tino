;==================================================================================================
;	   Register Definitions
;==================================================================================================
;-------------------------------------F-Plane Register Files---------------------------------------
;Rambank 0
;-------------------------------------F-Plane Register Files---------------------------------------
;--------Rambank1 Register Files (20h~7fh)---------------------------
Indf		 		equ		00h
Timer0				equ		01h
Pcl			 	equ		02h
Psw				equ		03h
	RomPage			defstring	03h,6
	RamBank 		defstring 	03h,5
	Zero			defstring 	03h,2
	DCarry 			defstring 	03h,1
	Carry  			defstring 	03h,0

Fsr		 		equ		04h	;F-plane file select register
Rsr				equ		05h	;R-plane file select register
PaReg				equ		06h
	SDA			defstring	06h,1
PbReg				equ		07h
PeReg				equ		0ah
	SCL			defstring	0ah,0
    	LED1			defstring	0ah,1
    	LED2			defstring	0ah,2
        LED			defstring	0ah,3

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

UsbAddrReg			equ		10h			;
	UsbEnable		defstring	10h,7
Int0Reg				equ		11h
	Set0i			defstring 	11h,7 	;
	Out0i			defstring 	11h,6 	;
	Tx0i			defstring 	11h,5 	;
	Tx1i			defstring 	11h,4 	;
	Tx2i			defstring 	11h,3 	;
	Suspi			defstring	11h,2	;
	Tx3i			defstring 	11h,1 	;
	Rc4i  			defstring 	11h,0 	;

Int1Reg				equ		12h
	Wkti			defstring	12h,5
	Rsti			defstring 	12h,4 	;
	Rsmi			defstring 	12h,3 	;
	Pb0i			defstring	12h,1	;
	Timer0i			defstring	12h,0	;

UsbCtrlReg			equ		13h
	Suspend			defstring 	13h,7 	;s/w force usb interface into suspend mode
	Resume			defstring 	13h,6 	;s/w force usb interface send RESUME signal in suspend mode
	Ep1Cfg			defstring 	13h,5
	Ep2Cfg			defstring 	13h,4
	DeviceR			defstring 	13h,3 	;
	Rc0Rdy			defstring 	13h,0 	;Ep0 Ready r
Tx0Reg				equ		14h
	Tx0Rdy			defstring 	14h,7 	;
	Tx0Tgl			defstring 	14h,6 	;
	Ep0Stall		defstring 	14h,5 	;
	In0Stall		defstring	14h,4	;
Tx1Reg				equ		15h
	Tx1Rdy			defstring 	15h,7 	;
	Tx1Tgl			defstring 	15h,6 	;
	Ep1Stall		defstring 	15h,5 	;
Tx2Reg				equ		16h
	Tx2Rdy			defstring 	16h,7 	;
	Tx2Tgl			defstring 	16h,6 	;
	Ep2Stall		defstring 	16h,5 	;
Tx3Reg				equ		17h
	Tx3Rdy			defstring 	17h,7 	;
	Tx3Tgl			defstring 	17h,6 	;
	Ep3Stall		defstring 	17h,5 	;
	Ep3Cfg			defstring 	17h,4 	;
Rc4Reg				equ		18h
	Rc4Rdy			defstring 	18h,7 	;
	Rc4Tgl			defstring 	18h,6 	;
	Ep4Stall		defstring 	18h,5 	;
	Ep4Cfg			defstring 	18h,4 	;
	Rc4Err			defstring	18h,3
Tx3Cnt				equ		19h	; (R/W)
Rc4Cnt				equ		1ah 	; (R only)
XramCtrlReg			equ		1ch
	Xram1Usb		defstring	1ch,5
	Xram2Usb		defstring	1ch,4
	Xram1Spi		defstring	1ch,3
	Xram2Spi		defstring	1ch,2
SpiCtrlReg			equ		1dh
	SpiMode			defstring	1dh,5
	SpiEnable		defstring	1dh,4	;SPI enable
	LsbFirst		defstring	1dh,3
	SetSpiIn		defstring	1dh,2	;write 1 to set spi receive data from SPI Device
	SetSpiCmdMode		defstring	1dh,1	;Switch SINGLE/MULTI access of spi
	ClearRamAddr		defstring	1dh,0	;write 1 to clear ram address
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;------------------------------------------------------------------------------
; Internal SRAM(0x20 ~0x3f,224 bytes)	don't need swith sram bank
;------------------------------------------------------------------------------
gCbwNextStep			equ		20h	;cbw state control
;	gbStepFlag_SendCSW	defstring	20h,1
;	gbStepFlag_Write	defstring	20h,0


gInt0Flag			equ		21h	;
	gbRc0Flag		defstring 	21h,7 	;
	gbOut0Flag		defstring 	21h,6 	;
	gbTx0Flag		defstring 	21h,5 	;
	gbTx1Flag		defstring 	21h,4 	;
	gbTx2Flag		defstring 	21h,3 	;
	gbSuspendFlag		defstring	21h,2	;
	gbTx3Flag		defstring 	21h,1 	;
	gbRc4Flag		defstring 	21h,0 	;
gInt1Flag			equ		22h	;
	gbExtFlag		defstring	22h,7	;
	gbVDD5VRFlag		defstring	22h,6	;
	gbWktFlag		defstring	22h,5	;
	gbRstFlag		defstring	22h,4	;
	gbRsmFlag		defstring	22h,3	;
	gbKbdFlag		defstring	22h,2	;
	gbPb0Flag		defstring	22h,1	;
	gbTm0Flag		defstring	22h,0	;
gInt2Flag			equ		23h	
	gbTm1Flag		defstring	23h,0
	gbNewAddrFlag		defstring 	23h,1
	gbEp0TalkFlag		defstring	23h,2
	DataOKFlag		defstring	23h,4
	;gbTestFlag1		defstring	23h,5
	;gbTestFlag2		defstring	23h,6
	;gbTestFlag3		defstring	23h,7
	
gI2CFlag			equ		24h
	DataOutFlag		defstring	24h,0
	;DataInFlag		defstring	24h,1
	OSType			defstring	24h,2
	StartScanFlag		defstring	24h,3
	Check_Flag		defstring	24h,4
	JudgeSendFlag		defstring	24h,5
	E2PROMFlag		defstring	24h,6
	;FormatFlag		defstring	24h,7

gScsiStatus2			equ		25h
	MacVerFlag		defstring	25h,7
	VerTestDoneFlag		defstring	25h,6		
;	E2PCheckFlag		defstring	25h,5
	;gbHidIdle		defstring	25h,4
	gbHidProtocol		defstring	25h,3
	;gbAreaIndexBit8		defstring	25h,2
	;gbDebug			defstring	25h,1
	GUIFlag			defstring	25h,0

;2Ah-2Fh FREE................
gbResetPath			defstring	2ah,0
EndTransFlag			defstring	2ah,1
OneFlag				defstring	2ah,2
TransFlag			defstring	2ah,3
PlugFlag			defstring	2ah,4
WinTransAscII			defstring	2ah,5
RestorLedsFlag			defstring	2ah,6
WinRFlag			defstring	2ah,7

EnterFlag			defstring	2bh,0
BreakFlag			defstring	2bh,1
DataInFlag1			defstring	2bh,2
gfUSEinitGetDescriptor		defstring	2bh,3
;gfGetString1			defstring	2bh,4
;gfGetString2			defstring	2bh,5
PressToggleFlag			defstring	2bh,6
KeyPressedFlag			defstring	2bh,7

;LEDCheckPoint			defstring	2ch,0
;GetInfoFlag			defstring	2ch,1
;NewOSFlag			defstring	2ch,2
USB30TrueFlag		defstring	2ch,2
;OSTypeFlag			defstring	2ch,3
USB30TestFlag		defstring	2ch,3
urladd1forenter		defstring	2ch,4
;gSendEnterOver		defstring	2ch,5
;gRegisterInitOver	defstring	2ch,6
;gEnterDelayOver	defstring	2ch,7

;SendSecurityEnd		defstring	2dh,0
CheckLanguage		defstring	2dh,1
W7StartCount		defstring	2dh,2
FriPlugEnd			defstring	2dh,3
NECUSB3ChipFlag		defstring	2dh,4
E2PROM512Flag		defstring	2dh,5
WriteE2EROMFlag		defstring	2dh,6
SendFlag			defstring	2dh,7
;FrescoChipFlag		defstring	2dh,4
;OSTypeTemp			defstring	2dh,5

CMDInFlag			defstring	2eh,0
;SecondCMDInFlag		defstring	2eh,1
AskROMSizeFlag		defstring	2eh,2
langSwitchDelayFlag	defstring	2eh,3
MSJudgeSendOnceFlag	defstring	2eh,4
AndroidOSFlag		defstring	2eh,5
ReportIDFlag		defstring	2eh,6
SendKeyNotYetFlag		defstring	2eh,7

GetDeviceDspt08Byte		defstring	2fh,0
AndroidURLDoneFlag		defstring	2fh,1
setting0x51addrFlag		defstring	2fh,2

gTempVar0			equ		30h
gTempVar1			equ		31h	;Temp use Variable
gTempVar2			equ		32h	;
table0x51addr			equ		32h	;

gTempVar3			equ		33h
gTempVar4			equ		34h
gTempVar5			equ		35h
table0x51addr_add5			equ		35h

gTempVar6			equ		36h

;37h-3Fh FREE.................
BackupPSW			equ		37h
TEMP1				equ		38h
TEMP2				equ		39h
AnyCountTemp			equ		3ah
UsbLedDataTemp			equ		3bh
WorkReg				equ		3ch
getstring2counter		equ		3dh
TimerRollOver			equ		3eh
getstring1counter		equ		3fh


;------------------------------------------------------------------------------
;40h~ffh(bank 0 start from here)
;------------------------------------------------------------------------------
gWLengthTemp			equ		40h
gLengthCnt			equ		41h
gTableCnt			equ		42h
gDatalength			equ		43h
gRemoteWakeupStatus   		equ		44h
gConfigurationStatus		equ		45h
gCurAlternate			equ		46h
TempReg				equ		47h
;W_I2C_Address			equ		48h
WindowsURLEnd			equ		48h
R_I2C_Address			equ		49h
R_I2C_Address1			equ		4ah
nextsetreportflag		equ		4bh
IdlePeriodStatus		equ		4ch
gHidProtocolVal			equ		4dh
;TEMPE2PDATA			equ		4eh
;MaxURLLength			equ		4fh
AndroidURLIndex			equ		4eh
AndroidURLLength		equ		4fh

ScanNumber			equ		50h
TempCount			equ		51h
EndMaxURL40h			equ		52h
ReadURLTime			equ		53h
UsbKeyBuffer0			equ		54h
UsbKeyBuffer2			equ		55h
UsbKeyBuffer3			equ		56h
UsbKeyBuffer4			equ		57h
KeyPress0			equ		58h
KeyPress1			equ		59h
KeyPress2			equ		5ah
IdlePeriodTemp			equ		5bh
UsbRequireState			equ		5ch
WorkRegTemp			equ		5dh
AsciiMSC			equ		5eh
AsciiMID			equ		5fh
AsciiLSC			equ		60h
Judge_Capital			equ		61h
CounterHead				equ		62h
CounterHead2			equ		63h
;69h
;W_I2C_AddressH			equ	64h
;Check0FF				equ	65h
;Check1FF				equ	66h
LanguageType			equ 64h
AndroidURLEnd			equ	65h
ScanNumTemp				equ	66h

ReportDataLength		equ	67h
ReportDataLengthH		equ	68h
UsbKeyBuffer5			equ 69h

;gTempTalkCnt1			equ		67h	;Temp only once
;gTempTalkCnt2			equ		68h	;Temp only once
;gTempTalkCnt3			equ		69h	;Temp only once

DelayCount			equ		6ah
DelayCountH			equ		6bh
BackupW				equ		6ch
;ReadI2CAddress		equ		6dh
DelayCount_us		equ		6dh
ReadI2CAddressH		equ		6eh
;PbdTemp				equ		6dh
;PbdLastStatus			equ		6eh
PressToggle			equ		6fh

DataBuffer0			equ		70h
TimerCountH			equ		70h
;GetReportCounter		equ		71h

CtrlCmdSpace		equ		72h
EncryptionValue		equ		73h
PitchXor			equ		74h
;SecurityKeyIndex	equ		75h
MACURLEnd		equ		75h

ResetFlag0			equ		72h
ResetFlag1			equ		73h
ResetFlag2			equ		74h
ResetFlag3			equ		75h

URLLenTemp			equ		76h
;SecurityDelayTime	equ		77h
TimeBuffer			equ		78h
SendSecuritytimes	equ		79h

MacVerFlag0			equ		76h
MacVerFlag1			equ		77h
MacVerFlag2			equ		78h
MacVerFlag3			equ		79h

URLAddressIndex		equ		7ah
URLAddressLen		equ		7bh
MacURLAddressIndex	equ		7ch
MacURLAddressLen	equ		7dh
Setreportcount		equ		7eh
Getreportcount		equ		7fh
;---------------------BANK1-----------------------------------------------------------
ReadBuffer			equ		40h
ReadBuffer0			equ		40h
ReadBuffer1			equ		41h
ReadBuffer2			equ		42h
ReadBuffer3			equ		43h
ReadBuffer4			equ		44h
ReadBuffer5			equ		45h
ReadBuffer6			equ		46h
ReadBuffer7			equ		47h
ReadBuffer22			equ		56h
ReadBuffer23			equ		57h
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-------------------------------------R-Plane Register Files---------------------------------------
;-
;-------------------------------------R-Plane Retister Files---------------------------------------
INDR				equ		00h	; (R/W)  R-Plane address=[RSR]

T0RLD				equ		01h
T0en				defstring	02h,4
T0Pscl				equ		02h	;	.3~0

PwrDownCtrlReg			equ		03h	; (W only) write this register to enter Power-Down Mode
WDTE				equ		04h	; (W only) write this register to clear WDT & enable WDT

WrcConfig			equ		06h
	Wrc_PD			defstring	06h,7

ClockCtrlReg			equ		07h	; (W only) cpu clock speed select
	En_Pe3_Cko		defstring	09h,1
	IrcCko_Sel		defstring	09h,0

TestReg				equ		10h
Int0IeReg			equ		11h	; (W only)
Int1IeReg			equ		12h	; (W only)

Rc0Cnt				equ		13h	; (bit3-bit0) R only
Rc0Reg				equ		13h	; (R only)
	Rc0ToggleFlag		defstring 	13h,7	;
	Rc0ErrorFlag		defstring 	13h,6 	;	<<<<<<<<<<< In R-Plan, it may need test bit by byte read.(movrw)
	Ep0DirFlag		defstring 	13h,5 	;
	Ep0SetFlag		defstring 	13h,4 	;

PAE				equ		20h	;7~0
PBE				equ		21h	;3~0
PEE				equ		24h	;4~0
PAPU				equ		25h	;7~0
PBPU				equ		26h	;3~0
PCDEPU				equ		27h	;0

;____________SPI
SpiConfigReg			equ		3bh	; (W only)
SpiCrsReg			equ		3ch	; (W only) spi clock select
SpiDmaLengthReg			equ		3dh	; (W only) spi dma transfer length(1~64 bytes)
SpiTxDataReg			equ		3eh	; (W only)
SpiRxDataReg			equ		3fh	; (R only)

Set0FifoReg			equ		40h	; (R only) 40h~47h
	BmRequestType		equ		40h
	BRequest		equ		41h
	WValue		  	equ		42h	;default wValue (8-bits)
	WValueHi		equ		43h
	WIndex		  	equ		44h	;default wIndex (8-bits)
	WIndexHi		equ		45h
	WLength		 	equ		46h	;default wLength (8-bits)
	WLengthHi	   	equ		47h
Out0FifoReg			equ		48h	; (R only) 48h~4fh
Out1FifoReg			equ		49h	;
Tx0FifoReg			equ		50h	; (W only) 50h~57h
	Tx0Fifo0		equ		50h
	Tx0Fifo1		equ		51h
	Tx0Fifo2		equ		52h
	Tx0Fifo3		equ		53h
	Tx0Fifo4		equ		54h
	Tx0Fifo5		equ		55h
	Tx0Fifo6		equ		56h
	Tx0Fifo7		equ		57h
Tx1FifoReg			equ		58h	; (W only) 58h~5fh
Tx1FifoReg0			equ		58h
Tx1FifoReg1			equ		59h
Tx1FifoReg2			equ		5ah
Tx1FifoReg3			equ		5bh
Tx1FifoReg4			equ		5ch
Tx1FifoReg5			equ		5dh
Tx1FifoReg6			equ		5eh
Tx1FifoReg7			equ		5fh

Tx2FifoReg			equ		60h	; (W only) 60h~67h
Tx2FifoReg0			equ		60h
Tx2FifoReg1			equ		61h
Tx2FifoReg2			equ		62h
Tx2FifoReg3			equ		63h
Tx2FifoReg4			equ		64h
Tx2FifoReg5			equ		65h
Tx2FifoReg6			equ		66h
Tx2FifoReg7			equ		67h

Xram1StartAddress		equ		80h
Xram10				equ		80h
Xram11				equ		81h
Xram12				equ		82h
Xram13				equ		83h
Xram14				equ		84h
Xram15				equ		85h
Xram16				equ		86h
Xram17				equ		87h
Xram2StartAddress		equ		c0h
Xram20				equ		c0h
Xram21				equ		c1h
Xram22				equ		c2h
Xram23				equ		c3h
Xram24				equ		c4h
Xram25				equ		c5h
Xram26				equ		c6h
Xram27				equ		c7h

;==================================================================================================
;	   			Constant Definition
;==================================================================================================
BIT0				equ		01h
BIT1				equ		02h
BIT2				equ		04h
BIT3				equ		08h
BIT4				equ		10h
BIT5				equ		20h
BIT6				equ		40h
BIT7				equ		80h
UsbNoReport			equ		00h
UsbReportError			equ		01h
UsbReport			equ		02h
;--------------------------------------------------------------------------------------------------
; Normal Constant Definition
;--------------------------------------------------------------------------------------------------
W				equ		00h
F				equ		01h
;--------------------------------------------------------------------------------------------------
; For USB Constant Definition
;--------------------------------------------------------------------------------------------------
;--------Define BmRequestType Types Files----------------------------
HostToDevice			equ		00h
HostToInterface			equ		01h
HostToEndpoint			equ		02h
HostClassToInterface		equ		21h
DeviceToHost			equ		80h
InterfaceToHost			equ		81h
EndpointToHost			equ		82h
InterfaceToHostClass		equ		a1h

;--------Define BRequest Types Files---------------------------------

GetStatus			equ		00h
ClearFeature			equ		01h
;GetIdle			equ		02h
SetFeature			equ		03h
SetAddress			equ		05h
GetDescriptor			equ		06h
GetConfiguration		equ		08h
SetConfiguration		equ		09h
GetInterface			equ		0ah
SetInterface			equ		0bh
;--------Standard Descriptor Types-----------------------------------

Device				equ		01h
Configuration			equ		02h
String				equ		03h
Interface			equ		04h
Endpoint			equ		05h
HidClass			equ		21h
HidReport			equ		22h

String0				equ		00h
String1				equ		01h
String2				equ		02h
String3				equ		03h

Report1				equ		01h
Report2				equ		02h

;------------------------------------------------------------------------
; For HID Constant Definition
;------------------------------------------------------------------------
;-class specific descriptor types from section  Standard Requests-

GetRequest			equ		a1h
SetRequest			equ		21h

;-class specific request codes from section 7.2 Class Specific Requests

GetReport			equ		01h
GetIdle				equ		02h
GetProtocol			equ		03h
SetReport			equ		09h
SetIdle				equ		0ah
SetProtocol			equ		0bh

;-------------------------------------------------------------------------
UnConfig			equ		00h
Config				equ		01h

LedValue			equ		02h
StallValue			equ		01h

DisableRemoteWakeup		equ		00h
EnableRemoteWakeup		equ		02h

Endpoint0			equ		80h	;
Endpoint1			equ		81h	;Tx1
Endpoint2			equ		82h	;Tx2
Endpoint3			equ		83h	;Tx3
Endpoint4			equ		04h	;Rc4

Interface0			equ		00h
Interface1			equ		01h
Interface2			equ		02h

DeviceLen			equ		12h
ConfigLen			defstring	(String0_Descriptor-Configuration_Descriptor)

String0Len		  	equ		04h
String1Len		  	defstring 	(String2_Descriptor-String1_Descriptor)
String2Len		  	defstring 	(HID_Report1_Desc-String2_Descriptor)

ConfigIndex			defstring	(Configuration_Descriptor-Device_Descriptor)
String0Index			defstring	(String0_Descriptor-Device_Descriptor)
String1Index			defstring	(String1_Descriptor-Device_Descriptor)
String2Index			defstring	(String2_Descriptor-Device_Descriptor)

KeyboardReport			equ		01h
LedReport			equ		02h

HidClassLen			equ		09h
HidReport1Len			defstring	(Device_Status_Table1-HID_Report1_Desc)
HidClass1Index			defstring	(HID_Class1_Desc-Device_Descriptor)
HidReport1Index			defstring	(HID_Report1_Desc-Device_Descriptor)

;HidReport2Len			defstring	(Device_Status_Table2-HID_Report2_Desc)
;HidClass2Index			defstring	(HID_Class2_Desc-Device_Descriptor)
;HidReport2Index			defstring	(HID_Report2_Desc-Device_Descriptor)

;DeviceIDIndex			defstring	(DeviceIDTable-DeviceIDTable)
;URLAddressIndex		defstring	(URLAddressTable-DeviceIDTable)
;URLAddressLen			defstring	(MacURLAddressTable-URLAddressTable+1)
;URLAddressLenMinus1	defstring	(MacURLAddressTable-URLAddressTable)

;MacURLAddressIndex		defstring	(MacURLAddressTable-DeviceIDTable)
;MacURLAddressLen		defstring	(SecurityKeyURLAddress-MacURLAddressTable+2)
;MacURLAddressLenMinus1	defstring	(SecurityKeyURLAddress-MacURLAddressTable)

;SecurityKeyIndex		defstring	(SecurityKeyURLAddress-DeviceIDTable)
;SecurityKeyLen			defstring	(SecurityKeyEnd-SecurityKeyURLAddress)
;SecurityEndAddr			defstring	(SecurityKeyEnd-DeviceIDTable)

MacWebLength			defstring	(MacArray_end-MacArray_start)
MacWebLength1			defstring	(MacArray_end1-MacArray_start1)
WinWebLength			defstring	(WinArray_endA-WinArray_startA)

LanguageNumber				equ		01h
EncryptionType				equ		02h
WindowsURLaddrStartLow		equ		04h
WindowsURLaddrLength		equ		05h
WindowsURLaddrEndtLow		equ		07h
CtrlCmdSpaceType			equ		0dh

MACURLaddrStartLow		equ		04h
MACURLaddrLength		equ		05h
MACURLaddrEndtLow		equ		07h

AndroidWebLength		defstring	(AndroidArray_end-AndroidArray_start)
AndroidThirdLength		defstring	(AndroidThird_end-AndroidThird_start)
AndroidURLaddrStartLow		equ		04h
AndroidURLaddrLength		equ		05h
AndroidURLaddrEndtLow		equ		07h
;--------------------------------------------------------------------------------------------------
;Macro Definition
;--------------------------------------------------------------------------------------------------
XRAM1CPU_XRAM2CPU	.MAC
	clrf	XramCtrlReg
.ENDM

XRAM1SPI_XRAM2CPU	.MAC
	movlw	08h
	movwf	XramCtrlReg
.ENDM

XRAM1CPU_XRAM2SPI	.MAC
	movlw	04h
	movwf	XramCtrlReg
.ENDM

XRAM1CPU_XRAM2USB	.MAC
	movlw	10h
	movwf	XramCtrlReg
.ENDM

XRAM1USB_XRAM2CPU	.MAC
	movlw	20h
	movwf	XramCtrlReg
.ENDM

XRAM1SPI_XRAM2USB	.MAC
	movlw	18h
	movwf	XramCtrlReg
.ENDM

XRAM1USB_XRAM2SPI	.MAC
	movlw	24h
	movwf	XramCtrlReg
.ENDM

;----------------------------------------
LBA_SWITCH_P1	.MAC
	bsf	03h,6	;RomPage1
.ENDM
LBA_SWITCH_P0	.MAC
	bcf 03h,6	;RomPage0
.ENDM
;----------------------------------------
Delay_us   .MAC   Time            ;Delay "Cycles" instruction cycles

  .IF (Time+0=1)
  	goto $ + 1
        nop
        .EXITMAC
  .ENDIF

  .IF (Time+0=2)
  	goto $ + 1
        goto $ + 1
        nop
        .EXITMAC
  .ENDIF

  .IF (Time+0=3)
        goto $ + 1
        goto $ + 1
        goto $ + 1
        goto $ + 1
        .EXITMAC
  .ENDIF

  .IF (Time+0=4)
        goto $ + 1
        goto $ + 1
        goto $ + 1
        goto $ + 1
        goto $ + 1
        nop
        .EXITMAC
  .ENDIF

  .IF (Time+0=5)
  	goto $ + 1
  	goto $ + 1
  	goto $ + 1
  	goto $ + 1
        goto $ + 1
        goto $ + 1
        goto $ + 1
        .EXITMAC
  .ENDIF

  .IF (Time+0=6)
        goto $ + 1
        goto $ + 1
  	goto $ + 1
  	goto $ + 1
  	goto $ + 1
  	goto $ + 1
  	goto $ + 1
    	goto $ + 1
        .EXITMAC
  .ENDIF

  .IF (Time+0=7)
  	goto $ + 1
  	goto $ + 1
  	goto $ + 1
        goto $ + 1
  	goto $ + 1
  	goto $ + 1
        goto $ + 1
        goto $ + 1
        nop
        .EXITMAC
  .ENDIF

  .IF (Time+0=8)
        goto $ + 1
        goto $ + 1
  	goto $ + 1
  	goto $ + 1
        goto $ + 1
  	goto $ + 1
  	goto $ + 1
        goto $ + 1
  	goto $ + 1
  	goto $ + 1
        goto $ + 1
        .EXITMAC
  .ENDIF


  .IF (Time%2=0)
        movlw 	Time
        movwf	DelayCount_us
	decfsz	DelayCount_us,F
	goto	$ - 1
       .EXITMAC
  .ENDIF

  .IF (Time%2=1)
        movlw 	Time
        movwf	DelayCount_us
	decfsz	DelayCount_us,F
	goto	$ - 1
;       .EXITMAC
  .ENDIF

.ENDM