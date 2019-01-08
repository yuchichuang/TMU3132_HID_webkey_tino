
;==================================================================================================
		org		    0c00h
;==============================================================================
;	   Device  Descriptor
;==============================================================================
.TABLE
DeviceDescTable:
		addwf	Pcl,F
Device_Descriptor:
		retlw   12h				;bLength			=>12h byte
		retlw   01h				;bdescriptorType		=>Device
		retlw   10h				;bcdUSB low Byte		=>USB is VER:1.1
		retlw   01h				;bcdUSB hi  Byte
		retlw   00h				;bDeviceClass
		retlw   00h				;bDeviceSubClass
		retlw   00h				;bDeviceProtocol
		retlw   08h				;bMaxPacketSize0		=>8 byte
		retlw   VID_LO				;idVendor low byte		=>Tenx Vendor ID is 1130
		retlw   VID_HI				;idVendor hi  byte
		retlw   PID_LO				;idProduct low byte		=>Product ID for MASK type.
		retlw   PID_HI				;idProduct hi byte
		retlw   00h				;bcdDevice low byte
		retlw   05h				;bcdDevice hi byte
		retlw   01h				;iManufacturer
		retlw   02h				;iProduct
		retlw   00h				;iSeriaNumber
		retlw   01h				;bNumConfigurations		=>One configuration
;------------------------------------------------------------------------
;	   Configuration  Descriptor			  12h
;------------------------------------------------------------------------
Configuration_Descriptor:
		retlw   09h				;bLength			=>9 byte
		retlw   02h				;bDescriptorType		=>Configuration
		retlw   ConfigLen		  	;wTotalLength low Byte	  	=>Transfer all byte number
		retlw   00h				;wTotalLength  hi  Byte
		retlw   01h;02h				;bNumInterfaces			=>Two Interface
		retlw   01h				;bConfigurationValue		=>Configruation Valume
		retlw   00h				;iConfiguration			=>Unused
		retlw   80h				;bmAttribute			=>(Bit7:Bus supply Power/Bit5:RemoteWakeUp)
		retlw   32h				;MaxPower   			=>Max Current 500mA
HID_Class1_Begin:
;------------------------------------------------------------------------
;	   HID Interface Descriptor
;------------------------------------------------------------------------
		retlw   09h				;bLength			=>9 byte
		retlw   04h				;bDescriptorType		=>Interface
		retlw   00h				;bInterfaceNumber		=>set0
		retlw   00h				;bAlternateSetting		=>0
		retlw   01h				;bNumEndPoint			=>EndPoint 1
		retlw   03h				;bInterfaceClass
		retlw   01h				;bInterfaceSubclass
		retlw   01h				;bIinterfaceProtocal
		retlw   00h				;iInterface
;------------------------------------------------------------------------
;	   HID Class Descriptor
;------------------------------------------------------------------------
HID_Class1_Desc:
		retlw	09h
		retlw	21h
		retlw	10h
		retlw	01h
		retlw	00h;21h				;bCountryCode
		retlw	01h
		retlw	22h
		retlw	HidReport1Len
		retlw	00h
;------------------------------------------------------------------------
;	   HID Endpoint descriptor
;------------------------------------------------------------------------
		retlw   07h				;bLength			=>7 byte
		retlw   05h				;bDescriptorType		=>endpoint
		retlw   81h				;enpoint address	 	=>in endpoint, endpoint 1
		retlw   03h				;endpoint attribute		=>interrupt
		retlw   08h				;max packet size		=>8 bytes
		retlw   00h				;max packet size
		retlw   0ah				;polling interval		=>1 ms
HID_Class1_End:

