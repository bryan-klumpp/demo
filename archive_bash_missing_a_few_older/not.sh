"$@"
bret=$?
if [ $bret -eq 0 ] 
	then return 1
elif [ $bret -eq 1 ]
	then return 0
else
  errtxt='warning: return code '$bret' returned to "not" command, possible logic issues. subcommand was: '"$*"
  err "$errtxt"
  #echo "$errtxt"
  return 0
fi
