; Copyright © 2021 Bryan Klumpp.  All Rights Reserved.

/*
This script should be considered beta, but it is useful enough that I use it full-time.  While there are a number of features in this script, the best part (imho) is the keyboard emulation of the left mouse button.  I find it ergonomic, fast, and even fun to go through my day without ever having to click the left mouse button.  When the mouse cursor is moved more than a designated number of pixels (the global constant userPrefNavigationModeTriggerNumPixelsMoved), "navigation mode" is enabled and the space bar becomes a mouse left-click button.  If powerUserMode is disabled, then typing most other keys (such as alphabet keys) will turn the spacebar back into a spacebar.  If powerUserMode is enabled, navigation mode overloads other keys as well (see more detail where powerUserMode is declared).  In power user mode, I still do find myself occasionally thinking I am in text mode when I'm not and trying to type and not getting all the characters; for that situation, simply press the CapsLock key to force text entry mode.  If you actually want to type all capital letters, use Shift + CapsLock

The worst side effect of this program is that accidentally bumping the mouse while typing may result in the mouse cursor jumping if the next character you type happens to be a space (also causes problems for other overloaded keys in powerUserMode).  If this becomes a problem, see the documentation next to the userPrefNavigationModeTriggerNumPixelsMoved constant below.  Future enhancements will hopefully better detect accidental mouse bumps and provide alternative ways to invoke mousekeys besides mouse motion. 

*/

; ####################### SCRIPT DIRECTIVES ################

#SingleInstance force
#InstallKeybdHook
#InstallMouseHook
#UseHook
; note: these are left at defaults mainly for clarity/documentation purposes for now; changing them is experimental due to the potential for key repeating when holding down key for mouse drag, etc.
#MaxThreadsBuffer Off
#MaxThreads 1  ; increasing this would help with the problem of some fast sequences discarding characters, but need to check for repeats that would happen with mouse drags
#MaxThreadsPerHotkey 1

; ########### USER PREFERENCES GLOBAL CONSTANTS ############
; 
powerUserMode := 1  ; this enables additional keys on the keyboard to be used for navigation, right-click, etc. (but can be frustrating if user is not accustomed to how the app switches between text and navigation mode).  In navigation mode, f or j will scroll down, e or i will scroll up, w or o will do a right-click, and a or ; will do a left-click (in addition to CapsLock and SpaceBar) and then switch back to "text mode" for typing.
global userPrefNavigationModeTriggerNumPixelsMoved := % (powerUserMode ? 100 : 50)  ;#### If you're having trouble with accidental mouse bumps or after-click movements inadvertently triggering navigation mode, set this number higher.  Set it lower to enable a smaller mouse movement to trigger navigation mode.  Or if you want to completely disable navigation mode being triggered by the mouse moving (perhaps make hotkey triggers instead), just set this so high that it will never be triggered.  Note that when you are ready to type something, it's often easiest to take your hand off the mouse and then "click" with the spacebar or the a key; this will avoid after-click movement and so the spacebar will avoid turning back into a mouse clicker again.  You can use the physical mouse clicker buttons too of course, but just be careful to avoid after-click movement.  If in powerUserMode, the pixel distance needed to trigger a "movement" should maybe be increased because accidental mouse bumps are more likely to mess you up if you're typing.

; ##################### SPLASH SCREEN ######################
; Greeting message, web browser functions only
; MsgBox, See script source code for documentation 

; ##################### INITIALIZATION #####################

CoordMode, Mouse, Screen
SetTitleMatchMode, RegEx

; note: when X and Y are set to a number way off the screen like -5000, it indicates that the last coordinates should be considered unreliable/unusable (which will typically force navigation mode vs. text entry mode).
global flagXYUnusableVal := -5000
global lastRecordedMouseX := flagXYUnusableVal  
global lastRecordedMouseY := flagXYUnusableVal
global boolTextEntryMode := 0 ; 0 means false, anything other number means true
global waitSleep := 20
global flagXYUnusableVal := -5000
global capsLockToggle := GetKeyState("CapsLock","T")

; ########## SWAP BACKSPACE AND CAPS LOCK KEYS #############
~Backspace::doThisWithEveryKeypressOrClick(1)
+CapsLock::      ; use Shift + CapsLock to perform normal CapsLock function
  doThisWithEveryKeypressOrClick(1)
  SetCapsLockState, % (capsLockToggle:=!capsLockToggle) ?  "On" :  "Off"
return

; ########### LEFT MOUSE BUTTON SPECIAL HANDLING ###########
~LButton::   
  enableTextEntryMode()
  waitForKeyUp("LButton")  ;this is important when the mouse is dragged to highlight text, to wait for mouse up before setting last position
  delayedupdateRecordedMouseCoordinates(1) ; TODO bug, setting it super-low for now because for some reason when I click LButton then try to type a immediately it does nothing until this time expires, maybe because a is not passthrough and need to enable multiple hotkey threads (and check for key already down...)?
