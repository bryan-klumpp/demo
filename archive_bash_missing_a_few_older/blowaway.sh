echo CAREFUL ! ! ! ! ! ! !!!!!!!!!!!   sleeping for a bit while you inspect command carefully...'

sleep 5

fa | files | bxargs 'chmod +w {} && rm {}'  #change files to writeable and blow them away first
ls | rm -R {} #now the directories
