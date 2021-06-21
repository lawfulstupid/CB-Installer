@echo off

echo.
echo ====================================================================================================
echo.
echo 'D^&D 4e Offline Character Builder' created by Wizards of the Coast (www.wizards.com).
echo 'Character Builder Loader' created by the CBLoader team (github.com/cbloader/cbloader).
echo Please report bugs to https://github.com/lawfulstupid/CB-Installer/issues.
echo.
echo ====================================================================================================
echo.

setlocal EnableDelayedExpansion
cd "%~dp0"

@REM PARAMETERS
set version=1.3
set filelist=16g7969GIRjOUPG8dY3jfdUo6AhL8dX26
set "install_dir=C:\Program Files (x86)\Wizards of the Coast\Character Builder"
set "work_dir=%temp%\charbuildinstall"
set "app_name=DnD 4e Character Builder"
set "cb_args=-d -F"

@REM INITIALISATION
title Character Builder Installation Wizard v%version%
mkdir %work_dir% >nul 2>&1

@REM ARGUMENTS
for %%A in (%*) do set flag%%~A=1
if defined flag-d set no_install=1
if defined flag-i set no_download=1
if defined flag-v goto info
if defined flag-h goto help
if defined flag-? goto help

goto info_end
:info
echo Character Builder Installation Wizard
echo Version %version%
echo.
echo https://drive.google.com/open?id=1bs8bjQFw41FDjM27X-aaPmJeV_KoTr55
goto:eof
:info_end

goto help_end
:help
echo Character Builder Installation Wizard
echo Arguments:
echo    -d	Only download files, do not install.
echo    -i	Only install, assumes files have been downloaded correctly.
echo    -v	Show version and information.
echo    -h	Show this help page.
goto:eof
:help_end

@REM ELEVATOR
verify >nul
net session >nul 2>&1
if not %errorlevel%==0 (
	echo CreateObject^("Shell.Application"^).ShellExecute "%~0", "%*", "", "runas", 1 > "%work_dir%\elevate.vbs"
	wscript "%work_dir%\elevate.vbs"
	exit /b 2
)

@REM CONFIRMATION
echo You are about to install the D^&D 4e Character Builder.
echo Required space: 400 MB
@REM 372527104 bytes
echo Installation time: approx. 10-15 minutes
call:query "Continue?"
if %ans%==N goto abort


@REM CHECK 7-ZIP
verify >nul
7z -h >nul 2>&1
if %errorlevel%==0 goto skip7z

for %%i in (
	"C:\Program Files\7-Zip"
	"C:\Program Files (x86)\7-Zip"
) do (
	set dir7z=%%~i
	if exist "!dir7z!\7z.exe" goto set7z
)

echo 7-Zip is required, but has not been detected on your system.
call:query "Have you already installed 7-Zip?"
if %ans%==N (
	call:query "Would you like to install 7-Zip now?"
	if %ans%==N goto abort
	start http://www.7-zip.org/download.html
	exit /b 2
)

:dir7z_enter
echo Please enter the location of your 7-Zip installation.
set /p dir7z=^> 
set dir7z=%dir7z:"=%
echo.
if exist "%dir7z%\7z.exe" goto set7z
echo 7z.exe was not found in this directory.
goto dir7z_enter

:set7z
setx /m PATH "%dir7z%;%PATH%" >nul
set "PATH=%dir7z%;%PATH%" >nul
echo 7-Zip successfully registered.
echo.
:skip7z


@REM CHOOSE INSTALL DIRECTORY
echo The Character Builder will be installed in "%install_dir%".
call:query "Is this OK?"
if %ans%==N (
	echo Please enter a new installation directory.
	set /p install_dir=^> 
	set install_dir=!install_dir:"=!
	echo.
)

if defined no_download (
	echo Skipping download.
	echo.
	goto install_start
)

@REM GET FILELIST
set "dlcode=https://drive.google.com/uc?export=download&id"
call:download "%dlcode%=%filelist%" "%work_dir%\filelist.txt"

