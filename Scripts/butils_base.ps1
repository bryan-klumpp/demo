




<#  This file is labeled "DO_NOT_SHARE" because I've have written it so that it
is quite useful to encapsulate my daily tasks, but not at this point adapted,
documented, or packaged for general consumption.
 -Bryan Klumpp  #>




$global:outlookexe = 'C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE'
$global:teamsexe = 'C:\Users\b\AppData\Local\Microsoft\Teams\current\Teams.exe'
$global:templatesDir = 'C:\Users\b\eclipse\w1\Scripts\templates'
$ShellObj = (New-Object -ComObject WScript.Shell)  #please clean up in finalize(); this is more reliable than PowerShell sendkeys etc.
function finalize() {
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$ShellObj)
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Windows.Forms

#$myPath = Get-Item $MyInvocation.MyCommand.Path #non-ISE
$isISE = ($psISE.CurrentFile.FullPath -ne $null)
$myPath = switch($isISE) { $true {$psISE.CurrentFile.FullPath} $false { 
    #TODO find a way to get path in normal PowerShell window    
} }

$myDir=[String](([System.IO.DirectoryInfo]$myPath).Parent.FullName)

new-alias getEnvironmentVariable -Name env   #bshort
function  getEnvironmentVariable() {
    return [System.Environment]::GetEnvironmentVariable($args[0])
}
$windir=getEnvironmentVariable('WINDIR')

new-alias skimFileForSecurity -Name ssk
function  skimFileForSecurity() {
    Start-Process ($windir+'\notepad.exe') -ArgumentList $myPath -WindowStyle Maximized
}

#--------- Set Color Scheme Black on White - begin -------------
$ANSIColorSequenceBW="$([char]0x1b)[38;2;0;0;0;48;2;255;255;255;m"
Function bw() {
    if($isISE) {
        psISEBlackOnWhite
        return
    }

    $host.ui.rawui.ForegroundColor = 'Black'
    $host.ui.rawui.BackgroundColor = 'White'
    Set-PSReadLineOption -Colors @{
        ContinuationPrompt="$ANSIColorSequenceBW" 
        Emphasis= "$ANSIColorSequenceBW"
        Error= "$ANSIColorSequenceBW"
        Selection= "$ANSIColorSequenceBW"
        Default= "$ANSIColorSequenceBW"
        Comment= "$ANSIColorSequenceBW"
        Keyword= "$ANSIColorSequenceBW"
        String= "$ANSIColorSequenceBW"
        Operator= "$ANSIColorSequenceBW"
        Variable= "$ANSIColorSequenceBW"
        Command= "$ANSIColorSequenceBW"
        Parameter= "$ANSIColorSequenceBW"
        Type= "$ANSIColorSequenceBW"
        Number= "$ANSIColorSequenceBW"
        Member= "$ANSIColorSequenceBW"
        InlinePrediction= "$ANSIColorSequenceBW"
    }
    $Host.PrivateData.ErrorForegroundColor = "Red"
    $Host.PrivateData.ErrorBackgroundColor = "White"
    $Host.PrivateData.WarningForegroundColor = "Black"
    $Host.PrivateData.WarningBackgroundColor = "White"
    $Host.PrivateData.DebugForegroundColor = "Black"
    $Host.PrivateData.DebugBackgroundColor = "White"
    $Host.PrivateData.VerboseForegroundColor = "Black"
    $Host.PrivateData.VerboseBackgroundColor = "White"
    $Host.PrivateData.ProgressForegroundColor = "Black"
    $Host.PrivateData.ProgressBackgroundColor = "White"
 
    #Note that the overriden Prompt method fixes the remaining color piece
}

<#Override default prompt to set color scheme; This may have unexpected behavior if created in a ISE window?
function Prompt   
{
    $ANSIColorSequenceBW+"PSbw $($executionContext.SessionState.Path.CurrentLocation)$('>' `
    * ($nestedPromptLevel + 1)) "
}
#---------------- Set Color Scheme - end -------------------

<# not sure the all the background colors are canonically correct,
   but seems to be working great, so I'm not messing with it #>
