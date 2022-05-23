mkdir c:\backup
robocopy %USERPROFILE% c:\backup /E /SJ /SL /DCOPY:DAT /XD "C:\Users\b\AppData" /XJ /R:0 /W:0 /V /FP /LOG:c:\backup\robocopy_log.txt /TEE
echo Please screenshot this text and send to IT if there are any questions about whether it was totally successful, especially if more than 0 files show up as FAILED
pause
pause
pause
