#Note: this code was written by Bryan Klumpp, and was written for my personal use only, which explains the extreme conciseness
# and lack of documentation.  This was never really intended to be used by others (at least without a lot of renaming and documentation).
# The reason for sharing it as-is is simply to demonstrate that I have done some bash coding using a variety of programs
# and non-trivial complexity.  The code that I do in a team environment has longer method/variable names and better documentation.

# This particular file is from back when I was putting many of my shorter methods in a single file.  At some point that got unwieldy
# and I started breaking it out into separate files, but I may link to this file just as a quick way to view a lot of my code at once.


#for general credits see the #generalcredits section

. /b/sh/generated_functions.sh
cd $(cat /b/wd.txt)

#echo Hello World

shopt -s globstar

#source /b/sh/dec myexport yuio
#echo 'trysubdeclare:'$myexport

#colori=40
#while true; do
#	sql "insert into sub(parent,child) values ('$parent','$1')" && whereis $1
#	(i == 47) && break || i=(i + 1) 
#done

#echo asdf|grep --color=auto sd  #grep test debugging
#-----------  end of startup stuff -------------------------#
shdir=/b/sh


declare -x -g q="'"
declare -x -g qq='"'
declare -x -g zero=$'\0'

#---------------------------------------------------------------------------------------------
alias paste='xclip -o -selection clipboard'
alias ta='tee -a'
alias p=paste
alias cb='c /b'
alias disp='/usr/bin/kcmshell4 kcm_kscreen'
alias 7zd='ice file:///usr/share/doc/p7zip-full/DOCS/MANUAL/index.htm'
alias night='jnl spent night on farm for rent deduction from Jacob:'
alias pt='praytime 1'
alias Ts=/b/sh/Ts.sh
alias map='a iceweasel maps.google.com'
alias jig='lynx http://cdimage.debian.org/debian-cd/8.6.0/i386/jigdo-dvd/'
alias id='a icedove'
alias tt3='t|tail -n 3'
alias t3='tail -n 3'
alias 3=t3
alias randint='j randint'
alias cups='a iceweasel localhost:631'
alias printers=cups
alias setup='ls -l /b/sh/setup*sh'
alias lowriter=low
alias bls=d


alias echoalias='. /b/sh/becho.sh'
function echofunction() { . /b/sh/becho.sh "$@"; }

alias gdu='a baobab .'  #graphical disk usage analyzer
alias bak=/b/sh/bak.sh
alias bed='te /b/checklist/bedtime.txt'
alias bf=/b/sh/bf.sh
alias tse='te /b/text_search_patterns_to_exclude_extended.txt'


alias taxd='c /b/financial/15'
alias ifc='sudo ifconfig -a'
alias bset=/b/sh/bset.sh
alias re='sudo shutdown -r 0'
alias blkid='sudo \blkid'
alias blk='sudo \blkid'

alias k='a konqueror'

alias gset=/b/sh/gset.sh

alias umiso='sudo umount /mnt/iso'
alias ac=acpi
alias cc='a gnome-control-center'
alias snd='cc sound'
alias nw='cc network'
alias ice='a konqueror'
alias gmw='a konqueror https://mail.google.com'
alias down='sudo shutdown 0'
alias x=bex;
alias urlencode='j urlencode'
alias dol='a dolphin .'
alias rain='a konqueror http://www.srh.noaa.gov/ridge2/RFC_Precip/'
alias au='a audacity'
alias cl=clear
alias white='a loimpress --show /b/white.ppt'
alias comm='te /b/spirit/writings/language_communication_erosion_authority_subtopic.txt'
alias conanicalize=can
alias conanonical=can
alias echon='echo -n'
alias ech='echo -n'

function work() { btr start work; t work; cl; }
function unwork() { t t; btr 'stop work'; }

function btr() { ! isval $1 && jnl|g 'tr:' || jnl tr:"$*" ; }
alias fin=led
function led() { jnl acct:financial:ledger:taxable:"$*" ; }




