$localCSfile=($env:USERPROFILE + "\TreeSize.cs")  #'c:\users\b\source\repos\ConsoleApp1\ConsoleApp1\Program.cs'

if(false) {
    $githuburl = 'https://raw.githubusercontent.com/bryan-klumpp/demo/main/Scripts/TreeSize.cs'
    ((Invoke-WebRequest $githuburl).Content) > $localCSfile
    #PLEASE review the downloaded code
    Get-Content $localCSfile
}

#Add-Type -TypeDefinition (get-content 'c:\users\b\source\repos\ConsoleApp1\ConsoleApp1\Program.cs' | out-string)
Add-Type -TypeDefinition (get-content 'c:\users\b\source\repos\ConsoleApp1\ConsoleApp1\Program.cs' | out-string)

[FileUtils.FileTreeSize]::treeSize('c:\')