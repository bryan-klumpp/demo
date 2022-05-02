browser=fox
isequal $1 c && { browser=chromium-browser; shift 1; }
jnl "searched for $*"
searchstr="$(j urlencode "$*")"
#url='https://www.google.com/search?q='"$searchstr"
url='https://duckduckgo.com/html/?q='"$searchstr"
#wd "$url" ; return
$browser "$url"; return
blynx -nomargins --accept-all-cookies -use_mouse https://duckduckgo.com/html/?q="$searchstr"; return