alias brad='a okular "/media/b/b/contact/2015 Bradford Directory pages as of Sept 8 2015.pdf"'
alias brad2="a okular '/media/b/b/contact/2015 Bradford Directory pages as of Sept 8 2015.pdf'"

alias tea='alarm 3 .2 teakettle'
alias actech='url http://www.accounseling.org/page.cfm?p=1546'

GC="ms=30;47:mc=02;32:sl=:cx=:fn=34:ln=31:bn=30:se=30"  
#30=black? 31=red, 32=closetogreen, 33=yellow? 34=blue, 35=somekindofblue? 36=lightblue, 37=lavendar, 31=red30-37=foreground?, 
#40-47 background 40=black 41=red 42=green... 
declare -x -g GREP_COLORS="$GC"
#GREP_COLORS="$GC"
#export GREP_COLORS="$GC"
export q="'"
export qq='"'

#declare -x -g -f function testfunction() { echo woohoo; }

function dec() { declare -x -g "$@" ; }

function hyg() { t hygiene; }

function teeth() { t 'hygiene:dental'; }
function laundry() { t 'hygiene:laundry'; }

function testparm() {
parmnum=1
echo $BASH_ARGC
}

function timesum() {
j timesum 2016-01-06 2016-01-16
}

function pubcat() { sql "delete from pubcat where key = '$1'; insert into pubcat (key, desc) values ('$1','$2')"; }

function count() { egrep --count '^'; }

alias web='a konqueror'  #epiphany-browser

function debugarg() {
echo '$1:'$1
echo '$@:'$@
echo '"$1":'"$1"
echo '"$@":'"$@"
}

