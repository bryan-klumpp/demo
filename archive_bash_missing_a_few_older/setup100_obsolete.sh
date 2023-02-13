#obsolete, see setup101

[[ $USER -eq 'root' ]] || { echo 'must be root'; return; }
shopt -s globstar && shopt -s dotglob
test -e /sbin/cryptsetup || apt-get install cryptsetup || return 2
function bmkdir() { test -d "$1" || { mkdir "$1" && chown b "$1"; } }
test -e /t || { bmkdir /b; bmkdir /t; bmkdir /ram; } #add more directories to taste
test -e /med || { ln -s /media/b /med; }
#test -e /b/sh/bashrc.sh || ln -s /home/b/**/b1_* /b/sh
#test -e /dev/mapper/5tbclear || cryptsetup open /dev/disk/by-uuid/e8112194-6a2f-4790-8ffd-214b017fa6ef 5tbclear || return 3
#test -e /mnt/5tb/bmnt.flag || mount /dev/mapper/5tbclear /mnt/5tb || return 4
test -f /media/b/stretch/debian-stretch-DI-rc2-i386-DVD-1.iso  || return 9 && grep contrib /etc/apt/sources.list && for ((i=1;$i<15;i++)) do { mount -o ro /media/b/stretch/*-$i.iso /media/cdrom && apt-cdrom add --no-mount && umount /media/cdrom || return 5; } done  #no likey semicolons??
grep contrib /etc/apt/sources.list && { { sed --in-place 's/ contrib//g' /etc/apt/sources.list && nano /etc/apt/sources.list && { apt-get update || return 7; } } || return 6; }

apt-get update
#install - scrot needed for screenshotgrab, 
apt-get install grub-doc lsb info wine gimp sudo jack links vgrabbj scrot p7zip-full audacity cheese brasero gnome-disk-utility   xclip firefox-esr shc gnome-disks smbclient libreoffice ntpdate xsltproc mlocate lynx hplip glabels icedove xiphos diatheke net-tools acpitool acpi acpi-support gnome-control-center pv default-jdk rsync reportbug less geany sqlite3 perl-doc claws-mail baobab vlc jigdo-file imagemagick  kate gparted pdftk gddrescue pstotext cryptsetup vokoscreen lame pacpl lvm2 kde-plasma-desktop fslint alpine okular shutter ksnapshot kamerka perl-doc  #pacpl=perl audio converter  #rosegarden qsynth   #see greed1/jackd.txt for realtime audio config explanation #libxp6 needed for xpdf which you have to download and install manually
#xsltproc needed for epscan
sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32
echo '#Bryans additions' >> /etc/lynx/lynx.cfg
echo 'SET_COOKES:FALSE' >> /etc/lynx/lynx.cfg
return #-------- STOP HERE - MANUAL FROM HERE ON -------------------------------------
##### ---  MOVE FILES TO /home/b
usermod -a -G sudo b   #reboot to take effect  #sudo1
grep NOPASSWD /etc/sudoers || echo '%sudo   ALL=(ALL) NOPASSWD: ALL   #modified from default' >> /etc/sudoers #sudo2   #visudo  #not needed if copyover config files or append line to /etc/suoders   #Defaults timestamp_timeout=30
shopt -s globstar && { echo '. '; echo /home/b/**/b13_*; } | sudo tee -a /root/.bashrc >> /home/b/.bashrc
cp -a /home/b/**/b1_*/s.sh /s


