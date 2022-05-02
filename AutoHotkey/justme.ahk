#SingleInstance force
#InstallKeybdHook
#InstallMouseHook
#UseHook

; ################################## other stuff ###################################

;Greeting message, everything
;MsgBox, This script can be used as a daily driver to dramatically streamline  interaction with your PC.  However, it's not yet ready for the general public (I'm just starting on documenting it, and some AutoHotkey knowledge is needed in order to tune or disable the parts that you don't like.`n`nMy favorite part of this script is the mouse/keyboard hybrid functions.  For example, if you move your mouse more than %navigationModeTriggerNumPixelsMoved% pixels and then hit the space bar, it will emulate a left mouse click.  I find this more efficient, ergonomic, and even enjoyable compared to clicking the mouse button.  Key overloading does come with some challenges (accidental mouse bumps will throw your typing off, for example), and this code is relatively immature, but I think there's a lot of potential here.


;RButton::
;  Click, Down  
;  waitForKeyUp("RButton")
;  Click, Up
;return

;MButton::Click, Right

; this is a way to prevent the mouse cursor from moving excessively (accidentally) when scrolling.  The flip side is you have to wait for a time interval after scrolling before moving the mouse on purpose, so it's a tradeoff for now




~WheelUp::
~WheelDown::
  global flagXYUnusableVal
  global lastXofKeyOrButtonPress
         lastXofKeyOrButtonPress := flagXYUnusableVal
  global lastYofKeyOrButtonPress
         lastYofKeyOrButtonPress := flagXYUnusableVal
  BlockInput, MouseMove
  sleep 500
  BlockInput, MouseMoveOff
return


WheelLeft::
  Click, Right
  Sleep, 200
return  

^PgDn::SendInput {Ctrl Down}{End}{Ctrl Up}
^PgUp::SendInput {Ctrl Down}{Home}{Ctrl Up}
 
 VKC0:: SendInput {Ctrl Down}c{Ctrl Up}  ;C0 virtual key  029 scancode - backwards quote mark
^VKC0:: SendInput ``  ;C0  029 backwards quote mark

^Right::
 VKB7:: 
  FormatTime, ts, ,yyyyMMddHHmmss
  SendInput , % ts
return
+VKB7:: 
  FormatTime, ts, ,yyyy'-'MM'-'dd' 'HH':'mm':'ss 
  SendInput , % ts
return


F1:: SendInput ^v

+F6::
+F7::
+F12::
; skipping !F5 due to conflict with Eclipse hotkey
!F6::
!F7::
!F12::
  WinClose , BJShell
F6::
F7::
IfWinExist, BJShell
{
    WinActivate , BJShell
    return  
}
^F5::
^F6::
^F7::
    Run, C:\Users\b\.p2\pool\plugins\org.eclipse.justj.openjdk.hotspot.jre.full.win32.x86_64_15.0.2.v20210201-0955\jre\bin\javaw.exe -Dfile.encoding=Cp1252 -classpath C:\Users\b\eclipse\w1\BJShell\target\classes;C:\Users\b\eclipse\w1\b\target\classes;C:\Users\b\.m2\repository\org\xerial\sqlite-jdbc\3.34.0\sqlite-jdbc-3.34.0.jar -XX:+ShowCodeDetailsInExceptionMessages -XX:+HeapDumpOnOutOfMemoryError -enableassertions com.bryanklumpp.custom.SwingShellLauncher
return 

F12::Run,C:\Users\b\Documents\src\WindowsPowerShell\PowerShell.bat


F2:: SendInput !{Tab}
F4:: SendInput !{F4}


;;;<bryanklumpp>
;;;<private>

:*:nnn::309-251-9396
:*:mmm::klumpp6@gmail.com
:*:sgg::Bryan Klumpp`n309-251-9396
:*:sga::Bryan Klumpp`n2522 W Scenic Dr.`nPeoria, IL 61615`n309-251-9396
::tesths::Testing a hotstring that can be terminated by spacebar
::rad:: 
  SendInput Reset user's password in Active Directory
return
:*:(c)::©
:*:k6::klumpp6@gmail.com
::251::(309) 251-9396
:*:2522::2522 W Scenic Dr.Peoria, IL 61615-3806

;;;</private>
;;;</bryanklumpp>



;##################### <shared> methods across scripts ########################
waitForKeyUp(key) {
  while (getKeyState(key, "P")) {
    global waitSleep
    sleep 23
  }
}
;##################### </shared> methods across scripts ########################

pop(s) {
  MsgBox, 4,, %s%
}

; ############# following section just has some developer tools, can be removed ###########
~!1:: ;---------------- save and reload the script --------------------
{
  SendInput ^s ; does not work in visual studio, try grabbing focus
  Sleep 800    ; wait for save to take effect
  Reload
  Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
  MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
  IfMsgBox, Yes, Edit
  return
}

^!F9:: ;diagnostic tool to show current window class for app id
    WinGetClass, curWindowClass, A
    pop(curWindowClass)


; ####### MISCELLANEOUS STANDALONE HOTKEYS/HOTSTRINGS ########