function jcl() { while true; do jc "$@"; done }
function allx() { chmod +x /b/sh/*; }

function difffilelist() {
wdir="$(pwd)"
cd "$1"
find|sort>/t/left
cd "$2"
find|sort>/t/right
cd "$wdir"
diff /t/left /t/right
}


alias df='\df -h'
alias ledger='a localc /b/financial/16/ledger.ods'

dec leaf='[^/]*/?$'

function es() { te /b/sh/$1; }




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

function ta() { tail "$@"; }


function addr() {
echo -n '2318 Akelana Dr.
Kalona, IA 52247-9505' | clip
}

alias gedit='echo gedit seems to be crashing gnome lately'
alias fl='te freedom_level.txt'
#alias d=bdo
alias bv='te /b/spirit/bvhistory.txt'
alias openbsd='url http://mirror.team-cymru.org/pub/OpenBSD/5.8/packages/i386/'

alias aliasecho=echo  #when you do this with the function below it fails but this works if you turn this line into a function #bug bash bug bashbug
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
alias ph='echo -n "309-251-9396" | clip'

function pipedisk() { 
mytmpfile=$(tmpfilename).pipe
#cat - > $mytmpfile & &>$mytmpfile
cat - > $mytmpfile
cat $mytmpfile
}


function parsevirusscan() { grep ' ERROR$\| FOUND$' stdout_and_stderr.log|grep -v '/sys/.*t read file\|cds_master\|/virusscan/\|eicar\|Chief.Architect\|DriveGreen1\|Elements-WT' ; }

function ajav() { a jav "$@"; }

alias sus='suspend'
alias suspend='sudo acpitool -s'

function bfind() { 
dir="$(pwd)"; isval "$1" && dir="$1"
find "$dir"|xargs barepath
}

function barepath() { ls --indicator-style=slash -d "$1"; }

alias btime=/b/sh/btime.sh
function btimes() { echo $(date '+%Y-%m-%d %H:%M:%S'); }
function btimeonly() { echo $(date +%H%M%S); }
function bdate() { echo $(date +%Y%m%d); }
function bdates() { echo $(date +%Y-%m-%d); }

function audjnl() { cd /b/t && rename -e "s%^%$(btime)_%" *ogg && mv -t $(b 3)/audio 20*ogg ; } #-e and 20 untested
function audjnlx() {
cd /b/t 
echo -n $(find /b/t|grep ogg|grep -v 2015) | xargs -0 rename -e "s%^%$(btime)_%"
mv /b/t/20*ogg $(b 3)/audio; 
}

#constants 
. /b/sh/setclasspath


function bt() { #simplest parameter test
echo numparms$#
if [ $# -ge 1 ] ; then
	echo parm1 is set
else
	echo parm1 is not set
fi
}
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

alias ink='xdg-open /media/b/b/inkjet_printer_keepalive_CMYK.odg'
alias echo='echo -e'
function echoln() { echo -n $*'\n'; }
alias bunk='mv -T "$1" "$1"_bunk'

function pr() { pray & }


function bible() { timetrack bible xiph & }
function xiph() { xiphos >/dev/null 2>&1 ; }


function tbare() {
sql "select desc from do_log where end = 'in_progress'"
}

function argg() { arg j alarm ; }
function arg() {
"$@"
}

alias pills=drugs
alias pill=drug
alias med=drug
alias meds=drugs
alias medication=drug
alias medications=drugs
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
alias ll='ls -l'

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

alias 'noCatR=ln /b/folder_flags_files/no_Caterpillar_files_here_recursive.txt .'
alias 'noCat=ln /b/folder_flags_files/no_Caterpillar_files_here_single_folder.txt .'
alias locked=fuser
#alias sudo=command  #uncomment for Ubuntu and others that require you to use sudo
alias test1='echo 1'
alias sb=/b/1/sh/scan.sh
alias reverse='/sh/?/reverse'
alias du2='dux 2'
alias i='info $1'
alias dt='diatheke -b KJV'
alias src=source
alias sr=source
alias xa='xargs -i'
alias gpart='sudo gparted 2>/dev/null &'
function u()  { cd ..       ; bls ; }
function u2() { cd ../..    ; bls ; }
function u3() { cd ../../.. ; bls ; }
alias jdr='java -jar /b/2/bin/jdiskreport/jdiskreport.jar'
alias n='a nautilus .'
alias i='info $1'
alias goog1='te /1/Cat/4/google_6tb.txt'
alias goog='xclip /home/b/g -selection clipboard'
alias k6='echo -n klumpp6@gmail.com|xclip -selection clipboard'
function lb() { 
isval $1 && { 
	searchpat="$1"; shift 1; 
	ls -tal --group-directories-first "$@" | grep -vE ' \.?\.$' | grep -E "$searchpat" | tac | grep -E --color=auto '^[^d]|^d.*$' ; 
} || {  ls -tal --group-directories-first "$@" | grep -vE ' \.?\.$'                        | tac | grep -E --color=auto '^[^d]|^d.*$' ; }


}  #note - grep pipe removes coloring, always won't work here; -t=--sort=time    ls -r would reverse sort but we're using sort cmd instead

alias google="te /home/b/4/google/google.txt"
alias fin="cd /b/1/financial/15"
function todo() { a lowriter /b/todo2.odt; }
alias index='te /b/index.htm'
alias du0='dux 0'
alias du1='dux 1'
alias du2='dux 2'
alias .java='cd /b/src/java/mine/b'
alias ejav='te /b/src/java/mine/b/B.java'
alias ungrep='grep -vE'
alias ug=ungrep
alias nb='netbeans --jdkhome /usr/lib/jvm/java-7-openjdk-i386 & ; disown' #credit http://wiki.netbeans.org/FaqRunningOnJre
alias nb8='/usr/local/netbeans-8.1/bin/netbeans --jdkhome /usr/lib/jvm/java-7-openjdk-i386 &'
alias sp=sudoprep
alias cjav='cd /b/src/java/mine/b'

function bakjava() {
	bakdir=/b/archive/$(btime)_src_java_mine
	mkdir $bakdir
	cp -a /b/src/java/mine/b/* $bakdir
	ls $bakdir
}

alias findup='/usr/share/fslint/fslint/findup'
alias hm='url file://'$(echo /b/index.htm)
alias crisis='cd /5/Cat/0_MASTER_Caterpillar_originally_from_crisis_hpt_home/crisis'
alias disk='a gnome-disks'
alias sqlexample='te /b/sqlexamples.txt'
alias bkill='kill -9'
#sudo badblocks -sw -o /b/20150901_passport2g_badblocks_log_-sw.log /dev/sdc

function jcut() { jc && j unittest; }
alias notes='te /b/notes.txt'
alias jdksrc='cd /mnt/5tb/b/src/java/openjdk-7_source_code_from_debian_source_dvd_7/jdk-1e6db4f8b0f3/src/share/classes'
alias data='te /b/data_usage.txt'
function bark() { cvlc --no-loop --play-and-exit --volume 64 /m/hpt3/1/audio/LRBark_1_by_Lionel_Allorge.ogg; }

#override .bashrc for ubuntu

#function websearch() { xdg-open 'https://www.google.com/search?&as_q='"$1"'+-site:stackoverflow.com+-site:superuser.com&as_rights=(cc_publicdomain).-(cc_noncommercial|cc_nonderived|cc_attribute|cc_sharealike)'; }
function sfree() { a konqueror "https://www.google.com/search?&as_q=$*&as_rights=(cc_publicdomain).-(cc_noncommercial|cc_nonderived|cc_attribute|cc_sharealike)"; }
function gov() { a xdg-open "https://www.google.com/search?&as_q=$*+site:gov"; }
function com() { url $1.com; }
function org() { url $1.org; }

#print
function rp() { mydir=/b/pq_archive/$(btime) && mkdir $mydir && mv ~/PDF/* $mydir && mv /b/pq/* $mydir && rm /media/b/e/pq/* ; }
function prt3() { cd ~/PDF && convert -type bilevel -density 300 *pdf /b/pq/print.tif && cp /b/pq/print.tif /media/b/e/pq && echo 'ready for printer console, use rp afterward'; }

#function Z() { nl=$'\0'; sed --zero-terminated s/'\n'/$nl/gm; }
function Z() { tr '\n' '\000'; } #big thanks to http://news-posts.aplawrence.com/721.html
function leman() { td=/b/copy_leman; mkdir $td; fc leman|gr marvin|ug 'jnl|journal'|Z|sudo xargs -0 sudo cp -a --parents -t $td; cd $td; allmine;  } #

notefile=/b/notes.txt
function note() { isval $1 && echo $(btime) "$@" >> $notefile && tail $notefile || cat $notefile; }
function notee() { te $notefile; }


function url() { a konqueror $1; }
function dictw() { url http://dictionary.reference.com/browse/"$1"?s=t; }
function proc() { ps -ef|ungrep "grep.*$1"|g "$1"; }
#function urla() { async konqueror $1; }
alias async=a
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

function Fc() {
isval $1 && { cat /b/f|G "$@"; return; }
cat /b/f
}

function fc() {
isval $1 && { cat /b/f|g "$@"; return; }
cat /b/f
}


function fcx() { grep -iE --color=auto "$1" /b/f; }
#bad alias fc='Fc -i'
function latest() { head <(ls -lR);  }
#-----------------------------------------------------
function bvirusscan() { 
isroot want || return
logdir=/b/Mothx/virusscan/$(btime)_$(pwd) #chg
echo 'logging to directory '$logdir #chg
mkdir $logdir
mkdir $logdir/t
mkdir $logdir/virus_files
sudo clamscan -varz --stdout --tempdir=$logdir/t --follow-dir-symlinks=0 --follow-file-symlinks=0 --copy=$logdir/virus_files . > $logdir/stdout_and_stderr.log 2>&1 & #chg &
sudo chown -R b $logdir
} 
#-----------------------------------------------------
function grvirus() {
egrep -v '\.Trash|/virus(_)?scan/|eicar.com|virus_(actual_)?files' *log|egrep 'FOUND'
}

function allmine() { sudo chown -R b *; }

function it() { info $1 |tei; }

alias esword='wine "c:\program files\e-sword\e-sword.exe"&'

alias s3=/usr/bin/sqlite3
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
alias q=bquery
function bquery() { tmpfile=/tmp/$(btime)_tmp.html && s3 /l/15 "$*" > $tmpfile && cat $tmpfile; }
#function inn() { [ $# -eq 2 ] && sql "insert into sub(parent,child) values ('$1','$2')" && whereis $2 || { [ $# -eq 1 ] && sql "select * from s

alias ga=storein
alias inn=storein
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

alias ga2=storein2
function storein2() {
	parent=$1 ; shift 1
	while true; do
		sql "insert into sub(parent,child) values ('$parent','$1')" && whereis $1
		shift 1; isval $1 || break
	done
}

function bakdb () { ts=$(btime) && cp /l/15 /l/22/archive/"$ts"_archive_b_"$1".db && find /b/db/archive |g $ts; }

function new() {
newi=$(sql 'select max(i) + 1 from b')
isint $1 && { ga $1 $newi > /dev/null ; shift 1; }
sql "insert into b(i,t) values ( $newi, '""$*""')"; whereis $newi
}

function gC() { 
G "$@" -i --color=always 
} 


function G0() { G "$@" --null-data ; }

function Gleaf() { G "$@"'[^/]*/?$' ; }

function gl() { 
Gl "$@" -i
} 
function Gl() { 
#grep -E --color=always --group-separator=------------------------------------------------------------------------------ "$@" | less -R
G "$@" --color=always | less -R  #setting --color twice but this overrides
} 


alias lr='l'

function to() {
sql "select * from task order by priority"
}
function nto() { #todo
isint $1 && { pri=$1; shift 1; } || pri=6
sql "insert into task(i, desc, priority) values ( (select max(i) + 1 from task), '$*', $pri)" && echo -n 'inserted>> ' && to|tail -n 1
}
function inet() { 
isval $1 || { to; return; }
nto 'internet: '"$*" ;
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
alias wi=whereis
function whereis() {
sql 'with recursive mytree(i, depth) as (values('$1', 0) union 
all select parent, mytree.depth + 1 from sub, mytree where sub.child = mytree.i) select b.i, depth, b.t from mytree join b on mytree.i = b.i'
}

#alias pff="new 'paper file folder -$*'"
function pff() {
parent=$1; shift 1
new $parent 'paper file folder - '"$*"
}
function all1() { sqlall="select i, t, insert_ts from b"; isval $1 && sql "$sqlall"|gr "$*"; isval $1 || sql "$sqlall"; }

alias timesheetlegacy='te '/b/acct/15/business_work_billing_invoice_whatever/timesheet.txt

function b() { 
isint $1 && whereis $1 || {
	isval $1 || { sql "select * from b"; return; }
	sql "select * from b" | g "$1"
}  #j borg
}

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

alias ckorphan="sql \"select parent,child,'missing parent' from sub where parent not in (select i from b) union all select parent,child,'missing child' from sub where child not in (select i from b)\""
alias echop="echo $1"
function desc() { myid=$1; shift 1 && sql "update b set t='$*' where i = $myid" && whereis $myid; }

function unlock() { udisksctl unlock -b /dev/disk/by-uuid/e2e211ab-d468-4b56-b540-83314357e003; } #credit http://askubuntu.com/questions/630717/how-to-lock-luks-partition-from-terminal
function sudoprep() { return; xclip /home/b/g -selection clipboard && sudo echo 'ready to sudo'; } #disabled for now since sudo not needed

function isroot() { isequal $USER root && return 0 || return 1; }




#$1=source $2=destination
function brsync() { isroot need && rsync -aAXu --progress --exclude-from=/b/exclude-from.txt --delete-before --size-only "$1" "$2"; }
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
find -print0 |grep -iE '\.(txt|log)$' --null-data | xargs  -i -r -0 /b/sh/greponefile "$searchstring" {} #--verbose
}


function e() { te $(find -maxdepth 1|grep ^$1$); }
function f0() { find $1 --maxdepth 0 ; }
function grf() { grep -$2 --group-separator=------------------------------------------------------------------------------ "$1"; }
function md() { mkdir "$*" && cd "$*"; }
function bae() { source /b/sh/bashrc.sh; } # $shdir/b
#function bibled() { a /b/installed/java/bibledesktop/BibleDesktop.sh; }
function esword() { env WINEPREFIX="/home/b/.wine" wine C:\\Program\ Files\\e-Sword\\e-Sword.exe 1>&- 2>&- & }
function es2() { env WINEPREFIX="/home/b/.wine" wine C:\\Program\ Files\\e-Sword\\e-Sword.exe & } #from shortcut with trailing & added
function e2() { te $1; }
alias spng='scan png 300'
function scanstdwebcam() { scanimage --resolution $2 --format=tiff --mode Color -d v4l:/dev/video0|convert - ./$(date +%Y%m%d%H%M%S)_"$3".$1; }  # genesys:libusb:002:020 (numbers vary based on port) or pixma:04A9173A_B94E2B or v4l:/dev/video0 (webcam) or old Epson epson2:libusb:001:016 or new Epson epkowa:usb:001:014
function scan() { test -z $scannere && fscanb jpg 300 "$@" || fscane jpg 300 "$@"; }
alias sc='scan'
##
function setscanba() { bdec scannere=$(scanimage -L | grep -o 'fdepkowa.\{12\}') ; bdec scannerb=$(scanimage -L | grep -o 'brother4.\{10\}'); }
function fscanb() { #WARNING stderr nulled due to noise # genesys:libusb:002:020 (numbers vary based on port) or pixma:04A9173A_B94E2B or v4l:/dev/video0 (epson) or old Epson epson2:libusb:001:016 or juse scanimage -L
scanext=$1;scanres=$2;shift 2
filename="./$(date +%Y%m%d%H%M%S)_"$*"_Epson_WF-3640_scanned.$scanext"
sudo scanimage --resolution $scanres --format=tiff -d $scannerb --mode='24bit Color' |convert - "$filename" && ls "$filename"    #Brother machine does not like scanimage option --mode Color which works for Epson but it seems like the equal sign is preferred over space anyway.  Brother also forced me to use sudo otherwise it fails to even open scanner.
chown b "$filename"
}  #--mode='24bit Color' for scanimage not sure why not working

alias s300='scan jpg 300'
alias s600='scan jpg 600'
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
alias of=fo


function cx() { cd $(b finddir $*); find $(pwd); }
function cont1() { grep -ir --color=auto "$1" /b/contact; }  
alias co=cont

function loc() {
if [ ! -n ''$1 ]
	then te /b/locate/locate.txt
else
	bquery "select * from b where t like '%$*%'"
fi 
}


function h() { $1 --help|le; }
function uuid() { sudo blkid; find /dev/disk/by-id; find /dev/disk/by-uuid; } #credit https://help.ubuntu.com/community/UsingUUID
jnlfile=$(b 3)/journal.txt
function jnlr() { xro $jnlfile; }
function jnle() { echo -n "\n$(btime) " >> $jnlfile && te $jnlfile; }
function dad() { te $(b 3)/dad.txt; }
function jnlG() { 
isval $1 || { cat $jnlfile; return; }
mytime=$(btime)
echo "\n$mytime $@" >> $jnlfile ; tail -n 3 $jnlfile |G $mytime'.*$|^' ; 
}
function jnlbak() { cp $jnlfile /b/archive/$(btime)_jnl.txt; }
function jnlf() { 
isval $1 || { cat $jnlfile; return; }
mytime=$(btime)
echo "\n$mytime $@" >> $jnlfile ; tail -n 3 $jnlfile |grep -E $mytime'.*$|^' ; 
}
function scruple() { jnle scruple "$@"; }

function dummy() { echo 'X' > "$*".txt; }

function zero() { zerop 1000000c 1000;}
function zerop() { #/b/1/zero/Gb.sh  #credit purely from linuxquestions.org
	rootdir="."
	isval $3 && rootdir="$3"
	test -e $rootdir || mkdir "$rootdir"
	while true; do
		zerofile="$rootdir"/zero/$RANDOM$RANDOM$RANDOM.zero
		dd if=/dev/zero bs=$1 count=$2|pv > "$zerofile" || { rm "$zerofile"; break; } #remove the last one to leave some space
		#if [[ "$?" != "0" ]]; then break; fi
	done
}

function tepipe() {
tmpfile=$(tmpfilename).txt
cat - > $tmpfile ; a leafpad $tmpfile
}

function tmpfilename() {
echo /tmp/$RANDOM$RANDOM$RANDOM_"$@"
}

function te() { a kate "$*"; } #-w --new-window 
function tet() { tmpfile=/tmp/$RANDOM$RANDOM.txt && cp $1 $tmpfile && te $tmpfile; }
function infoe() { tet <(info "$1"); }
function ma() { man "$1"; }
alias sources='sudo te /etc/apt/sources.list'
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
function mall() {
#source /b/sh/mro.sh 7340032 /media/b/6tb_1/Cat/hpt/20150804_hptouch_laptop_sda_550G_md5_d388592fd4aaebf17a6b76fa1846d96b_typed.img /m/hpt1
#source /b/sh/mro.sh 59999518720 /media/b/6tb_1/Cat/hpt/20150804_hptouch_laptop_sda_550G_md5_d388592fd4aaebf17a6b76fa1846d96b_typed.img /m/hpt2
#source /b/sh/mro.sh 89999278080 /media/b/6tb_1/Cat/hpt/20150804_hptouch_laptop_sda_550G_md5_d388592fd4aaebf17a6b76fa1846d96b_typed.img /m/hpt3
source /b/sh/mro.sh 1048576 /media/b/6tb_1/Cat/passport2t/20150801_passport_ddrescue_sde_some_files_already_moved_to_6tb_and_most_accessed_recently_unfortunately_md5_cd44894cd3cc95af911f21f714f33eb6.img /m/passport2t
#source /b/sh/mro.sh 1048576 /m/passport2t/crisis/img/hpbig500spinning/hpbig500spinningaux_convsyncnoerror_take3_md5_6a5a6f71c9ed7fa5f69ef133c45cb69a_md5.img /m/hpbig_500_1 #this one files are mostly Windows-encrypted
#source mro.sh 209715200 /media/b/6tb_2/Cat/copy_hpbig_256_uncompressed/copy_256_take3_I_think_I_uncompressed_c_drive_before_this_but_not_positive_md5_4529dd26da221a550cd612647b942676.img /m/hpbig256_main

}

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

function last() { t last "$@"; }
function end() { last end; }
function tt() { thist "$@" | boldtime ; }
alias e=end
function end() { isval $1 && t end "$@" || switch; }


function dc() { sql "select i, start, end, desc from do_log where end = 'in_progress' order by start"; }

function undox() { 
while true; isval $1 || break; do sql "update do_log set intensity = 0, end = '$(btimes)' where i = '$1'" && shift 1; done; curt; }

function undo() { 
while true; isval $1 || break; do t $1 0 && shift 1; done; curt; }


#generalcredits TODO

#credit1
function shortest() { sort; }


# how NOT to write scripts
#alias ba="gedit /b/.bash_aliases||source /b/.bash_aliases"
#alias md="mkdir $1 ; cd $1"
#alias md1='mkdir $1' && 'cd $1'
#alias md2="mkdir $1 && cd $1"
#alias bibled="/b/1/installed/java/bibledesktop/BibleDesktop.sh &"

#credit1  Modified by me but got the sort-then-head idea, putting a number at the beginning of the line so you can sort numerically, from Ted Hopp (http://stackoverflow.com/users/535871/ted-hopp) at http://stackoverflow.com/questions/5046261/grepsort-and-display-only-the-first-line which was licensed under https://creativecommons.org/licenses/by-sa/3.0/

#tee http://unix.stackexchange.com/questions/41246/how-to-redirect-output-to-multiple-log-files

. /b/sh/generated_functions.sh
. /b/sh/aliases.sh
