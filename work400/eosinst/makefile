RPATH = ..\resource
WPATH = ..\resource\watcom

PRG     = eosinst
ULIB    = .\lib
UINC    = .

CDEP    =
CFLAGS  = -D_X86_=1 -D_WIN32 -DWIN32 -DWINVER=0x0400 /I=$(UINC) -5r -fp5 -ox -d0
RFLAGS  = -D_X86_=1 -D_WIN32 -DWIN32 -DWINVER=0x0400 /I $(UINC)

LLIBS   = DDRAW.LIB DINPUT.LIB


all : $(PRG).exe

$(PRG).exe: $(PRG).obj $(PRG).res getdxver.obj
        $(WPATH)\link -subsystem:windows -out:$(PRG).exe  \
        $(PRG).obj $(PRG).res getdxver.obj ddraw.lib  dxguid.lib


.rc.res:
        $(WPATH)\rc $(RFLAGS) $*.rc
.c.obj:
        $(WPATH)\wcc386 $(CFLAGS) -zw $*.c
.cpp.obj:
        $(WPATH)\wcc386 $(CFLAGS) -zw $*.cpp
.asm.obj:
        $(RPATH)\tasm32 $*.asm /ml /m /p /q /i$(UINC) /DWIN32=1

$(PRG).obj: $(PRG).c $(CDEP)


clean:
# Windows 9x check
!if $d(WINBOOTDIR)
        del $(PRG).exe
        del $(PRG).obj
        del $(PRG).res
        del getdxver.obj
        del *.err
        del *.AAA
!else
        del /Q $(PRG).exe
        del /Q $(PRG).obj
        del /Q $(PRG).res
        del /Q getdxver.obj
        del /Q *.err
        del /Q *.AAA
!endif


.PHONY: all clean
