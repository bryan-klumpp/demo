a torbrowser-launcher "$@"; return
#a chromium-browser "$@"; return


ffc=$(which firefox || ifex /opt/firefox59/firefox || ifex /opt/firefox58/firefox)
isval $1 && { a $ffc "$@"; return; }
paste | grep -E --silent '^http' && { a $ffc "$(paste)"; return; }
#a $ffc "$@"
