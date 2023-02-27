myhome=/b
mygeneratedlnkdir=/l
mygitusername=bryan-klumpp
mygitemail=klumpp6@gmail.com
mylanid=klumpb
myDefaultArchiveDir=/b/b22_archive

wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O ~/Downloads/vscode.deb
sudo apt install ~/Downloads/vscode.deb
#manual: ext install eamodio.gitlens
manual: sudo apt install git curl chromium-browser xclip
git config --global user.name $mygitusername
git config --global user.email $mygitemail
sudo mkdir ${myhome}
sudo chown klumpb ${myhome}
chgrp klumpb ${myhome}
chmod 750 ${myhome}
myworkspace=${myhome}/workspace
mkdir $myworkspace
git clone https://github.com/bryan-klumpp/demo "{$myworkspace}/bbase"
shlnk=/sh
shdir="${myworkspace}/bbase/Scripts/sh"
     chmod -R 750       $shdir
sudo chown -R root:${mylanid} $shdir
sudo ln -s $shdir $shlnk
test -e ~/.bash_aliases || { echo '. /sh/b13_.bash_aliases.sh' > ~/.bash_aliases; }
test -e /b || { sudo mkdir /b; sudo chown ${mylanid}:${mylanid} /b; }
test -e ${myDefaultArchiveDir} || { sudo mkdir ${myDefaultArchiveDir}; sudo chown ${mylanid}:${mylanid} ${myDefaultArchiveDir}; }

#Sublime installation as per https://www.sublimetext.com/docs/linux_repositories.html
#note, this step may prompt you for 
curl -s https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

test -e /mnt || { sudo mkdir /mnt; }
test -e /mnt/hgfs || { sudo mkdir /mnt/hgfs; }

