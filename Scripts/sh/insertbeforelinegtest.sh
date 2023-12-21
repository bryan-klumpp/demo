printf "xxasdf1xx\nxxasdf2xx\nxxasdf3xx" > /tmp/insertbeforelinetestfile
insertbeforelineg 'asdf11' 'asdf1.5' /tmp/insertbeforelinetestfile
echo 'result starts on following line:'
cat /tmp/insertbeforelinetestfile
echo 'result preceding'