new-alias psISEBlackOnWhite -name bwise 
function  psISEBlackOnWhite() { 
    $psISE.Options.ErrorForegroundColor           ='#FFFF9494'
    $psISE.Options.ErrorBackgroundColor           ='#00FFFFFF'
    $psISE.Options.WarningForegroundColor         ='#FFFF8C00'
    $psISE.Options.WarningBackgroundColor         ='#00FFFFFF'
    $psISE.Options.VerboseForegroundColor         ='#FF00FFFF'
    $psISE.Options.VerboseBackgroundColor         ='#00FFFFFF'
    $psISE.Options.DebugForegroundColor           ='#FF00FFFF'
    $psISE.Options.DebugBackgroundColor           ='#00FFFFFF'
    $psISE.Options.ConsolePaneBackgroundColor     ='#FFFFFFFF'
    $psISE.Options.ConsolePaneTextBackgroundColor ='#FFFFFFFF'
    $psISE.Options.ConsolePaneForegroundColor     ='#FF000000'
    $psISE.Options.ScriptPaneBackgroundColor      ='#FFFFFFFF'
    $psISE.Options.ScriptPaneForegroundColor      ='#FF000000'
    
    #https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/object-model/the-iseoptions-object?view=powershell-7.2
$psISE.Options.ConsoleTokenColors["Attribute"]='black'
$psISE.Options.ConsoleTokenColors["Command"]='black'
$psISE.Options.ConsoleTokenColors["CommandArgument"]='black'
$psISE.Options.ConsoleTokenColors["CommandParameter"]='black'
$psISE.Options.ConsoleTokenColors["Comment"]='black'
$psISE.Options.ConsoleTokenColors["GroupEnd"]='black'
$psISE.Options.ConsoleTokenColors["GroupStart"]='black'
$psISE.Options.ConsoleTokenColors["Keyword"]='black'
$psISE.Options.ConsoleTokenColors["LineContinuation"]='black'
$psISE.Options.ConsoleTokenColors["LoopLabel"]='black'
$psISE.Options.ConsoleTokenColors["Member"]='black'
$psISE.Options.ConsoleTokenColors["NewLine"]='black'
$psISE.Options.ConsoleTokenColors["Number"]='black'
$psISE.Options.ConsoleTokenColors["Operator"]='black'
$psISE.Options.ConsoleTokenColors["Position"]='black'
$psISE.Options.ConsoleTokenColors["StatementSeparator"]='black'
$psISE.Options.ConsoleTokenColors["String"]='black'
$psISE.Options.ConsoleTokenColors["Type"]='black'
$psISE.Options.ConsoleTokenColors["Unknown"]='black'
$psISE.Options.ConsoleTokenColors["Variable"]='black' 


#Honestly I don't recall if there is anything useful in the rest of the commented code below in this function, but I'll leave it just in case

   #$psISE.Options.RestoreDefaultConsoleTokenColors()  

    <# default ConsoleTokenColors
    PS C:\Users\b> $psISE.Options.ConsoleTokenColors

               Key Value    
               --- -----    
         Attribute #FFB0C4DE
           Command #FF000000
   CommandArgument #FFEE82EE
  CommandParameter #FFFFE4B5
           Comment #FF98FB98
          GroupEnd #FFF5F5F5
        GroupStart #FFF5F5F5
           Keyword #FFE0FFFF
  LineContinuation #FFF5F5F5
         LoopLabel #FFE0FFFF
            Member #FFF5F5F5
           NewLine #FFF5F5F5
            Number #FFFFE4C4
          Operator #FFD3D3D3
          Position #FFF5F5F5
StatementSeparator #FFF5F5F5
            String #FFDB7093
              Type #FF8FBC8F
           Unknown #FFF5F5F5
          Variable #FFFF4500
    #>
}


