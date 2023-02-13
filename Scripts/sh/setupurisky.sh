sudo apt install baobab brasero gnome-disk-utility acpitool pv redshift sqlite3 lynx default-jdk xclip xiphos diatheke audacity clamav scrot vgrabbj
sudo apt install xubuntu-desktop xfce4-volumed ifuse libimobiledevice-utils wine-development
sudo apt install gparted
return

test -e /media/b/2 || { echo 'please mount /media/b/2 first'; return 83; }
test -e /sh || { sudo ln -s $(pwd) /sh; } &&
test -e /l || { sudo mkdir /l && sudo chown b /l && . bln.sh; } &&
test -e /t || { sudo mkdir /t && sudo chown b /t; } &&
#test -e /etc/apt/sources.list.d/unit193-ubuntu-crosswire-bionic.list || 
#   { sudo apt-add-repository ppa:unit193/crosswire; } && 
test -L /sd || sudo ln -s /media/b/2 /sd &&
test -L /mnt/sd || sudo ln -s /media/b/2 /mnt/sd &&
test -e ~/.bash_aliases && touch ~/.bash_aliases &&
grep 'b13_' ~/.bash_aliases || { echo '. /sh/b13_*' >> ~/.bash_aliases; } &&
sudo apt update && sudo apt dist-upgrade && 
