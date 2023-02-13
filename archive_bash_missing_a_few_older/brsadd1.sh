! test -e "$2" && { echo 'cat '"$1"'|pv|dd of='"$2"\' >> /t/brscommit.sh; return; }
# mod1=$(stat --terse --format='%Y' "$1")
# mod2=$(stat --terse --format='%Y' "$2")
# size1=$(stat --terse --format='%s' "$1")
# size2=$(stat --terse --format='%s' "$2")
# [[ $mod1 -gt $mod2 ]] || { [[ $mod1 -eq $mod2 ]] && [[ $size1 -gt $size2 ]]; } && echo 'cp -a '"$1" "$2" >> /t/brscommit.sh