#q="'"
gsettings list-schemas|{ xargs -i bash -c '{ 
   schema={}
   gsettings list-keys $schema | xargs -i\<\> bash -c '$q'{ echo \#gsettings set {} <> $(gsettings get {} <>) ; }'$q'
}' ; } | grep -Ei "$1"
