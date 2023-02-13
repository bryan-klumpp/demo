isint $1 && { greplink='^  '$1'\. '; url=$(grep -E "$greplink" /t/b.html | 
       sed s/"$greplink"//g); } || url=$(clipdef "$@"|trim)
echon 'viewing URL '; echon "$url" | tee >(clip); echo
lynx --dump "$url" > /t/b.html
cat /t/b.html|l
