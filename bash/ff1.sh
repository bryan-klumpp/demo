isempty "$1" && return  #do nothing if drive not mounted
outfile=$(b 19)/"$2"_filenamefindcache.txt
ffexclude='(/proc)|backup|archive|transfer|trash|[_ ]copy|copy[_ ]|donotexcludeanythinguseful'
test -z $3 || ffexclude="$3"
find "$1" | grep -vE "$ffexclude" | j findDecorate | sort | \
         tee $(b 19)/"$2"_filenamefindcache.txt > /dev/null #/ram/filenamefindcache/"$2"_filenamefindcache.txt


return
######################
#bupdatedb && echo 'bupdate db done; starting old ff logic with modified dates'
#a cp -a /t/f /b;   #grep -vE '/.ecryptfs/|/.cache/mozilla|/proc' 
