#### manual steps
# - disable auto update even for package lists
# - connect via USB network only
# - restrict sources.list
# - run apt update with NO REDIRECT
# - Firefox install NoScript and Image Block
# - remove ~/Downloads etc and link to external storage 
# - 


function mkrd() { test -e /$1 || { sudo mkdir /$1 && sudo chown b /$1; };   mkrd l; mkrd b; mkrd /sh;

gsettings set org.gnome.desktop.media-handling automount false
cat ~/.bashrc | grep b13_ > /dev/null || { echo '. /sh/b13_*' >> ~/.bashrc; }


return 88 #just want to make this more dummy-proof before enabling the whole script

sudo apt install ufw; sudo ufw deny incoming; sudo ufw delete allow 5223; ... sudo ufw status

sudo apt install xclip pv sqlite3 libreoffice-writer libreoffice-calc clamav \
       acpitool baobab ffmpeg vorbis-tools rename vgrabbj


echo make sure you did sudo apt update ; sleep 5 || return 46
#sudo apt dist-upgrade
test -e /l || { sudo mkdir -p /ram /home/b/2 /l;  sudo chown b /l; sudo ln -s /home/b/2/30_32g/tmp /t; sudo chown b /t; }
sudo cp /etc/fstab ~/fstab.backup$RANDOM && sudo echo 'tmpram /ram tmpfs size=32M,mode=777 0 1' | sudo dd of=/etc/fstab oflag=append conv=notrunc
sudo apt install xclip redshift lynx pv sqlite3
sudo apt install xiphos diatheke acpitool baobab ntpdate p7zip-full
sudo apt install audacity vgrabbj net-tools scrot brasero
sudo apt install vlc konsole cheese vorbis-tools arecord
sudo apt install default-jdk libreoffice-writer libreoffice-calc
sudo apt install clamav rkhunter chkrootkit ###wait for virus definitions to download to avoid issues
sudo apt install # eclipse torbrowser-launcher lubuntu-desktop  #optional
sudo apt purge at-spi2-core gnome-online-accounts
echo 'b ALL = (root) NOPASSWD: /sh/nwrx.sh,/usr/bin/acpitool,/sbin/shutdown'|tee >(xclip -i -selection clipboard) > /dev/null; sudo visudo  
rmdir /home/b/Pictures && ln -s /home/b/2/30_32g/Pictures /home/b/Pictures
test -e /sh/setupu2.sh || { sudo ln -s /home/b/2/sh /sh; sudo chown b /sh; }
test -e /sd || { sudo ln -s /home/b/2 /sd; sudo chown b /sd; }


return
#in firefox - disable hardware acceleration and limited processes in normal settings, then go to about:config and do webgl.disabled and media.hardware-video-decoding.enabled false
other interesting firefox settings media.suspend-bkgnd-video.enabled and search video*enabled, hardware, gl - dom.maxHardwareConcurrency also interesting for just plain page rendering bugs

