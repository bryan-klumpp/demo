#credit http://www.linuxquestions.org/questions/linux-general-1/how-to-add-numbers-in-a-formatted-file-via-a-bash-script-191207/  see post at 12-24-2010, 06:48 PM - I refreshed my memory on basic syntax from it although I did totally understand it and it's pretty simple
[ $# -ge 1 ] && {
  sum=0
  for nnum in $(cat -); do
    sum=$(( $sum + $nnum ))
  done; echo $sum;
  return
}

#assume piped to xargs
rf=/tmp/add.sh.counter
echo -n 0 > $rf
########################### remove anything with $ in path after money amount, just for simplicity
nocolor | grep -E "$mnyamtrgx"$leaf |
  bxargs '. /sh/adddol.sh {}'
cat $rf
