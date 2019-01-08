;TMU3132
;2011/01/11
;2011/09/22 chen add "indf equ	00h" + "indr equ  00h"

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;       F-plane
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        indf            equ             00h
        tm0             equ             01h
        timer0          equ             01h
        pc              equ             02h
        rambank         .defstr         03h,5
        zf              .defstr         03h,2
        zflag           .defstr         03h,2
        df              .defstr         03h,1
        dcflag          .defstr         03h,1
        cf              .defstr         03h,0
        cflag           .defstr         03h,0
        fsr             equ             04h
        rsr             equ             05h
        pad             equ             06h
        pbd             equ             07h
        ped             equ             0ah
        usbe            .defstr         10h,7
        funadr          equ             10h
        set00i          .defstr         11h,7
        out0i           .defstr         11h,6
        tx0i            .defstr         11h,5
        tx1i            .defstr         11h,4
        tx2i            .defstr         11h,3
        suspi           .defstr         11h,2
        tx3i            .defstr         11h,1
        rc4i            .defstr         11h,0
        wkti            .defstr         12h,5
        rsti            .defstr         12h,4
        rsmi            .defstr         12h,3
        pb0i            .defstr         12h,1
        tm0i            .defstr         12h,0
        suspnd          .defstr         13h,7
        rsmo            .defstr         13h,6
        ep1cfg          .defstr         13h,5
        ep2cfg          .defstr         13h,4
        device_r        .defstr         13h,3
        Device_R        .defstr         13h,3
        out0rdy         .defstr         13h,0
        tx0rdy          .defstr         14h,7
        tx0tgl          .defstr         14h,6
        ep0stall        .defstr         14h,5
        in0stall        .defstr         14h,4
        tx0cnt          equ             14h
        tx1rdy          .defstr         15h,7
        tx1tgl          .defstr         15h,6
        ep1stall        .defstr         15h,5
        tx1cnt          equ             15h
        tx2rdy          .defstr         16h,7
        tx2tgl          .defstr         16h,6
        ep2stall        .defstr         16h,5
        tx2cnt          equ             16h
        tx3rdy          .defstr         17h,7
        tx3tgl          .defstr         17h,6
        ep3stall        .defstr         17h,5
        ep3cfg          .defstr         17h,4
        rc4rdy          .defstr         18h,7
        rc4tgl          .defstr         18h,6
        ep4stall        .defstr         18h,5
        ep4cfg          .defstr         18h,4
        rc4err          .defstr         18h,3
        tx3cnt          equ             19h
        rc4cnt          equ             1ah
        xramcon         equ             1ch
        sram1usb        .defstr         1ch,5
        sram2usb        .defstr         1ch,4
        sram1spi        .defstr         1ch,3
        sram2spi        .defstr         1ch,2
        spi_mode        .defstr         1dh,5
        spi_en          .defstr         1dh,4
        lsb_first       .defstr         1dh,3
        lsb_First       .defstr         1dh,3
        spi_in          .defstr         1dh,2
        spi_cmd_sw      .defstr         1dh,1
        clr_ram_adr     .defstr         1dh,0

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;       R-plane
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        indr            equ             00h
        t0rld           equ             01h

        r02             equ             02h
        t0en            equ             00010000b
        t0pscl3         equ             00001000b
        t0pscl2         equ             00000100b
        t0pscl1         equ             00000010b
        t0pscl0         equ             00000001b

        pwrdown         equ             03h
        wdte            equ             04h

        r06             equ             06h
        wrc_pd          equ             10000000b
        wdtpsc6         equ             01000000b
        wdtpsc5         equ             00100000b
        wktpsc4         equ             00010000b
        wktpsc3         equ             00001000b

        clkdiv          equ             07h

        r09             equ             09h
        en_pe3_cko      equ             00000010b
        irccko_sel      equ             00000001b

        testreg         equ             10h

        r11             equ             11h
        set0ie          equ             10000000b
        out0ie          equ             01000000b
        tx0ie           equ             00100000b
        tx1ie           equ             00010000b
        tx2ie           equ             00001000b
        suspie          equ             00000100b
        tx3ie           equ             00000010b
        rc4ie           equ             00000001b

        r12             equ             12h
        wktie           equ             00100000b
        rstie           equ             00010000b
        rsmie           equ             00001000b
        pb0ie           equ             00000010b
        tm0ie           equ             00000001b

        r13             equ             13h
        rc0tgl          equ             10000000b
        rc0err          equ             01000000b
        ep0dir          equ             00100000b
        ep0set          equ             00010000b
        out0cnt3        equ             00001000b
        out0cnt2        equ             00000100b
        out0cnt1        equ             00000010b
        out0cnt0        equ             00000001b

        pae             equ             20h
        pbe             equ             21h
        pee             equ             24h
        papu            equ             25h
        pbpu            equ             26h
        pepu            equ             27h

        r3b             equ             3bh
        cpol            equ             00100000b
        cpha            equ             00010000b
        bsl3            equ             00001000b
        bsl2            equ             00000100b
        bsl1            equ             00000010b
        bsl0            equ             00000001b

        crs             equ             3ch
        spi_length      equ             3dh
        spi_txdat       equ             3eh
        spi_rxdat       equ             3fh

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;       F-PLANE
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        INDF            EQU             00H
        TM0             EQU             01H
        TIMER0          EQU             01H
        PC              EQU             02H
        RAMBANK         .DEFSTR         03H,5
        ZF              .DEFSTR         03H,2
        ZFLAG           .DEFSTR         03H,2
        DF              .DEFSTR         03H,1
        DCFLAG          .DEFSTR         03H,1
        CF              .DEFSTR         03H,0
        CFLAG           .DEFSTR         03H,0
        FSR             EQU             04H
        RSR             EQU             05H
        PAD             EQU             06H
        PBD             EQU             07H
        PED             EQU             0AH
        USBE            .DEFSTR         10H,7
        FUNADR          EQU             10H
        SET00I          .DEFSTR         11H,7
        OUT0I           .DEFSTR         11H,6
        TX0I            .DEFSTR         11H,5
        TX1I            .DEFSTR         11H,4
        TX2I            .DEFSTR         11H,3
        SUSPI           .DEFSTR         11H,2
        TX3I            .DEFSTR         11H,1
        RC4I            .DEFSTR         11H,0
        
        WKTI            .DEFSTR         12H,5
        RSTI            .DEFSTR         12H,4
        RSMI            .DEFSTR         12H,3
        PB0I            .DEFSTR         12H,1
        TM0I            .DEFSTR         12H,0
        
        SUSPND          .DEFSTR         13H,7
        RSMO            .DEFSTR         13H,6
        EP1CFG          .DEFSTR         13H,5
        EP2CFG          .DEFSTR         13H,4
        DEVICE_R        .DEFSTR         13H,3
        OUT0RDY         .DEFSTR         13H,0
        
        TX0RDY          .DEFSTR         14H,7
        TX0TGL          .DEFSTR         14H,6
        EP0STALL        .DEFSTR         14H,5
        IN0STALL        .DEFSTR         14H,4
        TX0CNT          EQU             14H
        
        TX1RDY          .DEFSTR         15H,7
        TX1TGL          .DEFSTR         15H,6
        EP1STALL        .DEFSTR         15H,5
        TX1CNT          EQU             15H
        
        TX2RDY          .DEFSTR         16H,7
        TX2TGL          .DEFSTR         16H,6
        EP2STALL        .DEFSTR         16H,5
        TX2CNT          EQU             16H
        TX3RDY          .DEFSTR         17H,7
        TX3TGL          .DEFSTR         17H,6
        EP3STALL        .DEFSTR         17H,5
        EP3CFG          .DEFSTR         17H,4
        RC4RDY          .DEFSTR         18H,7
        RC4TGL          .DEFSTR         18H,6
        EP4STALL        .DEFSTR         18H,5
        EP4CFG          .DEFSTR         18H,4
        RC4ERR          .DEFSTR         18H,3
        TX3CNT          EQU             19H
        RC4CNT          EQU             1AH
        XRAMCON         EQU             1CH
        SRAM1USB        .DEFSTR         1CH,5
        SRAM2USB        .DEFSTR         1CH,4
        SRAM1SPI        .DEFSTR         1CH,3
        SRAM2SPI        .DEFSTR         1CH,2
        SPI_MODE        .DEFSTR         1DH,5
        SPI_EN          .DEFSTR         1DH,4
        LSB_FIRST       .DEFSTR         1DH,3
        SPI_IN          .DEFSTR         1DH,2
        SPI_CMD_SW      .DEFSTR         1DH,1
        CLR_RAM_ADR     .DEFSTR         1DH,0

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;       R-PLANE
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        INDR            EQU             00H
        T0RLD           EQU             01H

        R02             EQU             02H
        T0EN            EQU             00010000B
        T0PSCL3         EQU             00001000B
        T0PSCL2         EQU             00000100B
        T0PSCL1         EQU             00000010B
        T0PSCL0         EQU             00000001B

        PWRDOWN         EQU             03H
        WDTE            EQU             04H

        R06             EQU             06H
        WRC_PD          EQU             10000000B
        WDTPSC6         EQU             01000000B
        WDTPSC5         EQU             00100000B
        WKTPSC4         EQU             00010000B
        WKTPSC3         EQU             00001000B

        CLKDIV          EQU             07H

        R09             EQU             09H
        EN_PE3_CKO      EQU             00000010B
        IRCCKO_SEL      EQU             00000001B

        TESTREG         EQU             10H

        R11             EQU             11H
        SET0IE          EQU             10000000B
        OUT0IE          EQU             01000000B
        TX0IE           EQU             00100000B
        TX1IE           EQU             00010000B
        TX2IE           EQU             00001000B
        SUSPIE          EQU             00000100B
        TX3IE           EQU             00000010B
        RC4IE           EQU             00000001B

        R12             EQU             12H
        WKTIE           EQU             00100000B
        RSTIE           EQU             00010000B
        RSMIE           EQU             00001000B
        PB0IE           EQU             00000010B
        TM0IE           EQU             00000001B

        R13             EQU             13H
        RC0TGL          EQU             10000000B
        RC0ERR          EQU             01000000B
        EP0DIR          EQU             00100000B
        EP0SET          EQU             00010000B
        OUT0CNT3        EQU             00001000B
        OUT0CNT2        EQU             00000100B
        OUT0CNT1        EQU             00000010B
        OUT0CNT0        EQU             00000001B

        PAE             EQU             20H
        PBE             EQU             21H
        PEE             EQU             24H
        PAPU            EQU             25H
        PBPU            EQU             26H
        PEPU            EQU             27H

        R3B             EQU             3BH
        CPOL            EQU             00100000B
        CPHA            EQU             00010000B
        BSL3            EQU             00001000B
        BSL2            EQU             00000100B
        BSL1            EQU             00000010B
        BSL0            EQU             00000001B

        CRS             EQU             3CH
        SPI_LENGTH      EQU             3DH
        SPI_TXDAT       EQU             3EH
        SPI_RXDAT       EQU             3FH
