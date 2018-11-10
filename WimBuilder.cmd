@echo off
cd /d "%~dp0"
title WimBuilder(%cd%)

rem run with Administrators right
bin\IsAdmin.exe
if not ERRORLEVEL 1 (
  if not "x%~1"=="xrunas" (
    set ElevateMe=1
    bin\ElevateMe.vbs "%~0" "runas" %*
  )
  goto :EOF
)
if "x%~1"=="xrunas" (SHIFT)


rem init i18n file
set "I18N_SCRIPT=%~dp0i18n\i18n_.wsf"
for /f "tokens=3 delims=='; " %%i in ('findstr "$lang" config.js') do (
  set LocaleID=%%i
)
if not "x%LocaleID%"=="x" goto :SKIP_AUTO_LANG
set LocaleID=0
for /f "delims=" %%i in ('cscript.exe //nologo "%I18N_SCRIPT%" init') do set LocaleID=%%i
if "x%LocaleID%"=="x" set LocaleID=0

:SKIP_AUTO_LANG
set I18N_LCID=%LocaleID%
set WB_UI_LANG=%LocaleID%
if not exist i18n\%LocaleID%.vbs (
    set I18N_LCID=0
    goto :MAIN_ENTRY
)

set "I18N_SCRIPT=%~dp0i18n\i18n.wsf"
if not exist i18n\0.vbs goto :UPDATE_I18NRES
fc /b i18n\%LocaleID%.vbs i18n\0.vbs>nul
if not ERRORLEVEL 1 goto :MAIN_ENTRY

:UPDATE_I18NRES
copy /y i18n\%LocaleID%.vbs i18n\0.vbs

:MAIN_ENTRY
set "WB_ROOT=%~dp0"
set "Factory=%WB_ROOT%_Factory_"
set "ISO_DIR=%WB_ROOT%_ISO_"

rem ======set bin PATH======
set "PATH=%WB_ROOT%bin;%PATH%"
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
  set "PATH=%WB_ROOT%bin\x64;%PATH%"
) else (
  set "PATH=%WB_ROOT%bin\x86;%PATH%"
)
set "PATH=%WB_ROOT%lib\macros;%PATH%"
rem ========================

rem mount winre.wim/boot.wim with wimlib, otherwise dism
set USE_WIMLIB=0
start WimBuilder_UI.hta %*
