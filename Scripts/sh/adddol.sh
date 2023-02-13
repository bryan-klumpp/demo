rf=/tmp/add.sh.counter
f="$1"
sum=$(cat $rf)
#moneyamtregex='\$([0-9]{1,}\.[0-9]{2})($|[^0-9])' #see b222_v.sh
echo "$f" | grep --silent -E "$mnyamtrgx" || return 0 #not a money line
moneyamt=$(echo -n "$f" | sed --regexp-extended 's/.*'"$mnyamtrgx"'.*/\1/g')
sum=$(python -c "print $sum + $moneyamt")
echo -n $sum > $rf   

