myhome=/b
mygeneratedlnkdir=/l
mygitusername=bryan-klumpp
mygitemail=klumpp6@gmail.com
mylanid=klumpb

wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O ~/Downloads/vscode.deb
sudo apt install ~/Downloads/vscode.deb
#ext install eamodio.gitlens
sudo apt install git curl chromium-browser 
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
     chmod -R 755       $shdir
sudo chown -R root:${mylanid} $shdir
sudo ln -s $shdir $shlnk

#Sublime installation as per https://www.sublimetext.com/docs/linux_repositories.html
#note, this step may prompt you for 
curl -s https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text