function psISEColorDefault() {
    $psISE.Options.ErrorForegroundColor           ='#FFFF9494'
    $psISE.Options.ErrorBackgroundColor           ='#00FFFFFF'
    $psISE.Options.WarningForegroundColor         ='#FFFF8C00'
    $psISE.Options.WarningBackgroundColor         ='#00FFFFFF'
    $psISE.Options.VerboseForegroundColor         ='#FF00FFFF'
    $psISE.Options.VerboseBackgroundColor         ='#00FFFFFF'
    $psISE.Options.DebugForegroundColor           ='#FF00FFFF'
    $psISE.Options.DebugBackgroundColor           ='#00FFFFFF'
    $psISE.Options.ConsolePaneBackgroundColor     ='#FF000080'
    $psISE.Options.ConsolePaneTextBackgroundColor ='#FF012456'
    $psISE.Options.ConsolePaneForegroundColor     ='#FFF5F5F5'
    $psISE.Options.ScriptPaneBackgroundColor      ='#FFFFFFFF'
    $psISE.Options.ScriptPaneForegroundColor      ='#FF000000'
}
function psISEColorInverted() {
    $psISE.Options.ErrorBackgroundColor           ='#FFFF9494'
    $psISE.Options.ErrorForegroundColor           ='#00FFFFFF'
    $psISE.Options.WarningBackgroundColor         ='#FFFF8C00'
    $psISE.Options.WarningForegroundColor         ='#00FFFFFF'
    $psISE.Options.VerboseBackgroundColor         ='#FF00FFFF'
    $psISE.Options.VerboseForegroundColor         ='#00FFFFFF'
    $psISE.Options.DebugBackgroundColor           ='#FF00FFFF'
    $psISE.Options.DebugForegroundColor           ='#00FFFFFF'
    $psISE.Options.ConsolePaneForegroundColor     ='#FF000080'
    $psISE.Options.ConsolePaneTextForegroundColor ='#FF012456'
    $psISE.Options.ConsolePaneBackgroundColor     ='#FFF5F5F5'
    $psISE.Options.ScriptPaneForegroundColor      ='#FFFFFFFF'
    $psISE.Options.ScriptPaneBackgroundColor      ='#FF000000'
}

New-Alias restartScript -Name rr  #bprs
New-Alias restartScript -Name boot  #bprs
function  restartScript() {
    # the reason the batch file starts with a strange key pattern like _b73_ 
    # is so that the rest of it can be renamed for clarity, but another user 
    # would be less likely to touch a pattern like _b73_
    Start-Process (Get-ChildItem -Path $myDir "_b73_*")  #TODO verify still works after $myDir creation as String
    exit
}

new-alias focusoneditor -Name e
new-alias focusoneditor -Name foe
function focusOnEditor() {
    Ctrl 'i'
}

#Not sure if this will work in PsExec, but here is an example of path for a WindowsShortcut to load a script and launch a function in RegularPowerShell: %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -command "Invoke-Expression ((Get-Content C:\Users\......\Scripts\butils_base.ps1) | Out-String); bbb"   OR   %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -command "Get-Content 'C:\Users\......\Scripts\butils_base.ps1' | Out-String | Invoke-Expression; bw"
function myBat() {
    ($PSHOME + '\powershell_ise.exe "'+$mypath+'"')|clip
    ww "Copied to clipboard batch file command(s) that will open PowerShell ISE with this file"
}
function edit() {
    Start-Process ($PSHOME + '\powershell_ise.exe') $mypath
}
New-Alias editAndRestart -Name edb  #bprs
function  editAndRestart() {
    Start-Process -wait ($PSHOME + '\powershell_ise.exe') $mypath
    restartScript
}

function userProfileDir() {
    return $env:USERPROFILE
}

function wait() {
    start-sleep -Milliseconds ($args[0])
}

