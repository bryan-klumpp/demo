echo $(ps -ef | grep -iE "$1" 2>&1 | sed -E 'b *([0-9]*)/\1/')
