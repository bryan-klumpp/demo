#grep 'b13_' /home/b/.bashrc || { echo '. $(shpath)/b13_bashrc.sh' >> /home/b/.bashrc; }


#return
 # #for general credits see the #generalcredits section

#PS1="$(echo -n "$(pwd)" | grep -oE '.{,20}$')"'> '

#gsettings set org.gnome.desktop.media-handling automount true

fourtd=/dev/disk/by-uuid/e1af1621-c92e-4013-8c8b-67a8e6b69297
! grep -E --silent '\S' <(ls /4) && test -e $fourtd && false && {
  sudo cryptsetup open $fourtd 4tclear
  sudo fsck /dev/mapper/4tclear && sudo mount -o rw,sync /dev/mapper/4tclear
}
#  grep -E --silent '\S' <(ls /4) || { echo '/4 not mounted properly'; return 4; }

#test -e $(shpath)/b2323_* || . $(shpath)/mkf.sh
. "$(shpath)"/generated_functions.sh # generated functions - maybe should come before aliases due to possible issue with dependencies
. "$(shpath)"/b21_*   # manual aliases
xrandr -q | grep 'current 320 x 200' && { son; exit; } #special case just turn screen on and close prompt
bbg #will invoke redshift etc
#test -e /ram || { sudo mkdir /ram && sudo chown b /ram; }
#test -e /ram/t.flag || . $(shpath)/bootinit.sh

false && {   #see init.sh - this is redundant
        mkdir /ram/var
	# rm -R /tmp/* || { echo 'failed to blow away /tmp'; }
        sudo mount -t tmpfs arbitrary /ram -o size=32M,mode=777 && 
	echo -n '' > /ram/.bash_history
        echo asdf > /ram/t.flag; mkdir /ram/filenamefindcache; mkdir /ram/var; 
        mall
        sudo swapoff -a
        # ifc|grep -Eo '^w\w*'| bxargs 'sudo ifconfig {} down'   #shut down wireless
	#test -e /dev/disk/by-label/CARAUDIO && { sudo mount /dev/disk/by-label/CARAUDIO /mnt/caraudio && cp /mnt/caraudio/google /ram && echo 'copied to /ram/google' && sudo umount /mnt/caraudio; }
	# cat /media/b/bd128/Secure9/b4_google_Secure9/x1 > /ram/google
        #echo -n 'type password for /ram/google: '; dd 2>/dev/null | trim >> /ram/google
	#nano /ram/google2
	########## bbg  #should invoke bredshift but seems to be failing to register anything permanently
        #cp -a $(b 19)/*txt /ram/filenamefindcache & disown;    #async launch copy filename cache to RAM
 }  #RAMDISK!


. "$(shpath)"/b222_*  # global constants
#echo 'should have created vars'
#echo Hello World

shopt -s globstar
shopt -s nocaseglob
shopt -s dotglob
#gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.wm.preferences focus-new-windows smart #default was 'smart', enum and strict are options  #gsettings range org.gnome.desktop.wm.preferences focus-new-windows

#source ${HOME}/l/1/dec myexport yuio
#echo 'trysubdeclare:'$myexport

#colori=40
#while true; do
#	sql "insert into sub(parent,child) values ('$parent','$1')" && whereis $1
#	(i == 47) && break || i=(i + 1) 
#done

#echo asdf|grep --color=auto sd  #grep test debugging
#-----------  end of startup stuff -------------------------#
shdir=${HOME}/l/1

strn='\s*(\s*<[HG][0-9]{1,5}>)*\s*'

#---------------------------------------------------------------------------------------------
function echofunction() { . ${HOME}/l/1/becho.sh "$@"; }
function btr() { ! isval $1 && jnl|g 'tr:' || jnl tr:"$*" ; }

GC="ms=30;47:mc=02;32:sl=:cx=:fn=34:ln=31:bn=30:se=30"  
#30=black? 31=red, 32=closetogreen, 33=yellow? 34=blue, 35=somekindofblue? 36=lightblue, 37=lavendar, 31=red30-37=foreground?, 
#40-47 background 40=black 41=red 42=green... 
declare -x -g GREP_COLORS="$GC"

bd   #echo directory listing
##############proc 'sleep 55' || bbg #{ echo '\n>>> WARNING <<< - check to see if bbg running.     >>> WARNING <<<'; }

function xx_command_not_found_handle() {
  mg "$@"
}

#GREP_COLORS="$GC"
#export GREP_COLORS="$GC"
export q="'"
export qq='"'

#declare -x -g -f function testfunction() { echo woohoo; }

. "$(shpath)"/functions_ripped_from_b13_bashrc.sh
# how NOT to write scripts

#credit1  Modified by me but got the sort-then-head idea, putting a number at the beginning of the line so you can sort numerically, from Ted Hopp (http://stackoverflow.com/users/535871/ted-hopp) at http://stackoverflow.com/questions/5046261/grepsort-and-display-only-the-first-line which was licensed under https://creativecommons.org/licenses/by-sa/3.0/

#tee http://unix.stackexchange.com/questions/41246/how-to-redirect-output-to-multiple-log-files

#. ${HOME}/l/1/generated_functions.sh
#. ${HOME}/l/21  #manual aliases

bset gmtoffset 5

#cd /home/b/mast_ul/b1_sh_Greed0 #for troubleshooting


return ###################################    RETURN  ###########################################

############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################
############################################ OBSOLETE ###########################################

function last() { t last "$@"; }
function end() { last end; }
function end() { isval $1 && t end "$@" || switch; }