return
stdDelayedupdateRecordedMouseCoordinates() {
  delayedupdateRecordedMouseCoordinates(1) ; note: setting this too high can mess up typing a character too quickly after a physical or key-emulated mouse click, and possibly even mess up double-click.  For now I have to set it basically too low to be useful.  Need to figure out how to do this asynchronously in AHK
}
; this is an attempt to prevent inadvertent after-click movement from incorrectly switching to navigation mode (does not address accidental mouse bumps though).
delayedupdateRecordedMouseCoordinates(delay) {
  sleep, delay
  updateRecordedMouseCoordinates()
}

; ############ KEYS EMULATING MOUSE BEHAVIOR ###############
; For now, I'm disabling most of the bonus navigation features below and making the keys pass-through for now until I figure out how to make re-entering text mode more intuitive (and make it so these don't break caps lock)

Space:: entryOfKeyCapableOfSingleClick(" " ,"Left" , 0)

a::     
  entryOfKeyCapableOfSingleClick("a" ,"Left" , 1)
return
CapsLock::  
  ; clickOrDrag("CapsLock", "Left") ; 
  doThisWithEveryKeypressOrClick(1)  ; 
return
`;::    
  entryOfKeyCapableOfSingleClick("`;","Left" , 1)
return
w::     
  if (powerUserMode) {
    entryOfKeyCapableOfSingleClick("w" ,"Right", not powerUserMode)
  } else {
      SendKeyedInput("w")
      doThisWithEveryKeypressOrClick(1)
  }
return
o::     
  if (powerUserMode) {
    entryOfKeyCapableOfSingleClick("o" ,"Right", not powerUserMode)
  } else {
      SendKeyedInput("o")
      doThisWithEveryKeypressOrClick(1)
  }
return
f::
  entryOfKeyCapableOfNonClickNavigation("f"  ,"{WheelDown}")
return
j::     
  entryOfKeyCapableOfNonClickNavigation("j"  ,"{WheelDown}")
return
e::     
  entryOfKeyCapableOfNonClickNavigation("e"  ,"{WheelUp}")
return
i::     
  entryOfKeyCapableOfNonClickNavigation("i"  ,"{WheelUp}")
return

; ################## NO MODE TRIGGER KEYS ##################
; these keys will not switch text vs. navigation mode because they are useful in both and don't clearly predict what the user wants to do next.  All of these will execute the statement(s) at the end of the list.
; actually just a placeholder, haven't found ambiguous keys like this yet
;  doThisWithEveryKeypressOrClick(0)
;return

; ############## NAVIGATION MODE TRIGGER KEYS ##############
; below are some pass-through special key combinations that force navigation mode.  All of these will execute the statement(s) at the end of the list.
!CapsLock::
  doThisWithEveryKeypressOrClick(0)
  enableNavigationMode()
return

; ################# TEXT MODE TRIGGER KEYS #################
; These should all invoke doThisWithEveryKeypressOrClick(1)
~F3::
  doThisWithEveryKeypressOrClick(1)
return

; below are some pass-through special keys and combinations that force text entry mode.  All of these will execute the statement(s) at the end of the list.
~Up::
~Down::
~Left::
~Right::
~F2::
~!Tab::
~Shift::
~Del::
~Tab::
~^a::
~^c::
~^f::
~^k::
~^l::
~^v::
~^x::
~^+r::
~^+t::
~^Esc::
~d::    
~k::
~b::
~c::
~g::
~h::
~m::
~n::
~l::
~p::
~q::
~r::
~t::
~u::
~v::
~s::
~x::
~y::
~z::
~0::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~Home::
~End::
~LWin::
  doThisWithEveryKeypressOrClick(1) ; every key above this with no code after :: will drop down and execute this statement
return


isDoNavigationEvenIfNoMouseMove() {
  return not isTextEntryMode()
}

; I tried looking up the last key pressed instead of forcing it to be passed as a parameter, but I got mistypes which I think were due to threading issues.  Still keeping the A_ variables for part of this but not for actually typing the characters
entryOfKeyCapableOfSingleClick(key, LeftRight, isInvokeTextEntryModeAfterward)      
{
  enableNavigationModeIfMouseMovedOverThreshold() 
  if( isNavigationMode() ) {
    ClickOrDrag(key, LeftRight)
    doThisWithEveryKeypressOrClick(isInvokeTextEntryModeAfterward)
    stdDelayedupdateRecordedMouseCoordinates()
  } else {
    doThisWithEveryKeypressOrClick(isInvokeTextEntryModeAfterward)
    SendKeyedInput(key)
  }
  
}

clickOrDrag(keyOrButton, LeftRight) {
  Click, %LeftRight% Down
  while (getKeyState(keyOrButton, "P")) {
    global waitSleep
    sleep  waitSleep
  }
  Click, %LeftRight% Up
}

