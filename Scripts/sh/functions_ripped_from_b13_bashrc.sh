function dec() { declare -x -g "$@" ; }


function testparm() {
parmnum=1
echo $BASH_ARGC
}

function timesum() {
j timesum 2016-01-06 2016-01-16
}

function pubcat() { sql "delete from pubcat where key = '$1'; insert into pubcat (key, desc) values ('$1','$2')"; }


function debugarg() {
echo '$1:'$1
echo '$@:'$@
echo '"$1":'"$1"
echo '"$@":'"$@"
}

function jcl() { while true; do jc "$@"; done }
function allx() { chmod +x /l/1/*; }




function es() { te /l/1/$1; }




function freshfindexp() { #works but xargs makes it slow but good demonstration of using null \0 characters  --xargs demo - not sure why it was missing the --null but I added it and haven't tested it in this but did in another example 
isequal $USER root || { echo 'need to be root'; return 1; }
find / -print0 | grep --null-data --null -vE '/.ecryptfs/|/.cache/mozilla|/proc' \
    | xargs -0 -i sh -c 'echo -n "'"{}"'"; test -d "'"{}"'" && echo -n / ; echo' > /b/Mothx/fexp && echo 'freshfind cache update complete'
} 
function findDecorate() {
echo -n "$1"
test -d "$1" && echo -n /
echo #endline character
}

function mkjavadoc() {
mydir=/mnt/5tb/b/src/java/openjdk-7_source_code_from_debian_source_dvd_7/jdk-1e6db4f8b0f3/src/share/classes
target=/b/javadoc/$(btime)_openjdk7
log=$target/generation_stdout_and_stderr.log
mkdir $target
cd $mydir
javadoc -J-Xmx2624m -d $target $(b jpackages) >$log 2>&1
cat $log

#2624 is the most I've gotten away with but could go a few notches higher probably.  However javadoc for openjdk7 seemed to peak around 1G of actual usage
#4096	4032	3968	3904	3840	3776	3712	3648	3584	3520	3456	3392	3328	3264	3200	3136	3072	3008	2944	2880	2816	2752	2688	2624
}


function testml() { echo asdf\ #multi-line test
echo jkl; }
function test1() { 1=asdf; echo $1; }

function Wendell() { 
wlist='Wendell Joel Gabe (driver) Isaac (heavy, tender) Tobias Esther [Alan Janice no promise] Craig Terri Carol Denise Tim Weston Jill (might be 1-2 others)
[I doubt I promised others in Wendells family like Roseann, Deanne & Dan, Darwin & Robin]'
echo "$wlist" | clip
pray Linda_fam
}



function fdoesntwork() { flvl2 aliasecho dummy ; }
function fdoeswork() { flvl2 dummy ; } #why does this work but not the other?
function flvl2() { #TODO why not working
$@
$*
$1
'$@'
'$*'
'$1'
"$@"
"$*"
"$1"

}







function mcmtlegacy() { verseref="$*"; cat /b/sword/cmtlist.txt | xargs -i diatheke -b {} -k $verseref ; }  #xargs -t echoes commands
function cmt0() { diatheke -b $1 -k $2 ; }

function sync_nolog() { "$@" >/dev/null 2>&1 ; }

function clist() { echo "$*" >> /b/Christmas_list.txt; }

function pipedisk() { 
mytmpfile=$(tmpfilename).pipe
#cat - > $mytmpfile & &>$mytmpfile
cat - > $mytmpfile
cat $mytmpfile
}


function parsevirusscan() { grep ' ERROR$\| FOUND$' stdout_and_stderr.log|grep -v '/sys/.*t read file\|cds_master\|/virusscan/\|eicar\|Chief.Architect\|DriveGreen1\|Elements-WT' ; }

function ajav() { a jav "$@"; }


function bfind() { 
dir="$(pwd)"; isval "$1" && dir="$1"
find "$dir"|xargs barepath
}

function barepath() { ls --indicator-style=slash -d "$1"; }

function btimes() { echo $(date '+%Y-%m-%d %H:%M:%S'); }
function btimeonly() { echo $(date +%H%M%S); }


#constants 
. /sh/setclasspath.sh


function bt2() { echo numparms$#; if [[ $# -ge 1 ]] ; then echo parm1 is set ; else echo parm1 is not set ; fi } #one-line iffi statement

function bt3() { #boolean function call using eval - TODO not working right
echo numparms$#
isval $1 && echo parm1 is set - noif || echo parm1 is not set - noif
isval $1; if (( ! $? )) ; then  #kludgy - why is it so hard to figure out how to do a boolean function-based if statement?
	echo parm1 is set - if
else
	echo parm1 is not set - if
fi
isval $1; if [ $? -eq 0 ] ; then  #kludgy - why is it so hard to figure out how to do a boolean function-based if statement?
	echo parm1 is set - test
else
	echo parm1 is not set - test
fi
}

function bt4() { echo numparms$#; if (( $# >= 1 )) ; then echo parm1 is set ; else echo parm1 is not set ; fi } #arithmetic expansion arithmetic comparison
function bt5() { echo numparms$#; if (( $# >= 1 )) ; then echo parm1 is set ; else echo parm1 is not set ; fi } #TODO not working at the moment, playing with comparison operators
#function bt6() { if $(metrue) ; then echo echometrue ; else echo echomefalse ; fi ; if $(mefalse) ; then echo echometrue ; else echo echomefalse ; fi } #trying to print metrue then mefalse
function bt8() { isval $1; if [[ $? -eq 0 ]] ; then echo echotrue; fi } #another way to do it but not as elegant, still educational
function bt9() { isval $1; if ! (( $? )) ; then echo echotrue; fi } #another way to do it but kludgy, not as elegant, still educational - shows goofy arithmetic return value
function bt7() { isval $1 && echo echotrue || echo echofalse; } #FINALLY an elegant way to do isparm, this is a one-liner
function bt11() { isval $1 && { echo echotrue; echo echotrue; } || echo echofalse; } #FINALLY an elegant way to do isparm, this is a one-liner with compound statements
function bt10() { isval $1 && { 
	echo echotrue
	echo echotrue
} || echo echofalse; } #FINALLY an elegant way to do isparm with compound statements multiple lines etc now we're getting somewhere
function bt11() { isint $1 && echo yesisint; }

function metrue() { echo called metrue; true; }
function mefalse() { echo called mefalse; return 1; } #could just call false

function isintlen() { echo $2|egrep '^[[:digit:]]{'$1','$1'}$' >/dev/null; }

function isequal() {
isval $3 && echo 'too many arguments passed to isequal()' && return 3
if [[ $1 = $2 ]] ; then
	return 0
else
	return 1
fi		
}

function isvalf() {
#echo begin isval
#if [ ! -n ''$1 ] ; then  #credit https://fuhell.com/doku.php?id=scripts:bash:add-description-to-interface.sh for this little trick which should NOT be necessary
if [[ ! $1 =~ .{1,} ]] ; then
	return 1
else
	return 0
fi		
echo end isval
}
function isvalx() {
echo begin isval
if [ ! -n ''$1 ] ; then  #credit https://fuhell.com/doku.php?id=scripts:bash:add-description-to-interface.sh for this little trick which should NOT be necessary
	return 4
else
	return 0
fi		
echo end isval
}

function echoln() { echo -n $*'\n'; }





function argg() { arg j alarm ; }
function arg() {
"$@"
}

function drugs() { sql "select * from v_do_log where desc like '%pill%'"; } 
function drug() { timetrack 'medical:medication:takepills:drugs:meds:fluoxetine:prozacgeneric' sleep 60; } 

function paste() { pv=$(xclip -o -selection clipboard); echo $pv; }
#paste >/dev/null #causing errors in plain console

function cparm1() {
cmd=$1
if [ ! -n ''"$2" ]
	then $cmd "$(paste)"
else
	$cmd "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
fi 
}
function cparm() {
cmd=$1
if [ ! -n ''"$2" ]
	then $cmd "$(paste)"
else
	$cmd $@
fi 
}

function xro() { 
parmfile="$*"
tempfile=$(randfile).txt
cp "$parmfile" $tempfile
modro $tempfile
te $tempfile
} 
function randfile() { echo /t/$RANDOM$RANDOM$RANDOM; }

function modro() { chmod -w "$@"; }

function args() { #recursive - wow that was painful
	if hasval $1
		then echo $(args 1)
	elif [[ $1 -le 9 ]]
		then echo \"\$$1\" $(args $(($1+1)) )
	fi
}

function hasval() {
myparm='asdf'$1
if [ $myparm == 'asdf' ]
#if test $myparm '-eq asdf'  #not working
	then
#	echo '<'$1'>' does not have a value
	return 1
else
#	echo '<'$1'>' has a value
	return 0
fi
echo 'should not get here asdfeij3'
}


function lb() { 
isval $1 && { 
	searchpat="$1"; shift 1; 
	ls -tal --group-directories-first "$@" | grep -vE ' \.?\.$' | grep -E "$searchpat" | tac | grep -E --color=auto '^[^d]|^d.*$' ; 
} || {  ls -tal --group-directories-first "$@" | grep -vE ' \.?\.$'                        | tac | grep -E --color=auto '^[^d]|^d.*$' ; }


}  #note - grep pipe removes coloring, always won't work here; -t=--sort=time    ls -r would reverse sort but we're using sort cmd instead

function bakjava() {
	bakdir=/b/archive/$(btime)_src_java_mine
	mkdir $bakdir
	cp -a /b/src/java/mine/b/* $bakdir
	ls $bakdir
}

#sudo badblocks -sw -o /b/20150901_passport2g_badblocks_log_-sw.log /dev/sdc

function jcut() { jc && j unittest; }
function bark() { cvlc --no-loop --play-and-exit --volume 64 /m/hpt3/1/audio/LRBark_1_by_Lionel_Allorge.ogg; }

#override .bashrc for ubuntu

#function websearch() { xdg-open 'https://www.google.com/search?&as_q='"$1"'+-site:stackoverflow.com+-site:superuser.com&as_rights=(cc_publicdomain).-(cc_noncommercial|cc_nonderived|cc_attribute|cc_sharealike)'; }
function sfree() { a konqueror "https://www.google.com/search?&as_q=$*&as_rights=(cc_publicdomain).-(cc_noncommercial|cc_nonderived|cc_attribute|cc_sharealike)"; }

#print
function rp() { mydir=/b/pq_archive/$(btime) && mkdir $mydir && mv ~/PDF/* $mydir && mv /b/pq/* $mydir && rm /media/b/e/pq/* ; }
function prt3() { cd ~/PDF && convert -type bilevel -density 300 *pdf /b/pq/print.tif && cp /b/pq/print.tif /media/b/e/pq && echo 'ready for printer console, use rp afterward'; }

#function Z() { nl=$'\0'; sed --zero-terminated s/'\n'/$nl/gm; }
function Z() { tr '\n' '\000'; } #big thanks to http://news-posts.aplawrence.com/721.html
function leman() { td=/b/copy_leman; mkdir $td; fc leman|gr marvin|ug 'jnl|journal'|Z|sudo xargs -0 sudo cp -a --parents -t $td; cd $td; allmine;  } #

notefile=/b/notes.txt
function note() { isval $1 && echo $(btime) "$@" >> $notefile && tail $notefile || cat $notefile; }
function notee() { te $notefile; }


function dictw() { url http://dictionary.reference.com/browse/"$1"?s=t; }
#function urla() { async konqueror $1; }
function a() { { "$@" &>/dev/null & disown; } &>/dev/null; } #command "$@"
function al() { { "$@" & disown; } } #command "$@"
function inst() { sudoprep && sudo apt-get install $1; }
#function fc { locate --regex "$1"|grep "$1"; }

function Fcx() {
if [ -n ''$2 ]
	then 
#	echo hi
	grep -Ev "$2" /b/f | grep -E --color=auto "$1"
else
#	echo bye
	grep -E --color=auto "$1" /b/f
fi 
}


function fcx() { grep -iE --color=auto "$1" /b/f; }
function latest() { head <(ls -lR);  }
#-----------------------------------------------------
#-----------------------------------------------------
function grvirus() {
egrep -v '\.Trash|/virus(_)?scan/|eicar.com|virus_(actual_)?files' *log|egrep 'FOUND'
}

function it() { info $1 |tei; }


function s3i() { s3 /l/15; }

function sqle() {
leafpad "$1"
sql ".read $1"
}

function editview() {
tmpfile=/t/$(btime).tmp
sql '.schema '$1 > $tmpfile
leafpad $tmpfile
sql 'drop view '$1
sql $tmpfile
}

function schema() { sql ".schema $1" ; }


function qh() { tmpfile=/tmp/$(btime)_tmp.html && s3 -html /l/15 "$*" > $tmpfile && konqueror $tmpfile; }
function bquery() { tmpfile=/tmp/$(btime)_tmp.html && s3 /l/15 "$*" > $tmpfile && cat $tmpfile; }
#function inn() { [ $# -eq 2 ] && sql "insert into sub(parent,child) values ('$1','$2')" && whereis $2 || { [ $# -eq 1 ] && sql "select * from s

function storein() { [ $# -ge 2 ] && {
	parent=$1 ; shift 1
	while true; do
		sql "delete from sub where child = '$1'"
		sql "insert into sub(parent,child) values ('$parent','$1')" && whereis $1
		shift 1; isval $1 || break
	done
} || { 
	[ $# -eq 1 ] && sql "select * from subr where parent = $1" || sql 'select * from subr'; 
}
}

function storein2() {
	parent=$1 ; shift 1
	while true; do
		sql "insert into sub(parent,child) values ('$parent','$1')" && whereis $1
		shift 1; isval $1 || break
	done
}


function gC() { 
gg "$@" -i --color=always 
} 


function G0() { gg "$@" --null-data ; }

function Gleaf() { gg "$@"'[^/]*/?$' ; }




function to() {
sql "select * from task order by priority"
}
function nto() { #todo
isint $1 && { pri=$1; shift 1; } || pri=6
sql "insert into task(i, desc, priority) values ( (select max(i) + 1 from task), '$*', $pri)" && echo -n 'inserted>> ' && to|tail -n 1
}


function bdo_deprecated() {
sql "update do_log set end = '$(btimes)' where end='in_progress'"
newi=$(sql 'select max(i) + 1 from do_log')
start=$(btimes); #default
[[ $1 =~ ^[[:digit:]][[:digit:]]:[[:digit:]][[:digit:]]$ ]] && { start="$(bdates) $1:00"; shift 1; }
desc='x'; #default
isval $1 && desc="$*"
sql1="insert into do_log(i,desc,start,end) values ( $newi, '$desc', '$start', 'in_progress')"
echo "$sql1"
sql "$sql1"
dc
}


function whereis1() {
sql 'with recursive mytree(i) as (values('$1') union all select parent from sub, mytree where sub.child = mytree.i) select b.i, b.t from mytree join b on mytree.i = b.i'
}
function whereis() {
sql 'with recursive mytree(i, depth) as (values('$1', 0) union 
all select parent, mytree.depth + 1 from sub, mytree where sub.child = mytree.i) select b.i, depth, b.t from mytree join b on mytree.i = b.i'
}