HID_Class2_Begin:
;------------------------------------------------------------------------
;	   HID Interface2 Descriptor
;------------------------------------------------------------------------
		;retlw   09h				;bLength			=>9 byte
		;retlw   04h				;bDescriptorType		=>Interface
		;retlw   01h				;bInterfaceNumber		=>set1
		;retlw   00h				;bAlternateSetting		=>0
		;retlw   01h				;bNumEndPoint			=>EndPoint 1
		;retlw   03h				;bInterfaceClass
		;retlw   00h				;bInterfaceSubclass
		;retlw   00h				;bIinterfaceProtocal
		;retlw   00h				;iInterface
;------------------------------------------------------------------------
;	   HID Class2 Descriptor
;------------------------------------------------------------------------
HID_Class2_Desc:
		;retlw	09h
		;retlw	21h
		;retlw	10h
		;retlw	01h
		;retlw	21h
		;retlw	01h
		;retlw	22h
		;retlw	HidReport2Len
		;retlw	00h
;------------------------------------------------------------------------
;	   HID Endpoint2 descriptor
;------------------------------------------------------------------------
		;retlw   07h				;bLength			=>7 byte
		;retlw   05h				;bDescriptorType		=>endpoint
		;retlw   06h				;enpoint address	 	=>out endpoint, endpoint 6
		;retlw   03h				;endpoint attribute		=>interrupt
		;retlw   08h				;max packet size		=>8 bytes
		;retlw   00h				;max packet size
		;retlw   0ah				;polling interval		=>1 ms
HID_Class2_End:

;-----------------------------------------------------------------------
;	   String Index0  Descriptor
;-----------------------------------------------------------------------
String0_Descriptor:
		retlw   04h				;length
		retlw   03h				;type (3 = string)Language English
		retlw   09h				;Language:English
		retlw   04h  			   	;Sub-Language:default
;-----------------------------------------------------------------------
;	   String Index1  Descriptor
;-----------------------------------------------------------------------
String1_Descriptor:
		retlw   0ah				;length
		retlw   03h				;type (3 = string)Language English

		retlw	'T'
		retlw   00h
		retlw	'E'
		retlw	00h
		retlw	'N'
		retlw	00h
		retlw	'X'
		retlw	00h
;-----------------------------------------------------------------------
;	   String Index2  Descriptor
;-----------------------------------------------------------------------
;------------------------------------------------------------------------------
;TP6620 WEBKEY
;-----------------------------------------------------------------------------
String2_Descriptor:
		retlw	28		;34 bytes
		retlw	03h

		retlw	'T'
		retlw	00h
		retlw	'P'
		retlw	00h
		retlw	'9'
		retlw	00h
		retlw	'8'
		retlw	00h
		retlw	'0'
		retlw	00h
		retlw	'8'
		retlw	00h
		retlw	' '
		retlw	00h
		retlw	'W'
		retlw	00h
		retlw	'E'
		retlw	00h
		retlw	'B'
		retlw	00h
		retlw	'K'
		retlw	00h
		retlw	'E'
		retlw	00h
		retlw	'Y'
		retlw	00h
		;retlw	' '
		;retlw	00h
		;retlw	' '
		;retlw	00h
		;retlw	' '
		;retlw	00h
