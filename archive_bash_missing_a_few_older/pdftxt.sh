#pdftk "$1" output "$1".txt uncompress  #not working
#echo "$1"|grep -iE '\.pdf$'>/dev/null || { return 0; } #do nothing if not a pdf file
#test -f "$1".txt            && { return 0; } #do nothing if output file already exists
#pdftotext "$1" "$1".txt

#find /b/financial/bank\ statements/secured -print0

cd $(b 23)
find -L $(pwd) -print0 |grep --null-data 'PDF$' \
      | esc \
      | xargs -i -r -0 sh -c ' {
	   filename={}
           filenameunsec="$filename".pdf
           filenametxt="$filenameunsec".txt
           test -e "$filenameunsec" || { echo unsec={}; pdftk "$filename" input_pw $(cat /b/l/4/bankpdf.txt) output "$filenameunsec" uncompress; }
           test -e "$filenametxt" ||  pstotext "$filenameunsec" > "$filenametxt"
      }'