function all1() { sqlall="select i, t, insert_ts from b"; isval $1 && sql "$sqlall"|gr "$*"; isval $1 || sql "$sqlall"; }



function all() { 
sqlall="select i, t, insert_ts from b"
isval $1; if (( $? == 0 )) ; then
	sql "$sqlall"|gr "$*"
else
	sql "$sqlall"; #extra semicolon see if it hurts
fi
}

function status() {
$@
mystatus=$?
echo $mystatus
return $mystatus
}

function desc() { myid=$1; shift 1 && sql "update b set t='$*' where i = $myid" && whereis $myid; }

function unlock() { udisksctl unlock -b /dev/disk/by-uuid/e2e211ab-d468-4b56-b540-83314357e003; } #credit http://askubuntu.com/questions/630717/how-to-lock-luks-partition-from-terminal
function sudoprep() { return; xclip /home/b/g -selection clipboard && sudo echo 'ready to sudo'; } #disabled for now since sudo not needed

function isroot() { isequal $USER root && return 0 || return 1; }




#$1=source $2=destination
function brsyncxx() { isroot need && rsync -aAXu --progress --exclude-from=/b/exclude-from.txt --delete-before --size-only "$1" "$2"; }
function bakall() {
brsync /b /med/bakfat/b
brsync /b /med/bakntfs/b
brsync /5 /med/bakntfs/5
}