;------------------------------------------------------------------------------
;General Purpose USB
;-----------------------------------------------------------------------------
HID_Report1_Desc:
		retlw   05h	; usage page (generic desktop)		;65 bytes----------00h
		retlw	01h
		retlw   09h	; usage (keyboard)
		retlw	06h
		retlw   a1h	; collection (application)
		retlw	01h
		
		retlw	85h	; report id(1)
		retlw	01h
		
		retlw   05h	; USAGE_PAGE (Keyboard)
		retlw	07h

		retlw   19h	; USAGE_MINIMUM (Keyboard LeftControl)
		retlw	e0h
		retlw   29h	; USAGE_MAXIMUM (Keyboard Right GUI)
		retlw	e7h
		retlw   15h	; logical minimum (0)
		retlw	00h
		retlw   25h	; logical maximum (1)
		retlw	01h

		retlw   75h	; report size (1 bit)
		retlw	01h
		retlw   95h	; report count (8 bits)
		retlw	08h
		retlw   81h	; input (data, variable, absolute)
		retlw	02h
		retlw   95h	; report count (1 byte)
		retlw	01h

		retlw   75h	; report size (8 bits)
		retlw	08h
		retlw   81h	; input (constant)
		retlw	01h
		retlw   95h	; report count (3)
		retlw	03h
		retlw   75h	; report size (1)
		retlw	01h

		retlw   05h	; usage page (LEDs)
		retlw	08h
		retlw   19h	; usage minimum (1)
		retlw	01h
		retlw   29h	; usage maximum (3)
		retlw	03h
		retlw   91h	; output (data, variable, absolute)
		retlw	02h

		retlw   95h	; report count (5)
		retlw	05h
		retlw   75h	; report size (1)
		retlw	01h
		retlw   91h	; output (constant)
		retlw	01h
		retlw   95h	; report count (6)
		retlw	05h	;06h

		retlw   75h	; report size (8)
		retlw	08h
		retlw   15h	; logical minimum (0)
		retlw	00h
		retlw   26h	; logical maximum (255)
		retlw	ffh
		retlw	00h
		retlw   05h	; usage page (key codes)

		retlw	07h
		retlw   19h	; usage minimum (0)
		retlw	00h
		retlw   2ah	; usage maximum (255)
		retlw	ffh
		retlw	00h
		retlw   81h	; input (data, array)
		retlw	00h

		retlw   c0h	; end collection
		
		retlw	05h	; usage page(consumer)
		retlw	0ch
		retlw	09h	; usage(remote control)
		retlw	01h		
		retlw	a1h	; collection(application)
		retlw	01h
		retlw	85h	; report ID
		retlw	02h
		retlw	15h	; logical minimal
		retlw	00h
		retlw	25h	; logical maximal
		retlw	01h
		retlw	75h	; report size(1)
		retlw	01h
		retlw	0ah	; usage(AC search)
		retlw	21h
		retlw	02h
		retlw	0ah	; usage(AC Home)
		retlw	23h
		retlw	02h

		;retlw	0ah	; usage(AC Yes)
		;retlw	5dh
		;retlw	02h
		;retlw	0ah	; usage(AC No)
		;retlw	5eh
		;retlw	02h
		;retlw	0ah	; usage(AC Cancel)
		;retlw	5fh
		;retlw	02h		
		
		retlw	95h	; report count(2)
		retlw	02h
		retlw	81h	; input(data, variable, absolute)
		retlw	06h
		retlw	75h	; report size(1)
		retlw	01h
		retlw	95h	; report count(6)
		retlw	06h
		retlw	81h	; input(constant)
		retlw	01h
		retlw	c0h			

		
Device_Status_Table1:
				
;HID_Report2_Desc:		;//HOST TO DEVICE,used to send CBW¡£
;		retlw   05h		;//Usage Page (Generic Desktop Control)		05 01
;		retlw	01h
;		retlw   09h		;//Usage (Reserved)							09 03
;		retlw	03h	
;		retlw   a1h		;//Collection (Application)					A1 01
;		retlw	01h

		;//  DEVICE TO HOST¡£32*8BIT£¬DATA£¬ARRAY£¬ABSOLUTE
;		retlw   95h		;//Report Count (32)						95 20
;		retlw	20h      
;		retlw   75h		;//Report Size (8)							75 08  
;		retlw	08h 	 
;		retlw   15h		;//Logical Minimum (0)						15 00  
;		retlw	00h       
;		retlw   26h		;//Logical Maximum (255)					26 ff 00  
;		retlw	ffh    
;		retlw   00h
;		retlw	05h     ;//Usage Page (Keyboard/Keypad Keys)		05 07
;		retlw   07h	
;		retlw	19h		;//Usage Minimum (0)						19 00
;		retlw   00h
;		retlw	2ah     ;//Usage Maximum (255)						2A FF 00
;		retlw   ffh	
;		retlw	00h    
;		retlw   b1h		;//feature(Data, Array, Absolute)			81 00
;		retlw	00h     

		                ;//  HOST TO DEVICE 64*8BIT £¨64bytes at a time)
