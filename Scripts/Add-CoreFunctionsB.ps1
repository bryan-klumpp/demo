<#### Commented out code but might be useful executing in some environments
      like PowerShell ISE or computers without existing shortcuts

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

#command snippets
([System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\IT\Add-CoreFunctionsB.ps1')
                                        ( $Env:USERPROFILE   + '\IT\Add-CoreFunctionsB.ps1')

# execute non-admin, then admin, on user's PC 
Start-Process ($PSHOME + "\powershell.exe") -ArgumentList ('-ExecutionPolicy Unrestricted `
   -NoProfile -NoExit -File ' + $psISE.CurrentFile.FullPath)
Start-Process ($PSHOME + "\powershell.exe") -ArgumentList ('-ExecutionPolicy Unrestricted `
   -NoProfile -NoExit -File ' + $psISE.CurrentFile.FullPath) -Verb RunAs

####>

Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Windows.Forms

$myPath = Get-Item $MyInvocation.MyCommand.Path
$myDir = $myPath.Directory

new-alias getEnvironmentVariable -Name env   #bshort
function  getEnvironmentVariable() {
    return [System.Environment]::GetEnvironmentVariable($args[0])
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
    Start-Process (Get-ChildItem -Path $myDir "_b73_*")  
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

function f() { Param($regex)
    get-childitem -Recurse -Path . | select-Object FullName | select-String "$regex" | Select-Object "Line"
}

#Set-Alias -Name a -Value activate
function act() { Param($titleFrag)
    #Set-ForegroundWindow (Get-Process "Edge").MainWindowHandle
    #(Get-Process | Where-Object { $_.MainWindowTitle -like '*Edge' })
    (New-Object -ComObject WScript.Shell).AppActivate((Get-Process `
     | Where-Object { $_.MainWindowTitle -like ('*'+$titleFrag+'*') }).MainWindowTitle)
}

function toArrayList() {
    $al = [System.Collection.ArrayList](New-Object System.Collections.ArrayList($null))
    $al.AddRange($args)
    return $al
}


function whatisit() {
    Write-Host (whatisitO $args[0] $args[1])
}
function whatisitO() {
    $s = ($args[0])
    $x = $args[1]
    if($x -is [Array]) {
        $xa = [Array]$x
        $s = ($s + '@(')
        for($i = 0; $i -lt $xa.Count; $i++) {
            $s += (whatisitO '' $xa[$i])
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
    [System.Windows.Forms.SendKeys]::SendWait($args[0])
}
function AltTab() {
    SendKeys "%({TAB})"
}
function AltTabTab() {
    [System.Windows.Forms.SendKeys]::SendWait("%({TAB}{TAB})")
}
function CtrlC() {
    [System.Windows.Forms.SendKeys]::SendWait("^c")
}
function CtrlV() {
    [System.Windows.Forms.SendKeys]::SendWait("^v")
}
function AltTabPasteArg0() {
    $text = $args[0]
    set-clipboard $text
    AltTab
    CtrlV
}

function nitt() {
    AltTabPasteArg0 "Now is the time`nfor all good men to come to the aid of their country."
}

foreach ($nextCustScript in (dir .\*custom*functions*ps1) ) {
    . $nextCustScript
}

#non-function code executed on startup
#bw
