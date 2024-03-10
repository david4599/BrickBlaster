@echo off

set msdoscmd=..\RESOURCE\msdos -e
set removecmd=rmdir /S /Q

:: Windows 9x check
if exist %winbootdir%\win.com goto lwin9x
goto lnext

:lwin9x
set msdoscmd=
set removecmd=deltree /Y

:lnext
if not exist pack\nul mkdir pack
copy media.gif pack\media.gif
copy blaster.flc pack\blaster.flc
copy blaster.lv0 pack\blaster.lv0
copy blaster.lv1 pack\blaster.lv1
copy blaster.lv2 pack\blaster.lv2
copy sprite0.pal pack\sprite0.pal
copy sprite1.pal pack\sprite1.pal
copy blaster.cfg pack\blaster.cfg
copy blaster.ico pack\blaster.ico
echo.

if not exist tmp\nul mkdir tmp
copy resource\*.* tmp

:: call %msdoscmd% ..\RESOURCE\diet -B blaster.exe
call %msdoscmd% ..\RESOURCE\diet -B pack\blaster.cfg
call %msdoscmd% ..\RESOURCE\diet -B pack\blaster.lv0
call %msdoscmd% ..\RESOURCE\diet -B pack\blaster.lv1
call %msdoscmd% ..\RESOURCE\diet -B tmp\*.mod
call %msdoscmd% ..\RESOURCE\diet -B tmp\*.iff
call %msdoscmd% ..\RESOURCE\diet -B tmp\*.flc
echo.
call %msdoscmd% ..\RESOURCE\llink complete.eos

%removecmd% tmp
echo.

dir pack\*.*
pause
