return 88 #just want to make this more dummy-proof before enabling the whole script
echo make sure you did sudo apt update or interrupt now; sleep 5 || return 46
#sudo apt dist-upgrade
test -e /l || { sudo mkdir -p /ram /home/b/2 /l;  sudo chown b /l; sudo ln -s /home/b/2/30_32g/tmp /t; sudo chown b /t; }
sudo echo 'tmpram /ram tmpfs size=32M,mode=777 0 1'|sudo tee -a /etc/fstab > /dev/null
# sudo apt purge gnome-software
sudo apt install xiphos diatheke libreoffice default-jdk xclip
sudo apt install pv cryptsetup-bin sqlite3 acpitool vlc baobab
sudo apt install audacity vgrabbj net-tools scrot brasero
sudo apt install p7zip-full ntpdate konsole lynx torbrowser-launcher
sudo apt install lubuntu-desktop redshift lvm2
sudo apt install clamav ###wait for virus definitions to download to avoid issues
rmdir /home/b/Pictures && ln -s /home/b/2/30_32g/Pictures /home/b/Pictures
test -e /sh/setupu2.sh || { sudo ln -s /home/b/2/sh /sh; sudo chown b /sh; }
test -e /sd || { sudo ln -s /home/b/2 /sd; sudo chown b /sd; }
gsettings set org.gnome.desktop.media-handling automount false


return
#in firefox - disable hardware acceleration and limited processes in normal settings, then go to about:config and do webgl.disabled and media.hardware-video-decoding.enabled false
other interesting firefox settings media.suspend-bkgnd-video.enabled and search video*enabled, hardware, gl - dom.maxHardwareConcurrency also interesting for just plain page rendering bugs

