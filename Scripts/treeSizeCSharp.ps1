
Add-Type -TypeDefinition (get-content 'c:\users\b\source\repos\ConsoleApp1\ConsoleApp1\Program.cs' | out-string)

[FileUtils.FileTreeSize]::treeSize('c:\')