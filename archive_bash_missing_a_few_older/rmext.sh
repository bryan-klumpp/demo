#optional - pass $1 maximum number of characters in extension, if exceeded assume the file has some other kind of period in the file name and no extension.  Should rarely be needed
#assuming that there is at least one character in an extension.  Trailing periods preserved as well as leading periods (hidden files)

sed -r 's%([^/])\.[^./]{1,'$1'}(\d000|$)%\1\2%g'  # tricky WOW that was ferocious.  Had to use $ instead of \n for newline-delimited files.  But cool backreferences, didn't even need multi-line, seems to be completely consistent behavior, even strips .bashrc.txt, handles relative (with or without leading ./) and absolute paths both,     Test: find|stripext>d1; find|mkzero|stripext|mknl>d2; diff d1 d2
#.
#./err.txt
#./asdf.txt
#./asdf.
#./d1
#./d3
#./.bashrc
#./news.html
#./17998.html
#./d2
#./.bashrc.txt
#./sltemp.txt
#./a.b.c.wav

 
 
 
# the development process........................................... 
 
 
#I'm lazy and don't want to have to decide if input is delimited by zeros or newlines, so just run it through sed twice.  Newlines in zero-delimited files are hereby declared unsupported.
#For consistency/clarity I've used multi-line mode.  May someday blow out memory space.
#  sed -r --zero-terminated 's/\.[^./]{,'$1'}$//g' |
#  sed -r                   's/\.[^./]{,'$1'}$//g'


#Tricky - must NOT do this double-pass thing while using $ because it turns a.b.txt into just a
#sed -r                   's/([^/])\.[^./]{1,'$1'}\x00/\1\x00/g' |  #tricky - sed uses lines terminated by newline here, so a zero-delimited file list will be processed as one line. Not sure if trailing newline at end of file might ever be an inconsistency or not.  Multi-line mode seemed to remove a newline inconsistency somewhere, not sure exactly why but the bug seems to have disappeared.  I'm getting exact matches using find|stripext>d1; find|mkzero|stripext|mknl>d2; diff d1 d2
#sed -r --zero-terminated 's/([^/])\.[^./]{1,'$1'}\n/\1\n/g' #tricky - could use single-line mode with just $// but I was getting an unexpected newline at the end sometimes.  Multi-line mode seemed to remove a newline inconsistency somewhere, not sure exactly why but the bug seems to have disappeared.  Not sure I totally understand sed's behavior there either.

#sed -r 's%([^/])\.[^./]{1,'$1'}(\d000|$)%\1\2%g'   #getting there but not there