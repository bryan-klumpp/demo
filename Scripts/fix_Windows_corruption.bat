mkdir %USERPROFILE%\it
set logfile=%USERPROFILE%\it\fix_Windows_corruption_bat.log
@echo off
echo This batch job runs chkdsk c:, and if it succeeds it then runs a sequence of sfc, dism, and sfc again for good measure.  The window can run in the background while the user works.  It will not show the key output to the console window, but instead log it to the file %logfile%  This window will close itself when finished; please do not restart, sleep, or shutdown, if possible, until this window disappears.
@echo on
chkdsk c: >> %logfile% 2>&1
if %ERRORLEVEL% neq 0 goto LabelChkdskFail
sfc /scannow >> %logfile% 2>&1
dism /online /cleanup-image /restorehealth >> %logfile% 2>&1
sfc /scannow >> %logfile% 2>&1

rem echo If possible, do not press any key (despite what is printed below), ideally contact analyst to review this, minimize the window for now.  If you need to restart or shut down, if possible, drag your cursor from the lower-right corner to the very top-left corner of the screen to highlight all text, press Ctrl + C, and paste into email to analyst.  
rem pause
rem pause
rem pause

goto End

:LabelChkdskFail
chkdsk c: /offlinescanandfix