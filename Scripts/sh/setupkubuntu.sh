pwd | grep -E 'Scripts/sh$' || { echo 'need to run this from Scripts/sh'; return 1; } &&
test -e /sh || { sudo ln -s "$(pwd)" /sh; } &&

{
test -e ~/l || { mkdir ~/l; } && { test -e /l || { sudo ln -s ~/l /l; } } &&
alias mast='. mast.sh' &&
. bln1.sh ~ &&
. mkfa.sh &&
grep -qE "/l/13$" ~/.bash_aliases || echo '. ~/l/13' >> ~/.bash_aliases &&
sudo apt install xclip filelight &&   #TODO add others from localpc/install.log
echo 'done'
}