function bcp1() {
   cp -a -t "$1" "$2" && c "$1" && f nocopy$leaf; 
}
function bcpto() {
target="$1" && shift 1
cp -a -t "$target" "$@" && c "$target" && f nocopy$leaf; 
}

function bcprel() { sudo cp -a -t "$1" "$@"; }
function diffb() { sudo diff -qr --no-dereference "$1" "$2" 2>&1 |tee "$3"; }
function diffname() { cd "$1"; sudo find > /t/findleft.txt 2>&1; cd "$2"; sudo find > /t/findright.txt 2>&1; diffsort /t/findleft.txt /t/findright.txt; }
function testx() { echo "$@"; } 
function ddresume() { blocks=$[$3/512] && echo "skipping $blocks 512-byte blocks" && dd if="$1" skip=$blocks|pv|dd of="$2" seek=$blocks; } #note that we're not backing up (originally I had done $3/512-2048), assuming the last written block was correct
function root() { sudo -i; bae; }
function goog1() { xclip /home/b/g -selection clipboard; }
function inst() { sudo apt-get install "$1"; }
function diffsort() { diff <(cat "$1"|sort) <(cat "$2"|sort); }
function diffr() { diff -rb --no-dereference "$1" "$2"; }
#function dummy() { echo $2> } 
function ripdd() { dd if=/dev/sr0 > /1/iso_rip_from_dvd/"$1".iso && eject; }
#function ungrep() { grep -vrEi "$1"; }