new-alias findRegex -Name f
function findRegex() { Param($regex)
    #get-childitem -Recurse -Path . | select-Object FullName | select-String "$regex" | Select-Object "Line"
    get-childitem -Recurse -Path . | select-Object FullName | select-String "$regex"    #| Select-Object "Line" | Format-Table -Wrap
}
new-alias Activate-Window -Name acta
function Activate-Window() {
    $ShellObj.AppActivate($args[0]) | Out-Null
    wait 200 #seems like nearly all subsequent actions require at least some delay
}
New-Alias Activate-Window-Wildcard -Name act
function  Activate-Window-Wildcard() { Param($titleFrag)
    #Set-ForegroundWindow (Get-Process "Edge").MainWindowHandle
    #(Get-Process | Where-Object { $_.MainWindowTitle -like '*Edge' })
    $shellObj.AppActivate((Get-Process `
     | Where-Object { $_.MainWindowTitle -like ('*'+$titleFrag+'*') }).MainWindowTitle)
}

function toArrayList() {
    $al = [System.Collection.ArrayList](New-Object System.Collections.ArrayList($null))
    $al.AddRange($args)
    return $al
}


function whatisit() {
    Write-Host (whatisitRecurse '' $args[0])
}
function whatisitRecurse() {
    $s = ($args[0])
    $x = $args[1]
    if($x -is [Array]) {
        $xa = [Array]$x
        $s = ($s + '@(')
        for($i = 0; $i -lt $xa.Count; $i++) {
            $s += (whatisitRecurse '' $xa[$i])
            if($i -lt $xa.Count - 1) {
                $s += ','
            }
        }
        $s += ')'
    } else {
        if($x -eq $null) {
            $s = ($s + 'null')
        } else {
            $s = ($s + ($x.GetType().FullName) )
        }
    }
    return $s
}



################# web/intranet searching ###################
<#/table/incident?sysparm_query=sys_id=bbc2ddcedba51300b2bd711ebf961944
  ^category=enquiry&sysparm_exclude_reference_link=true&sysparm_view=false
  &sysparm_display_value=false&sysparm_suppress_pagination=false&sysparm_limit=500  
  https://community.servicenow.com/community?id=community_question&sys_id=a3a50c1edbd7d3001cd8a345ca961942  IP1 #>

function inctempl() {
    searchByURL ('https://<instance name>.service-now.com/incident_list.do?HTML' +`
                 '&sysparm_query=priority=1&sysparm_orderby=assigned_to')
}
New-Alias task -Name ta
function  tasktempl() {
    $searchFor = ('number='+$args[0])
    searchByURL ('https://<instance name>.service-now.com/task_list.do?HTML' +`
    '&sysparm_query=_searchFor_&sysparm_orderby=assigned_to') $searchFor
}
new-alias googleSearch -Name se #bshort
function  googleSearch() {
    searchByURL "https://www.google.com/search?q=_searchFor_" $args
}



function autoClipParm() {
    $clipt = (Get-Clipboard).trim()
    if( matches ($clipt) $args[0] ) {
        return ($clipt)
    } else {
        return $args[1].trim()
    }
}

function searchByURL() { 
    #Add-Type -AssemblyName System.Web  #included at beginning of file?
    $base      = $args[0]
    $searchStrings = @($args[1])
    for(($i=0); $i -lt $SearchStrings.length; $i++){
        #make sure it doesn't already start with a quote, but if not, and it has spaces, quote it
        if($SearchStrings[$i] -Match ' ' -and (-not($SearchStrings[$i] -Match '$"'))) { 
            $SearchStrings[$i] = ('"'+$SearchStrings[$i]+'"')
        }
    }
    $searchFor=($SearchStrings -join ' ')
    $encodedSearch=UrlEncode($searchFor)
    $combinedUrl = $base -replace '_searchFor_',$encodedSearch
    web $combinedUrl
}

function uriescape() {
    return [uri]::EscapeDataString($args[0])
}

function urlencode() {
    return [System.Web.HTTPUtility]::UrlEncode($args[0] -replace(' ','%20'))
}
function urldecode() {
    return [System.Web.HTTPUtility]::UrlDecode($args[0])
}
function web() {
    Start-Process $args[0] #uses default browser
}

new-alias Write-Output -name ww

function myServiceTag() {
    return (wmic bios get serialnumber | select -index 2)
}

New-Alias dellSupport -Name atccds
function  dellSupport() {
    AltTab; CtrlC; Start-Process "https://www.dell.com/support/home/en-us"
}

new-alias dells -Name dellst
function  dells() {
    searchByURL https://www.dell.com/support/home/en-us/product-support/servicetag/_searchFor_ `
     (autoclipparm '[A-Za-z0-9]{7}')
}

Function AdminShell() {
  start-process -Credential (get-credential) -verb runas powershell
}

Function robobak() {
    $bakDir='c:\backup'
    $userProfile=$env:USERPROFILE
    #make the filename shorter than c:\users to attempt to avoid total path length issues, although still possible
    # not using /Z, possible better performance, TODO measure it; also re-evaluate /B, may need admin elevation
    # remove /SEC if wanting to execute with non-admin user
    md $bakDir  
    $cmdString = ("`@echo off`r`nrobocopy $userProfile $bakDir /E /SEC /SJ /SL /DCOPY:DAT /XD" + `
       " `"$userProfile\AppData`" /XJ /R:0 /W:0 /V /FP /LOG:$bakDir\robocopy_log.txt /TEE`n" + `
       "echo Please screenshot this text and send to IT if there are any questions about whether " + `
       "it was totally successful, especially if more than 0 files show up as FAILED`r`npause`r`npause`r`npause")
    $bat = ($bakDir + "\_go.bat")
    Write-Output $cmdString | Out-File -Encoding utf8 $bat
    Write-Host ("run batch file " + $bat + " as Administrator, copying to clipboard")
    $bat | Set-Clipboard
}


function AltTab() {
    SendKeysSyncNoTranslate "%({TAB})"
}
function AltTabTab() {
    SendKeysSyncNoTranslate("%({TAB}{TAB})")
}
function CtrlX() {
    Ctrl("x")
}
function CtrlC() {
    Ctrl("c")
}
function CtrlV() {
    Ctrl("v")
}
function ctrl() {
    SendKeysSyncNoTranslate('^('+$args[0]+')')
}
function ctrlShift() {
    SendKeysSyncNoTranslate('^(+('+$args[0]+'))')
}
function AltShift() {
    SendKeysSyncNoTranslate('%(+('+$args[0]+'))')
}
function Alt() {
    SendKeysSyncNoTranslate('%({'+$args[0]+'})')
}

New-Alias AltTabText -Name att

function escapeSendKeys() {
    return $args[0] -replace "`r`n", "{Enter}"`
                    -replace   "`n", "{Enter}"`
                    -replace "\(","{(}" `
                    -replace "\)","{)}" `
                    -replace "\+","{+}" `
                    -replace "\^","{^}" `
                    -replace "\%","{%}" `
                    -replace "\~","{~}"
}
function escapeSendKeysShiftEnter() {
    return $args[0] -replace "`r`n", "+{Enter}"`
                    -replace   "`n", "+{Enter}"`
                    -replace "\(","{(}" `
                    -replace "\)","{)}" `
                    -replace "\+","{+}" `
                    -replace "\^","{^}" `
                    -replace "\%","{%}" `
                    -replace "\~","{~}"
}
function SendKeysFromRawText() {
    SendKeysAsyncTranslate ($args[0])
}

function  AltTabText() {
    $text = $args[0]
    AltTab
    wait 1000
    SendKeysAsyncTranslate ($args[0])
}

new-alias SendKeysAsyncTranslate -Name SendKeys1
function  SendKeysAsyncTranslate() {
    foreach ($arg in $args) {
        SendKeysAsyncNoTranslate(escapeSendKeys($arg))    
    }    
}
function SendKeysAsyncNoTranslate() {
    $text=($args[0])
    $ShellObj.SendKeys( $text )
}
new-alias SendKeysSyncNoTranslate -Name SendKeys2
function SendKeysSyncNoTranslate() {
    [System.Windows.Forms.SendKeys]::SendWait($args[0])
}
function SendKeys3broke() {
    #for this option to actually work we need to SetActiveWindow() somehow as per https://stackoverflow.com/questions/32077050/sending-a-keypress-to-the-active-window-that-doesnt-handle-windows-message-in-c
    [System.Windows.Forms.SendKeys]::Send($args[0])
}

New-Alias -Name AltTabPaste AltTabPasteArg0
function AltTabPasteArg0() {
    $text = $args[0]
    set-clipboard $text
    AltTab
    wait 1000
    CtrlV
}

function nitttest() {
    AltTabPasteArg0 "Now is the time`nfor all good men to come to the aid of their country."
}

function atpdemo1() {
    alttabpaste ("asdf" `
                + "`nasdf")
}

function delaliasdoesnotworkinsidefunctionjustforexamplecode() { 
    del alias:$args[0] 2>&1 | Out-Null  #not bothering to test, just suppressing error if doesn't exist
}

function exists() {
    return Test-Path $args[0]
}

new-alias filetostring -Name f2s
function  filetostring() {
    if(exists($args[0])) {
        return get-content $args[0] -raw
    } else {
        $key=$args[0]
        $fileN=($myDir+'\strings\'+$key+'.txt')
        if(exists($fileN)) {
            return get-content $fileN -raw
        } else {
            $props = convertfrom-stringdata (get-content ($myDir+'\strings.txt') -raw)
            return $props.get_item($key)
        }
    }
}

new-alias readFileAsArrayOfStrings -Name readarray 
function  readFileAsArrayOfStrings() {
    return get-content $args[0]
}
new-alias readFileAsSingleString -Name readraw
function  readFileAsSingleString() {
    return get-content -raw $args[0]
}


function newNotepadFromStartMenu() {
    Ctrl '{Esc}'
    SendKeysAsyncTranslate 'notepad'
    wait 1500
    SendKeysAsyncTranslate '{Enter}'
}

new-alias EnableHibernateInstructions -Name hibi
function  EnableHibernateInstructions() {
    AltTab
    wait 500
    SendKeysFromRawText (f2s 'EnableHibernateInstructions')
}

new-alias activate-teams -name acttms
function  Activate-Teams() {
    Activate-Window 'Chat' #not sure why 'Teams' doesn't always work, window matching used to work on the end of the Window title
}
new-alias New-Teams-Chat -name newtms
function  New-Teams-Chat() {
    Activate-Teams
    Ctrl 'n'
}


new-alias Activate-Outlook -name actout
function  Activate-Outlook() {
    Activate-Window 'Inbox' #not sure why 'Outlook' doesn't work now, window matching used to work on the end of the Window title
}

function Activate-Remote-Window() {
    if (!(Activate-Window 'SCCM')) {
        AltTab  #fallback, assume running locally one either my PC or user's
    }
}

function activate-outlook() {
    #activate-window 'Inbox'
    Start-Process $global:outlookexe -ArgumentList '/recycle'
}

#https://support.microsoft.com/en-us/office/command-line-switches-for-microsoft-office-products-079164cd-4ef5-4178-b235-441737deb3a6#Category=Outlook
function new-Outlook-Message() {
    #activate-Outlook; wait 500; CtrlShift 'M'
    Start-Process $global:outlookexe `
      -ArgumentList '/recycle /c ipm.note'

}

#could refine the criteria even more, doesn't include ALL the email rules yet, but works well enough for now
function isEmail() {
    return matches $args[0] '[A-Za-z0-9.]{1,50}@[A-Za-z0-9.]{3,50}'
}

function matches() {
    return $args[0] -Match ('^' + $args[1] + '$')
}


function  Tab() {
    SendKeysSyncNoTranslate '{Tab}'
}
function  loader() {
    Activate-Remote-Window
    wait 500
    SendKeysAsyncTranslate '\\server\share'
}

new-alias fixWindowsCorruption -Name fwc
new-alias fixWindowsCorruption -Name corrupt
function  fixWindowsCorruption() {
    Activate-Remote-Window
    wait 500
    $batFileP='DO_NOT_SHARE___fix_Windows_corruption.bat'
    #SendKeysAsyncTranslate ('copy '+$myDir+'\empty_file.txt '+$batFileP+'{Enter}')
    
    wait 200; SendKeysAsyncTranslate ('[System.Environment]::CurrentDirectory = (Get-Location).Path{Enter}')
    #wait 200; SendKeysAsyncTranslate ('$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False{Enter}')
    #wait 200; SendKeysAsyncTranslate ('[System.IO.File]::WriteAllLines{(}"'+$batFileP+'", "", $Utf8NoBomEncoding{)}{Enter}')
    wait 200; SendKeysAsyncTranslate ('[System.IO.File]::WriteAllText("'+$batFileP+'", ""){Enter}')
    #wait 200; SendKeysAsyncTranslate ('$batFilePFQ[System.IO.File]::WriteAllText(((Get-Location).Path)+"\'+$batFileP+'"), ""){Enter}')
    #wait 200; SendKeysAsyncTranslate ('[System.IO.File]::WriteAllText(((Get-Location).Path)+"\'+$batFileP+'"), ""){Enter}')

    wait 300
    SendKeysAsyncTranslate ('start-process -Wait notepad -ArgumentList ("'+$batFileP+'"){Enter}')         
    wait 1500
    SendKeysFromRawText (f2s ($myDir+'\DO_NOT_SHARE___fix_Windows_corruption.bat') )
    wait 2000
    Alt 'F'; wait 500; SendKeysAsyncTranslate 'S'; Alt 'F4'; wait 500
<#    SendKeysAsyncTranslate ('explorer /select,'+$batFileP+'{Enter}')
    wait 2000  '#>
   # SendKeysAsyncTranslate ('start-process -verb runas '+$windir+'\system32\cmd.exe -ArgumentList "/c '+$batFileP+'"')
   SendKeysAsyncTranslate ('start-process -verb runas ./'+$batFileP)
}

function Activate-Teams() {
    #window text activate does not always work, just hitting the exe instead
    Start-Process $global:teamsexe
}
#Clipboard: email address, $args[0]=Message text
function  Teams-EndToEnd-1-OLD() {
    $addr=(get-clipboard)
    $msg=(escapeSendKeysShiftEnter $args[0])
    new-Teams-Message
    wait 1000; AltShift 'c'; wait 500
    SendKeysAsyncNoTranslate $msg
    wait 4000  #give a chance to abort
    Ctrl '{Enter}'
}
#maybe best to have Teams not visible before running this?
new-alias Teams-EndToEnd-Message -Name te2e
function Teams-EndToEnd-Message() {
    $emailaddress=(Get-Clipboard)
    $bodyKeys=(escapeSendKeysShiftEnter $args[0])
    activate-Teams
    wait 500
    Ctrl 'N'
    wait 500
    #if (isEmail($clip) -or matches $clip '[A-Za-z0-9]{1,8}') {
        CtrlV; wait 4000
    #}
    AltShift 'c'; wait 400
    SendKeysAsyncNoTranslate $bodyKeys; wait 4000
    Ctrl '{Enter}'
    #Alt '{F4}'
}


# email address on clipboard, 1=subject, 2=full message
new-alias Email-EndToEnd-1 -Name oe2e
new-alias Email-EndToEnd-1 -Name ee2e
function  Email-EndToEnd-1() {
    $addr=(get-clipboard)
    $subject=$args[0]
    $body=$args[1]

    #new-Outlook-Message
    #wait 300; CtrlV
    #wait 200; Tab; wait 200; Tab
    #SendKeysAsyncTranslate $subject
    #wait 200; Tab
    #SendKeysAsyncTranslate $body
    #testdata copy klumpp6@ggggggggmail.com   
    Start-Process $global:outlookexe -ArgumentList ('/c ipm.note /m '+$addr+'?subject='+(uriescape $subject)+'&body='+(uriescape $body))
    wait 4000  #give a chance to abort
    send-Outlook-Message
}
function send-Outlook-Message() {
    #activate-Outlook
    #wait 500
    Alt 's'
    #Ctrl '{Enter}'
}
new-alias cnr1 -Name cc
function  cnr1() {
    $issue=$args[0]
    $emailsubject=('Contact me regarding '+$issue)
    $messagecore=("Hello, this is Bryan from desktop support.  I'm reaching out in regard to the issue you raised, regarding" `
      + " "+$issue+".  I do apologize for the delay in reaching out."`
      + "  You can reach out to me by email, chat, or call me directly (I'm usually available for calls outside of 9:00-9:45)" `
      + " to discuss this issue further." `
      + "  If applicable, let me know the time(s) of day that you are generally the most available for scheduling appointments.")
    $worknotes=("I sent an Outlook direct email to the user with the same message as the Additional Comments." `
      + " .__ " ) #custom notes
    $emailmessage=($messagecore + "`n`nBryan Klumpp`ncontact_info")
    AltTab; wait 500  #switch back to ServiceNow browser window
    SendKeys1 $worknotes; SendKeys2 '{Tab}{Tab}'; SendKeys1 $messagecore
    wait 1000
    ee2e $emailsubject $emailmessage
    te2e $messagecore
    #Alt '{F4}'
}
function downloadMeCAREFULbackupfirst() {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bryan-klumpp/demo/main/Scripts/do_not_share____Bryan_Klumpp.ps1" -OutFile $myPath
}

function Hello-World() {
    ww "Hello World"
}

function testnotin() {
    $in0 = @('asdf','xbsdf')
    $in1 = @('asdf')
    notin $in0 $in1
}

function notin() {
    $in0 = @($args[0])
    $in1 = @($args[1])
    $notin = [System.Collections.ArrayList]::new()

    foreach ($next0 in $in0) {
        $foundMatch=$false
        foreach ($next1 in $in1) {
           if($next0.trim() -eq $next1.trim()) {
                $foundMatch = $true
                break
           }
        }
        if(-not $foundMatch) {
            $notin.Add( $next0 ) > $null
        }
    }
    return $notin.ToArray()
}

function copyIPAddresses() {
    ipconfig /all | findstr 'IPv4' | set-clipboard
    <#
    powershell -Command 'ipconfig /all | findstr IPv4; pause'
    #>
}

function base64encode() {
    [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Args[0]))
}

function base64decode() {
    [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Args[0]))
}

function equalsTrim() {
    return $args[0].trim() -eq $args[1].trim()
}

#Thanks to whoever came up with this C# keyboard hook, I found it at a post by user "marsze" at https://stackoverflow.com/questions/54236696/how-to-capture-global-keystrokes-with-powershell but it looks to be older, https://hinchley.net/articles/creating-a-key-logger-via-a-global-system-hook-using-powershell (Pete Hinchley) and https://null-byte.wonderhowto.com/how-to/create-simple-hidden-console-keylogger-c-sharp-0132757/ (Mr. Falkreath) are posts from 2013 and 2012, respectively.
Add-Type -TypeDefinition '
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace KeyLogger {
  public static class Program {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;

    private static HookProc hookProc = HookCallback;
    private static IntPtr hookId = IntPtr.Zero;
    private static int keyCode = 0;

    [DllImport("user32.dll")]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("kernel32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    public static int WaitForKey() {
      hookId = SetHook(hookProc);
      Application.Run();
      UnhookWindowsHookEx(hookId);
      return keyCode;
    }

    private static IntPtr SetHook(HookProc hookProc) {
      IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
      return SetWindowsHookEx(WH_KEYBOARD_LL, hookProc, moduleHandle, 0);
    }

    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
      if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) {
        keyCode = Marshal.ReadInt32(lParam);
        Application.Exit();
      }
      return CallNextHookEx(hookId, nCode, wParam, lParam);
    }
  }
}
' -ReferencedAssemblies System.Windows.Forms