;		retlw  15h		;//Logical Minimum (0)						15 00
;		retlw	00h	  
;		retlw  25h		;//Logical Maximum (1)						25 01  
;		retlw	01h     
;		;retlw  96h		;//Report Count (128)						96 00 01  
;		;retlw	00h      
;		;retlw	01h
;		;retlw  75h		;//Report Size (8)							75 08  
;		;retlw	01h	
;		retlw  05h		;//Usage Page (LED)							05 08
;		retlw	08h 	
;		retlw  19h		;//Usage Minimum (1)						19 01
;		retlw	01h     
;		retlw  29h		;//Usage Maximum (128)						29 80
;		retlw	80h    
;		retlw  91h		;//Output (Data, Variable, Absolute)		91 02
;		retlw	02h     
;		retlw  C0h		;//End Collection							C0

;Device_Status_Table2:
.ENDTABLE

		org 0d78h

		
.TABLE		
WindowsURLTable:
		addwf	Pcl,F
	WindowsIDTable:
		retlw	12h						;verify tag v3
		retlw	01h						;language type(use 0f00) 
		retlw	02h						;encryption type(use 0f00)
		retlw	00h						;Windows URL started address high byte
		retlw	10h						;Windows URL started address low byte
		retlw	13h						;Windows URL length(1 Bytes 1 char)
		retlw	00h						;next OS URL started address high byte
		retlw	23h						;next OS URL started address low byte
		retlw	13h						;next OS URL length
		retlw	00h						;security key started address high byte
		retlw	49h						;security key started address low byte
		retlw	00h						;reserved
		retlw	00h						;reserved
		retlw	02h						;reserved
		retlw	00h						;reserved
		retlw	00h						;reserved
		
	WindowsURLAddress:
		retlw	68h			;68h
		retlw	f4h			;'T'
		retlw	74h			;'t'
		retlw	f0h			;'p'
		retlw	3ah			;':'
		retlw	afh			;'/'
		retlw	2fh			;'/'
		retlw	f7h			;'w'
		retlw	77h			;'w'
		retlw	f7h			;'w'
		retlw	2eh			;'.'
		retlw	e1h			;'a'
		retlw	73h			;'s'
		retlw	efh			;'o'
		retlw	73h			;'s'
		retlw	aeh			;'.'
		retlw	63h			;'c'
		retlw	efh			;'o'
		retlw	6dh			;'m'
		

	WindowsURLDone:	
	
.ENDTABLE

;===========================Device Information Table===========================
			org	0e00h;0f00h
;==============================================================================
.TABLE		
MACURLTable:
;DeviceInfoTable:
		addwf	Pcl,F
;	DeviceIDTable:
	MACIDTable:
		retlw	12h						;verify tag v3
		retlw	01h						;language type(use 0f00) 
		retlw	02h						;encryption type(use 0f00)
		retlw	00h						;MAC URL started address high byte
		retlw	10h						;MAC URL started address low byte
		retlw	13h						;MAC URL length(2 Bytes 1 char,max 79 char)
		retlw	00h						;next OS URL started address high byte
		retlw	36h						;next OS URL started address low byte
		retlw	13h						;next OS URL length
		retlw	00h						;security key started address high byte
		retlw	4Ch						;security key started address low byte
		retlw	00h						;reserved
		retlw	00h						;reserved
		retlw	02h						;reserved
		retlw	00h						;reserved
		retlw	00h						;reserved
		
;	URLAddressTable:
	
