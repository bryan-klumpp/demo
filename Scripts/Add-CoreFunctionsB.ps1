Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.Windows.Forms


$myPath = Get-Item $MyInvocation.MyCommand.Path
$myDir = $myPath.Directory

#--------------- Set Color Scheme - begin ------------------
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

function Prompt   #Override default prompt to set color scheme
{
    $ANSIColorSequenceBW+"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
#---------------- Set Color Scheme - end -------------------

New-Alias restartScript -Name rr  #bprs
New-Alias restartScript -Name boot  #bprs
function  restartScript() {
    Start-Process (Get-ChildItem -Path $myDir "_b73_*")  #the reason the batch file starts with a strange key pattern like _b73_ is so that the rest of it can be renamed for clarity, but another user would be less likely to touch a pattern like _b73_
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
    (New-Object -ComObject WScript.Shell).AppActivate((Get-Process | Where-Object { $_.MainWindowTitle -like ('*'+$titleFrag+'*') }).MainWindowTitle)
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
#/table/incident?sysparm_query=sys_id=bbc2ddcedba51300b2bd711ebf961944^category=enquiry&sysparm_exclude_reference_link=true&sysparm_view=false&sysparm_display_value=false&sysparm_suppress_pagination=false&sysparm_limit=500  https://community.servicenow.com/community?id=community_question&sys_id=a3a50c1edbd7d3001cd8a345ca961942  IP1
function inc() {
    searchByURL 'https://<instance name>.service-now.com/incident_list.do?HTML&sysparm_query=priority=1&sysparm_orderby=assigned_to'
}
function task() {
    searchByURL 'https://<instance name>.service-now.com/task_list.do?HTML&sysparm_query=priority=1&sysparm_orderby=assigned_to'
}
function w() {
    searchByURL "https://www.google.com/search?q=_searchFor_" $args
}
New-Alias dellSupport -Name d
function  dellSupport() {
    AltTab; CtrlC; Start-Process "https://www.dell.com/support/home/en-us"
}
New-Alias -Name se searchByURL
function searchByURL() { 
    #Add-Type -AssemblyName System.Web  #included at beginning of file?
    $base      = $args[0]
    $searchStrings = @($args[1])
    for(($i=0); $i -lt $SearchStrings.length; $i++){
        if($SearchStrings[$i] -Match ' ' -and (-not($SearchStrings[$i] -Match '$"'))) { #make sure it doesn't already start with a quote, but if not, and it has spaces, quote it
            $SearchStrings[$i] = ('"'+$SearchStrings[$i]+'"')
        }
    }
    $searchFor=($SearchStrings -join ' ')
    $encodedSearch=[System.Web.HTTPUtility]::UrlEncode($searchFor)
    $combinedUrl = $base -replace '_searchFor_',$encodedSearch
    Start-Process ($combinedUrl)  #uses default browser
}

function ww() {
  Write-Output $args
}

Function AdminShell() {
  start-process -Credential (get-credential) -verb runas powershell
}

Function robobak() {
    $bakDir='c:\backup'
    $userProfile=$env:USERPROFILE
    md $bakDir  #make the filename shorter than c:\users to attempt to avoid total path length issues, although still possible
    # not using /Z, possible better performance, TODO measure it; also re-evaluate /B, may need admin elevation
    # remove /SEC if wanting to execute with non-admin user
    $cmdString = "`@echo off`r`nrobocopy $userProfile $bakDir /E /SEC /SJ /SL /DCOPY:DAT /XD `"$userProfile\AppData`" /XJ /R:0 /W:0 /V /FP /LOG:$bakDir\robocopy_log.txt /TEE`necho Please screenshot this text and send to IT if there are any questions about whether it was totally successful, especially if more than 0 files show up as FAILED`r`npause`r`npause`r`npause"
    $bat = ($bakDir + "\_go.bat")
    Write-Output $cmdString | Out-File -Encoding utf8 $bat
    Write-Host ("run batch file " + $bat + " as Administrator")
}


function AltTab() {
    [System.Windows.Forms.SendKeys]::SendWait("%({TAB})")
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

#startup
bw