; note, if we are in basic user mode (not powerUserMode), this will skip checking for navigation and just output the key
entryOfKeyCapableOfNonClickNavigation(key, nav) 
{  
  global   powerUserMode
  if ( not powerUserMode ) {
    SendKeyedInput(key)
    doThisWithEveryKeypressOrClick(1)
    return
  }

  doThisWithEveryKeypressOrClick(0)
  if( isNavigationMode() ) {
    SendInput %nav%
  } else {
    enableNavigationModeIfMouseMovedOverThreshold()  ; could have done this up front and had only one SendInput %nav%, I doubt performance matters but this just seems clearer
    if( isNavigationMode() ) {
      SendInput %nav%
    } else {
      SendKeyedInput(key)
    }
  }
}

; at one point I had different behavior based on whether a web browser window was active, although at the time of this writing there is no distinction
isWebBrowserActive() {
  WinGetClass, curWindowClass, A
  browserNeedle := "Chrome|Firefox|Mozilla|Edge|Safari"  
  return RegExMatch(curWindowClass, browserNeedle)              
}

isTextEntryMode() {
  global boolTextEntryMode
  return boolTextEntryMode
}

isNavigationMode() {
  return not isTextEntryMode()
}

enableTextEntryMode() {
  updateRecordedMouseCoordinates()
  setIsTextEntryMode(1)
}

enableNavigationMode() {
  setIsTextEntryMode(0)
}

enableNavigationModeIfMouseMovedOverThreshold() {
  if (isMouseMovedOverThreshold()) {
    enableNavigationMode()
  }
}

setIsTextEntryMode(parm_boolTextEntryMode) {
  global boolTextEntryMode
         boolTextEntryMode := parm_boolTextEntryMode
}

; This method should ideally be called by every single keyboard key press AND combination, and will likely do more stuff in the future.  Generally this should be called after executing any navigation-mode functions if isInvokeTextEntryMode is true.  I would have preferred a generic key handler API, but AutoHotkey does not expose it so this is the best way I've found for now.  For now this method does nothing if the parameter is false, so it's more important to make sure we hotkey all of the keys/combinations that should invoke text mode.
doThisWithEveryKeypressOrClick(isInvokeTextEntryMode) 
{
  if (isInvokeTextEntryMode) {
    enableTextEntryMode()
  }  
}

updateRecordedMouseCoordinates()
{
  MouseGetPos, X, Y

  global lastRecordedMouseX
         lastRecordedMouseX := X
  global lastRecordedMouseY
         lastRecordedMouseY := Y
  global forceText
         forceText = false
}


isMouseMovedOverThreshold()
{
  global userPrefNavigationModeTriggerNumPixelsMoved
  global lastRecordedMouseX
  global lastRecordedMouseX
  MouseGetPos, X, Y
  mmot := abs(X - lastRecordedMouseX) > userPrefNavigationModeTriggerNumPixelsMoved || abs(Y - lastRecordedMouseY) > userPrefNavigationModeTriggerNumPixelsMoved
  return mmot
}


waitForKeyUp(key) {
  while (getKeyState(key, "P")) {
    global waitSleep
    sleep waitSleep
  }
}

log(s) {
  ; make up your own logging code if debugging is needed
}
logMousePos()
{
  log(getMousePosDesc())
}
popMousePos()
{
  pop(getMousePosDesc())
}
getMousePosDesc()
{
  global userPrefNavigationModeTriggerNumPixelsMoved
  global lastRecordedMouseX
  global lastRecordedMouseX
  MouseGetPos, X, Y
  return "last position: " lastRecordedMouseX " " lastRecordedMouseY "current position: " X " " Y
}
pop(s) {
  MsgBox, 4,, %s%
}

; #################### DEVELOPER HOTKEYS #####################
~!2:: ;---------------- Alt + 2 will save and reload the script --------------------
{ 
  doThisWithEveryKeypressOrClick(0)
  SendInput ^s ; does not work in visual studio, try grabbing focus
  Sleep 800    ; wait for save to take effect
  Reload
  Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
  MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
  IfMsgBox, Yes, Edit     
  return
}
~^!F9::  ; Ctrl + Alt + F9 will pop up a status dialog
  doThisWithEveryKeypressOrClick(0)
  pop("isTextEntryMode(): " isTextEntryMode() "`nisWebBrowserActive(): "isWebBrowserActive())
return
!^+F6::
  pop("isNavigationMode: " isNavigationMode())
return

SendKeyedInput(x)
{
  StringLen, Length, x
  if (capsLockToggle and Length = 1) { 
    StringUpper, upper, x
    SendInput %upper%
  } else {
    SendInput %x%
  }
}



; Copyright © 2021 Bryan Klumpp.  All Rights Reserved.