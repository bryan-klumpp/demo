echo $(( $(nocolor | j size) / 1 / 1 )) B




return #OLD SLOW BELOW

echo '0'>/ram/totalsize.txt
bxargs '
   totalsize=$(cat /ram/totalsize.txt); size=$(stat --printf=%s {} ); totalsize=$(($totalsize + $size)); echo -n $totalsize > /ram/totalsize.txt'  
echo 'totalsize='$(cat /ram/totalsize.txt)
