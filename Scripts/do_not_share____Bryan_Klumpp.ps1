






<#  This file is labeled "DO_NOT_SHARE" because I (Bryan Klumpp) have written it so that it
is quite useful to me, but not at this point documented or packaged for general consumption  #>















$ShellObj = (New-Object -ComObject WScript.Shell)  #more reliable than PowerShell sendkeys etc

function finalize() {
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$ShellObj)
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Windows.Forms

#$myPath = Get-Item $MyInvocation.MyCommand.Path #non-ISE
$myPath=$psISE.CurrentFile.FullPath
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

<#Override default prompt to set color scheme; commented out for now 
  because I'm using PowerShell ISE exclusively for now, and this is 
  for a normal Powershell window; TODO2 make this context-sensitive#>
#function Prompt   
#{
#    $ANSIColorSequenceBW+"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' `
#    * ($nestedPromptLevel + 1)) "
#}
#---------------- Set Color Scheme - end -------------------

New-Alias restartScript -Name rr  #bprs
New-Alias restartScript -Name boot  #bprs
function  restartScript() {
    # the reason the batch file starts with a strange key pattern like _b73_ 
    # is so that the rest of it can be renamed for clarity, but another user 
    # would be less likely to touch a pattern like _b73_
    Start-Process (Get-ChildItem -Path $myDir "_b73_*")  #TODO verify still works after $myDir creation as String
    exit
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

function f() { Param($regex)
    get-childitem -Recurse -Path . | select-Object FullName | select-String "$regex" | Select-Object "Line"
}

#Set-Alias -Name a -Value activate
function act() { Param($titleFrag)
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
        $s = ($s + ($x.GetType().FullName) )
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


function matches() {
    return $args[0] -Match ('^' + $args[1] + '$')
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
    $encodedSearch=[System.Web.HTTPUtility]::UrlEncode($searchFor)
    $combinedUrl = $base -replace '_searchFor_',$encodedSearch
    web $combinedUrl
}

function web() {
    Start-Process $args[0] #uses default browser
}

function ww() {
  Write-Output $args
}

function myServiceTag() {
    return (wmic bios get serialnumber | select -index 2)
}

New-Alias dellSupport -Name d
function  dellSupport() {
    AltTab; CtrlC; Start-Process "https://www.dell.com/support/home/en-us"
}

new-alias dells -Name st
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


function SendKeys() {
    SendKeys2($args[0])
}
function AltTab() {
    SendKeys2 "%({TAB})"
}
function AltTabTab() {
    SendKeys2("%({TAB}{TAB})")
}
function CtrlC() {
    SendKeys2("^c")
}
function CtrlV() {
    Ctrl("v")
}
function ctrl() {
    SendKeys2('^'+$args[0])
}

New-Alias AltTabText -Name att

function rawTextToSendKeys() {
    return $args[0] -replace "`r`n", "{Enter}"`
                    -replace   "`n", "{Enter}"`
                    -replace "\(","{(}" `
                    -replace "\)","{)}" `
                    -replace "\+","{+}" `
                    -replace "\^","{^}" `
                    -replace "\%","{%}" `
                    -replace "\~","{~}"
}

function SendKeysFromRawText() {
    SendKeys1 (rawTextToSendKeys $args[0])
}

function  AltTabText() {
    $text = $args[0]
    AltTab
    wait 1000   #below, we escape/translate characters that are special to SendKeys
    SendKeys1 (rawTextToSendKeys $args[0])
}

function SendKeys1() {
    $ShellObj.SendKeys($args[0])
}
function SendKeys2() {
    [System.Windows.Forms.SendKeys]::SendWait($args[0])
}
function SendKeys3() {
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

function nitt() {
    AltTabPasteArg0 "Now is the time`nfor all good men to come to the aid of their country."
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


function newNotepadFromStartMenu() {
    Ctrl '{Esc}'
    SendKeys1 'notepad'
    wait 1500
    SendKeys2 '{Enter}'
}

new-alias EnableHibernateInstructions -Name hibi
function  EnableHibernateInstructions() {
    AltTab
    wait 500
    SendKeysFromRawText (f2s 'EnableHibernateInstructions')
}

new-alias fixWindowsCorruption -Name fwc
function  fixWindowsCorruption() {
    AltTab
    wait 500
    $batFileP='DO_NOT_SHARE___fix_Windows_corruption.bat'
    #SendKeys1 ('copy '+$myDir+'\empty_file.txt '+$batFileP+'{Enter}')
    
    wait 200; SendKeys1 ('[System.Environment]::CurrentDirectory = {(}Get-Location{)}.Path{Enter}')
    #wait 200; SendKeys1 ('$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False{Enter}')
    #wait 200; sendKeys1 ('[System.IO.File]::WriteAllLines{(}"'+$batFileP+'", "", $Utf8NoBomEncoding{)}{Enter}')
    wait 200; sendKeys1 ('[System.IO.File]::WriteAllText{(}"'+$batFileP+'", ""{)}{Enter}')

    wait 300
    SendKeys1 ('start-process -Wait notepad -ArgumentList ('+$batFileP+'){Enter}')         
    wait 1500
    SendKeysFromRawText (f2s ($myDir+'\DO_NOT_SHARE___fix_Windows_corruption.bat') )
    wait 2000
    SendKeys1 '%({F})'
    wait 500
    SendKeys1 'S%{F4}'
    wait 500
<#    SendKeys1 ('explorer /select,'+$batFileP+'{Enter}')
    wait 2000  '#>
   # SendKeys1 ('start-process -verb runas '+$windir+'\system32\cmd.exe -ArgumentList "/c '+$batFileP+'"')
   SendKeys1 ('start-process -verb runas ./'+$batFileP)
}

#inline/startup/init code (end of function declarations)
foreach ($nextCustScript in (dir .\*custom*functions*ps1) ) {
    . $nextCustScript
}
psISEBlackOnWhite