#from infopage: find /home/gigi -name '*.c' -print0 | xargs -0r grep -H 'hello'
function Tsold() { 
searchstring="$1"
shift 1
find -print0 |grep -iE --null-data '\.(txt|log)$' | xargs --verbose -ir -0 grep -H -E --color=auto --group-separator=------------------------------------------------------------------------------\
                   -e "$searchstring" "$@" {}
}
function Ts2() {  
echo stupid
searchstring="$1"
shift 1
find -print0 |grep -iE '\.(txt|log)$' --null-data | xargs  -i -r -0 /l/1/greponefile "$searchstring" {} #--verbose
}


function f0() { find $1 --maxdepth 0 ; }
function grf() { grep -$2 --group-separator=------------------------------------------------------------------------------ "$1"; }
#function bibled() { a /b/installed/java/bibledesktop/BibleDesktop.sh; }
function esword() { env WINEPREFIX="/home/b/.wine" wine C:\\Program\ Files\\e-Sword\\e-Sword.exe 1>&- 2>&- & }
function es2() { env WINEPREFIX="/home/b/.wine" wine C:\\Program\ Files\\e-Sword\\e-Sword.exe & } #from shortcut with trailing & added
function e2() { te $1; }
function scanstdwebcam() { scanimage --resolution $2 --format=tiff --mode Color -d v4l:/dev/video0|convert - ./$(date +%Y%m%d%H%M%S)_"$3".$1; }  # genesys:libusb:002:020 (numbers vary based on port) or pixma:04A9173A_B94E2B or v4l:/dev/video0 (webcam) or old Epson epson2:libusb:001:016 or new Epson epkowa:usb:001:014
##
function setscanba() { bdec scannere=$(scanimage -L | grep -o 'fdepkowa.\{12\}') ; bdec scannerb=$(scanimage -L | grep -o 'brother4.\{10\}'); }

