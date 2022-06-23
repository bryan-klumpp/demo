start-process -FilePath powershell -ArgumentList "-Command Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process; . C:\Users\b\Documents\WindowsPowerShell\nestnesting\runas_sub.ps1; pause"
#from sub just FYI: start-process -FilePath cmd -Verb runas -WindowStyle maximized
#from sub just FYI: start-process -FilePath cmd -Verb runas -WindowStyle max