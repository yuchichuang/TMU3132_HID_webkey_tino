.export stkptr
stkptr = $0020
.export __STKPTRSAVESIZE__ ;0
__STKPTRSAVESIZE__ = 0
.export _fpruntimestack
_fpruntimestack = $0288
.export RSR, __BANK1_OFFSET_VALUE__,__OPXSTKPTRSIZE__
RSR = $0005
__OPXSTKPTRSIZE__ = 0 ;stkptr=0, tmp1size=0
__BANK1_OFFSET_VALUE__ = $00C0
.export __FPLANE_ADDRESS_MAX__,__RPLANE_ADDRESS_MAX__
__FPLANE_ADDRESS_MAX__ = $00FF
__RPLANE_ADDRESS_MAX__ = $00FF
.AutoImport	on
.export stkptr
stkptr = $0020
.export __STKPTRSAVESIZE__ ;0
__STKPTRSAVESIZE__ = 0
.export _fpruntimestack
_fpruntimestack = $0288
.export RSR, __BANK1_OFFSET_VALUE__,__OPXSTKPTRSIZE__
RSR = $0005
__OPXSTKPTRSIZE__ = 0 ;stkptr=0, tmp1size=0
__BANK1_OFFSET_VALUE__ = $00C0
.export __FPLANE_ADDRESS_MAX__,__RPLANE_ADDRESS_MAX__
__FPLANE_ADDRESS_MAX__ = $00FF
__RPLANE_ADDRESS_MAX__ = $00FF
.AutoImport	on