function adf() { 
	while true; do
		i="0"
		scanimage --source "Automatic Document Feeder" --resolution 75 --format=tiff --mode Color -d epson2:libusb:002:012 |convert - ./$(date +%Y%m%d%H%M%S)_"$1"_$i.jpg; 
		if [[ "$?" != "0" ]]; then break; fi
		i=$[$i+1]
	done
}
function spp() { scanimage --resolution 600 --format=tiff --mode Lineart -d pixma:04A9173A_B94E2B|convert - ./$(date +%Y%m%d%H%M%S)_"$1".png; }
function sm() { scanimage --resolution 600 --format=tiff --mode Lineart -d pixma:04A9173A_B94E2B|convert - ./$(date +%Y%m%d%H%M%S)_"$1".png; }
function sb() { scanimage --brightness -40% --resolution 600 --format=tiff --mode Lineart -d pixma:04A9173A_B94E2B|convert - ./$(date +%Y%m%d%H%M%S)_"$1".png; }
function igl() { info $1|grep -3 --group-separator=------------------------------------------------------------------------------ --color=always "$2"|less -R; } #credit to http://serverfault.com/questions/26509/colors-in-bash-after-piping-through-less
#function fcs() { find "$(pwd)" -maxdepth 500 2>/t/err.txt |grep -E "$1"|grep -v 'Permission denied'; }
function errtxt() { head /t/error.txt; }  


