::see https://support.microsoft.com/en-us/topic/use-the-system-file-checker-tool-to-repair-missing-or-corrupted-system-files-79aa86cb-ca52-166a-92a3-966e85d4094e for why sfc is run after dism
mkdir %USERPROFILE%\IT
set logfile=%USERPROFILE%\IT\fix_Windows_corruption_bat_%RANDOM%.log
@echo off
echo " "
echo "------------------------------------------------------"
echo This batch job runs chkdsk c:, and if it succeeds it then runs a sequence of sfc, dism, and sfc again.  The window can run in the background while the user works.  It will not show the detailed output to this window, but instead log it to the file %logfile%  If possible, please do not restart, sleep, or shutdown until this window either says it is finished or disappears, and notify analyst when the window either says it is finished or disappears.
echo "------------------------------------------------------"
@echo on
chkdsk c: >> %logfile% 2>&1
if %ERRORLEVEL% neq 0 goto LabelChkdskFail
sfc /scannow >> %logfile% 2>&1
dism /online /cleanup-image /restorehealth >> %logfile% 2>&1
sfc /scannow >> %logfile% 2>&1
@echo off
echo "------------------------------------------------------"
echo Jobs finished running, please notify analyst
echo "------------------------------------------------------"
@echo on
pause

goto End

:LabelChkdskFail
@echo off
echo Because errors were found on your disk, you will need to restart the computer (at your convenience) in order to continue the corruption repair procedure.  Upon restart, you will see a disk repair process running for a few minutes before Windows comes up, so bear in mind this could take 5 minutes, or possibly much longer if there are serious issues.  After Windows comes back up, please reach out to the analyst.
@echo on
echo y | chkdsk c: /f