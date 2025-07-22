[ $# -eq 0 ] && { 
  #######################################################################switch to latest directory
  latestdir="$(ls --sort=time --group-directories-first | head -n 1)"
  c "$latestdir"
  return;
}

declare -x -g nosuch='No such file or directory'
function csubrout() {
  test -d "$*" && { echo "$*" > /tmp/cd; return 0; }
  candidate="$(grep -v "$nosuch" | grep -iE "$1" | bdirs | sort | head -n 1)"  
  test -z "$candidate" && return 1 || { echo "$candidate" > /tmp/cd; return 0; }
}

#start here----------------------------------------------------------
echo '' > /tmp/nosuch  #initialize
#p1=$(tofilename "$*") #no worky if spaces in full path
p1="$*"
#test -d "$(paste)" && p1="$(paste)"

isint "$p1" && test -e "$p1" && test -d ${HOME}/l/"$p1" && { echo 'sorry... ambiguous command due to direct integer subdirectory existence; aborting.' ; return; } 
  isint "$p1" && { test -d ${HOME}/l/"$p1" && cd ${HOME}/l/"$p1" && can && bd; return; }   #shortcut for integer arguments going straight to special marked directories b1_*, etc
# isint "$p1" && { test -d ${HOME}/l/"$p1" && cd ${HOME}/l/"$p1"        && bd; return; }   #shortcut for integer arguments going straight to special marked directories b1_*, etc

                                       echo "$p1" | csubrout "$p1" || 
                                       ls -d 2>&1 | csubrout "$p1" ||
                                     ls -d * 2>&1 | csubrout "$p1" ||
                                   ls -d */* 2>&1 | csubrout "$p1" || 
                                 ls -d */*/* 2>&1 | csubrout "$p1" || 
                               ls -d */*/*/* 2>&1 | csubrout "$p1" || 
                             ls -d */*/*/*/* 2>&1 | csubrout "$p1" || 
                           ls -d */*/*/*/*/* 2>&1 | csubrout "$p1" ||
                         ls -d */*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
                       ls -d */*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
                     ls -d */*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
                   ls -d */*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
                 ls -d */*/*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
               ls -d */*/*/*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                                ls -d /b/* 2>&1 | csubrout "$p1" ||
#                              ls -d /b/*/* 2>&1 | csubrout "$p1" ||
#                            ls -d /b/*/*/* 2>&1 | csubrout "$p1" ||
#                          ls -d /b/*/*/*/* 2>&1 | csubrout "$p1" ||
#                        ls -d /b/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                      ls -d /b/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                    ls -d /b/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                  ls -d /b/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                ls -d /b/*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#              ls -d /b/*/*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                     ls -d /mnt/sd/**/*     2>&1 | csubrout "$p1" ||
#                            ls -d /media/*/* 2>&1 | csubrout "$p1" ||
#                          ls -d /media/*/*/* 2>&1 | csubrout "$p1" ||
#                        ls -d /media/*/*/*/* 2>&1 | csubrout "$p1" ||
#                      ls -d /media/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                    ls -d /media/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                  ls -d /media/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                ls -d /media/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#              ls -d /media/*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#            ls -d /media/*/*/*/*/*/*/*/*/*/* 2>&1 | csubrout "$p1" ||
#                      ls -d /media/**/*      2>&1 | csubrout "$p1" ||
                                                             false &&
                               { cd "$(cat /tmp/cd)" && can && bd; }           || err 'could not find directory' 
#                              { cd "$(cat /tmp/cd)"        && bd; }           || err 'could not find directory' 

###########################################################################################
# { loc=$(blocate "$p1"|head -n 1) && cd "$loc"; }


# function croutine() {
#   for ((i = 0; $i < $1; i++)); do {
#     echo $i
#   }; done
# }
# 
# p1=$(clipdef "$1")
# test -d "$p1" && { cd "$p1"; } || {
#   
# } && can


#  grep --silent "$nosuch" /t/nosuch && { err 'cannot find relative, try from root'; return 0; }  #did we hit the end of the tree?

  #[ #? -eq 0 ] && echo "$candidates"|sort


#&& p1=$(j findDir "$p1")