$key = $prevKey1 = $null
[System.Windows.Forms.Keys[]]$ModKeys = @("LControlKey","LShiftKey", "Alt")
function isModKey() {
    return $ModKeys -contains $args[0]
}

# Some functions can be reflectively invoked, using functions with names like "kh_F12", "kh_LControlKey_F12", etc., while first testing to see if the function actually exists for a given key combination.
# However - I found that using Invoke-Expression caused issues with functions that activated windows, so some of this has to be done by normal invocation
new-alias keyboardHook -Name bhk
new-alias keyboardHook -Name bbb
function  keyboardHook() {
    while ($true) {
        $prevKey1 = $key
        $key = [System.Windows.Forms.Keys][KeyLogger.Program]::WaitForKey()

        if(isModKey $prevKey1) {
            $functName = ("khx_"+$prevKey1+"_"+$key)
        } else {
            $functName = ("khx_"              +$key)
        }
        if (Get-Command -ErrorAction SilentlyContinue $functName) {
            Invoke-Expression $functName
            continue
        }

        #This section is for commands such as window activators that require direct invocation rather than Invoke-Expression.  As this could grow to some size, I'm compressing the lines more than usual
        if ($key -eq "F12") {if (-not (isModKey( $prevKey1 ))) { kh_F12 } continue } 

    }
}

function khx_F2() {
    AltTab
}
function khx_F11() {
    Get-Content ($templatesDir + '\' + "HelloWorld.txt") | Set-Clipboard
    CtrlV
}

function khx_F10() {
    SendKeys1 'Hello World'
}
function khx_LControlKey_F10() {
    SendKeys1 'HELLO WORLD'
}

function kh_F12() {
    Activate-Window "interactive"
}



#inline/startup/init code (end of function declarations)
foreach ($nextCustScript in (dir .\*custom*functions*ps1) ) {
    . $nextCustScript
}

