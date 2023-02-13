h
xscript='test {} -nt /med/sanbak/{} && cp -v --parents {} /med/sanbak'
script='findrel|files|Greed0|Secure0|bxargs '"'$xscript'"
echo -n "$script" | tee >(clip)



#cp --no-clobber --parents

#echo 'rsync -a --exclude-from=/b/archive/flashbackup_exclude.txt --progress /b /media/b/f128 && echo "done backing up"'