---- MOSTLY OBSOLETE
echo 'help'
test -e /b/nocopy/nocopyexternaldriveflag.txt && { echo 'be REALLY careful - you are in danger of overwriting master drive'; return 111; exit 111; }
function bmkdir() {
  test -e "$1" || mkdir -p "$1" && chown -R b "$1" && chown -R b /b
}
function softlink() {
  test -e "$2" || sudo ln -s "$1" "$2" && sudo chown b "$2"
}
cd /mnt/bext #----------------------------- cd -------------------------------------#
bmkdir /b
#chown -R b /b
cp sh /b
. /b/sh/bashrc.sh
#test -z $setupdir && { echo 'setupdir variable not set'; return; } &&
#sudo useradd --password 'password' b &&   #seems like user created is not the same as during install
cd /mnt/bext  #----------------------------- cd -------------------------------------#
cp -a sh setup /b #iffy
cp -a /b/setup/copyover_files /  #iffy
cd /          #----------------------------- cd -------------------------------------#
softlink b/sh/s.sh s && chmod +x s
softlink media/b med
softlink b/t t
#nano rc.local &&
bashrc=/home/b/.bashrc
grep 'b13_\.*sh' $bashrc || { echo '. /b/sh/bashrc.sh' >> $bashrc; }
bmkdir /b/big/deb
bmkdir /mnt/iso
#cp -a /mnt/bext/big/iso/debian-8.6.0-i386-DVD /b/big/iso
function ee() {
  bmkdir /b/big/deb/debian-8.6.0-i386-DVD-$1 &&
  mount -o ro /mnt/bext/big/iso/debian-8.6.0-i386-DVD/debian-8.6.0-i386-DVD-$1.iso /mnt/iso &&
  cp -a /mnt/iso/**/*deb /var/cache/apt/archives &&
  #cp -a /mnt/iso/* /b/big/deb/debian-8.6.0-i386-DVD-$1 &&
  #apt-cdrom --no-auto-detect -d /b/big/deb/debian-8.6.0-i386-DVD-$1 -m add
  umount /mnt/iso || { echo 'error unmounting /mnt/iso'; return 111; }
} &&
ee 1 && ee 2 && ee 3 && ee 4 && ee 5 && ee 6 && ee 7 && ee 8 && ee 9 && ee 10 && ee 11 && ee 12 && ee 13
#installing gnome seems to fix sound, may need to do this in a separate step if sound not working.  However using gnome crashes R11
cp -a /b/setup/copyover_files /  #iffy     do again to overwrite after apt-get install
#lxterminal colors
#firefox privacy mode
#xiphos modules
#make backup image
#provide source code if for others
apt-get remove openssh-server openssh-sftp-server avahi-daemon  #thought this was installed by webcam software which didn't work anyway
## remove avahi-daemon and related stuff interfering with wireless after printers installed.  What a PAIN - watch out for massive unexplained package removals.  may need to reinstall gnome-bluetooth.
#cp /etc/apt/sources.list /tmp &&
#cp /etc/apt/sources_non-free.list /etc/apt/sources.list && #iffy
#apt-get update &&
dpkg -i /b/setup/firmware_non-free/select/*deb
#apt-get install firmware-iwlwifi firmware-ralink firmware-realtek && #iffy firmware-realtek maybe not needed as rt3290.bin seems to be in ralink instead  #note rt3290.bin is actually in ralink?!
sudo /b/setup/Epson_allinone_printer_scanner_drivers_Toyota_internet_so_only_agreed_to_Epson_license_agreement/iscan-bundle-1.0.0.x86/iscan-bundle-1.0.0.x86.deb/install.sh   #epson and realtek and/or wifi module install; for Epson use ones downloaded from Toyota 2015-10 and install lsb first  dpkg -i <>.deb   #for epson installed modules are similar to printer-driver-escpr I think there's a scanner also   #greed1 installed ./setup.sh for iscan bundle from Toyota-downloaded Epson drivers on R11 20160820 #iffy
sudo dpkg -i /b/setup/Epson_allinone_printer_scanner_drivers_Toyota_internet_so_only_agreed_to_Epson_license_agreement/epson-inkjet-printer-escpr_1.6.1-1lsb3.2_i386.deb #iffy
sudo dpkg -i --force-all /b/setup/brother_allinone/brscan4-0.4.4-1.i386.deb #iffy Greed?
sudo dpkg -i --force-all '/b/setup/brother_allinone/LPR printer driver - Brother license only/hl2280dwlpr-2.1.0-1.i386.deb' #iffy
sudo dpkg -i --force-all /b/setup/GPL/cupswrapperHL2280DW/cupswrapperHL2280DW-2.0.4-2.i386.deb  #http://support.brother.com/g/b/downloadhowto.aspx?c=us_ot&lang=en&prod=hl2280dw_us&os=128&dlid=dlf005899_000&flang=4&type3=561  #iffy
#cp /tmp/sources.list /etc/apt/sources.list &&
#apt-get update && apt-get dist-upgrade
echo 'whatisgoingonhere reached end of setup1.sh'
#/home/b/.kde/share/apps/konsole/Shell.profile