@REM DOWNLOAD
echo ====================================================================================================
echo.
echo This installer requires no more input. Come back in about 10-15 minutes.
echo.
for /f "tokens=1,2" %%F in (%work_dir%\filelist.txt) do (
	echo Downloading %%~nG...
	call:download "%dlcode%=%%~F" "%work_dir%\%%~nxG"
)
echo Done.
echo.

:install_start
if defined no_install (
	echo Terminating before installation.
	echo Press any key to exit.
	pause >nul
	exit /b 2
)

@REM INSTALLATION
cd %work_dir%
echo Installing Character Builder...
start /wait CharacterBuilderInstaller.exe /S /v"/qn" /v"INSTALLDIR=\"%install_dir%""
echo Installing updates...
7z x -y -o"%install_dir%" CharacterBuilderUpdateAug2010.exe >nul
7z x -y -o"%install_dir%" CharacterBuilderUpdateOct2010.exe >nul
echo Installing CBLoader...
7z x -y -o"%install_dir%" CBLoader.zip >nul
copy /y WotC.index "%install_dir%\Custom" >nul
setlocal DisableDelayedExpansion
7z e -y -i!parts\*.part -i!sorted\*.part -o"%install_dir%\Custom" parts.zip >nul
setlocal EnableDelayedExpansion
echo Done.
echo.

@REM Just to be safe?
erase "%install_dir%\Custom\WotC.index"

@REM COMPILATION
echo Configuring CBLoader...
echo.
cd /d "%install_dir%"
call RegPatcher.exe >nul
call CBLoader.exe -a -n -d -e
echo.

@REM MAKE SHORTCUTS

@REM Shortcut Script
set "shortcut=%work_dir%\make_shortcut.vbs"
echo set oShellLink = WScript.CreateObject("WScript.Shell").CreateShortcut(Wscript.Arguments(0) ^& "\%app_name%.lnk") > %shortcut%
echo oShellLink.TargetPath = "%install_dir%\CBLoader.exe" >> %shortcut%
echo oShellLink.Arguments = "%cb_args%" >> %shortcut%
echo oShellLink.Save >> %shortcut%

@REM Start Menu
set "startext=\Microsoft\Windows\Start Menu\Programs\Wizards of the Coast\Character Builder"
for %%D in (C:\ProgramData, %appdata%) do (
	if exist "%%~D%startext%\*.lnk" (
		erase "%%~D%startext%\Char*"
		wscript %shortcut% "%%~D%startext%"
	)
)
@REM Desktop
erase "%systemdrive%\Users\Public\Desktop\Character Builder.lnk"
wscript %shortcut% "%userprofile%\Desktop"
echo Done.

@REM COMPLETE
rmdir /s /q "%work_dir%" >nul 2>&1
echo.
echo ====================================================================================================
echo.
echo The Character Builder has been installed.
call:query "Would you like to launch it now?"
if "%ans%"=="Y" CBLoader.exe %cb_args% >nul
exit /b 0

:abort
echo Character Builder installation has been aborted.
echo Press any key to exit.
pause >nul
exit /b 2

@REM SUBROUTINES

:query
@REM query [question]
@REM Presents a Y/N question, result returned in errorlevel
verify >nul
choice /? >nul 2>&1
if %errorlevel%==0 (
	REM CHOICE exists
	choice /m "%~1" /c YN
	if !errorlevel!==1 (
		set ans=Y
	) else (
		set ans=N
	)
) else (
	REM CHOICE does not exist
	:query_ans
	set /p ans=%~1 [Y/N]?
	set ans=!ans:~0,1!
	if "!ans!"=="y" (
		set ans=Y
	) else if "!ans!"=="n" (
		set ans=N
	) else (
		goto query_ans
	)
)
echo.
goto:eof

:download
@REM download url dest
@REM Saves the file in the url at the given destination
powershell -Command "(New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
goto:eof