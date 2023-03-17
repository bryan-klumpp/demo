set -e

function makeUserOwnedRootLinkIfNotExists() {
    USER_NON_ROOT=$USER
    test -e "$2" || { echo 'Creating link in root, need sudo...' &&
             sudo ln -s "$1" "$2" && 
             sudo chown $USER_NON_ROOT:$USER_NON_ROOT "$2" && chmod 700 "$2"; }
    ls -ld "$2"; }
function makeLinkIfNotExists() {
    test -e "$2" || { ln -s "$1" "$2" && 
                  chown $USER:$USER                   "$2" && chmod 700 "$2"; }
    ls -ld "$2"; }
function makeDirIfNotExists() {
    test -e "$1" || { mkdir "$1"; }

makeLinkIfNotExists $(readlink -e $(dirname "$0")) ~/sh
makeDirIfNotExists "~/b"
makeDirIfNotExists "~/b/code"
makeDirIfNotExists "~/b/code/util"

# Yes I'm going for extreme conciseness here;
# running shell scripts is a very frequent activity...
makeUserOwnedRootLinkIfNotExists ~/sh /sh
makeUserOwnedRootLinkIfNotExists ~/sh /s 

echo; echo "Script complete: "$0

#testing: suuuuuuuuuudo rm /s ~/sh; ./make_link_dirs.sh; ./make_link_dirs.sh