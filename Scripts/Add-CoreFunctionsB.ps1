$myPath = Get-Item $MyInvocation.MyCommand.Path
$myDir = $myPath.Directory

#--------------- Set Color Scheme - begin ------------------
$ANSIColorSequenceBW="$([char]0x1b)[38;2;0;0;0;48;2;255;255;255;m"
Function colorMaster() {
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
colorMaster   #doitnow

function Prompt   #Override default prompt to set color scheme
{
    $ANSIColorSequenceBW+"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
#---------------- Set Color Scheme - end -------------------

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

function se() { 
    Add-Type -AssemblyName System.Web
    $joined=($args -join ' ')
    $encodedSearch=[System.Web.HTTPUtility]::UrlEncode($joined)
    Start-Process ("https://www.google.com/search?q="+$encodedSearch)
}

function ww() {
  Write-Output $args
}

Function AdminShell() {
  start-process -Credential (get-credential) -verb runas powershell
}

Function robobak() {
    $bakDir='c:\bak'
    $userProfile=$env:USERPROFILE
    md $bakDir  #make the filename shorter than c:\users to attempt to avoid total path length issues, although still possible
    # not using /Z, possible better performance, TODO measure it; also re-evaluate /B, may need admin elevation
    $cmdString = "`@echo off`r`nrobocopy $userProfile $bakDir /E /SEC /SJ /SL /DCOPY:DAT /XD `"$userProfile\AppData`" /XJ /R:0 /W:0 /V /FP /LOG:$bakDir\robocopy_log.txt /TEE`necho Please screenshot this text and send to IT if there are any questions about whether it was totally successful, especially if more than 0 files show up as FAILED`r`npause`r`npause`r`npause"
    $bat = ($bakDir + "\_go.bat")
    Write-Output $cmdString | Out-File -Encoding utf8 $bat
    Write-Host ("run batch file " + $bat + " as Administrator")
}

# IP3 https://web.archive.org/web/20160115183554/http://blogs.msdn.com/b/daiken/archive/2007/02/12/compress-files-with-windows-powershell-then-package-a-windows-vista-sidebar-gadget.aspx
#usage: new-zip c:\demo\myzip.zip 
function New-Zip
{
	param([string]$zipfilename)
	set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
	(dir $zipfilename).IsReadOnly = $false
}

# IP3 https://web.archive.org/web/20160115183554/http://blogs.msdn.com/b/daiken/archive/2007/02/12/compress-files-with-windows-powershell-then-package-a-windows-vista-sidebar-gadget.aspx
#usage: dir c:\demo\files -Recurse | add-Zip c:\demo\myzip.zip

function Add-Zip
{
	param([string]$zipfilename)

	if(-not (test-path($zipfilename)))
	{
		set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
		(dir $zipfilename).IsReadOnly = $false	
	}
	
	$shellApplication = new-object -com shell.application
	$zipPackage = $shellApplication.NameSpace($zipfilename)
	
	foreach($file in $input) 
	{ 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500  #hopefully there was a good reason for this expensive line
	}
}

# IP3 https://web.archive.org/web/20160115183554/http://blogs.msdn.com/b/daiken/archive/2007/02/12/compress-files-with-windows-powershell-then-package-a-windows-vista-sidebar-gadget.aspx
#usage: Get-Zip c:\demo\myzip.zip
function Get-Zip
{
	param([string]$zipfilename)
	if(test-path($zipfilename))
	{
		$shellApplication = new-object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$zipPackage.Items() | Select Path
	}
}

# IP3 https://web.archive.org/web/20160115183554/http://blogs.msdn.com/b/daiken/archive/2007/02/12/compress-files-with-windows-powershell-then-package-a-windows-vista-sidebar-gadget.aspx
#usage: extract-zip c:\demo\myzip.zip c:\demo\destination
function Extract-Zip
{
	param([string]$zipfilename, [string] $destination)

	if(test-path($zipfilename))
	{	
		$shellApplication = new-object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$destinationFolder = $shellApplication.NameSpace($destination)
		$destinationFolder.CopyHere($zipPackage.Items())
	}
}

function AltTab() {
    [System.Windows.Forms.SendKeys]::SendWait("%({TAB})")
}

function AltTabPasteText() {
    $text = $args[0]
    set-clipboard $text
    AltTab
    [System.Windows.Forms.SendKeys]::SendWait("^v")
}

function nitt() {
    AltTabPasteText "Now is the time`nfor all good men to come to the aid of their country."
}