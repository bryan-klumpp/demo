; This is an AutoHotkey script that can be used to bring the BJShell window to the foreground,
; restart it, and/or launch an additional window.  This file can be referenced by placing 
; a shortcut at shell:startup in Windows Explorer.  This makes it easy to re-launch after
; changing code, and also enables multiple simultaneous windows without worrying about 
; threading and shared static code complexities, since each window gets its own JVM.
; AuthotKey can be downloaded at https://www.autohotkey.com/

                        ; ! represents Alt, ^ represents Ctrl, + represents Shift
!F9::                   ; Use this hotkey to re-launch BJShell window (closing existing window), after changing code 
WinClose , BJShell      ; Note that there is no return statement, script will continue to next code line
F9::                    ; Use this hotkey to bring the window to the forefront, if it exists
IfWinExist, BJShell     ; If this comes back false (no existing window), the return line will be skipped
{                       ;     and execution will go to the line that launches a new window
   WinActivate , BJShell
   return  
}
^F9::                   ; User needs to tweak the appropriate location for javaw/java exe, classpath location, etc.
Run, C:\Users\b\.p2\pool\plugins\org.eclipse.justj.openjdk.hotspot.jre.full.win32.x86_64_15.0.2.v20210201-0955\jre\bin\javaw.exe -Dfile.encoding=Cp1252 -classpath C:\Users\b\eclipse\w1\BJShell\target\classes;C:\Users\b\.m2\repository\org\xerial\sqlite-jdbc\3.34.0\sqlite-jdbc-3.34.0.jar -XX:+ShowCodeDetailsInExceptionMessages -XX:+HeapDumpOnOutOfMemoryError -enableassertions com.bryanklumpp.custom.SwingShellLauncher
return 
