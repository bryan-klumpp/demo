
#sendkeys old way, much worse because had to put sleep in combinations, alt-tab needed 2 TABs as in "%({TAB}{TAB})"...
$wScriptObj=(New-Object -ComObject WScript.Shell)  #TODO check to see if this needs cleaned up when script exits gracefully
$wScriptObj.SendKeys("^v")


#$psExeStr="$PSHOME"+"\powershell.exe"

function launchMeScript () { #https://stackoverflow.com/questions/5466329/whats-the-best-way-to-determine-the-location-of-the-current-powershell-script/5466355
    $scriptFile = $psise.CurrentFile.FullPath #may need different strategy outside of ISE environment
    $batTxt += ('start /D c:\windows c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process; . '+$scriptFile+'"')
    Set-Clipboard $batTxt
    ww 'Script batch command copied to clipboard...'
}
function playground() {
ww (@("asdf","asdff") | select *)
}

function screenshot($path) 
{

   [Reflection.Assembly]::LoadWithPartialName("System.Drawing")   #expensive?	
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")   #expensive?
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  #expensive?

    $width = 0;
    $height = 0;
    $workingAreaX = 0;
    $workingAreaY = 0;

    $screen = [System.Windows.Forms.Screen]::AllScreens;

    foreach ($item in $screen)
    {
        if($workingAreaX -gt $item.WorkingArea.X)
        {
            $workingAreaX = $item.WorkingArea.X;
        }

        if($workingAreaY -gt $item.WorkingArea.Y)
        {
            $workingAreaY = $item.WorkingArea.Y;
        }

        $width = $width + $item.Bounds.Width;

        if($item.Bounds.Height -gt $height)
        {
            $height = $item.Bounds.Height;
        }
    }

    $bounds = [Drawing.Rectangle]::FromLTRB($workingAreaX, $workingAreaY, 1920, 1080); 
    $bmp = New-Object Drawing.Bitmap 1920, 1080;
    $graphics = [Drawing.Graphics]::FromImage($bmp);

    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size);

    $bmp.Save($path);

    $graphics.Dispose();
    $bmp.Dispose();
}

#COLORS failed attempts--------------------------------------------------------------------------------------
#Set-PSReadLineOption -Colors @{None='black';Comment='black';Keyword='black';String='black';Operator='black';Variable='black';Command='black';Parameter='black';Type='black';Number='black';Member='black'}

Function invert-consolecolors { #doesn't work well for me, but credit https://www.dotnetcatch.com/2017/04/09/light-theme-for-the-powershell-console/
 
    $oldForeground = $host.ui.rawui.ForegroundColor 
    $oldBackground = $host.ui.rawui.BackgroundColor
    $host.ui.rawui.ForegroundColor = $oldBackground
    $host.ui.rawui.BackgroundColor = $oldForeground
 
    Set-PSReadlineOption -ContinuationPromptBackgroundColor $oldForeground
    Set-PSReadlineOption -Token None -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Comment -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Keyword -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token String -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Operator -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Variable -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Command -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Parameter -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Type -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Number -BackgroundColor $oldForeground
    Set-PSReadlineOption -Token Member -BackgroundColor $oldForeground
    Set-PSReadlineOption -EmphasisBackgroundColor $oldForeground
    Set-PSReadlineOption -ErrorBackgroundColor $oldForeground
    Set-PSReadlineOption -ContinuationPromptForegroundColor $oldBackground
    Set-PSReadlineOption -Token None -ForegroundColor $oldBackground
    Set-PSReadlineOption -Token Command -ForegroundColor "Blue"
    Set-PSReadlineOption -Token Type -ForegroundColor "DarkGray"
    Set-PSReadlineOption -Token Number -ForegroundColor "DarkGreen"
    Set-PSReadlineOption -Token Member -ForegroundColor "DarkGreen"
    Set-PSReadlineOption -Token Variable -ForegroundColor "DarkGray"
     
    $Host.PrivateData.ErrorBackgroundColor = "Yellow"
 
    cls
}

Function reset-consolecolors { #doesn't work well for me, but credit https://www.dotnetcatch.com/2017/04/09/light-theme-for-the-powershell-console/
     
    $host.ui.rawui.ForegroundColor = "DarkYellow"
    $host.ui.rawui.BackgroundColor = "DarkMagenta"
 
    Set-PSReadlineOption -ResetTokenColors
 
    $Host.PrivateData.ErrorForegroundColor = "Red"
    $Host.PrivateData.ErrorBackgroundColor = "Black"
    $Host.PrivateData.WarningForegroundColor = "Yellow"
    $Host.PrivateData.WarningBackgroundColor = "Black"
    $Host.PrivateData.DebugForegroundColor = "Yellow"
    $Host.PrivateData.DebugBackgroundColor = "Black"
    $Host.PrivateData.VerboseForegroundColor = "Yellow"
    $Host.PrivateData.VerboseBackgroundColor = "Black"
    $Host.PrivateData.ProgressForegroundColor = "Yellow"
    $Host.PrivateData.ProgressBackgroundColor = "DarkCyan"
 
    cls
 
}

