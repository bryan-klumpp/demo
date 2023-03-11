#sef "$@"; return;

#browser=/usr/bin/google-chrome
browser=firefox
isequal "$1" f && { browser=firefox; shift 1; }
jnl "searched for $*"
searchstr="$(j urlencode "$*")"
url='https://www.google.com/search?q='"$searchstr"
#url='https://duckduckgo.com/html/?q='"$searchstr"
#wd "$url" ; return
a $browser "$url"; 
return

blynx https://duckduckgo.com/html/?q="$searchstr"; return
