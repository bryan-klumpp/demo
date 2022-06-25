mkdir %USERPROFILE%\IT
set logfile=%USERPROFILE%\IT\fix_Windows_corruption_bat_%RANDOM%.log
chkdsk c: >> %logfile% 2>&1
if %ERRORLEVEL% neq 0 goto LabelChkdskFail
sfc /scannow >> %logfile% 2>&1
dism /online /cleanup-image /restorehealth >> %logfile% 2>&1
sfc /scannow >> %logfile% 2>&1
goto End
:LabelChkdskFail
chkdsk c: /f
