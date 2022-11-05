set bakdir=e:\20220622_c_Users_b
mkdir %bakdir%
robocopy %USERPROFILE% %bakdir% /E /SJ /SL /DCOPY:DAT /XD %USERPROFILE%\AppData /XJ /R:0 /W:0 /V /FP 
/LOG:%bakdir%\%RANDOM%baklog.txt 2>&1