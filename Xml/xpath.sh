PS /b/b8_/code/github_demo/Xml2> select-xml  -path helloworld.xml -XPath '//elementl2' | Format-Table @{Label="Name"; Expression= {get-Xpath $_.node}}

Name
----
/xml/elementl1/elementl2
/xml/elementl1/elementl2

PS /b/b8_/code/github_demo/Xml2> function Get-XPath($n) {                                                       >>   if ( $n.GetType().Name -ne 'XmlDocument' ) {
>>     "{0}/{1}" -f (Get-XPath $n.ParentNode), $n.Name
>>   }
>> }
