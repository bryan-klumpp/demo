start-process -WorkingDirectory $env:ALLUSERSPROFILE -credential $cred -FilePath $psexe -ArgumentList @('-noexit', '-command', 'start-process', '-verb', 'runas', '-Command', 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
)

` -Command` echo` Hello` World

, '-ArgumentList',
'-noexit -Command . c:\users\public\temp\test.ps1'