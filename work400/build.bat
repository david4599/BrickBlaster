@echo off

if "%1" == "help" goto lusage

set option=
set complete=

set cmdprogram=cmd.exe

:: Windows 9x check
if exist %winbootdir%\win.com set cmdprogram=command.com


if "%2" == "complete" goto lcomplete
if "%2" == "" goto lnext
goto linvalid

:lcomplete
set complete=yes


:lnext
if "%1" == "make" goto lexecbuild
if "%1" == "makenone" goto lmakenone
if "%1" == "makeall" goto lmakeall
if "%1" == "clean" goto lclean
if "%1" == "" goto lexecbuild
goto linvalid

:lmakenone
cd blaster
goto lexeccomplete

:lmakeall
set option=-B
goto lexecbuild

:lclean
set option=clean
set complete=

:lexecbuild
cd diam95
..\resource\make %option%
echo.
cd ..\wineos
..\resource\make %option%
echo.
cd ..\blaster
..\resource\make %option%
echo.

:lexeccomplete
if "%complete%" == "yes" start %cmdprogram% /c complete.bat
cd ..
pause
goto lexit


:linvalid
echo Build error: invalid command, see usage with help option
echo.
goto lexit


:lusage
echo Usage (w/o quotes): "build.bat [help] <make|makenone|makeall|clean> [complete]"
echo Examples:
echo   - Build Blaster without preparing release (default): "build.bat make"
echo   - Build Blaster and prepare release: "build.bat make complete"
echo   - Only prepare release: "build.bat makenone complete"
echo   - Rebuild everything and prepare release: "build.bat makeall complete"
echo   - Remove created files (except release in Blaster\pack): "build.bat clean"
echo.


:lexit