Function color1 { #based on credit https://www.dotnetcatch.com/2017/04/09/light-theme-for-the-powershell-console/
 
 
    $host.ui.rawui.ForegroundColor = 'Black'
    $host.ui.rawui.BackgroundColor = 'White'
 
    Set-PSReadLineOption -Colors @{
  Command            = 'Black'
  Number             = 'Black'
  Member             = 'Black'
  Operator           = 'Black'
  Type               = 'Black'
  Variable           = 'Black'
  Parameter          = 'Black'
  ContinuationPrompt = 'Black'
  Default            = 'Black'
}

    Set-PSReadlineOption -Token ContinuationPromptBackgroundColor $bg
    Set-PSReadlineOption -Token ContinuationPromptForegroundColor $fg
    Set-PSReadlineOption -Token None -BackgroundColor $bg
    Set-PSReadlineOption -Token None -ForegroundColor $fg
    Set-PSReadlineOption -Token Comment -BackgroundColor $bg
    Set-PSReadlineOption -Token Keyword -BackgroundColor $bg
    Set-PSReadlineOption -Token String -BackgroundColor $bg
    Set-PSReadlineOption -Token Operator -BackgroundColor $bg
    Set-PSReadlineOption -Token Variable -BackgroundColor $bg
    Set-PSReadlineOption -Token Command -BackgroundColor $bg
    Set-PSReadlineOption -Token Command -ForegroundColor $fg
    Set-PSReadlineOption -Token Parameter -BackgroundColor $bg
    Set-PSReadlineOption -Token Type -BackgroundColor $bg
    Set-PSReadlineOption -Token Type -ForegroundColor $fg
    Set-PSReadlineOption -Token Number -BackgroundColor $bg
    Set-PSReadlineOption -Token Number -ForegroundColor $fg
    Set-PSReadlineOption -Token Member -BackgroundColor $bg
    Set-PSReadlineOption -Token Member -ForegroundColor $fg
    Set-PSReadlineOption -Token Variable -ForegroundColor $fg
    Set-PSReadlineOption -Token EmphasisBackgroundColor $bg
    Set-PSReadlineOption -Token ErrorBackgroundColor $bg
 
 
     
    $Host.PrivateData.ConsolePaneBackgroundColor = $bg
    $Host.PrivateData.ConsolePaneForegroundColor = $fg
    $Host.PrivateData.ConsolePaneTextBackgroundColor = $bg
   
    #$Host.PrivateData.TokenColors = @{ Command=$fg; }
        
    $Host.PrivateData.DebugBackgroundColor = $bg
    $Host.PrivateData.DebugForegroundColor = $fg
    $Host.PrivateData.ErrorBackgroundColor = $bg
    $Host.PrivateData.ErrorForegroundColor = $fg
 
     $Host.PrivateData.ProgressBackgroundColor = $bg
    $Host.PrivateData.ProgressForegroundColor = $fg
 
    $Host.PrivateData.ScriptPaneBackgroundColor = $bg
    $Host.PrivateData.ScriptPaneForegroundColor = $fg
    
    ##$Host.PrivateData.TokenColors = $
    
    $Host.PrivateData.VerboseBackgroundColor = $bg
    $Host.PrivateData.VerboseForegroundColor = $fg
    $Host.PrivateData.WarningBackgroundColor = $bg
    $Host.PrivateData.WarningForegroundColor = $fg
    
    #$Host.PrivateData.XmlTokenColors = $

   

}


function intro() { Param($obj)
    $line1='';
    if($obj -is [array]){$line1+=('Array of ')}
    $line1+=($obj.GetType())
    ww $line1
}

unction Prompt
{
    #$promptString = "PS " + $(Get-Location) + ">"
    #Write-Host $promptString -NoNewline -ForegroundColor Black
    #return " "
 
$ANSIColorSequenceBW+"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "

#Write-Host $promptString -NoNewline -ForegroundColor Black
# .Link
# https://go.microsoft.com/fwlink/?LinkID=225750
# .ExternalHelp System.Management.Automation.dll-help.xml
#return $promptString  #this was not in the built-in function definition but seems to be needed to avoid duplicate printing
}



#no worky
    write-host ('0:'+($arr[0])+':0')
    write-host ('1:'+($arr[1])+':1')
    return @($arr)

    Write-Host ("isarray"+  ($args -is [Array]) )
    $argsAL=[System.Collection.ArrayList](toArrayList($args))
    write-host ('0:'+$argsAL[0]+':0')
    write-host ('1:'+$argsAL[1]+':1')
    $argsAL | get-member
    $argsAL.RemoveAt(0)
    write-host ("shrunk: "+$argsAL.ToArray()[0])
    return $argsAL.ToArray()


function from1() {
    $inA = $args[0]
    #$al=[System.Collections.ArrayList]::new()
    #$a = New-Object int[] ($inA.Count - 1)
    for($i=1; $i -lt $inA.Count; $i=$i + 1) {
        $al.add($inA[$i])
    }
    write-host $a
}
function se_old_deleteme() { 
    Add-Type -AssemblyName System.Web
    $joined=($args -join ' ')
    $encodedSearch=[System.Web.HTTPUtility]::UrlEncode($joined)
    Start-Process ("https://www.google.com/search?q="+$encodedSearch)
}