function cx() { cd $(b finddir $*); find $(pwd); }
function cont1() { grep -ir --color=auto "$1" /b/contact; }  

function blocatex() {
if [ ! -n ''$1 ]
	then te /b/locate/locate.txt
else
	bquery "select * from b where t like '%$*%'"
fi 
}


function hh() { $1 --help|le; }
function uuid() { sudo blkid; find /dev/disk/by-id; find /dev/disk/by-uuid; } #credit https://help.ubuntu.com/community/UsingUUID
jnlfile=$(b 3)/journal.txt
function jnlr() { xro $jnlfile; }
function dad() { te $(b 3)/dad.txt; }
function jnlG() { 
isval $1 || { cat $jnlfile; return; }
mytime=$(btime)
echo "\n$mytime $@" >> $jnlfile ; tail -n 3 $jnlfile |gg $mytime'.*$|^' ; 
}
function jnlbak() { cp $jnlfile /b/archive/$(btime)_jnl.txt; }
function jnlf() { 
isval $1 || { cat $jnlfile; return; }
mytime=$(btime)
echo "\n$mytime $@" >> $jnlfile ; tail -n 3 $jnlfile |grep -E $mytime'.*$|^' ; 
}
function scruple() { jnle scruple "$@"; }


function zeroba() { zerop 1000000c 1000;}
function zeropba() { #/b/1/zero/Gb.sh  #credit purely from linuxquestions.org
	rootdir="."
	isval $3 && rootdir="$3"
	test -e $rootdir || mkdir "$rootdir"
	while true; do
		zerofile="$rootdir"/zero/$RANDOM$RANDOM$RANDOM.zero
		dd if=/dev/zero bs=$1 count=$2|pv > "$zerofile" || { rm "$zerofile"; break; } #remove the last one to leave some space
		#if [[ "$?" != "0" ]]; then break; fi
	done
}


