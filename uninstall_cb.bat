@echo off
setlocal enabledelayedexpansion
cd "%~dp0"

REM INITIALISATION
set "workdir=%temp%\charbuilduninstall"
mkdir %workdir% >nul 2>&1

REM ELEVATOR
verify >nul
net session >nul 2>&1
if not "%errorlevel%"=="0" (
	echo CreateObject^("Shell.Application"^).ShellExecute "%~0", "", "", "runas", 1 > "%workdir%\elevate.vbs"
	wscript "%workdir%\elevate.vbs"
	exit /b
)

REM UNINSTALL
REM Finds and executes the uninstall utility
set "startext=\Microsoft\Windows\Start Menu\Programs\Wizards of the Coast"
for %%d in (C:\ProgramData, %appdata%) do (
	if exist "%%~d%startext%" (
		call "%%~d%startext%\Character Builder\Uninstall Character Builder.lnk" >nul 2>&1
		rd /s /q "%%~d%startext%" >nul 2>&1
	)
)

REM MANUAL CLEANUP
rd /s /q "%appdata%\CBLoader" >nul 2>&1
rd /s /q "%localappdata%\Wizards_of_the_Coast" >nul 2>&1
rd /s /q "%userprofile%\Documents\ddi\CBLoader" >nul 2>&1
erase "%userprofile%\Documents\builder_known_files.txt" >nul 2>&1
erase "%userprofile%\Desktop\Dnd 4e Character Builder.lnk" >nul 2>&1

REM COMPLETE
rd /s /q "%workdir%"
echo Character Builder has been uninstalled.
echo You may have characters saved in "My Documents\ddi\Saved Games", so this folder was not removed.
pause
exit /b 0