;		retlw	68h;e8h;68h
;		retlw	f4h;74h;'T'
;		retlw	74h;f4h;'t'
;		retlw	f0h;70h;'p'
;		retlw	3ah;bah;':'
;		retlw	afh;2fh;'/'
;		retlw	2fh;afh;'/'
;		retlw	f7h;77h;'w'
;		retlw	77h;f7h;'w'
;		retlw	f7h;77h;'w'
;		retlw	2eh;aeh;'.'
;		retlw	e9h;		'i'
;		retlw	70h;		'p'
;		retlw	f0h;		'p'
;		retlw	30h;		'0'
;		retlw	aeh;		'.'
;		retlw	6eh;		'n'
;		retlw	e5h;		'e'
;		retlw	74h;		't'
	
;	MacURLAddressTable:	
	MACURLAddress:
		retlw	00h
		retlw	8bh		;h
		retlw	00h
		retlw	97h		;t
		retlw	00h
		retlw	97h		;t
		retlw	00h
		retlw	93h		;p
		retlw	02h
		retlw	b3h		;:
		retlw	00h
		retlw	b8h		;/		
		retlw	00h				
		retlw	b8h		;/		
		retlw	00h		
		retlw	9ah		;w
		retlw	00h
		retlw	9ah		;w
		retlw	00h
		retlw	9ah		;w
		retlw	00h		
		retlw	b7h		;.
		retlw	00h
		retlw	8ch		;i
		retlw	00h
		retlw	93h		;p
		retlw	00h
		retlw	93h		;p
		retlw	00h
		retlw	a7h		;0
		retlw	00h
		retlw	b7h		;.
		retlw	00h		
		retlw	91h		;n
		retlw	00h		
		retlw	88h		;e		
		retlw	00h		
		retlw	97h		;t
		

	MACURLDone:	


.ENDTABLE	

		
;	SecurityKeyURLAddress:	
;		retlw	02h;
;		retlw	05h;'B'
;		retlw	02h;
;		retlw	10h;'M'
;		retlw	02h;
;		retlw	1ah;'W'
;		retlw	02h;
;		retlw	20h;'#'
;		retlw	'#'
;		;retlw	'#'
;	SecurityKeyEnd:	


;===========================Device Information Table===========================
			org	0f00h
;==============================================================================
.TABLE		
AndroidURLTable:
		addwf	Pcl,F
	AndroidIDTable:
		retlw	12h						;verify tag v3
		retlw	01h						;language type(use 0f00) 
		retlw	02h						;encryption type(use 0f00)
		retlw	00h						;Android URL started address high byte
		retlw	10h						;Android URL started address low byte
		retlw	13h						;Android URL length(2 Bytes 1 char,max 79 char)
		retlw	00h						;next OS URL started address high byte
		retlw	36h						;next OS URL started address low byte
		retlw	13h						;next OS URL length
		retlw	00h						;security key started address high byte
		retlw	4Ch						;security key started address low byte
		retlw	00h						;reserved
		retlw	00h						;reserved
		retlw	02h						;reserved
		retlw	00h						;reserved
		retlw	00h						;reserved
	AndroidURLAddress:	
		retlw	00h
		retlw	8bh		;h
		retlw	00h
		retlw	97h		;t
		retlw	00h
		retlw	97h		;t
		retlw	00h
		retlw	93h		;p
		retlw	02h
		retlw	b3h		;:
		retlw	00h
		retlw	b8h		;/		
		retlw	00h				
		retlw	b8h		;/		
		retlw	00h		
		retlw	97h		;t
		retlw	00h
		retlw	9ah		;w
		retlw	00h		
		retlw	b7h		;.
		retlw	00h
		retlw	9ch		;y
		retlw	00h
		retlw	84h		;a
		retlw	00h
		retlw	8bh		;h
		retlw	00h
		retlw	92h		;o
		retlw	00h
		retlw	92h		;o		
		retlw	00h
		retlw	b7h		;.
		retlw	00h		
		retlw	86h		;c
		retlw	00h		
		retlw	92h		;o		
		retlw	00h		
		retlw	90h		;m


		
	AndroidURLDone:	


.ENDTABLE