function tek() { a kate "$*"; } #-w --new-window 
function tet() { tmpfile=/tmp/$RANDOM$RANDOM.txt && cp $1 $tmpfile && te $tmpfile; }
function infoe() { tet <(info "$1"); }
function ma() { man "$1"; }
#function tei() { gedit -w --new-window - 2>/dev/null; } #-w --new-window 
#function tei() { kate "$*" > /dev/null 2>&1 ; }
function dux() { sudo \du -a -d $1|sort -n; }
function bakb() { cp /dev/mmcblk0 >(pv>$(bdate)_b_small_backup_cp_locked.img); }

function brip() { md "$*" && jack -k && eject; }

function cdsmartx() {
dep=1
res=$(find . -maxdepth $dep -regex ".*$*.*")
while true; do
	echo res=$res
	hasval $res && cd "$(tail -n 1 "$res")" && return
	test $dep -gt 50 && return
	dep=$[$dep + 1]
	res=$(find . -maxdepth $dep -regex ".*$*.*")
done
}



function cbash() {
test -d "$1" && { cd "$1"; l; return; }
#cd "$(j findDir $*)" && l
mydir=**/*"$1"*
echo "$mydir"
test -d "$mydir" && { cd "$mydir" && l; return; }
mydir=/b/*/*"$1"*
test -d "$mydir" && { cd "$mydir" && l; return; }
mydir=/5/*/*"$1"*
test -d "$mydir" && { cd "$mydir" && l; return; }
}

function cdstupid() {
dep=1
res=$(find . -maxdepth $dep -regex ".*$*.*" | tail -n 1)
while true; do
#	echo res=$res
	hasval $res && cd "$res" && return
	test $dep -gt 50 && return
	dep=$[$dep + 1]
	res=$(find . -maxdepth $dep -regex ".*$*.*")
done
}

function batch() { ps -ef|g "java.*b.B batch" || { { j batch&disown; } && { sleep 1; ps -ef|g "java.*b.B batch"; } } }  #ungrep "grep.*$1"

function cdset() { mount -o ro /root/cdset/*-$1.iso /media/cdrom; }
function cdsetu() { mount -o ro /root/cdset/update/*-$1.iso /media/cdrom; }

function grabscan() {
scanmnt=/media/b/E
mkdir $scanmnt
mount /dev/disk/by-uuid/841D-E38C $scanmnt
scandir=$scanmnt/EPSCAN/001
test -d $scandir || { echo 'scan directory not ready'; return 1; }
find $scandir|grep 'JPG' || { echo 'scan directory empty'; return 1; }
finaldir="./$(btime)_Epson_scan_$*"
mkdir "$finaldir" && cp $scandir/* "$finaldir" && find $scandir/* | xargs -i sh -c 'shred {} && echo shredded' && rm $scandir/* && cd "$finaldir" && ls && echo "please>> zerop 1000000c 1000 $scanmnt; umount $scanmnt && rmdir $scanmnt"
}


function boldtime() { grep -E --color=auto '^|[[:digit:]][[:digit:]]:[[:digit:]][[:digit:]]' ; }

function curt() { 
ip=$(sql "select * from v_do_log where end = 'in_progress'")
isval $ip && echo "in progress........................\n$ip" || echo 'no tasks active'
}



function dc() { sql "select i, start, end, desc from do_log where end = 'in_progress' order by start"; }

function undox() { 
while true; isval $1 || break; do sql "update do_log set intensity = 0, end = '$(btimes)' where i = '$1'" && shift 1; done; curt; }

function undo() { 
while true; isval $1 || break; do t $1 0 && shift 1; done; curt; }


#generalcredits TODO

#credit1
function shortest() { sort; }

